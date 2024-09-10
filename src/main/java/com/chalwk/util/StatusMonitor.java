/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Enums.ColorName;
import com.chalwk.util.Logging.Logger;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.Message;
import org.json.JSONArray;
import org.json.JSONObject;

import java.awt.*;
import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

import static com.chalwk.util.Helpers.*;
import static com.chalwk.util.StatusInfo.getStatus;

public class StatusMonitor {

    public StatusMonitor(String serverID, int intervalInSeconds, Guild guild) {
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new Task(guild, serverID), 0, intervalInSeconds * 1000L);
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

    private static void updateEmbed(StatusInfo serverStatus, String messageID) throws IOException {
        EmbedBuilder embed = createEmbedMessage(serverStatus.status);
        serverStatus.channel.retrieveMessageById(messageID)
                .queue(message -> message.editMessageEmbeds(embed.build()).queue());
    }

    private static void createInitialMessage(StatusInfo serverStatus, String serverID) throws IOException {
        EmbedBuilder embed = createEmbedMessage(serverStatus.status);
        Message message = serverStatus.channel.sendMessageEmbeds(embed.build()).complete();

        JSONObject channelIDs = FileIO.getJSONObjectFromFile(messageIDFile);
        channelIDs.put(serverID, message.getId());

        FileIO.saveJSONObjectToFile(channelIDs, messageIDFile);
    }

    private static class Task extends TimerTask {

        private final Guild guild;
        private final String serverID;

        public Task(Guild guild, String serverID) {
            this.guild = guild;
            this.serverID = serverID;
        }

        @Override
        public void run() {
            try {

                StatusInfo serverStatus = getStatus(serverID, guild);
                if (serverStatus == null) {
                    return;
                }
                if (serverStatus.channel == null || serverStatus.status == null) {
                    cancel();
                    return;
                }

                String messageID = getMessageID(serverID);
                if (messageID == null || !messageExists(serverStatus, messageID)) {
                    createInitialMessage(serverStatus, serverID);
                } else {
                    updateEmbed(serverStatus, messageID);
                }
            } catch (IOException | RuntimeException e) {
                Logger.warning("Error updating status message: " + e.getMessage());
            }
        }
    }
}
