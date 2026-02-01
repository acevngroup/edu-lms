@echo off
setlocal

REM Get the directory of the batch file and change to it
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%moodle-docker"

REM Set environment variables for the current Command Prompt session
set "MOODLE_DOCKER_WWWROOT=C:/Workspace/Eduweb/moodle"
set "MOODLE_DOCKER_DB=pgsql"
set "MOODLE_DOCKER_WEB_PORT=8080"

echo Environment variables set:
echo MOODLE_DOCKER_WWWROOT=%MOODLE_DOCKER_WWWROOT%
echo MOODLE_DOCKER_DB=%MOODLE_DOCKER_DB%
echo MOODLE_DOCKER_WEB_PORT=%MOODLE_DOCKER_WEB_PORT%
echo.

echo Now running bin/moodle-docker-compose up -d...

REM IMPORTANT: The 'bin/moodle-docker-compose' is a bash script (.sh).
REM This will only work if 'bash.exe' is in your system's PATH
REM (e.g., from Git Bash, Cygwin, or WSL).
REM If not, you might need to specify the full path to your bash executable,
REM e.g., "C:\Program Files\Git\bin\bash.exe" bin\moodle-docker-compose up -d
REM Or for WSL: wsl bash bin/moodle-docker-compose up -d

bin\moodle-docker-compose up -d

endlocal