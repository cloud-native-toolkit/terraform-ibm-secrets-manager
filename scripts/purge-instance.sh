#!/usr/bin/env bash
#
# This script purges a resource instance from reclamation. Note that this permanently removes the instance.
# It is not possible to recover the instance after this script has run.
# Script reads a file containing the instance id to purge from reclamation
#

ID_FILE=$1
INSTANCE_ID=$(cat ${ID_FILE})

if [[ ! -f $ID_FILE ]] || [[ -z $INSTANCE_ID ]]; then
    echo "ERROR: No file with instance id provided or file did not contain instance id."
    echo "Usage : $0 ID_FILE"
    exit 1
fi

# Set BIN_DIR in environment variables if CLI binaries are not in path
if [[ -z $BIN_DIR ]]; then
    DIR=""     # Use shell path for CLIs
else
    DIR="$BIN_DIR/"
fi

# Login to ibmcloud
if [[ -z $APIKEY ]]; then
    echo "ERROR: APIKEY not set. Please set environment variable prior to calling script."
    exit 1
fi

echo "Logging in to ibmcloud CLI"
${DIR}ibmcloud login --apikey $APIKEY -q --no-region

echo "Finding reclamation id for $INSTANCE_ID"
RECLAMATION_ID=$(${DIR}ibmcloud resource reclamations --resource-instance-id $INSTANCE_ID --output json | ${DIR}jq -r '.[].id')

if [[ -z $RECLAMATION_ID ]]; then
    echo "No reclamation instance found for instance id $INSTANCE_ID"
    exit 1
else
    echo "Purging instance id $INSTANCE_ID with reclamation id of $RECLAMATION_ID"
    ${BIN}ibmcloud resource reclamation-delete $RECLAMATION_ID -f
fi

while : 
do
    STATE=$(${BIN}ibmcloud resource reclamations --resource-instance-id $INSTANCE_ID --output json | jq -r '.[].state')
    if [[ ! -z $STATE ]]; then
        echo "STATE = ${STATE}. Sleeping 30 seconds."
        sleep 30
    else
        echo "Resource successfully purged from reclamation."
        break
    fi
done