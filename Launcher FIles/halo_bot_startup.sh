#!/bin/sh
# Halo Discord Bot startup script for Linux systems

# Set the JAR file name
JAR_FILE_NAME="HaloBot-1.4.0.jar"

# Run the bot using Java with specified memory limits
java -Xms512m -Xmx1024m -jar $JAR_FILE_NAME

# Wait for user input before exiting the script
read -n 1 -s -r -p "Press any key to continue..."