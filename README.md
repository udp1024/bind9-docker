# Multi-Arch ISC BIND 9 DNS Server (`amd64` / `arm64`)

[![Build & Publish Multi-Arch BIND 9](https://github.com/udp1024/bind9-docker/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/udp1024/bind9-docker/actions/workflows/build-and-push.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/udp1024/bind9.svg)](https://hub.docker.com/r/udp1024/bind9)
[![Docker Image Size](https://img.shields.io/docker/image-size/udp1024/bind9/latest)](https://hub.docker.com/r/udp1024/bind9)
[![Architectures](https://img.shields.io/badge/architectures-amd64%20%7C%20arm64-blue.svg)](https://hub.docker.com/r/udp1024/bind9)
[![GitHub Actions](https://img.shields.io/badge/build-automated%20daily-success.svg)](https://github.com/udp1024/bind9-docker)

Automated, multi-architecture Docker container running **ISC BIND 9**, built directly from the [official ISC Launchpad PPA](https://launchpad.net/~isc/+archive/ubuntu/bind) on Ubuntu 24.04 LTS (Noble Numbat).

---

## ⚡ Why Use This Image?

| Feature | `udp1024/bind9` | Official `internetsystemsconsortium/bind9` | Distro `ubuntu/bind9` |
| :--- | :---: | :---: | :---: |
| **Native ARM64 / Raspberry Pi** |  **Yes** (`linux/arm64`) | ❌ No (`amd64` only) |  Yes |
| **Latest ISC Point Releases** |  **Yes** (tracks official PPA) | ⚠️ Often lagging | ❌ Frozen on distro release |
| **Automated Daily Sync** |  **Yes** (GitHub Actions at 06:00 UTC) | Manual / Infrequent | Distro release cycle |
| **Clean Privilege Separation** |  **Yes** (runs as `bind:bind`) |  Yes |  Yes |

1. **Native Multi-Arch:** Built natively for both `linux/amd64` and `linux/arm64`. Prevents `exec format error` on Apple Silicon, Raspberry Pi 4/5, and ARM64 cloud instances (AWS Graviton, Oracle Ampere).
2. **Always Up-to-Date:** Standard distribution packages freeze on older releases. This image automatically tracks the official ISC PPA to provide current maintenance releases (e.g., BIND 9.20.x) with the latest security fixes and DNS standards support.
3. **Automated CI/CD:** A scheduled runner checks the ISC PPA daily and automatically publishes new versions as multi-arch manifests.

---

## 🖥️ Supported Architectures

* **`linux/amd64`**: x86_64 servers, workstations, and hypervisors.
* **`linux/arm64`**: Raspberry Pi 4/5, Apple Silicon (M1/M2/M3/M4), AWS Graviton, Ampere Altra.

---

## 🏷️ Tags

* **`latest`**: Points to the most recent stable BIND 9 build.
* **`9.20`**: Tracks the latest release in the BIND 9.20 stable branch.
* **`9.20.x`** *(e.g. `9.20.30`)*: Pinned specific patch releases for reproducible deployments.

---

## 🚀 Quick Start

### 1. Direct `docker run`

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

### 2. Docker Compose

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

## ⚙️ Configuration & Volumes

| Container Path | Description | Recommended Permissions |
| :--- | :--- | :--- |
| `/etc/bind/conf` | Configuration files (`named.conf`, options, local zones) | `bind:bind` |
| `/var/cache/bind/zones` | Master, slave, and dynamic zone files | Read / Write for `bind:bind` |
| `/var/cache/bind/hints` | Root hint files (`named.root`) | Read-only |
| `/var/log` or `/var/log/named` | DNS query, security, and general logs | Read / Write for `bind:bind` |

### Environment Variables

| Variable | Default | Description |
| :--- | :--- | :--- |
| `BIND9_USER` | `bind` | System user executing the `named` daemon. |
| `USE_CONFIG_FILE_LOGGING` | *(unset)* | If set to any value, named starts with `-f` instead of `-g` to allow logging clauses in `named.conf` to handle all logging destinations. |
| `TZ` | `UTC` | Timezone for the container log timestamps (e.g. `America/New_York`, `Europe/London`). |

---

## 🔍 Verification

Verify that BIND 9 is running and responding:

```bash
# Query the local BIND 9 instance
dig @127.0.0.1 -p 53 example.com

# Check version inside the container
docker exec -it bind9 named -v
```

---

## 🔗 Links & Source Code

* **GitHub Repository:** [udp1024/bind9-docker](https://github.com/udp1024/bind9-docker)
* **ISC BIND 9 Official Site:** [isc.org/bind](https://www.isc.org/bind/)
* **Upstream Launchpad PPA:** [ppa:isc/bind](https://launchpad.net/~isc/+archive/ubuntu/bind)
