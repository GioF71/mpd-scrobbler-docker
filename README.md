# mpd-scrobbler-docker

A Docker image for mpdscribble (`Last.fm`, `Libre.fm` and `Jamendo` scrobbler for mpd).

## Reference

First and foremost, the reference to the awesome projects:

[Music Player Daemon](https://www.musicpd.org/)  
[MPDScribble](https://www.musicpd.org/clients/mpdscribble/)

## Links

Source: [GitHub](https://github.com/giof71/mpd-scrobbler-docker)  
Images: [DockerHub](https://hub.docker.com/r/giof71/mpd-scrobbler)

## Why

I prepared this Dockerfile Because I wanted to be able to install mpdscribble easily on any machine (provided the architecture is amd64 or arm). Configuring the container is easy through a webapp like Portainer.

## Prerequisites

You need to have Docker up and running on a Linux machine, and the current user must be allowed to run containers (this usually means that the current user belongs to the "docker" group).

You can verify whether your user belongs to the "docker" group with the following command:

`getent group | grep docker`

This command will output one line if the current user does belong to the "docker" group, otherwise there will be no output.

The Dockerfile and the included scripts have been tested on the following distros:

- Manjaro Linux with Gnome (amd64)
- Asus Tinkerboard
- Raspberry Pi 3 and 4, both 32 and 64 bit

As I test the Dockerfile on more platforms, I will update this list.

## Get the image

Here is the [repository](https://hub.docker.com/repository/docker/giof71/mpd-scrobbler) on DockerHub.

Getting the image from DockerHub is as simple as typing:

`docker pull giof71/mpd-scrobbler`

You may want to pull the "stable" image as opposed to the "latest".

## Usage

You can start mpd-scrobbler by simply typing:

```text
    docker run -d --rm \
        -e LASTFM_USERNAME=lastfmuser \
        -e LASTFM_PASSWORD=lastfmpassw \
        -e MPD_HOSTNAME=mpd-hostname \
        -e MPD_PORT=6600 \
        giof71/mpd-scrobbler`
```

### Environment Variables

The following tables reports all the currently supported environment variables.

VARIABLE | DEFAULT | NOTES
---|---|---
PUID||Run using this User id. Defaults to `1000`.
PGID||Run using this Group id. Defaults to `1000`.
MPD_HOST||The host running MPD, possibly protected by a password(`[PASSWORD@]HOSTNAME`). Defaults to `localhost`. Leave blank or `localhost` when running in `network=host` mode.
MPD_PORT||The port that the `MPD` listens on and `mpdscribble` should try to connect to. Defaults to `6600`, the default `MPD` port.
SCRIBBLE_VERBOSE||How verbose `mpdscribble`'s logging should be. Default is 1.
LASTFM_USERNAME||Username for `Last.fm`
LASTFM_PASSWORD||Password for `Last.fm`
LIBREFM_USERNAME||Username for `Libre.fm`
LIBREFM_PASSWORD||Password for `Libre.fm`
JAMENDO_USERNAME||Username for `Jamendo`
JAMENDO_PASSWORD||Password for `Jamendo`
PROXY||Proxy support for `mpdscribble`. Example value: `http://the.proxy.server:3128`
STARTUP_DELAY_SEC|0|Delay before starting the application.

### Volumes

Volume|Description
:---|:---
/app/scribble|Where `mpdscribble` will write its journals and its log file

## Notable changes to the configuration

A few environment variables have been deprecated, see the following table.

Deprecated Variable|Deprecated Since|Comment
---|---|---
USE_MPD_PASSWORD|2022-10-21|Removed variable: the `MPD` password must be specified with MPD_HOSTNAME if needed
USE_MPD_PASSWORD|2021-11-27|This variable is not required anymore: just set the MPD_PASSWORD variable

## Build

You can build (or rebuild) the image by opening a terminal from the root of the repository and issuing the following command:

`docker build . -t giof71/mpd-scrobbler`

It will take very little time even on a Raspberry Pi. When it's finished, you can run the container following the previous instructions.  
Just be careful to use the tag you have just built.

## Change History

Change Date|Major Changes
---|---
2022-10-24|Bugfix (wrong variable references and missing permissions)
2022-10-21|Run with unprivileged user
2022-10-21|Switch to `mpdscribble`
