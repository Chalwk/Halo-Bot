/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */
package com.chalwk;

import com.chalwk.bot.BotInitializer;

import java.io.IOException;

public class Main {

    /**
     * The main entry point of the application.
     *
     * @param args Command-line arguments passed to the application.
     */
    public static void main(String[] args) {
        try {
            // Initialize the bot using the BotInitializer class.
            new BotInitializer().initializeBot();
        } catch (IOException e) {
            // Print an error message if there is an issue reading the token or initializing the bot.
            System.err.println("Error reading token or initializing the bot: " + e.getMessage());
        }
    }
}
