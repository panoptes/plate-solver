#!/bin/bash -e
SOURCE_DIR="${PANDIR}/plate-solver"
CLOUD_FILE="cloudbuild.yaml"

echo "Building plate-solver"
gcloud builds submit \
    --config "${SOURCE_DIR}/docker/${CLOUD_FILE}" \
    "${SOURCE_DIR}"

