#!/bin/bash

CONFIG_FILE=/etc/mpdas.conf

if test -f "$CONFIG_FILE"; then 
    echo "$CONFIG_FILE exists, removing"
    rm $CONFIG_FILE;
fi

echo "Building configuration file $CONFIG_FILE ..."

echo "username = "${SERVICE_USERNAME} >> $CONFIG_FILE
echo "password = "${SERVICE_PASSWORD} >> $CONFIG_FILE

echo "host = "${MPD_HOSTNAME} >> $CONFIG_FILE

echo "MPD Password processing [${MPD_PASSWORD}]";

if [ -z "${MPD_PASSWORD}" ]; then \
  echo "No password specified for mpd"; \
else \
  echo "Using password for mpd"; \
  echo "mpdpassword = ${MPD_PASSWORD}" >> $CONFIG_FILE; \
fi

echo "port = "${MPD_PORT} >> $CONFIG_FILE

echo "runas = root" >> $CONFIG_FILE

echo "debug = "${DEBUG} >> $CONFIG_FILE
echo "service = "${SERVICE} >> $CONFIG_FILE

cat $CONFIG_FILE

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

/usr/bin/mpdas -c $CONFIG_FILE
