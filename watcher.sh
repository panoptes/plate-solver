#!/usr/bin/env bash

# Taken from:
# https://unix.stackexchange.com/questions/323901/how-to-use-inotifywait-to-watch-a-directory-for-creation-of-files-of-a-specific

INCOMING_DIR="${INCOMING_DIR:-/incoming}"

echo "Watching ${INCOMING_DIR} for file changes..."

inotifywait \
  "${INCOMING_DIR}" \
  --monitor \
  --recursive \
  --timefmt '%Y-%m-%dT%H:%M:%S' \
  --format '%T %w %f %e' |
  while read datetime dir filename event; do
    /app/handler.sh $datetime $dir $filename $event
  done
