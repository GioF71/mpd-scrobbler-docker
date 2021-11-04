from debian:stable-slim

RUN apt-get update
RUN apt-get install mpdas -y
RUN rm -rf /var/lib/apt/lists/*

ENV STARTUP_DELAY_SEC 0

ENV USERNAME SCROBBLER_USERNAME
ENV PASSWORD SCROBBLER_PASSWORD

ENV MPD_HOSTNAME localhost
ENV MPD_PORT 6600
ENV USE_MPD_PASSWORD no
ENV MPD_PASSWORD MPD_PASSWORD

ENV DEBUG 0
ENV SERVICE Last.fm

COPY run-mpdas.sh /run-mpdas.sh
RUN chmod u+x /run-mpdas.sh

ENTRYPOINT ["/run-mpdas.sh"]
