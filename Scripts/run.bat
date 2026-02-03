@echo off
setlocal enabledelayedexpansion

REM Get the directory of this script, then go to the Devrepo root.
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%.."

REM Define the path to the main .env file in Devrepo root
set "ENV_FILE=%CD%\.env"

if not exist "%ENV_FILE%" (
    echo ERROR: .env file not found at %ENV_FILE%
    echo Please create .env with your Moodle Docker configuration.
    pause
    exit /b 1
)

echo Loading environment variables from %ENV_FILE%

REM Read .env file and export variables
for /f "usebackq tokens=1* delims==" %%a in ("%ENV_FILE%") do (
    set "line=%%a"
    REM Skip empty lines and comments
    if not "!line!"=="" (
        if not "!line:~0,1!"=="#" (
            set "key=%%a"
            set "value=%%b"
            REM Export the variable by setting it
            set "%%a=%%b"
        )
    )
)

echo Environment variables loaded.
echo MOODLE_DOCKER_WWWROOT=%MOODLE_DOCKER_WWWROOT%
echo MOODLE_DOCKER_DB=%MOODLE_DOCKER_DB%
echo MOODLE_DOCKER_WEB_PORT=%MOODLE_DOCKER_WEB_PORT%

echo.
echo Starting Moodle Docker Compose...

REM Change directory to moodle-docker to run its compose command
cd /d "%CD%\moodle-docker"

REM Find bash executable - check Git Bash locations first to avoid WSL issues
set "BASH_EXE="

REM Check common Git Bash installation paths
if exist "C:\Program Files\Git\bin\bash.exe" (
    set "BASH_EXE=C:\Program Files\Git\bin\bash.exe"
) else if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    set "BASH_EXE=C:\Program Files (x86)\Git\bin\bash.exe"
) else if exist "%ProgramFiles%\Git\bin\bash.exe" (
    set "BASH_EXE=%ProgramFiles%\Git\bin\bash.exe"
) else if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" (
    set "BASH_EXE=%ProgramFiles(x86)%\Git\bin\bash.exe"
) else if exist "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" (
    set "BASH_EXE=%LOCALAPPDATA%\Programs\Git\bin\bash.exe"
)

if not "%BASH_EXE%"=="" (
    echo Running moodle-docker-compose with Git Bash...
    echo Using: %BASH_EXE%
    "%BASH_EXE%" bin/moodle-docker-compose up -d
) else (
    echo ERROR: Git Bash not found
    echo Please install Git for Windows from: https://git-scm.com/download/win
    echo.
    echo After installation, run this script again.
    pause
    exit /b 1
)

endlocal