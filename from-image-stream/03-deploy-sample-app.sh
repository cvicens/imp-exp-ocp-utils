#!/bin/sh

# Environment
. ./00-environment.sh

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 NAMESPACE GIT_URL GIT_CONTEXT_DIR" >&2
  exit 1
fi

NAMESPACE=$1
GIT_URL=$2
GIT_CONTEXT_DIR=$3

if [ ! -z ${GIT_CONTEXT_DIR} ]; then
CONTEXT_DIR_PARAM="--context-dir=${GIT_CONTEXT_DIR}"
fi

IMAGE_LIST=$(cat ${FROM_IMAGE_STREAM_FILE}.yaml | yq -r ".spec.tags[] | .from.name")
LAST_IMAGE=$(echo ${IMAGE_LIST} | awk '{print $(NF)}')
IMAGE_NAME=$(echo ${LAST_IMAGE} | awk -F'/' '{print $3}')

oc new-app ${TO_NAMESPACE}/${IMAGE_NAME}~${GIT_URL} ${CONTEXT_DIR_PARAM} -n ${NAMESPACE}