/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import org.json.JSONObject;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Helpers {

    public static final String messageIDFile = "message-ids.json";

    static boolean messageExists(StatusInfo status, String messageID) {
        return status.channel.retrieveMessageById(messageID).complete() != null;
    }

    static JSONObject getChannelIds() {
        try {
            return FileIO.getJSONObjectFromFile(messageIDFile);
        } catch (IOException e) {
            throw new IllegalStateException("Error reading channel IDs: " + e.getMessage());
        }
    }

    static String getMessageID(String serverID) {
        JSONObject channelIDs = Helpers.getChannelIds();
        return channelIDs.has(serverID) && !channelIDs.getString(serverID).isEmpty() ? channelIDs.getString(serverID) : null;
    }

    static String getTimestamp() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyy | HH:mm:ss");
        return now.format(formatter);
    }
}
