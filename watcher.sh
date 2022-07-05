#!/usr/bin/env bash

# Taken from:
# https://unix.stackexchange.com/questions/323901/how-to-use-inotifywait-to-watch-a-directory-for-creation-of-files-of-a-specific

INCOMING_DIR="${INCOMING_DIR:-.}"
OUTGOING_DIR="${OUTGOING_DIR:-.}"
SOLVE_OPTS="${SOLVE_OPTS:-}"


function handle_fits_file() {
  echo "Event: $datetime $dir $filename $event"
  echo "Running 'solve-field $SOLVE_OPTS ${dir}${filename}'"
  /usr/bin/solve-field $SOLVE_OPTS --dir "${OUTGOING_DIR}" "${dir}/${filename}"
}

echo "Watching ${INCOMING_DIR} for file changes..."
inotifywait \
  "${INCOMING_DIR}" \
  --monitor \
  -e close \
  --recursive \
  --timefmt '%Y-%m-%dT%H:%M:%S' \
  --format '%T %w %f %e' |
  while read datetime dir filename event; do
    if [ ${filename##*.} == 'fits' ]; then
      handle_fits_file "${datetime}" "${dir}" "${filename}" "${event}"
    fi
  done
