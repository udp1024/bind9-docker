FROM ubuntu:24.04

LABEL maintainer="udp1024 <udp1024@hotmail.com>" \
      description="Multi-arch (linux/amd64, linux/arm64) ISC BIND 9 built from official ISC PPA"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

# Install prerequisites, add official ISC BIND PPA, and install BIND 9
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        software-properties-common \
        tzdata && \
    add-apt-repository -y ppa:isc/bind && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        bind9 \
        bind9-utils \
        bind9-dnsutils && \
    apt-get purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ensure required directories exist with bind user ownership
RUN mkdir -p /etc/bind/conf /var/cache/bind/zones /var/cache/bind/hints /var/log/named && \
    chown -R bind:bind /etc/bind /var/cache/bind /var/lib/bind /var/log/named

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 53/udp 53/tcp 953/tcp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["named", "-g", "-u", "bind"]
# Built for multi-arch deployment tracking official ISC PPA
