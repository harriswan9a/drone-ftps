#!/bin/bash

if [ -z "$PLUGIN_USERNAME" ]; then
    echo "Need to set username"
    exit 1
fi

if [ -z "$PLUGIN_HOSTNAME" ]; then
    echo "Need to set hostname"
    exit 1
fi

if [ -z "$PLUGIN_SECURE" ]; then
    PLUGIN_SECURE="true"
fi

if [ -z "$PLUGIN_DEST_DIR" ]; then
    PLUGIN_DEST_DIR="/"
fi

if [ -z "$PLUGIN_SRC_DIR" ]; then
    PLUGIN_SRC_DIR="/"
fi

if [ -z "$PLUGIN_SSL_ALLOW" ]; then
    PLUGIN_SSL_ALLOW="true"
fi

PLUGIN_EXCLUDE_STR=""
PLUGIN_INCLUDE_STR=""

IFS=',' read -ra in_arr <<< "$PLUGIN_EXCLUDE"
for i in "${in_arr[@]}"; do
    PLUGIN_EXCLUDE_STR="$PLUGIN_EXCLUDE_STR -x $i"
done
IFS=',' read -ra in_arr <<< "$PLUGIN_INCLUDE"
for i in "${in_arr[@]}"; do
    PLUGIN_INCLUDE_STR="$PLUGIN_INCLUDE_STR -i $i"
done

lftp -c "open -u $PLUGIN_USERNAME,$FTP_PASSWORD $PLUGIN_HOSTNAME; set ftp:ssl-allow $PLUGIN_SSL_ALLOW; set ftp:ssl-force $PLUGIN_SECURE; set ftp:ssl-protect-data $PLUGIN_SECURE; mirror -R $PLUGIN_INCLUDE_STR $PLUGIN_EXCLUDE_STR $(pwd)$PLUGIN_SRC_DIR $PLUGIN_DEST_DIR"