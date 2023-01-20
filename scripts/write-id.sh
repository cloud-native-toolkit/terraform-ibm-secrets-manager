#!/bin/bash
#
# This script writes the id of the secrets manager to a temp file.
# This is needed to keep a copy of the secrets manager's id after it has been destroyed
# for reclamation remove if required.
#

ID=$1
FILE_PATH=$2
FILENAME=$3

if [[ -z $ID ]] || [[ -z $FILE_PATH ]] || [[ -z $FILENAME ]]; then
    echo "ERROR: Incorrect usage."
    echo "Usage: $0 INSTANCE_ID FILE_PATH FILENAME"
    exit 1
fi

# Create directory if it does not exists
mkdir -p $FILE_PATH

# Remove file if it already exists as we will replace with new instance
if [[ -f "${FILE_PATH}/${FILENAME}" ]]; then
    rm "${FILE_PATH}/${FILENAME}"
fi

echo "$ID" > "${FILE_PATH}/${FILENAME}"