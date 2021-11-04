#!/bin/sh

echo "username = " ${USERNAME} >> /etc/mpdas.conf
echo "password = " ${PASSWORD} >> /etc/mpdas.conf

echo "host = " ${MPD_HOSTNAME} >> /etc/mpdas.conf
if [ "$USE_MPD_PASSWORD" == "yes" ]; then \
  echo "MPD Password specified: $MPD_PASSWORD"; \
  echo "mpdpassword = " ${MPD_PASSWORD} >> /etc/mpdas.conf \
else \
  echo "MPD Password not specified"; \
fi

echo "port = " ${MPD_PORT} >> /etc/mpdas.conf

echo "runas = root" >> /etc/mpdas.conf

echo "debug = " ${DEBUG} >> /etc/mpdas.conf
echo "service = " ${SERVICE} >> /etc/mpdas.conf

cat /etc/mpdas.conf

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Rise and shine!"
/usr/bin/mpdas -c /etc/mpdas.conf
