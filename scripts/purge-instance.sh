#!/usr/bin/env bash
#
# This script purges a resource instance from reclamation. Note that this permanently removes the instance.
# It is not possible to recover the instance after this script has run.
#

INSTANCE_ID=$1

if [[ -z $INSTANCE_ID ]]; then
    echo "ERROR: No instance id provided."
    echo "Usage : $0 INSTANCE_ID"
    exit 1
fi

# Set BIN_DIR in environment variables if CLI binaries are not in path
if [[ -z $BIN_DIR ]]; then
    DIR=""     # Use shell path for CLIs
else
    DIR="$BIN_DIR/"
fi

RECLAMATION_ID=$(${DIR}ibmcloud resource reclamations --resource-instance-id $INSTANCE_ID --output json | ${DIR}jq -r '.[].id')

if [[ -z $RECLAMATION_ID ]]; then
    echo "No reclamation instance found for instance id $INSTANCE_ID"
    exit 1
else
    echo "Purging instance id $INSTANCE_ID with reclamation id of $RECLAMATION_ID"
    ${BIN}ibmcloud resource reclamation-delete $RECLAMATION_ID -f
fi