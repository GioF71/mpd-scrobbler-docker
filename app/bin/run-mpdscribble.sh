#!/bin/bash

SCRIBBLE_CONFIG_FILE=/app/conf/mpdscribble.conf

echo "#mpdscribble configuration" > $SCRIBBLE_CONFIG_FILE

if [ -n "$PROXY" ]; then
    echo "proxy = $PROXY" >> $SCRIBBLE_CONFIG_FILE
fi
echo "log = /app/log/mpdscribble/scribble.log" >> $SCRIBBLE_CONFIG_FILE
if [ -n "$SCRIBBLE_VERBOSE" ]; then
    echo "verbose = $SCRIBBLE_VERBOSE" >> $SCRIBBLE_CONFIG_FILE
fi

if [ -n "$MPD_HOSTNAME" ]; then
    echo "host = $MPD_HOSTNAME" >> $SCRIBBLE_CONFIG_FILE
fi

if [ -n "$MPD_PORT" ]; then
    echo "port = $MPD_PORT" >> $SCRIBBLE_CONFIG_FILE
fi

if [ -n "$LASTFM_USERNAME" ]; then
    echo "[last.fm]" >> $SCRIBBLE_CONFIG_FILE
    echo "url = https://post.audioscrobbler.com/" >> $SCRIBBLE_CONFIG_FILE 
    echo "username = ${LASTFM_USERNAME}" >> $SCRIBBLE_CONFIG_FILE
    echo "password = ${LASTFM_PASSWORD}" >> $SCRIBBLE_CONFIG_FILE
    echo "journal = /app/log/mpdscribble/lastfm.journal" >> $SCRIBBLE_CONFIG_FILE
fi
if [ -n "$LIBREFM_USERNAME" ]; then
    echo "[libre.fm]" >> $SCRIBBLE_CONFIG_FILE
    echo "url = http://turtle.libre.fm/" >> $SCRIBBLE_CONFIG_FILE 
    echo "username = ${LIBREFM_USERNAME}" >> $SCRIBBLE_CONFIG_FILE
    echo "password = ${LIBREFM_PASSWORD}" >> $SCRIBBLE_CONFIG_FILE
    echo "journal = /app/log/mpdscribble/librefm.journal" >> $SCRIBBLE_CONFIG_FILE
fi
if [ -n "$JAMENDO_USERNAME" ]; then
    echo "[jamendo]" >> $SCRIBBLE_CONFIG_FILE
    echo "url = http://postaudioscrobbler.jamendo.com/" >> $SCRIBBLE_CONFIG_FILE 
    echo "username = ${JAMENDO_USERNAME}" >> $SCRIBBLE_CONFIG_FILE
    echo "password = ${JAMENDO_PASSWORD}" >> $SCRIBBLE_CONFIG_FILE
    echo "journal = /app/log/mpdscribble/jamendo.journal" >> $SCRIBBLE_CONFIG_FILE
fi
echo "[file]" >> $SCRIBBLE_CONFIG_FILE
echo "file = /app/log/mpdscribble/file.log" >> $SCRIBBLE_CONFIG_FILE

cat $SCRIBBLE_CONFIG_FILE
/usr/bin/mpdscribble --no-daemon --conf $SCRIBBLE_CONFIG_FILE
