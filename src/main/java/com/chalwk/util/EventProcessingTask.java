/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import org.json.JSONArray;
import org.json.JSONObject;

import java.awt.*;
import java.util.Timer;
import java.util.TimerTask;

import static com.chalwk.util.Listeners.GuildReady.getGuild;

public class EventProcessingTask {

    private static JSONObject serverTable;

    public EventProcessingTask(JSONObject serverTable, int intervalInSeconds) {

        EventProcessingTask.serverTable = serverTable;

        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new EventProcessingTask.Task(), 1000 * 3, intervalInSeconds * 1000L);
    }

    private static JSONArray getEventTable() {
        return serverTable.getJSONArray("sapp_events");
    }

    private static TextChannel getTextChannel(String channelID) {
        Guild guild = getGuild();
        TextChannel channel = guild.getTextChannelById(channelID);
        if (channel == null) {
            throw new IllegalArgumentException("[EventProcessing Task] Channel not found: " + channelID);
        }
        return channel;
    }

    private static void sendMessage(String title, String description, String colorName, String channelID) {
        TextChannel channel = getTextChannel(channelID);
        channel.sendMessageEmbeds(new EmbedBuilder()
                .setTitle(title)
                .setDescription(description)
                .setColor(Color.getColor(colorName)).build()).queue();
    }

    private static class Task extends TimerTask {

        @Override
        public void run() {

            JSONArray eventTable = getEventTable();
            for (int i = 0; i < eventTable.length(); i++) {

                JSONObject event = eventTable.getJSONObject(i);
                String title = event.getString("title");
                String description = event.getString("description");
                String channelID = event.getString("channel");
                String color = event.getString("color");

                sendMessage(title, description, color, channelID);
            }
        }
    }
}
