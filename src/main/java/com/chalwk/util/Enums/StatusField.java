/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util.Enums;

public enum StatusField {

    SERVER_NAME("Server Name"),
    MAP("Map"),
    MODE("Mode"),
    TOTAL_PLAYERS("Total Players"),
    PLAYER_LIST("Player List");

    private final String fieldName;

    StatusField(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getFieldName() {
        return fieldName;
    }
}
