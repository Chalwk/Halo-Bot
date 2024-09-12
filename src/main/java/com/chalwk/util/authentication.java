package com.chalwk.util;

import java.io.IOException;

import static com.chalwk.util.FileIO.readFile;

public class authentication {

    /**
     * Retrieves the authentication token from the file.
     *
     * @return The authentication token as a String.
     * @throws IOException If an I/O error occurs reading the token or if the token is empty.
     */
    public static String getToken() throws IOException {
        String token = readFile("auth.token");
        if (token.isEmpty()) {
            throw new IOException("Failed to read authentication token from file. Please ensure the file exists and is not empty.");
        }
        return token;
    }
}