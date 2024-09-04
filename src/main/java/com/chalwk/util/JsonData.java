/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import org.json.JSONArray;
import org.json.JSONObject;

public class JsonData {

    private final JSONObject parentTable;

    public JsonData(JSONObject parentTable) {
        this.parentTable = parentTable;
    }

    public JSONArray getEventTable(String serverKey) {
        return parentTable.getJSONObject(serverKey).getJSONArray("sapp_events");
    }

    public JSONObject getParentTable() {
        return parentTable;
    }
}