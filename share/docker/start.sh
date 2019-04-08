#!/bin/sh

cd $GHOST_INSTALL

exec docker-entrypoint.sh node current/index.js
