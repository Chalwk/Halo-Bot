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

    // File name for storing message IDs.
    public static final String MESSAGE_ID_FILE = "message-ids.json";
    // File name for storing Halo events.
    public static final String HALO_EVENTS_FILE = "halo-events.json";
    // Formatter for date and time in the pattern "dd-MM-yyyy | HH:mm:ss".
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy | HH:mm:ss");

    /**
     * Checks if a message with the specified ID exists in the given text channel.
     *
     * @param channel   The text channel to check for the message.
     * @param messageID The ID of the message to check.
     * @return true if the message exists, false otherwise.
     */
    static boolean messageExists(TextChannel channel, String messageID) {
        try {
            return channel.retrieveMessageById(messageID).complete() != null;
        } catch (ErrorResponseException e) {
            return false;
        }
    }

    /**
     * Gets the current timestamp formatted as "dd-MM-yyyy | HH:mm:ss".
     *
     * @return The formatted current timestamp.
     */
    static String getTimestamp() {
        return LocalDateTime.now().format(FORMATTER);
    }

    /**
     * Creates an EmbedBuilder message from the provided JSON data.
     *
     * @param data The JSON object containing the data for the embed message.
     * @return An EmbedBuilder object with the specified title, description, color, and fields.
     */
    static EmbedBuilder createEmbedMessage(JSONObject data) {

        // Extract title, description, and color from the JSON data.
        String title = data.optString("title", "N/A");
        String description = data.optString("description", "N/A");
        String colorName = data.optString("color", "0x00FF00");

        // Convert the color name to a Color object.
        Color color = ColorName.fromName(colorName);
        String timestamp = getTimestamp();

        // Create and configure the EmbedBuilder.
        EmbedBuilder embed = new EmbedBuilder();
        embed.setTitle(title)
                .setDescription(description)
                .setColor(color)
                .setFooter("Last updated: " + timestamp, null);

        // Add fields to the embed if they exist in the JSON data.
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

    /**
     * Retrieves a TextChannel by its ID from the specified guild.
     *
     * @param channelID The ID of the text channel to retrieve.
     * @param guild     The guild (server) from which to retrieve the text channel.
     * @param serverID  The ID of the server for logging purposes.
     * @return The TextChannel object corresponding to the specified ID.
     * @throws IllegalArgumentException if the text channel is not found in the guild.
     */
    private static TextChannel getTextChannel(String channelID, Guild guild, String serverID) {
        TextChannel channel = guild.getTextChannelById(channelID);
        if (channel == null) {
            throw new IllegalArgumentException("[getTextChannel()] Channel not found: [" + channelID + "] (Server ID: " + serverID + ")");
        }
        return channel;
    }

    /**
     * Sends a message to a specified text channel in a guild.
     *
     * @param title       The title of the message.
     * @param description The description of the message.
     * @param colorName   The name of the color to be used for the message embed.
     * @param channelID   The ID of the text channel where the message will be sent.
     * @param guild       The guild (server) where the text channel is located.
     * @param serverID    The ID of the server for logging purposes.
     * @throws IllegalArgumentException if there is an error sending the message.
     */
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
