/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Logging.Logger;
import org.json.JSONObject;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileIO {

    static String programPath = getProgramPath();

    public FileIO() {

    }

    private static String getProgramPath() {
        String currentDirectory = System.getProperty("user.dir");
        currentDirectory = currentDirectory.replace("\\", "/");

        // This is for when the program is run from the IDE:
        if (currentDirectory.endsWith("/Halo-Bot")) {
            return currentDirectory + "/";
        }

        return currentDirectory + "/Halo-Bot/";
    }

    private static void checkExists(File file) throws IOException {
        boolean exists = file.exists();
        if (!exists) {
            boolean created = file.createNewFile();
            if (!created) {
                throw new IOException("Failed to create file: " + file.getAbsolutePath());
            }
        }
    }

    public static String readFile(String fileName) throws IOException {
        Path filePath = Paths.get(programPath, fileName);
        checkExists(filePath.toFile());

        byte[] contentBytes = Files.readAllBytes(filePath);

        return new String(contentBytes, StandardCharsets.UTF_8);
    }

    public static void saveJSONObjectToFile(JSONObject jsonObject, String fileName) {
        try {
            FileWriter file = new FileWriter(programPath + fileName);
            file.write(jsonObject.toString(4));
            file.flush();
            file.close();
        } catch (IOException e) {
            Logger.info("Error saving JSONObject to file: " + e.getMessage());
        }
    }

    public static JSONObject getJSONObjectFromFile(String fileName) throws IOException {
        String content = readFile(fileName);
        if (content.isEmpty()) {
            return new JSONObject();
        } else {
            return new JSONObject(content);
        }
    }
}
