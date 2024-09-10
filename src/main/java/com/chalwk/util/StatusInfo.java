/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import org.json.JSONObject;

import java.io.IOException;

class StatusInfo {

    TextChannel channel;
    JSONObject status;

    StatusInfo(TextChannel channel, JSONObject status) {
        this.channel = channel;
        this.status = status;
    }

    public static StatusInfo getStatus(String serverID, Guild guild) throws IOException {

        JSONObject parentTable = FileIO.getJSONObjectFromFile("halo-events.json");
        if (!parentTable.has(serverID)) {
            return null;
        }

        JSONObject status = parentTable.getJSONObject(serverID).getJSONObject("status");
        String channelID = status.getString("channel");
        TextChannel channel = guild.getTextChannelById(channelID);
        if (channel == null) {
            throw new IllegalArgumentException("Channel not found: " + channelID);
        }

        return new StatusInfo(channel, status);
    }
}
