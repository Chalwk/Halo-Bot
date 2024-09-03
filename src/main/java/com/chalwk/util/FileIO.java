/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.util;

import com.chalwk.util.Logging.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;

public class FileIO {

    public static String readFile(String fileName) {

        StringBuilder content = new StringBuilder();
        InputStream inputStream = FileIO.class.getClassLoader().getResourceAsStream(fileName);

        try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream))) {
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                content.append(line);
            }
        } catch (IOException e) {
            Logger.info("Error reading file: " + e.getMessage());
        }

        return content.toString();
    }

    public static void saveJSONObjectToFile(JSONObject jsonObject, String fileName) {
        try {
            File file = new File(FileIO.class.getClassLoader().getResource(fileName).getFile());
            FileWriter fileWriter = new FileWriter(file);
            fileWriter.write(jsonObject.toString(4));
            fileWriter.flush();
        } catch (IOException e) {
            Logger.info("Error saving JSONObject to file: " + e.getMessage());
        }
    }

    public static JSONArray getJSONArray(String fileName) throws IOException {
        String content = readFile(fileName);
        if (content.isEmpty()) {
            return new JSONArray();
        } else {
            return new JSONArray(content);
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
