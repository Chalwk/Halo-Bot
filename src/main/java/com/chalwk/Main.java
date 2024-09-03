/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */
package com.chalwk;

import com.chalwk.bot.BotInitializer;

import java.io.IOException;

public class Main {

    public static void main(String[] args) {
        try {
            new BotInitializer().initializeBot();
        } catch (IOException e) {
            System.err.println("Error reading token or initializing the bot: " + e.getMessage());
        }
    }
}