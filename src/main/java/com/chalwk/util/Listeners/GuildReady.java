/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util.Listeners;


import com.chalwk.util.StatusMonitor;
import net.dv8tion.jda.api.events.guild.GuildReadyEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.jetbrains.annotations.NotNull;

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

        System.out.println("Connected to " + event.getGuild().getName());
        System.out.println(logo);

        try {
            new StatusMonitor(event);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}