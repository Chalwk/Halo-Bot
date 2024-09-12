/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */
package com.chalwk.util.Logging;

import java.io.PrintStream;
import java.util.Date;

/**
 * A simple logging utility that logs messages to the console.
 * This class provides various methods to log messages at different levels of severity.
 * The log messages are printed to the console with a timestamp.
 */

public class Logger {

    // The PrintStream to which log messages will be written.
    private static final PrintStream stream = System.err;

    // The current log level. Only messages at this level or higher will be logged.
    private static LogLevel logLevel = LogLevel.WARNING;

    /**
     * Sets the log level. Only messages at this level or higher will be logged.
     *
     * @param level The log level to set.
     */
    public static void setLogLevel(LogLevel level) {
        logLevel = level;
    }

    /**
     * Logs a message at the specified log level.
     *
     * @param level   The log level of the message.
     * @param message The message to log.
     */
    public static void log(LogLevel level, String message) {
        if (level.getValue() >= logLevel.getValue()) {
            log(level.name() + " - " + message);
        }
    }

    /**
     * Logs a severe message.
     *
     * @param message The message to log.
     */
    public static void severe(String message) {
        log(LogLevel.SEVERE, message);
    }

    /**
     * Logs a warning message.
     *
     * @param message The message to log.
     */
    public static void warning(String message) {
        log(LogLevel.WARNING, message);
    }

    /**
     * Logs an informational message.
     *
     * @param message The message to log.
     */
    public static void info(String message) {
        log(LogLevel.INFO, message);
    }

    /**
     * Logs a configuration message.
     *
     * @param message The message to log.
     */
    public static void config(String message) {
        log(LogLevel.CONFIG, message);
    }

    /**
     * Logs a fine-grained informational message.
     *
     * @param message The message to log.
     */
    public static void fine(String message) {
        log(LogLevel.FINE, message);
    }

    /**
     * Logs a finer-grained informational message.
     *
     * @param message The message to log.
     */
    public static void finer(String message) {
        log(LogLevel.FINER, message);
    }

    /**
     * Logs the finest-grained informational message.
     *
     * @param message The message to log.
     */
    public static void finest(String message) {
        log(LogLevel.FINEST, message);
    }

    /**
     * Logs a message to the console with a timestamp.
     *
     * @param message The message to log.
     */
    private static void log(String message) {
        stream.println(new Date() + " - " + message);
    }
}
