#!/bin/bash

INCOMING=/incoming
OUTGOING=/outgoing

SOLVE_OPTS="${1:-v}"

echo "Solving with ${SOLVE_OPTS}"

inotifywait -m "${INCOMING}" -e create -e moved_to |
    while read path action file; do
	solve-field ${SOLVE_OPTS} -D "${OUTGOING}" "${INCOMING}/${file}"
	rm "${INCOMING}/${file}"
    done
