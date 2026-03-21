# Navidrome

Navidrome allows you to enjoy your music collection from anywhere, by making it available through a modern Web UI and through a wide range of third-party compatible mobile apps, for both iOS and Android devices.

www.navidrome.org

<img src="https://github.com/navidrome/navidrome/blob/master/ui/public/android-chrome-192x192.png?raw=true" alt="navidrome logo" width="30%" height="auto">

## How to use this Makejail

### Standalone

```
appjail makejail \
    -j navidrome \
    -f gh+AppJail-makejails/navidrome \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose="4533" \
    -o container="args:--pull"
appjail start navidrome
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
    arguments:
      - puid: 1000
      - pgid: 1000
    options:
      - expose: 4533
      - container: 'args:--pull'
    oci:
      environment:
        - ND_SCANSCHEDULE: 1h
        - ND_LOGLEVEL: info
        - ND_SESSIONTIMEOUT: 24h
    volumes:
      - nd_db: navidrome-db
      - nd_music: navidrome-music
default_volume_type: '<volumefs>'
volumes:
  nd_db:
    device: /var/appjail-volumes/navidrome/db
  nd_music:
    device: /var/appjail-volumes/navidrome/music
```

### Arguments

* `navidrome_from` (default: `ghcr.io/appjail-makejails/navidrome`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `navidrome_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Volumes

| Name            | Owner     | Group     | Perm | Type | Mountpoint                       |
| --------------- | --------- | --------- | ---- | ---- | -------------------------------- |
| navidrome-music | `${puid}` | `${pgid}` |  -   |  -   | /usr/local/share/navidrome/music |
| navidrome-db    | `${puid}` | `${pgid}` |  -   |  -   | /var/db/navidrome                |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.0
      containerfile: Containerfile.pkg
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.0"
```

## Notes

1. This Makejail includes [gh+AppJail-makejails/user-mapping](https://github.com/AppJail-makejails/user-mapping).
