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

# Create user and group

DEFAULT_UID=1000
DEFAULT_GID=1000

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
HOME_DIR=/home/$USER_NAME
### create home directory and ancillary directories
if [ ! -d "$HOME_DIR" ]; then
echo "Home directory [$HOME_DIR] not found, creating."

mkdir -p $HOME_DIR
chown -R mpdscribble-user:mpdscribble-user $HOME_DIR
ls -la $HOME_DIR -d
ls -la $HOME_DIR
fi
### create group
if [ ! $(getent group $GROUP_NAME) ]; then
    echo "group $GROUP_NAME does not exist, creating..."
    groupadd -g $PGID $GROUP_NAME
else
    echo "group $GROUP_NAME already exists."
fi
### create user
if [ ! $(getent passwd $USER_NAME) ]; then
    echo "user $USER_NAME does not exist, creating..."
    useradd -g $PGID -u $PUID -s /bin/bash -M -d $HOME_DIR $USER_NAME
    id $USER_NAME
    echo "user $USER_NAME created."
else
    echo "user $USER_NAME already exists."
fi
echo "Created $USER_NAME (group: $GROUP_NAME)";

chown -R mpdscribble-user:mpdscribble-user /app/log/mpdscribble

CMD_LINE="/usr/bin/mpdscribble --no-daemon --conf $SCRIBBLE_CONFIG_FILE"

echo "CMD_LINE=[$CMD_LINE]"

su - $USER_NAME -c "$CMD_LINE"
