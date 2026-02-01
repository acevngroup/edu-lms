@echo off
setlocal

REM Get the directory of this script, then go to the moodle-docker directory.
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%..\moodle-docker"

echo Stopping Moodle Docker Compose...

REM IMPORTANT: The 'bin/moodle-docker-compose' is a bash script (.sh).
REM This will only work if 'bash.exe' is in your system's PATH
REM (e.g., from Git Bash, Cygwin, or WSL).
REM If not, you might need to specify the full path to your bash executable,
REM e.g., "C:\Program Files\Git\bin\bash.exe" bin\moodle-docker-compose down
REM Or for WSL: wsl bash bin/moodle-docker-compose down

bin\moodle-docker-compose down

endlocal