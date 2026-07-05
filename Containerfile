ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Navidrome" \
    org.opencontainers.image.description="Modern Music Server and Streamer compatible with Subsonic/Airsonic" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/navidrome" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/navidrome" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U navidrome ffmpeg-nox11; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then
        pkg clean -a; \
        rm -rf /var/cache/pkg/* /var/db/pkg/repos/*; \
    fi

VOLUME ["/data", "/music"]
ENV ND_MUSICFOLDER=/music
ENV ND_DATAFOLDER=/data
ENV ND_CONFIGFILE=/data/config.toml
ENV ND_PORT=4533
ENV ND_ADDRESS=0.0.0.0
ENV ND_FFMPEGPATH=/usr/local/bin/ffmpeg
RUN echo -n > /.nddockerenv

EXPOSE ${ND_PORT}

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    mkdir -p /data /music && \
    chmod 755 /data /music 

ENTRYPOINT ["/entrypoint.sh"]
