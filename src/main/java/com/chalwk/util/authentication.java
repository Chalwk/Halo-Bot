/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */
package com.chalwk.util;

import java.io.IOException;

import static com.chalwk.util.FileIO.readFile;

public class authentication {

    public static String getToken() throws IOException {
        String token = readFile("auth.token");
        if (token.isEmpty()) {
            throw new IOException("Failed to read authentication token from file. Please ensure the file exists and is not empty.");
        }
        return token;
    }
}