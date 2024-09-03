/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Enums.StatusField;
import com.chalwk.util.Logging.Logger;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import org.jetbrains.annotations.Nullable;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import static com.chalwk.util.Listeners.GuildReady.getGuild;
import static java.time.LocalTime.now;

public class StatusMonitor {

    private static final ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
    private static String serverID;

    public StatusMonitor(String serverName, int intervalInSeconds) {
        serverID = serverName;
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new StatusUpdaterTask(), 1000 * 10, intervalInSeconds * 1000L);
    }

    private static EmbedBuilder createEmbedMessage(JSONObject data) {
        EmbedBuilder embed = new EmbedBuilder();
        embed.setTitle("Server Status");
        embed.setFooter("Last updated: " + now(), null);

        for (StatusField field : StatusField.values()) {
            embed.addField(field.getFieldName(), getFieldValue(data, field), false);
        }

        return embed;
    }

    private static String getFieldValue(JSONObject data, StatusField field) {
        if (Objects.requireNonNull(field) == StatusField.PLAYER_LIST) {
            JSONArray playerList = data.getJSONArray(field.getFieldName());
            StringBuilder players = new StringBuilder();
            for (int i = 0; i < playerList.length(); i++) {
                players.append(playerList.getString(i)).append("\n");
            }
            return players.toString();
        }
        return data.getString(field.getFieldName());
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
            if (channel == null) return;

            try {
                String messageID = getMessageID();
                if (messageID == null || !messageExists(channel, messageID)) {
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
                    channelIDs = FileIO.getJSONObject("message-ids.json");
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
                channelIDs.put(serverID, messageID);
                FileIO.saveJSONObjectToFile(channelIDs, "message-ids.json");
            }, 1000, TimeUnit.MILLISECONDS);
        }

        private boolean messageExists(TextChannel channel, String messageID) {
            return channel.retrieveMessageById(messageID).complete() != null;
        }

        @Nullable
        private TextChannel getTextChannel(JSONObject serverTable) {
            Guild guild = getGuild();
            String channelID = serverTable.getJSONObject("status").getString("CHANNEL_ID");
            TextChannel channel = guild.getTextChannelById(channelID);
            if (channel == null) {
                Logger.severe("Channel not found: " + channelID);
                return null;
            }
            return channel;
        }

        private String getMessageID() throws IOException {
            JSONObject channelIDs = FileIO.getJSONObject("message-ids.json");
            if (channelIDs.has(serverID) && !channelIDs.getString(serverID).isEmpty()) {
                return channelIDs.getString(serverID);
            } else {
                return null;
            }
        }
    }
}
