@echo off
setlocal

set "BASE_DIR=%~dp0"

echo [INFO] Starting firefox-sandbox using base directory: %BASE_DIR%

REM Ensure sandbox folders exist (defensive)
if not exist "%BASE_DIR%firefox-config" mkdir "%BASE_DIR%firefox-config"
if not exist "%BASE_DIR%firefox-config\profile" mkdir "%BASE_DIR%firefox-config\profile"
if not exist "%BASE_DIR%firefox-config\.config" mkdir "%BASE_DIR%firefox-config\.config"
if not exist "%BASE_DIR%firefox-downloads" mkdir "%BASE_DIR%firefox-downloads"

REM Sync user.js into firefox-config and profile
if exist "%BASE_DIR%user.js" (
  copy /Y "%BASE_DIR%user.js" "%BASE_DIR%firefox-config\user.js" >nul
  copy /Y "%BASE_DIR%user.js" "%BASE_DIR%firefox-config\profile\user.js" >nul
)

REM Ensure XDG downloads dir points to /downloads
(
  echo XDG_DESKTOP_DIR="$HOME/Desktop"
  echo XDG_DOWNLOAD_DIR="/downloads"
  echo XDG_DOCUMENTS_DIR="$HOME/Documents"
  echo XDG_MUSIC_DIR="$HOME/Music"
  echo XDG_PICTURES_DIR="$HOME/Pictures"
  echo XDG_VIDEOS_DIR="$HOME/Videos"
) > "%BASE_DIR%firefox-config\.config\user-dirs.dirs"

REM Check if container exists
docker ps -a --filter "name=firefox-sandbox" --format "{{.Names}}" | findstr /I "firefox-sandbox" >nul
if %errorlevel%==0 (
    echo [INFO] Container exists. Recreating to apply updated mounts...
    docker stop firefox-sandbox >nul 2>&1
    docker rm firefox-sandbox >nul 2>&1
)

echo [INFO] Creating container with Downloads mapped to host...
docker run -d ^
  --name firefox-sandbox ^
  -e PUID=1000 ^
  -e PGID=1000 ^
  -e TZ=Etc/UTC ^
  -p 3000:3000 ^
  -v "%BASE_DIR%firefox-config:/config" ^
  -v "%BASE_DIR%firefox-downloads:/downloads" ^
  -v "%BASE_DIR%firefox-downloads:/config/Downloads" ^
  --security-opt "no-new-privileges=true" ^
  --restart unless-stopped ^
  lscr.io/linuxserver/firefox:latest >nul

echo [INFO] Firefox container is running.
endlocal
