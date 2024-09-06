/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;

import static com.chalwk.util.Listeners.GuildReady.getGuild;

public class util {

    public static TextChannel getTextChannel(String channelID) {
        Guild guild = getGuild();
        TextChannel channel = guild.getTextChannelById(channelID);
        if (channel == null) {
            throw new IllegalArgumentException("[EventProcessing Task] Channel not found: " + channelID);
        }
        return channel;
    }
}
