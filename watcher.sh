#!/usr/bin/env bash

INCOMING_DIR="${INCOMING_DIR:-.}"
OUTGOING_DIR="${OUTGOING_DIR:-.}"
SOLVE_OPTS="${SOLVE_OPTS:-}"

function handle_cr2_file() {
  echo "Extracting JPEG from CR2."
  exiftool -b -PreviewImage "${dir}${filename}" > "${OUTGOING_DIR}/${filename%.cr2}.jpg"
  
  echo "Converting CR2 to FITS."
  rawtran -c plain -o "${OUTGOING_DIR}/${filename%.cr2}.fits" "${dir}${filename}"
  
  echo "Removing CR2 file."
  rm "${dir}${filename}"
}

function handle_fits_file() {
  echo "Running 'solve-field $SOLVE_OPTS ${dir}${filename}'"
  /usr/bin/solve-field $SOLVE_OPTS --dir "${OUTGOING_DIR}" "${dir}${filename}"
  rm "${dir}${filename}"
}

function handle_file() {
  echo "Event: $datetime $dir $filename $event"
  if [ "${filename##*.}" == 'fits' ]; then
    handle_fits_file "${datetime}" "${dir}" "${filename}" "${event}"
  fi
  if [ "${filename##*.}" == 'CR2' ] || [ "${filename##*.}" == 'cr2' ]; then
    handle_cr2_file "${datetime}" "${dir}" "${filename}" "${event}"
  fi
}

echo "Watching ${INCOMING_DIR} for file changes..."
inotifywait \
  "${INCOMING_DIR}" \
  --monitor \
  -e create \
  --recursive \
  --timefmt '%Y-%m-%dT%H:%M:%S' \
  --format '%T %w %f %e' |
  while read -r datetime dir filename event; do
    handle_file "${datetime}" "${dir}" "${filename}" "${event}"
  done
