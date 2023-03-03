#!/bin/bash

# error codes
# 9 Invalid parameter

DEFAULT_UID=1000
DEFAULT_GID=1000

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

CMD_LINE="/usr/bin/mpdscribble --no-daemon --conf $SCRIBBLE_CONFIG_FILE"

echo "CMD_LINE=[$CMD_LINE]";

number_re="^[0-9]+$"
if [[ -n "$STARTUP_DELAY_SEC" ]]; then
    if ! [[ $STARTUP_DELAY_SEC =~ $number_re ]]; then
        echo "Invalid parameter STARTUP_DELAY_SEC"
        exit 9
    fi
    if [[ $STARTUP_DELAY_SEC -gt 0 ]]; then
        echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
        sleep $STARTUP_DELAY_SEC
        echo "Ready to start."
    fi
fi

# Create user and group
if [[ -n "{${PUID}" || "${USER_MODE^^}" == "YES" ]]; then
    echo "User mode enabled"
    if [ -z "${PUID}" ]; then
        PUID=$DEFAULT_UID;
        echo "Setting default value for PUID: ["$PUID"]"
    fi
    if [ -z "${PGID}" ]; then
        PGID=$DEFAULT_GID;
        echo "Setting default value for PGID: ["$PGID"]"
    fi
    USER_NAME=mpdscribble-user
    GROUP_NAME=mpdscribble-user
    ### create group
    if [ ! $(getent group $GROUP_NAME) ]; then
        echo "group $GROUP_NAME does not exist, creating..."
        addgroup -g $PGID $GROUP_NAME
    else
        echo "group $GROUP_NAME already exists."
    fi
    ### create user
    if [ ! $(getent passwd $USER_NAME) ]; then
        echo "user $USER_NAME does not exist, creating..."
        adduser -D -G $GROUP_NAME -u $PUID -s /bin/bash $USER_NAME
        id $USER_NAME
        echo "user $USER_NAME created."
    else
        echo "user $USER_NAME already exists."
    fi
    echo "Created $USER_NAME (group: $GROUP_NAME)"
    echo "Setting ownership ..."
    chown -R mpdscribble-user:mpdscribble-user /app/log/mpdscribble
    echo "Executing ..."
    su - $USER_NAME -c "$CMD_LINE"
else
    eval "$CMD_LINE"
fi
