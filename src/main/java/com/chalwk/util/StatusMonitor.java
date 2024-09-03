/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Enums.StatusField;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import static com.chalwk.util.Listeners.GuildReady.getGuild;

public class StatusMonitor {

    private static final ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
    private static final String messageIDFile = "message-ids.json";
    private static String serverID;

    public StatusMonitor(String serverName, int intervalInSeconds) {
        StatusMonitor.serverID = serverName;
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new StatusUpdaterTask(), 1000 * 10, intervalInSeconds * 1000L);
    }

    private static EmbedBuilder createEmbedMessage(JSONObject data) {
        EmbedBuilder embed = new EmbedBuilder();
        embed.setTitle("Server Status");

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyy | HH:mm:ss");
        String timestamp = now.format(formatter);
        embed.setFooter("Last updated: " + timestamp, null);

        for (StatusField field : StatusField.values()) {
            embed.addField(field.getFieldName(), getFieldValue(data, field), false);
        }

        return embed;
    }


    private static String getFieldValue(JSONObject data, StatusField field) {
        if (field == StatusField.PLAYER_LIST) {
            JSONArray playerList = data.optJSONArray(field.getFieldName());
            if (playerList != null && !playerList.isEmpty()) {
                return playerList.toList().stream().map(Object::toString).collect(Collectors.joining("\n"));
            } else {
                return "No players online";
            }
        }
        return data.optString(field.getFieldName(), "N/A");
    }

    private static class StatusUpdaterTask extends TimerTask {

        @Override
        public void run() {

            JSONObject parentTable;
            JSONObject serverTable;

            try {
                parentTable = FileIO.getJSONObject("halo-events.json");
                serverTable = parentTable.getJSONObject(serverID);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            TextChannel channel = getTextChannel(serverTable);

            try {
                String messageID = getMessageID();
                if (messageID == null) {
                    createInitialMessage(serverTable, channel);
                } else if (!messageExists(channel, messageID)) {
                    createInitialMessage(serverTable, channel);
                } else {
                    updateEmbed(serverTable, channel, messageID);
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        private void updateEmbed(JSONObject serverTable, TextChannel channel, String messageID) {
            EmbedBuilder embed = createEmbedMessage(serverTable.getJSONObject("status"));
            channel.retrieveMessageById(messageID)
                    .queue(message -> message.editMessageEmbeds(embed.build()).queue());
        }

        private void createInitialMessage(JSONObject serverTable, TextChannel channel) throws IOException {
            EmbedBuilder embed = createEmbedMessage(serverTable.getJSONObject("status"));
            channel.sendMessageEmbeds(embed.build()).queue();

            executorService.schedule(() -> {
                String messageID = channel.getLatestMessageId();
                JSONObject channelIDs;
                try {
                    channelIDs = FileIO.getJSONObject(messageIDFile);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
                channelIDs.put(serverID, messageID);
                FileIO.saveJSONObjectToFile(channelIDs, messageIDFile);
            }, 1000, TimeUnit.MILLISECONDS);
        }

        private boolean messageExists(TextChannel channel, String messageID) {
            return channel.retrieveMessageById(messageID).complete() != null;
        }

        private TextChannel getTextChannel(JSONObject serverTable) {
            Guild guild = getGuild();
            String channelID = serverTable.getJSONObject("status").getString("CHANNEL_ID");
            TextChannel channel = guild.getTextChannelById(channelID);
            if (channel == null) {
                throw new IllegalArgumentException("Channel not found: " + channelID);
            }
            return channel;
        }

        private String getMessageID() {
            JSONObject channelIDs = getChannelIds();
            return channelIDs.has(serverID) && !channelIDs.getString(serverID).isEmpty() ? channelIDs.getString(serverID) : null;
        }

        private JSONObject getChannelIds() {
            try {
                return FileIO.getJSONObject(messageIDFile);
            } catch (IOException e) {
                throw new IllegalStateException("Error reading channel IDs: " + e.getMessage());
            }
        }
    }
}
