# Multi-Arch ISC BIND 9 Docker Image (`amd64` & `arm64`)

[![Build & Publish Multi-Arch BIND 9](https://github.com/udp1024/bind9-docker/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/udp1024/bind9-docker/actions/workflows/build-and-push.yml)

Automated, multi-architecture (`linux/amd64` and `linux/arm64`) Docker container for **ISC BIND 9**, built directly against the official [ISC Launchpad PPA](https://launchpad.net/~isc/+archive/ubuntu/bind) on Ubuntu 24.04 LTS (Noble).

---

## Why this image exists

1. **Native ARM64 Support:** The official ISC Docker Hub image (`internetsystemsconsortium/bind9`) only provides `linux/amd64` manifests, causing `exec format error` on ARM64 platforms like Raspberry Pi 4/5, AWS Graviton, and Apple Silicon.
2. **Current Upstream Releases:** Canonical's `ubuntu/bind9:latest` image tracks default Ubuntu distro packages, which stay frozen on older minor releases (e.g., `9.20.11`). This image delivers modern point releases (e.g., `9.20.30`).
3. **Automated Tracking:** A daily GitHub Actions workflow queries the official ISC PPA, detects new BIND 9 point releases, builds multi-arch images, and publishes them automatically to Docker Hub.

---

## Architectures Supported

* `linux/amd64` (x86_64 servers & workstations)
* `linux/arm64` (Raspberry Pi 4B/5, Apple Silicon, ARM64 cloud servers)

---

## Quick Start

### Direct `docker run`

```bash
docker run -d \
    --name bind9 \
    --restart unless-stopped \
    --net host \
    -v /mnt/data/bind/conf:/etc/bind/conf \
    -v /mnt/data/bind/zones:/var/cache/bind/zones \
    -v /mnt/data/bind/hints:/var/cache/bind/hints \
    -v /mnt/data/bind/logs:/var/log \
    udp1024/bind9:latest \
    named -g -c /etc/bind/conf/named.conf
```

### Docker Compose

```yaml
version: '3.8'

services:
  bind9:
    image: udp1024/bind9:latest
    container_name: bind9
    restart: unless-stopped
    network_mode: host
    environment:
      - TZ=UTC
      - BIND9_USER=bind
    volumes:
      - /mnt/data/bind/conf:/etc/bind/conf
      - /mnt/data/bind/zones:/var/cache/bind/zones
      - /mnt/data/bind/hints:/var/cache/bind/hints
      - /mnt/data/bind/logs:/var/log
    command: ["named", "-g", "-c", "/etc/bind/conf/named.conf"]
```

---

## Image Tags

| Tag | Description |
| --- | --- |
| `latest` | Latest stable BIND 9 build |
| `9.20` | Latest release within the 9.20 branch |
| `9.20.30` | Pinned patch release |

---

## Setup Automated Builds with GitHub Actions

To host and publish this yourself to your Docker Hub repository:

1. Push this repository to GitHub:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for automated multi-arch BIND 9 container"
   gh repo create udp1024/bind9-docker --public --source=. --push
   ```

2. Add two repository secrets in GitHub (`Settings -> Secrets and variables -> Actions`):
   * `DOCKERHUB_USERNAME`: Your Docker Hub username (e.g. `udp1024`)
   * `DOCKERHUB_TOKEN`: A Docker Hub Personal Access Token (Read & Write permissions)

3. Trigger the workflow manually from the **Actions** tab, or wait for the scheduled daily runner (`06:00 UTC`).
