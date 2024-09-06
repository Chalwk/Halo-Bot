/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util.Listeners;

import com.chalwk.util.EventProcessingTask;
import com.chalwk.util.FileIO;
import com.chalwk.util.StatusMonitor;
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.events.guild.GuildReadyEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

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
        try {
            processHaloData(event);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void processHaloData(GuildReadyEvent event) throws IOException {

        System.out.println("====================================================================");
        System.out.println(logo);

        Guild guild = event.getGuild();
        JSONObject parentTable = FileIO.getJSONObjectFromFile("halo-events.json");

        int count = 0;

        for (String serverID : parentTable.keySet()) {
            if (!monitoredServers.contains(serverID)) {
                new StatusMonitor(serverID, 30, guild);
                new EventProcessingTask(serverID, 1, guild);
                monitoredServers.add(serverID);
                count++;
            }
        }
        String plural = count > 1 ? "s" : "";
        System.out.println("Monitoring " + count + " Halo server" + plural + " on " + guild.getName());
        System.out.println("====================================================================");
    }
}