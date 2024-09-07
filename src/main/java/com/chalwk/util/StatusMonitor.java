/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Enums.StatusField;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.Message;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Timer;
import java.util.TimerTask;
import java.util.stream.Collectors;

public class StatusMonitor {

    private static final String messageIDFile = "message-ids.json";
    private static String serverID;
    private static Guild guild;

    public StatusMonitor(String serverKey, int intervalInSeconds, Guild thisGuild) {
        guild = thisGuild;
        serverID = serverKey;
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new StatusUpdaterTask(), 0, intervalInSeconds * 1000L);
    }

    private static EmbedBuilder createEmbedMessage(JSONObject data) {
        EmbedBuilder embed = new EmbedBuilder();
        embed.setTitle("Server Status");

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyy | HH:mm:ss");
        String timestamp = now.format(formatter);
        embed.setFooter("Last updated: " + timestamp, null);
        embed.setColor(0x00FF00); // green

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

    private static void updateEmbed(TextChannel channel, String messageID) throws IOException {
        EmbedBuilder embed = createEmbedMessage(getStatusTable());
        channel.retrieveMessageById(messageID)
                .queue(message -> message.editMessageEmbeds(embed.build()).queue());
    }

    private static void createInitialMessage(TextChannel channel) throws IOException {
        EmbedBuilder embed = createEmbedMessage(getStatusTable());
        Message message = channel.sendMessageEmbeds(embed.build()).complete();

            JSONObject channelIDs;
            try {
                channelIDs = FileIO.getJSONObjectFromFile(messageIDFile);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            channelIDs.put(serverID, message.getId());
            FileIO.saveJSONObjectToFile(channelIDs, messageIDFile);
    }

    private static boolean messageExists(TextChannel channel, String messageID) {
        return channel.retrieveMessageById(messageID).complete() != null;
    }

    private static TextChannel getTextChannel() throws IOException {
        String channelID = getStatusTable().getString("CHANNEL_ID");
        TextChannel channel = guild.getTextChannelById(channelID);
        if (channel == null) {
            throw new IllegalArgumentException("Channel not found: " + channelID);
        }
        return channel;
    }

    private static String getMessageID() {
        JSONObject channelIDs = getChannelIds();
        return channelIDs.has(serverID) && !channelIDs.getString(serverID).isEmpty() ? channelIDs.getString(serverID) : null;
    }

    private static JSONObject getChannelIds() {
        try {
            return FileIO.getJSONObjectFromFile(messageIDFile);
        } catch (IOException e) {
            throw new IllegalStateException("Error reading channel IDs: " + e.getMessage());
        }
    }

    private static JSONObject getStatusTable() throws IOException {
        JSONObject parentTable = FileIO.getJSONObjectFromFile("halo-events.json");
        return parentTable.getJSONObject(serverID).getJSONObject("status");
    }

    private static class StatusUpdaterTask extends TimerTask {

        @Override
        public void run() {
            TextChannel channel;
            try {
                channel = getTextChannel();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            try {
                String messageID = getMessageID();
                if (messageID == null) {
                    createInitialMessage(channel);
                } else if (!messageExists(channel, messageID)) {
                    createInitialMessage(channel);
                } else {
                    updateEmbed(channel, messageID);
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
