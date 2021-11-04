# mpd-scrobbler-docker - a Docker image for mpd with alsa

## Reference

First and foremost, the reference to the awesome projects:

[Music Player Daemon](https://www.musicpd.org/)  
[mpdas](https://github.com/hrkfdn/mpdas/)

## Links
Source: [GitHub](https://github.com/giof71/mpd-scrobbler-docker)  
Images: [DockerHub](https://hub.docker.com/r/giof71/mpd-scrobbler)

## Why

I prepared this Dockerfile Because I wanted to be able to install mpdas easily on any machine (provided the architecture is amd64 or arm). Configuring the container is easy through a webapp like Portainer.

## Prerequisites

You need to have Docker up and running on a Linux machine, and the current user must be allowed to run containers (this usually means that the current user belongs to the "docker" group).

You can verify whether your user belongs to the "docker" group with the following command:

`getent group | grep docker`

This command will output one line if the current user does belong to the "docker" group, otherwise there will be no output.

The Dockerfile and the included scripts have been tested on the following distros:

- Manjaro Linux with Gnome (amd64)
- Asus Tinkerboard
- Raspberry Pi 3 (but I have no reason to doubt it will also work on a Raspberry Pi 4/400)

As I test the Dockerfile on more platforms, I will update this list.

## Get the image

Here is the [repository](https://hub.docker.com/repository/docker/giof71/mpd-scrobbler) on DockerHub.

Getting the image from DockerHub is as simple as typing:

`docker pull giof71/mpd-scrobbler:stable`

You may want to pull the "stable" image as opposed to the "latest".

## Usage

Create your own mpdas.conf starting from the file

[sample-mpdas.conf](https://github.com/GioF71/mpdas-scrobbler-docker/blob/main/sample-mpdas.conf)

Customize your mpdas.conf file with you details, then start mpd-scrobbler by simply typing:

`docker run -it --rm \
    -v ${PWD}/mpdas.conf:/etc/mpdas.conf \
    --network host \
    giof71/mpd-scrobbler:stable`

Note that `--network host` is required should mpd be running on the host machine. If you deploy mpdas through docker-compose, using the host network will not be required and/or necessary.

The following tables reports all the currently supported environment variables.

VARIABLE | DEFAULT | NOTES
---|---|---
STARTUP_DELAY_SEC|0|Delay before starting the application.

## Build

You can build (or rebuild) the image by opening a terminal from the root of the repository and issuing the following command:

`docker build . -t giof71/mpd-scrobbler`

It will take very little time even on a Raspberry Pi. When it's finished, you can run the container following the previous instructions.  
Just be careful to use the tag you have just built.
