@echo off
setlocal

set "BASE_DIR=%~dp0"

echo [INFO] Starting firefox-sandbox using base directory: %BASE_DIR%

REM Ensure sandbox folders exist (defensive)
if not exist "%BASE_DIR%firefox-config" mkdir "%BASE_DIR%firefox-config"
if not exist "%BASE_DIR%firefox-downloads" mkdir "%BASE_DIR%firefox-downloads"

REM Check if container exists
docker ps -a --filter "name=firefox-sandbox" --format "{{.Names}}" | findstr /I "firefox-sandbox" >nul
if %errorlevel%==0 (
    echo [INFO] Container exists. Starting...
    docker start firefox-sandbox >nul
) else (
    echo [INFO] Container does not exist. Creating...
    docker run -d ^
      --name firefox-sandbox ^
      -e PUID=1000 ^
      -e PGID=1000 ^
      -e TZ=Etc/UTC ^
      -p 3000:3000 ^
      -v "%BASE_DIR%firefox-config:/config" ^
      -v "%BASE_DIR%firefox-downloads:/downloads" ^
      --security-opt "no-new-privileges=true" ^
      --restart unless-stopped ^
      lscr.io/linuxserver/firefox:latest >nul
)

echo [INFO] Firefox container is running.
endlocal
