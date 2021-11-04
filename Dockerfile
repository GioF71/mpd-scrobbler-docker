from debian:stable-slim

RUN apt-get update
RUN apt-get install mpdas -y
RUN rm -rf /var/lib/apt/lists/*

ENV STARTUP_DELAY_SEC 0

COPY run-mpdas.sh /run-mpdas.sh
RUN chmod u+x /run-mpdas.sh

ENTRYPOINT ["/run-mpdas.sh"]
