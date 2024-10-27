package com.chalwk.util;

import com.chalwk.util.Logging.Logger;
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
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import static com.chalwk.util.Helpers.*;

public class ServerMonitor {

    /**
     * Constructs a new ServerMonitor instance and schedules a task to run at a fixed rate.
     *
     * @param event The GuildReadyEvent that triggers the server monitor.
     * @throws IOException If an I/O error occurs.
     */
    public ServerMonitor(GuildReadyEvent event) throws IOException {
        // Create a CloseableScheduledExecutorService with a single-threaded scheduled executor.
        CloseableScheduledExecutorService scheduler = new CloseableScheduledExecutorService(Executors.newScheduledThreadPool(1));

        // Create a CloseableExecutorService with a cached thread pool executor.
        CloseableExecutorService executorService = new CloseableExecutorService(Executors.newCachedThreadPool());

        // Get the ExecutorService from the CloseableExecutorService.
        ExecutorService executor = executorService.executorService;

        // Create a new Task instance with the event and executor.
        Task task = new Task(event, executor);

        // Schedule the task to run at a fixed rate of every 2 seconds, with no initial delay.
        scheduler.scheduleAtFixedRate(task, 0, 2, TimeUnit.SECONDS);
    }

    /**
     * Updates the server status by sending or editing a message in the specified text channel.
     *
     * @param serverID    The ID of the server whose status is being updated.
     * @param parentTable The JSON object containing the server status information.
     * @param messageIDs  The JSON object containing the message IDs for each server.
     * @param guild       The guild (server) where the status update is being performed.
     */
    private static void updateServerStatus(String serverID, JSONObject parentTable, JSONObject messageIDs, Guild guild) {
        // Map to cache text channels by their IDs.
        Map<String, TextChannel> channelMap = new HashMap<>();

        // Retrieve the status information for the specified server.
        JSONObject status = parentTable.getJSONObject(serverID).getJSONObject("status");
        String statusChannelID = status.getString("channel");

        // Get or create the text channel for the status updates.
        channelMap.computeIfAbsent(statusChannelID, id -> Optional.ofNullable(guild.getTextChannelById(id)).orElseThrow(
                () -> new IllegalArgumentException("Channel not found: [" + id + "] (Server ID: " + serverID + ")")));

        TextChannel statusTextChannel = channelMap.get(statusChannelID);
        EmbedBuilder embed = createEmbedMessage(status);

        // Retrieve the message ID for the server status update.
        String messageID = messageIDs.optString(serverID, null);
        if (messageID == null || !messageExists(statusTextChannel, messageID)) {
            // Send a new message if no message ID exists or the message does not exist.
            Message message = statusTextChannel.sendMessageEmbeds(embed.build()).complete();
            messageIDs.put(serverID, message.getId());
            FileIO.saveJSONObjectToFile(messageIDs, MESSAGE_ID_FILE);
        } else {
            // Edit the existing message if it exists.
            statusTextChannel.retrieveMessageById(messageID).queue(message -> message.editMessageEmbeds(embed.build()).queue());
        }
    }

    /**
     * Sends event notifications for a specific server.
     *
     * @param serverID       The ID of the server for which events are being sent.
     * @param events         A JSON array containing the events to be sent.
     * @param updatedServers A set of server IDs that have been updated.
     */
    private static void sendEventNotification(String serverID, JSONArray events, Set<String> updatedServers, Guild guild) {
        for (Object o : events) {
            JSONObject event = (JSONObject) o;

            // Extract event details.
            String title = event.getString("title");
            String description = event.getString("description");
            String channelID = event.getString("channel");
            String color = event.getString("color");

            // Send the event message.
            sendMessage(title, description, color, channelID, guild, serverID);

            // Mark the server as updated.
            updatedServers.add(serverID);
        }

        // Clear the events after sending notifications.
        events.clear();
    }

    /**
     * A wrapper for ScheduledExecutorService that implements AutoCloseable.
     * This allows the service to be used in try-with-resources statements.
     */
    private record CloseableScheduledExecutorService(ScheduledExecutorService scheduler) implements AutoCloseable {

        /**
         * Schedules a task to run at a fixed rate.
         *
         * @param task         The task to be scheduled.
         * @param initialDelay The time to delay first execution.
         * @param period       The period between successive executions.
         * @param unit         The time unit of the initialDelay and period parameters.
         */
        public void scheduleAtFixedRate(Runnable task, long initialDelay, long period, TimeUnit unit) {
            scheduler.scheduleAtFixedRate(task, initialDelay, period, unit);
        }

        /**
         * Shuts down the ScheduledExecutorService.
         */
        @Override
        public void close() {
            scheduler.shutdown();
        }
    }

    /**
     * A wrapper for ExecutorService that implements AutoCloseable.
     * This allows the service to be used in try-with-resources statements.
     */
    private record CloseableExecutorService(ExecutorService executorService) implements AutoCloseable {

        /**
         * Shuts down the ExecutorService.
         */
        @Override
        public void close() {
            executorService.shutdown();
        }
    }

    private static class Task implements Runnable {

        private final Guild guild;
        private final ExecutorService executorService;

        public Task(GuildReadyEvent event, ExecutorService executorService) {
            this.guild = event.getGuild();
            this.executorService = executorService;
        }

        @Override
        public void run() {

            JSONObject servers;
            JSONObject messageIDs;

            try {
                // Load the server and message ID data from JSON files.
                servers = FileIO.getJSONObjectFromFile(HALO_EVENTS_FILE);
                messageIDs = FileIO.getJSONObjectFromFile(MESSAGE_ID_FILE);
            } catch (IOException e) {
                // Log a warning if there is an error reading the JSON files.
                Logger.warning("Error reading JSON file: " + e.getMessage());
                return;
            }

            // Set to keep track of updated servers.
            Set<String> updatedServers = new HashSet<>();
            for (String serverID : servers.keySet()) {

                // Submit a task to update the server status.
                executorService.execute(() -> updateServerStatus(serverID, servers, messageIDs, guild));

                // Retrieve the events for the server and send notifications.
                JSONArray events = servers.getJSONObject(serverID).getJSONArray("sapp_events");
                sendEventNotification(serverID, events, updatedServers, guild);
            }

            // Save the updated server data if any servers were updated.
            if (!updatedServers.isEmpty()) {
                FileIO.saveJSONObjectToFile(servers, HALO_EVENTS_FILE);
            }
        }
    }
}