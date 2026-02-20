# Arr Fullstack Docker Compose Template

This repository provides a **sanitized, public-safe template** for a full media automation stack using Docker Compose.

- Compose file: `arr-fullstack.compose.yml`
- Environment file: `arr-fullstack.env`

All host paths are generic placeholders (`/path/to/...`) and all credentials/API keys are non-sensitive placeholders.

## Included Services

### Core Automation
- **Prowlarr**: Indexer manager and indexer sync point for all Arr apps.
- **Sonarr**: TV show management and automation.
- **Radarr**: Movie management and automation.
- **Lidarr**: Music management and automation.
- **Readarr**: Book/audiobook management and automation.
- **Bazarr**: Subtitle management for Sonarr/Radarr libraries.

### Download Clients
- **qBittorrent**: Torrent client, routed through Gluetun VPN in this template.
- **SABnzbd**: Usenet downloader.

### Media Access & Requests
- **Jellyfin**: Media server for playback.
- **Overseerr**: User request front-end for media requests.

### Supporting Tools
- **Gluetun**: VPN container used by qBittorrent via `network_mode: service:gluetun`.
- **Flaresolverr**: Bypass helper for Cloudflare-protected indexers (when needed).
- **Recyclarr**: Syncs quality/release profiles (typically from TRaSH guides).
- **Unpackerr**: Unpacks completed downloads and notifies Arr applications.

## How to Use

1. Copy/edit `arr-fullstack.env` and replace placeholders:
   - VPN provider credentials
   - API key placeholders
   - UID/GID and timezone
2. Replace all `/path/to/...` mount paths in `arr-fullstack.compose.yml` with your real host paths.
3. Start the stack:

```bash
docker compose --env-file arr-fullstack.env -f arr-fullstack.compose.yml up -d
```

4. Open each app in a browser (using your Docker host IP):
   - Prowlarr: `http://<host>:9696`
   - Sonarr: `http://<host>:8989`
   - Radarr: `http://<host>:7878`
   - Lidarr: `http://<host>:8686`
   - Readarr: `http://<host>:8787`
   - Bazarr: `http://<host>:6767`
   - qBittorrent: `http://<host>:8080`
   - SABnzbd: `http://<host>:8085`
   - Jellyfin: `http://<host>:8096`
   - Overseerr: `http://<host>:5055`

## Notes on Paths

To avoid import/move issues in Arr apps:
- Keep a **single shared downloads root** mounted consistently (e.g., `/downloads`) across downloaders and Arr apps.
- Keep media roots (`/movies`, `/tv`, `/music`, `/books`) consistent with the paths you configure inside each app.

## Security & Public Sharing

This template intentionally contains no personal data:
- No real filesystem paths
- No real usernames/passwords
- No real API keys
- No real domain names or IP addresses

If you fork/share this repo, keep using placeholders and never commit live secrets.
