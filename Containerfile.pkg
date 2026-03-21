ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/base:${FREEBSD_RELEASE}

LABEL org.opencontainers.image.title="Navidrome" \
    org.opencontainers.image.description="Modern Music Server and Streamer compatible with Subsonic/Airsonic" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/navidrome" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/navidrome" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN pkg update && \
    pkg install -y navidrome && \
    install -d -m 755 /usr/local/sbin && \
    pkg clean -a && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/*

VOLUME ["/var/db/navidrome", "/usr/local/share/navidrome/music"]
ENV ND_MUSICFOLDER=/usr/local/share/navidrome/music
ENV ND_DATAFOLDER=/var/db/navidrome
ENV ND_CONFIGFILE=/usr/local/etc/navidrome/config.toml
ENV ND_PORT=4533
ENV ND_ADDRESS=0.0.0.0
RUN touch /.nddockerenv

EXPOSE ${ND_PORT}

ENTRYPOINT ["navidrome"]
