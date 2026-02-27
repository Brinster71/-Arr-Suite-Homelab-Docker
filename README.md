# Arr Fullstack Docker Compose Template

This repository provides a template for a full media automation stack using Docker Compose.

- `arr-fullstack.compose.yml` → standard layout with only qBittorrent ports published on Gluetun.
- `arr-fullstack.gluetun-full-ports.compose.yml` → expanded layout with many app ports published on Gluetun.
- `arr-fullstack.env` → shared environment file with all placeholder values.

## Why two Gluetun variants?

When services use `network_mode: service:gluetun`, inbound access is controlled by Gluetun.

- **Standard variant** (`arr-fullstack.compose.yml`)
  - Keeps your current behavior: only qBittorrent WebUI + torrent ports are on Gluetun.
  - Other services publish their own ports directly.

- **Full-ports-on-Gluetun variant** (`arr-fullstack.gluetun-full-ports.compose.yml`)
  - Publishes many service ports from the Gluetun container.
  - Service containers are attached to Gluetun with `network_mode: service:gluetun`.
  - Useful if you want most UI/network exposure to be controlled in one place.

## Included Services

### Core Automation
- **Prowlarr**: Indexer manager and indexer sync point for all Arr apps.
- **Sonarr**: TV show management and automation.
- **Radarr**: Movie management and automation.
- **Lidarr**: Music management and automation.
- **Readarr**: Book/audiobook management and automation.
- **Bazarr**: Subtitle management for Sonarr/Radarr libraries.

### Download Clients
- **qBittorrent**: Torrent client, routed through Gluetun VPN in both templates.

### Request & Supporting Tools
- **Overseerr**: User request front-end for media requests.
- **Gluetun**: VPN container used by qBittorrent and optionally more services.
- **Flaresolverr**: Helper for Cloudflare-protected indexers.
- **Recyclarr**: Syncs quality/release profiles (commonly from TRaSH).
- **Unpackerr**: Unpacks completed downloads and notifies Arr applications.

## Environment File (`arr-fullstack.env`)

The env file includes centralized **path markers**:

- `APPDATA_ROOT=/path/to/appdata`
- `DOWNLOADS_ROOT=/path/to/downloads`
- `INCOMPLETE_DOWNLOADS_ROOT=/path/to/incomplete-downloads`
- `TV_ROOT=/path/to/tv`
- `MOVIES_ROOT=/path/to/movies`
- `MUSIC_ROOT=/path/to/music`
- `BOOKS_ROOT=/path/to/books`

It also includes placeholder values for:
- VPN credentials/provider
- Arr service URLs for Unpackerr
- Arr API keys
- Published host ports

## How to Use

1. Edit `arr-fullstack.env` and replace every placeholder with your own values.
2. Choose your compose variant:
   - Standard (only qBittorrent ports on Gluetun):
     ```bash
     docker compose --env-file arr-fullstack.env -f arr-fullstack.compose.yml up -d
     ```
   - Full-ports on Gluetun:
     ```bash
     docker compose --env-file arr-fullstack.env -f arr-fullstack.gluetun-full-ports.compose.yml up -d
     ```
3. Access applications on the host ports you define in `arr-fullstack.env`.

## Security & Public Sharing

This template intentionally contains no personal data:
- No real filesystem paths
- No real usernames/passwords
- No real API keys
- No real domain names or IP addresses

If you fork/share this repo, keep using placeholders and never commit live secrets.

## Optional: Cron fix for Gluetun `/etc/resolv.conf`

If your `gluetun` container occasionally ends up with only:

```text
nameserver   127.0.0.1
```

you can use `scripts/check-gluetun-resolv.sh` to append:

- `nameserver   192.168.1.192`
- `nameserver   1.1.1.1`

The script only updates the file when **127.0.0.1 is the only nameserver entry**.

Example crontab entry (runs every 5 minutes):

```cron
*/5 * * * * /bin/bash /workspace/-Arr-Suite-Homelab-Docker/scripts/check-gluetun-resolv.sh >> /var/log/gluetun-resolv-cron.log 2>&1
```
