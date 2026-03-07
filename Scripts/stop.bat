@echo off
setlocal

REM Get the directory of this script, then go to the Devrepo root.
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%.."

REM Define the path to the main .env file in Devrepo root
set "ENV_FILE=%CD%\.env"

if not exist "%ENV_FILE%" (
    echo ERROR: .env file not found at %ENV_FILE%
    echo Cannot stop Moodle Docker Compose without environment context.
    pause
    exit /b 1
)

echo Loading environment variables from %ENV_FILE% for stopping...

REM Read .env file line by line and set environment variables for current session
for /f "usebackq tokens=*" %%a in ("%ENV_FILE%") do (
    call :ProcessLine "%%a"
)

echo Environment variables loaded.

echo Stopping Moodle Docker Compose...

REM Change directory to moodle-docker to run its compose command
cd /d "%CD%\moodle-docker"

REM Define the bash executable. By default, it looks for 'bash.exe' in your system's PATH.
REM If 'bash.exe' is not in your PATH (e.g., you're using Git Bash, Cygwin, or WSL),
REM you can uncomment and set the full path here.
REM Examples:
REM set "BASH_EXE=C:\Program Files\Git\bin\bash.exe"
REM set "BASH_EXE=wsl bash"
set "BASH_EXE=bash.exe"

REM IMPORTANT: The 'bin/moodle-docker-compose' is a bash script (.sh).
REM This will only work if '%BASH_EXE%' successfully finds bash.
%BASH_EXE% bin\moodle-docker-compose down

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