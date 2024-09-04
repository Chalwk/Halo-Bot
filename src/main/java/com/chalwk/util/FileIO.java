/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Logging.Logger;
import org.json.JSONObject;

import java.io.*;

public class FileIO {

    static String programPath = getProgramPath();

    private static String getProgramPath() {
        String currentDirectory = System.getProperty("user.dir");
        currentDirectory = currentDirectory.replace("\\", "/");
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

        File file = new File(programPath + fileName);
        checkExists(file);

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line = reader.readLine();

        StringBuilder content = new StringBuilder();
        while (line != null) {
            content.append(line);
            line = reader.readLine();
        }
        reader.close();

        return content.toString();
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

    public static JSONObject getJSONObject(String fileName) throws IOException {
        String content = readFile(fileName);
        if (content.isEmpty()) {
            return new JSONObject();
        } else {
            return new JSONObject(content);
        }
    }
}
