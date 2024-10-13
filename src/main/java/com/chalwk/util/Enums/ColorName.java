/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util.Enums;

import java.awt.*;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

public enum ColorName {
    RED(Color.RED),
    BLUE(Color.BLUE),
    GREEN(Color.GREEN),
    YELLOW(Color.YELLOW),
    ORANGE(Color.ORANGE),
    CYAN(Color.CYAN),
    MAGENTA(Color.MAGENTA),
    PINK(Color.PINK),
    WHITE(Color.WHITE),
    BLACK(Color.BLACK),
    GRAY(Color.GRAY),
    DARK_GRAY(Color.DARK_GRAY),
    LIGHT_GRAY(Color.LIGHT_GRAY);

    // A static map to store the mapping between color names and their corresponding NamedColor enum values.
    private static final Map<String, ColorName> colorMap = new HashMap<>();

    // Static block to initialize the colorMap with color names as keys and NamedColor enum values as values.
    static {
        for (ColorName color : ColorName.values()) {
            colorMap.put(color.name().toLowerCase(), color);
        }
    }

    // Instance variable to store the Color object for each enum value.
    private final Color color;

    /**
     * Constructor to initialize the enum values with their corresponding Color object.
     *
     * @param color The `java.awt.Color` object representing the color.
     */
    ColorName(Color color) {
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
        ColorName namedColor = colorMap.get(name.toLowerCase());
        return namedColor == null ? Color.GRAY : namedColor.getColor();
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
