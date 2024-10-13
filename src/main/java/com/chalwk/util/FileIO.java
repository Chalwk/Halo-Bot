package com.chalwk.util;

import com.chalwk.util.Logging.Logger;
import org.json.JSONObject;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileIO {

    // Path to the program's directory.
    static String programPath = getProgramPath();

    // Default constructor for FileIO.
    public FileIO() {

    }

    /**
     * Retrieves the program's path.
     *
     * @return The program's path as a String.
     */
    private static String getProgramPath() {
        String currentDirectory = System.getProperty("user.dir").replace("\\", "/");
        return currentDirectory.endsWith("/Halo-Bot") ? currentDirectory : currentDirectory + "/Halo-Bot/";
    }

    /**
     * Constructs a Path object for the given file name.
     *
     * @param fileName The name of the file.
     * @return The Path object for the specified file.
     */
    private static Path getFilePath(String fileName) {
        return Paths.get(programPath, fileName);
    }

    /**
     * Reads the content of a file as a String.
     *
     * @param fileName The name of the file to read.
     * @return The content of the file as a String.
     * @throws IOException If an I/O error occurs reading from the file.
     */
    public static String readFile(String fileName) throws IOException {
        Path filePath = getFilePath(fileName);
        if (!Files.exists(filePath)) {
            Files.createFile(filePath);
        }

        byte[] contentBytes = Files.readAllBytes(filePath);

        return new String(contentBytes, StandardCharsets.UTF_8);
    }

    /**
     * Saves a JSONObject to a file.
     *
     * @param jsonObject The JSONObject to save.
     * @param fileName   The name of the file to save the JSONObject to.
     */
    public static void saveJSONObjectToFile(JSONObject jsonObject, String fileName) {
        try {
            Files.writeString(getFilePath(fileName), jsonObject.toString(4), StandardCharsets.UTF_8);
        } catch (IOException e) {
            Logger.info("Error saving JSONObject to file");
        }
    }

    /**
     * Retrieves a JSONObject from a file.
     *
     * @param fileName The name of the file to read the JSONObject from.
     * @return The JSONObject read from the file.
     * @throws IOException If an I/O error occurs reading from the file.
     */
    public static JSONObject getJSONObjectFromFile(String fileName) throws IOException {
        String content = readFile(fileName);
        return content.isEmpty() ? new JSONObject() : new JSONObject(content);
    }
}