@echo off
setlocal

REM Get the directory of this script, then go to the Devrepo root.
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%.."

REM Define the path to the main .env file in Devrepo root
set "ENV_FILE=%CD%\.env"

if not exist "%ENV_FILE%" (
    echo ERROR: .env file not found at %ENV_FILE%
    echo Please create Devrepo/.env with your Moodle Docker configuration.
    pause
    exit /b 1
)

echo Loading environment variables from %ENV_FILE%

REM Read .env file line by line and set environment variables for current session
for /f "usebackq tokens=*" %%a in ("%ENV_FILE%") do (
    call :ProcessLine "%%a"
)

echo Environment variables loaded.

echo Starting Moodle Docker Compose...

REM Change directory to moodle-docker to run its compose command
cd /d "%CD%\moodle-docker"

REM IMPORTANT: The 'bin/moodle-docker-compose' is a bash script (.sh).
REM This will only work if 'bash.exe' is in your system's PATH
REM (e.g., from Git Bash, Cygwin, or WSL).
REM If not, you might need to specify the full path to your bash executable,
REM e.g., "C:\Program Files\Git\bin\bash.exe" bin\moodle-docker-compose up -d
REM Or for WSL: wsl bash bin/moodle-docker-compose up -d

bin\moodle-docker-compose up -d

REM End of main script
goto :eof

REM Subroutine to process each line from the .env file
:ProcessLine
set "LINE=%~1"
REM Skip empty lines or comments (lines starting with #)
if "%LINE%"=="" goto :eof
if "%LINE:~0,1%"=="#" goto :eof

REM Split the line at the first '=' to get KEY and VALUE
for /f "tokens=1* delims==" %%i in ("%LINE%") do (
    set "KEY=%%i"
    set "VALUE=%%j"
    
    REM Normalize MOODLE_DOCKER_WWWROOT: replace backslashes with forward slashes
    if /i "%KEY%"=="MOODLE_DOCKER_WWWROOT" (
        set "VALUE=!VALUE:\=/!"
    )
    
    REM Set the environment variable
    set "%KEY%=%VALUE%"
)
goto :eof

endlocal