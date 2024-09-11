/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.Message;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import net.dv8tion.jda.api.events.guild.GuildReadyEvent;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static com.chalwk.util.Helpers.*;

public class ServerMonitor {

    public ServerMonitor(GuildReadyEvent event) throws IOException {
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new Task(event), 0, 2000L);
    }

    private static void updateServerStatus(String serverID, JSONObject parentTable, JSONObject messageIDs, Guild guild) {
        Map<String, TextChannel> channelMap = new HashMap<>();

        JSONObject status = parentTable.getJSONObject(serverID).getJSONObject("status");
        String statusChannelID = status.getString("channel");

        channelMap.computeIfAbsent(statusChannelID, id -> Optional.ofNullable(guild.getTextChannelById(id)).orElseThrow(
                () -> new IllegalArgumentException("Channel not found: [" + id + "] (Server ID: " + serverID + ")")));

        TextChannel statusTextChannel = channelMap.get(statusChannelID);
        EmbedBuilder embed = createEmbedMessage(status);

        String messageID = messageIDs.optString(serverID, null);
        if (messageID == null || !messageExists(statusTextChannel, messageID)) {
            Message message = statusTextChannel.sendMessageEmbeds(embed.build()).complete();
            messageIDs.put(serverID, message.getId());
            FileIO.saveJSONObjectToFile(messageIDs, MESSAGE_ID_FILE);
        } else {
            statusTextChannel.retrieveMessageById(messageID).queue(message -> message.editMessageEmbeds(embed.build()).queue());
        }
    }

    private static class Task extends TimerTask {

        private final Guild guild;

        public Task(GuildReadyEvent event) {
            this.guild = event.getGuild();
        }

        @Override
        public void run() {

            long startTime = System.currentTimeMillis();
            ExecutorService executorService = Executors.newFixedThreadPool(4);
            JSONObject servers;
            JSONObject messageIDs;

            try {
                servers = FileIO.getJSONObjectFromFile(HALO_EVENTS_FILE);
                messageIDs = FileIO.getJSONObjectFromFile(MESSAGE_ID_FILE);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            Set<String> updatedServers = new HashSet<>();
            for (String serverID : servers.keySet()) {
                executorService.submit(() -> updateServerStatus(serverID, servers, messageIDs, guild));
                JSONArray events = servers.getJSONObject(serverID).getJSONArray("sapp_events");
                sendEventNotification(serverID, events, updatedServers);
            }
            executorService.shutdown();

            if (!updatedServers.isEmpty()) {
                FileIO.saveJSONObjectToFile(servers, HALO_EVENTS_FILE);
            }

            long endTime = System.currentTimeMillis();
            System.out.println("Execution time: " + (endTime - startTime) + "ms");
        }

        private void sendEventNotification(String serverID, JSONArray events, Set<String> updatedServers) {
            for (Object o : events) {
                JSONObject event = (JSONObject) o;
                String title = event.getString("title");
                String description = event.getString("description");
                String channelID = event.getString("channel");
                String color = event.getString("color");
                sendMessage(title, description, color, channelID, guild, serverID);
                updatedServers.add(serverID);
            }
            events.clear();
        }
    }
}