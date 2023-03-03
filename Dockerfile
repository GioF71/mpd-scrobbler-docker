ARG BASE_IMAGE="${BASE_IMAGE:-alpine:latest}"
FROM ${BASE_IMAGE}

RUN mkdir -p /app/conf

RUN apk add --no-cache mpdscribble
RUN apk add --no-cache bash

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/mpd-scrobbler-docker"

RUN mkdir -p /app/conf
RUN mkdir -p /app/bin
RUN mkdir -p /app/log/mpdscribble

RUN chmod -R 775 /app

VOLUME /app/log/mpdscribble

ENV STARTUP_DELAY_SEC ""

ENV MPD_HOSTNAME ""
ENV MPD_PORT ""

ENV SCRIBBLE_VERBOSE ""

ENV LASTFM_USERNAME ""
ENV LASTFM_PASSWORD ""

ENV LIBREFM_USERNAME ""
ENV LIBREFM_PASSWORD ""

ENV JAMENDO_USERNAME ""
ENV JAMENDO_PASSWORD ""

ENV PROXY ""

ENV MPD_HOSTNAME localhost
ENV MPD_PORT 6600
ENV USE_MPD_PASSWORD no
ENV MPD_PASSWORD ""

ENV USER_MODE ""
ENV PUID ""
ENV PGID ""

COPY app/bin/run-mpdscribble.sh /app/bin/run-mpdscribble.sh
RUN chmod 755 /app/bin/run-mpdscribble.sh

WORKDIR /app/bin
ENTRYPOINT ["/app/bin/run-mpdscribble.sh"]

