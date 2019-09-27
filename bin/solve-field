#!/bin/bash

INDEX_DIR=${INDEX_DIR:-/var/panoptes/astrometry/data}
SOLVE_FILE=$1

# Run the solve command
docker run \
	--rm \
	-v "${INDEX_DIR}":/usr/share/astrometry \
	-v "${PWD}":/tmp \
	--user $(id -u):$(id -g) \
	panoptes/plate-solver "${@:2}" "/tmp/${SOLVE_FILE}"

# Change permissions on all files
#chown $USER:$USER $(basename ${SOLVE_FILE} .fits)*
