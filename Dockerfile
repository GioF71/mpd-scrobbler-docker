ARG BASE_IMAGE="${BASE_IMAGE:-debian:bullseye-slim}"
FROM ${BASE_IMAGE} AS BASE
ARG USE_APT_PROXY

RUN mkdir -p /app/conf

COPY app/conf/01-apt-proxy /app/conf/

RUN echo "USE_APT_PROXY=["${USE_APT_PROXY}"]"

RUN if [ "${USE_APT_PROXY}" = "Y" ]; then \
    echo "Builind using apt proxy"; \
    cp /app/conf/01-apt-proxy /etc/apt/apt.conf.d/01-apt-proxy; \
    cat /etc/apt/apt.conf.d/01-apt-proxy; \
    else \
    echo "Building without apt proxy"; \
    fi

RUN apt-get update
RUN apt-get install -y mpdscribble
RUN apt-get install -y tzdata
RUN rm -rf /var/lib/apt/lists/*

FROM scratch
COPY --from=BASE / /

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/mpd-scrobbler-docker"

RUN mkdir -p /app/conf
RUN mkdir -p /app/bin
RUN mkdir -p /app/log/mpdscribble

VOLUME /app/log/mpdscribble

ENV STARTUP_DELAY_SEC 0

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

ENV LOG_DESTINATION ""

ENV PUID ""
ENV PGID ""

COPY app/bin/run-mpdscribble.sh /app/bin/run-mpdscribble.sh
RUN chmod u+x /app/bin/run-mpdscribble.sh

WORKDIR /app/bin

ENTRYPOINT ["/app/bin/run-mpdscribble.sh"]
