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

    // A static map to store the mapping between color names and their corresponding ColorName enum values.
    private static final Map<String, ColorName> colorMap = new HashMap<>();

    // Static block to initialize the colorMap with color names as keys and ColorName enum values as values.
    static {
        for (ColorName colorName : ColorName.values()) {
            colorMap.put(colorName.name.toLowerCase(), colorName);
        }
    }

    // Instance variables to store the name and Color object for each enum value.
    private final String name;
    private final Color color;

    /**
     * Constructor to initialize the enum values with their corresponding name and Color object.
     *
     * @param name  The name of the color.
     * @param color The `java.awt.Color` object representing the color.
     */
    ColorName(String name, Color color) {
        this.name = name;
        this.color = color;
    }

    /**
     * Retrieves the `Color` object corresponding to the given color name.
     * If the color name is not found, it returns `Color.GRAY` as the default color.
     *
     * @param name The name of the color.
     * @return The `java.awt.Color` object corresponding to the given color name.
     */
    public static Color fromName(String name) {
        ColorName colorName = colorMap.get(name.toLowerCase());
        return colorName == null ? Color.GRAY : colorName.getColor();
    }

    /**
     * Gets the `Color` object associated with this enum value.
     *
     * @return The `java.awt.Color` object.
     */
    public Color getColor() {
        return color;
    }
}
