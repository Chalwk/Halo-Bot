/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util.Enums;

import java.awt.*;
import java.util.HashMap;
import java.util.Map;

public enum ColorName {
    RED("RED", Color.RED),
    BLUE("BLUE", Color.BLUE),
    GREEN("GREEN", Color.GREEN),
    YELLOW("YELLOW", Color.YELLOW),
    ORANGE("ORANGE", Color.ORANGE),
    CYAN("CYAN", Color.CYAN),
    MAGENTA("MAGENTA", Color.MAGENTA),
    PINK("PINK", Color.PINK),
    WHITE("WHITE", Color.WHITE),
    BLACK("BLACK", Color.BLACK),
    GRAY("GRAY", Color.GRAY),
    DARK_GRAY("DARK_GRAY", Color.DARK_GRAY),
    LIGHT_GRAY("LIGHT_GRAY", Color.LIGHT_GRAY);

    private static final Map<String, ColorName> colorMap = new HashMap<>();

    static {
        for (ColorName colorName : ColorName.values()) {
            colorMap.put(colorName.name.toLowerCase(), colorName);
        }
    }

    private final String name;
    private final Color color;

    ColorName(String name, Color color) {
        this.name = name;
        this.color = color;
    }

    public static Color fromName(String name) {
        ColorName colorName = colorMap.get(name.toLowerCase());
        return colorName == null ? Color.GRAY : colorName.getColor();
    }

    public Color getColor() {
        return color;
    }
}
