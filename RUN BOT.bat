@echo off
set JAR_FILE_NAME=HaloBot-1.1.0.jar
color 0A
echo Halo Discord Bot version: 1.0.0
echo Running bot...
color 0C
java -Xms512m -Xmx1024m -jar %JAR_FILE_NAME%
color
pause
