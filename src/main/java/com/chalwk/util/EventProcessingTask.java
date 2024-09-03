/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;

public class EventProcessingTask {

    private static final String messageIDFile = "message-ids.json";
    private static JSONObject serverTable;
    private static String serverID;

    public EventProcessingTask(JSONObject serverTable, int intervalInSeconds, String serverID) {

        EventProcessingTask.serverTable = serverTable;
        EventProcessingTask.serverID = serverID;

        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new EventProcessingTask.Task(), 1000 * 10, intervalInSeconds * 1000L);
    }

    private static class Task extends TimerTask {

        @Override
        public void run() {

        }
    }
}
