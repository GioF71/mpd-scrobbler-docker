#!/bin/sh

#sed -i 's/MPD_AUDIO_DEVICE/'"$MPD_AUDIO_DEVICE"'/g' /etc/mpdas.conf

cat /etc/mpdas.conf

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Rise and shine!"
/usr/bin/mpdas -c /etc/mpdas.conf
