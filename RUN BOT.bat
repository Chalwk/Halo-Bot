@echo off

:: Set current directory to the batch file's directory
cd "%~dp0"

:: Get current timestamp
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=%datetime:~0,8%-%datetime:~8,6%

:: Create log file with timestamp
echo ===========================>> run_%datetime%.log
echo Starting bot...>> run_%datetime%.log
date /t >> run_%datetime%.log
time /t >> run_%datetime%.log
echo ===========================>> run_%datetime%.log

:: Run Java JAR file
start "bot" java -jar HaloBot-1.0.0.jar 2>> run_%datetime%.log

:: Check for errors
if %ERRORLEVEL% NEQ 0 (
    echo ===========================>> run_%datetime%.log
    echo Error: Failed to start bot!>> run_%datetime%.log
    echo ===========================>> run_%datetime%.log
    pause
    exit /b 1
)

echo ===========================>> run_%datetime%.log
echo Bot started successfully!>> run_%datetime%.log
echo ===========================>> run_%datetime%.log