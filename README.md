# Navidrome

Navidrome allows you to enjoy your music collection from anywhere, by making it available through a modern Web UI and through a wide range of third-party compatible mobile apps, for both iOS and Android devices.

www.navidrome.org

<img src="https://static-00.iconduck.com/assets.00/navidrome-icon-512x512-d71g7c3m.png" alt="navidrome logo" width="30%" height="auto">

## How to use this Makejail

### Standalone

```
appjail makejail \
	-j navidrome \
	-f gh+AppJail-makejails/navidrome \
	-o virtualnet=":<random> default" \
	-o nat \
	-o expose="4533"
```

### Deploy using appjail-director

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
    start-environment:
      - ND_SCANSCHEDULE: 1h
      - ND_LOGLEVEL: info
      - ND_SESSIONTIMEOUT: 24h
    volumes:
      - nd_db: navidrome-db
      - nd_music: navidrome-music

default_volume_type: '<volumefs>'

volumes:
  nd_db:
    device: .volumes/navidrome-db
  nd_music:
    device: .volumes/navidrome-music
```

**.env**:

```
DIRECTOR_PROJECT=navidrome
```

### Arguments

* `navidrome_tag` (default: `13.3`): See [#tags](#tags).

## Tags

| Tag    | Arch    | Version        | Type   |
| ------ | ------- | -------------- | ------ |
| `13.3` | `amd64` | `13.3-RELEASE` | `thin` |
| `14.1` | `amd64` | `14.1-RELEASE` | `thin` |
