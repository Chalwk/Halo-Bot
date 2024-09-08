/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util.Listeners;

import com.chalwk.util.EventProcessingTask;
import com.chalwk.util.FileIO;
import com.chalwk.util.Logging.Logger;
import com.chalwk.util.StatusMonitor;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.events.guild.GuildReadyEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

public class GuildReady extends ListenerAdapter {

    private static final Set<String> monitoredServers = new HashSet<>();
    private static final String logo = """
            '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|
             ||    ||     |||     ||       .|'    ||        .|'     '   ||  .
             ||''''||    |  ||    ||       ||      ||       ||          ||''|
             ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||
            .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....|""";

    @Override
    public void onGuildReady(@NotNull GuildReadyEvent event) {
        scheduleHaloDataProcessing(event);

        System.out.println("Connected to " + event.getGuild().getName());
        System.out.println(logo);
    }

    private void scheduleHaloDataProcessing(GuildReadyEvent event) {
        Timer timer = new Timer();
        TimerTask haloDataTask = new TimerTask() {
            @Override
            public void run() {
                try {
                    processHaloData(event);
                } catch (IOException e) {
                    Logger.info("Error processing halo data: " + e.getMessage());
                }
            }
        };
        timer.scheduleAtFixedRate(haloDataTask, 1000 * 2, 1000 * 3);
    }

    private void processHaloData(GuildReadyEvent event) throws IOException {
        Guild guild = event.getGuild();
        JSONObject parentTable = FileIO.getJSONObjectFromFile("halo-events.json");

        for (String serverID : parentTable.keySet()) {
            if (!monitoredServers.contains(serverID)) {

                JSONObject serverData = parentTable.getJSONObject(serverID);
                int statusInterval = serverData.getInt("statusCheckInterval");
                int eventsInterval = serverData.getInt("eventCheckInterval");

                if (statusInterval > 0) {
                    new StatusMonitor(serverID, statusInterval, guild);
                }

                if (eventsInterval > 0) {
                    new EventProcessingTask(serverID, eventsInterval, guild);
                }

                monitoredServers.add(serverID);
            }
        }
    }
}