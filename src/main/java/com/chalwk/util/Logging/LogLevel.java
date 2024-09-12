/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */
package com.chalwk.util.Logging;

public enum LogLevel {
    SEVERE(0),   // Most severe level, indicating a serious failure.
    WARNING(1),  // Indicates a potential problem.
    INFO(2),     // Informational messages that highlight the progress of the application.
    CONFIG(3),   // Configuration messages.
    FINE(4),     // Fine-grained informational events.
    FINER(5),    // Finer-grained informational events.
    FINEST(6),   // Finest-grained informational events.
    ALL(7);      // All levels, intended to turn on all logging.

    // The integer value associated with the log level.
    private final int levelValue;

    /**
     * Constructor to initialize the log level with its associated integer value.
     *
     * @param value The integer value representing the log level.
     */
    LogLevel(int value) {
        this.levelValue = value;
    }

    /**
     * Gets the integer value associated with the log level.
     *
     * @return The integer value of the log level.
     */
    public int getValue() {
        return levelValue;
    }
}
