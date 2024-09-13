@echo off
set VERSION=1.4.0
set JAR_FILE_NAME=HaloBot-%VERSION%.jar
color 0A
echo Halo Discord Bot version: %VERSION%
echo Running bot...
color 0C
java -Xms512m -Xmx1024m -jar %JAR_FILE_NAME%
color
pause
