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

REM Prepare profile and config paths
if not exist "%BASE_DIR%firefox-config\profile" (
    echo [INFO] Creating firefox-config\profile folder...
    mkdir "%BASE_DIR%firefox-config\profile"
)
if not exist "%BASE_DIR%firefox-config\.config" (
    echo [INFO] Creating firefox-config\.config folder...
    mkdir "%BASE_DIR%firefox-config\.config"
)

REM Copy user.js into config and profile if present
if exist "%BASE_DIR%user.js" (
    echo [INFO] Installing user.js into firefox-config and profile...
    copy /Y "%BASE_DIR%user.js" "%BASE_DIR%firefox-config\user.js" >nul
    copy /Y "%BASE_DIR%user.js" "%BASE_DIR%firefox-config\profile\user.js" >nul
) else (
    echo [WARN] user.js not found in base dir. Privacy settings may not be applied.
)

REM Set XDG download directory for Linux apps
(
  echo XDG_DESKTOP_DIR="$HOME/Desktop"
  echo XDG_DOWNLOAD_DIR="/downloads"
  echo XDG_DOCUMENTS_DIR="$HOME/Documents"
  echo XDG_MUSIC_DIR="$HOME/Music"
  echo XDG_PICTURES_DIR="$HOME/Pictures"
  echo XDG_VIDEOS_DIR="$HOME/Videos"
) > "%BASE_DIR%firefox-config\.config\user-dirs.dirs"

echo [INFO] Pulling Docker image lscr.io/linuxserver/firefox:latest ...
docker pull lscr.io/linuxserver/firefox:latest

echo [INFO] Setup complete.
endlocal
