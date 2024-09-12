/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util.Listeners;


import com.chalwk.util.ServerMonitor;
import net.dv8tion.jda.api.events.guild.GuildReadyEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.jetbrains.annotations.NotNull;

import java.io.IOException;

public class GuildReady extends ListenerAdapter {

    // ASCII art logo to be displayed when the guild is ready.
    private static final String logo = """
            '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|
             ||    ||     |||     ||       .|'    ||        .|'     '   ||  .
             ||''''||    |  ||    ||       ||      ||       ||          ||''|
             ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||
            .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....|""";

    @Override
    public void onGuildReady(@NotNull GuildReadyEvent event) {

        // Print the name of the connected guild to the console.
        System.out.println("Connected to " + event.getGuild().getName());

        // Print the ASCII art logo to the console.
        System.out.println(logo);

        try {
            // Initialize the ServerMonitor with the event.
            new ServerMonitor(event);
        } catch (IOException e) {
            // Throw a RuntimeException if an IOException occurs.
            throw new RuntimeException(e);
        }
    }
}