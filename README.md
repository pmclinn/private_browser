# Docker Firefox Sandbox (Windows)

A small, shareable setup for running Firefox inside a Linux Docker container on Windows 11. It’s designed for opening untrusted sites in an isolated environment so web apps can’t modify your PC. Bookmarks/extensions persist, but browsing runs in private mode to avoid leaving traces.

## Why Use This

- Run Firefox in a container, not on your Windows desktop
- Only two folders are exposed to the container: a profile folder and a downloads folder
- No privileged container; `no-new-privileges` is enabled
- Defaults to private browsing (no history, no disk cache, session-only cookies)

This is about isolating web pages from your PC’s filesystem and apps, not about anonymity.

## Requirements

- Windows 11
- Docker Desktop (Linux containers mode)
- Internet access (to pull the image)

## Installation

- Install Docker Desktop for Windows and enable Linux containers mode.
  - During install, enable the WSL2 backend if prompted.
  - Start Docker Desktop and wait until it reports "running".
- Get this repository:
  - Git: `git clone https://github.com/pmclinn/private_browser.git`
  - Or: download the ZIP from GitHub and extract it.
- First-time setup (one-time or when you want to refresh):
  - Double-click `setup_sandbox.bat`
  - This creates `firefox-config/` and `firefox-downloads/`, copies `user.js` into the profile, and pulls the Firefox Docker image.
- Run the sandbox:
  - Double-click `start_firefox_container.bat`
  - Then double-click `open_firefox_sandbox.bat` (opens `http://localhost:3000`).
- Update later:
  - Re-run `setup_sandbox.bat` or run `docker pull lscr.io/linuxserver/firefox:latest`.

## Quick Start

1) One-time setup (creates folders, installs privacy config, pulls the image)

- Double-click `setup_sandbox.bat`

2) Start the sandbox

- Double-click `start_firefox_container.bat`

3) Open the browser UI

- Double-click `open_firefox_sandbox.bat` or open `http://localhost:3000`

That’s it. You’ll get a noVNC web page with a Firefox window running inside the container.

## What It Does For Privacy/Security

- Container isolation
  - Firefox runs inside a Linux container, not on Windows
  - The container only sees two mapped folders in this repo directory:
    - `firefox-config/` is mounted to `/config` (Firefox profile: bookmarks, extensions, settings)
    - `firefox-downloads/` is mounted to `/downloads` (files you save)
  - No full-drive mounts, no `--privileged`, and `--security-opt no-new-privileges=true`

- Private browsing defaults (via `user.js`)
  - Always-on private browsing
  - No browsing history
  - Session-only cookies (cleared when the session ends)
  - Disk cache disabled
  - No form/search history
  - No crash session restore

- Controlled persistence
  - Bookmarks and extensions persist across container restarts (they live in `firefox-config/`)
  - Downloads land in `firefox-downloads/` for you to inspect before opening on Windows

## What It Does NOT Do

- Anonymity or traffic hiding
  - This is not a VPN or Tor. Your IP, ISP, and typical web tracking still apply.

- Magic protection against phishing or account takeovers
  - If you sign in and hand over credentials, the site has them.

- Perfect containment
  - It improves isolation, but a browser or container escape is theoretically possible. For very high-risk work, consider a dedicated VM in addition to this container.

- Automatic malware analysis of downloads
  - Files you download are saved to `firefox-downloads/`. If you choose to run them on Windows, that’s outside the sandbox.

- Protection from fingerprinting
  - Sites can still fingerprint the browser/graphics/fonts at the web layer.

## Files In This Repo

- `setup_sandbox.bat` — one-time (or occasional) setup
  - Creates `firefox-config/` and `firefox-downloads/`
  - Copies `user.js` into `firefox-config/`
  - Pulls `lscr.io/linuxserver/firefox:latest`

- `start_firefox_container.bat` — starts or creates the container
  - Exposes port `3000` for the noVNC UI
  - Mounts the two folders and sets security options

- `open_firefox_sandbox.bat` — opens `http://localhost:3000` in your default browser

- `user.js` — privacy preferences applied to the Firefox profile

- `.gitignore` — excludes local state (`firefox-config/`, `firefox-downloads/`) and local reference file `browser.md`

## Common Tasks

- Update to the latest image:

  ```bash
  docker pull lscr.io/linuxserver/firefox:latest
  ```

  Or just run `setup_sandbox.bat` again.

- Stop the container:

  ```bash
  docker stop firefox-sandbox
  ```

- Remove the container (keeps your config and downloads on disk):

  ```bash
  docker rm firefox-sandbox
  ```

- Reset everything (fresh start):
  1. `docker stop firefox-sandbox` (if running)
  2. `docker rm firefox-sandbox`
  3. Delete `firefox-config/` and `firefox-downloads/`
  4. Run `setup_sandbox.bat` again

## Troubleshooting

- Nothing shows at `http://localhost:3000`
  - Ensure Docker Desktop is running and using Linux containers
  - Check that the container is running: `docker ps`
  - Make sure port 3000 isn’t blocked by a firewall or used by another app

- Port conflict on 3000
  - Edit `start_firefox_container.bat` and change `-p 3000:3000` to another host port, e.g. `-p 3900:3000`, then go to `http://localhost:3900`

- Privacy settings not applied
  - Confirm `user.js` exists in repo root and that `setup_sandbox.bat` copied it to `firefox-config/user.js`

## Security Tips

- Keep the mapped folders minimal (only what the scripts mount)
- Be cautious with extensions—install only what you need
- Treat downloads as untrusted until inspected/scanned
- For very risky sites, consider a disposable Windows user account or an additional VM layer on top of this container

## Credits & Licenses

- LinuxServer.io Firefox image: lscr.io/linuxserver/firefox — docs and licenses: https://docs.linuxserver.io/images/docker-firefox/
- Mozilla Firefox: Mozilla Public License 2.0; Firefox and the Firefox logo are Mozilla trademarks. See https://www.mozilla.org/en-US/MPL/ and https://www.mozilla.org/foundation/trademarks/policy/
- Docker Desktop: subject to Docker’s terms. See https://www.docker.com/legal/docker-subscription-service-agreement/
- This project is not affiliated with Mozilla or LinuxServer.io.
