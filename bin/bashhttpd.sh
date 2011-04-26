#!/usr/bin/env bash
if [[ ! -e "../etc/bashhttpd.conf" ]]; then
	echo "Couldn't find config file."
	exit
fi
source ../etc/bashhttpd.conf
tcpserver $SERVER_BINDIP $SERVER_PORT ./../lib/core.sh
