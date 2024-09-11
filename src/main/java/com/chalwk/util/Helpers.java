/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Enums.ColorName;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import net.dv8tion.jda.api.exceptions.ErrorResponseException;
import org.json.JSONArray;
import org.json.JSONObject;

import java.awt.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Helpers {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy | HH:mm:ss");

    public static final String MESSAGE_ID_FILE = "message-ids.json";
    public static final String HALO_EVENTS_FILE = "halo-events.json";

    static boolean messageExists(TextChannel channel, String messageID) {
        try {
            return channel.retrieveMessageById(messageID).complete() != null;
        } catch (ErrorResponseException e) {
            return false;
        }
    }

    static String getTimestamp() {
        return LocalDateTime.now().format(FORMATTER);
    }

    static EmbedBuilder createEmbedMessage(JSONObject data) {

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
            for (Object o : fields) {
                JSONObject field = (JSONObject) o;
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

    static void sendMessage(String title, String description, String colorName, String channelID, Guild guild, String serverID) {
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
}
