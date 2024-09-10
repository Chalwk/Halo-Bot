/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import net.dv8tion.jda.api.exceptions.ErrorResponseException;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Helpers {

    public static final String MESSAGE_ID_FILE = "message-ids.json";
    public static final String HALO_EVENTS_FILE = "halo-events.json";

    static boolean messageExists(TextChannel channel, String messageID) {
        try {
            return channel.retrieveMessageById(messageID).complete() != null;
        } catch (ErrorResponseException e) {
            return false;
        }
    }

    static String getTimestamp() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyy | HH:mm:ss");
        return now.format(formatter);
    }
}
