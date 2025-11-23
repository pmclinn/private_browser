@echo off
setlocal

set "BASE_DIR=%~dp0"
echo [INFO] Base dir: %BASE_DIR%

REM Ensure sandbox folders exist
if not exist "%BASE_DIR%firefox-config" (
    echo [INFO] Creating firefox-config folder...
    mkdir "%BASE_DIR%firefox-config"
)

if not exist "%BASE_DIR%firefox-downloads" (
    echo [INFO] Creating firefox-downloads folder...
    mkdir "%BASE_DIR%firefox-downloads"
)

REM Copy user.js into config if present
if exist "%BASE_DIR%user.js" (
    echo [INFO] Installing user.js into firefox-config...
    copy /Y "%BASE_DIR%user.js" "%BASE_DIR%firefox-config\user.js" >nul
) else (
    echo [WARN] user.js not found in base dir. Privacy settings may not be applied.
)

echo [INFO] Pulling Docker image lscr.io/linuxserver/firefox:latest ...
docker pull lscr.io/linuxserver/firefox:latest

echo [INFO] Setup complete.
endlocal
