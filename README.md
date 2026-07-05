# Navidrome

Navidrome allows you to enjoy your music collection from anywhere, by making it available through a modern Web UI and through a wide range of third-party compatible mobile apps, for both iOS and Android devices.

www.navidrome.org

<img src="https://github.com/navidrome/navidrome/blob/master/ui/public/android-chrome-192x192.png?raw=true" width="30%" height="auto" alt="Navidrome logo">

## How to use this Makejail

### Standalone

```console
$ mkdir -p /var/appjail-volumes/navidrome/data \
    /var/appjail-volumes/navidrome/music
$ appjail oci run -Pd \
    -e PUID=1000 \
    -e PGID=1000 \
    -e ND_SCANSCHEDULE="1h" \
    -e ND_LOGLEVEL="info" \
    -e ND_SESSIONTIMEOUT="24h" \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=4533 \
    -o container="args:--pull" \
    -o fstab="/var/appjail-volumes/navidrome/data /data" \
    -o fstab="/var/appjail-volumes/navidrome/music /music nullfs ro" \
    ghcr.io/appjail-makejails/navidrome navidrome
```

### Deploy using appjail-director

**.env**:

```
DIRECTOR_PROJECT=navidrome
```

**appjail-director.yml**:

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:
services:
  navidrome:
    name: navidrome
    makejail: gh+AppJail-makejails/navidrome
    options:
      - expose: 4533
      - container: 'boot args:--pull'
    oci:
      environment:
        - ND_SCANSCHEDULE: 1h
        - ND_LOGLEVEL: info
        - ND_SESSIONTIMEOUT: 24h
        - PUID: 1000
        - PGID: 1000
    volumes:
      - nd_data: /data
      - nd_music: /music
volumes:
  nd_data:
    device: /var/appjail-volumes/navidrome/data
  nd_music:
    device: /var/appjail-volumes/navidrome/music
    options: ro
```

### Arguments (stage: build)

* `navidrome_from` (default: `ghcr.io/appjail-makejails/navidrome`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `navidrome_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).


### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${puid}` | `${pgid}` | - | - | /data |
| appjail-3e431e873f-music | `${puid}` | `${pgid}` | - | - | /music |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
```

## Notes

1. `navidrome-music` volume remains unchanged, allowing for read-only mounts.
