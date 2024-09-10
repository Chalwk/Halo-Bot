/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Enums.ColorName;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.Message;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import net.dv8tion.jda.api.events.guild.GuildReadyEvent;
import org.json.JSONArray;
import org.json.JSONObject;

import java.awt.*;
import java.io.IOException;
import java.util.Optional;
import java.util.Timer;
import java.util.TimerTask;

import static com.chalwk.util.Helpers.*;

public class StatusMonitor {

    public StatusMonitor(GuildReadyEvent event) throws IOException {
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new Task(event), 0, 2000L);
    }

    private static EmbedBuilder createEmbedMessage(JSONObject data) {

        String title = data.optString("title", "N/A");
        String description = data.optString("description", "N/A");
        String colorName = data.optString("color", "0x00FF00");

        Color color = ColorName.fromName(colorName);
        String timestamp = getTimestamp();

        EmbedBuilder embed = new EmbedBuilder();
        embed.setTitle(title)
                .setDescription(description)
                .setColor(color)
                .setFooter("Last updated: " + timestamp, null);

        JSONArray fields = data.optJSONArray("fields");
        if (fields != null) {
            for (Object fieldObj : fields) {
                JSONObject field = (JSONObject) fieldObj;
                String fieldName = field.optString("name", "N/A");
                String fieldValue = field.optString("value", "N/A");
                boolean inline = field.optBoolean("inline", false);
                embed.addField(fieldName, fieldValue, inline);
            }
        }

        return embed;
    }

    private static TextChannel getTextChannel(String channelID, Guild guild, String serverID) {
        TextChannel channel = guild.getTextChannelById(channelID);
        if (channel == null) {
            throw new IllegalArgumentException("[getTextChannel()] Channel not found: [" + channelID + "] (Server ID: " + serverID + ")");
        }
        return channel;
    }

    private static void sendMessage(String title, String description, String colorName, String channelID, Guild guild, String serverID) {
        TextChannel channel = getTextChannel(channelID, guild, serverID);

        Color color = ColorName.fromName(colorName);
        EmbedBuilder embedBuilder = new EmbedBuilder()
                .setTitle(title)
                .setDescription(description)
                .setColor(color);

        try {
            channel.sendMessageEmbeds(embedBuilder.build()).queue();
        } catch (Exception e) {
            throw new IllegalArgumentException("[sendMessage()] Error sending message: " + e.getMessage());
        }
    }

    private static class Task extends TimerTask {

        private final Guild guild;

        public Task(GuildReadyEvent event) {
            this.guild = event.getGuild();
        }

        @Override
        public void run() {
            JSONObject parentTable;
            JSONObject messageIDs;
            try {
                parentTable = FileIO.getJSONObjectFromFile(HALO_EVENTS_FILE);
                messageIDs = FileIO.getJSONObjectFromFile(MESSAGE_ID_FILE);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            for (String serverID : parentTable.keySet()) {
                updateServerStatus(serverID, parentTable, messageIDs);
                JSONArray eventTable = parentTable.getJSONObject(serverID).getJSONArray("sapp_events");

                // todo: Fix this. Sometimes events are not sent but the "eventTable" is cleared.

                for (Object o : eventTable) {
                    JSONObject event = (JSONObject) o;
                    String title = event.getString("title");
                    String description = event.getString("description");
                    String channelID = event.getString("channel");
                    String color = event.getString("color");
                    sendMessage(title, description, color, channelID, guild, serverID);
                }
                eventTable.clear();
            }
            FileIO.saveJSONObjectToFile(parentTable, HALO_EVENTS_FILE);
        }

        private void updateServerStatus(String serverID, JSONObject parentTable, JSONObject messageIDs) {
            JSONObject status = parentTable.getJSONObject(serverID).getJSONObject("status");
            String statusChannelID = status.getString("channel");
            TextChannel statusTextChannel = Optional.ofNullable(guild.getTextChannelById(statusChannelID)).orElseThrow(()
                    -> new IllegalArgumentException("Channel not found: [" + statusChannelID + "] (Server ID: " + serverID + ")"));

            EmbedBuilder embed = createEmbedMessage(status);
            String messageID = messageIDs.optString(serverID, null);

            if (messageID == null || !messageExists(statusTextChannel, messageID)) {
                Message message = statusTextChannel.sendMessageEmbeds(embed.build()).complete();
                messageIDs.put(serverID, message.getId());
                FileIO.saveJSONObjectToFile(messageIDs, MESSAGE_ID_FILE);
            } else {
                statusTextChannel.retrieveMessageById(messageID)
                        .queue(message -> message.editMessageEmbeds(embed.build()).queue());
            }
        }
    }
}