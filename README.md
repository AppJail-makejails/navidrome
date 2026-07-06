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

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${PUID}` | `${PGID}` | - | - | /data |
| appjail-3e431e873f-music | `${PUID}` | `${PGID}` | - | - | /music |

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
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```

## Notes

1. `navidrome-music` volume remains unchanged, allowing for read-only mounts.
2. If you want to use a configuration file with Navidrome running in AppJail, you can create a `config.toml` config file in the `/data`.
3. [Configuration options](https://www.navidrome.org/docs/usage/configuration/options/) can be customized with environment variables as needed. For `appjail-director` just add them to the `services.{service}.oci.environment` section. For `appjail oci run` use the `-e` parameter. Ex: `-e ND_SESSIONTIMEOUT=24h`.
4. Remember to change the volumes paths to point to your local paths. `/data` is where Navidrome will store its DB and cache, `/music` is where your music files are stored. For [multi-library setups](https://www.navidrome.org/docs/usage/features/multi-library/), you may need to mount additional volumes for each library.
