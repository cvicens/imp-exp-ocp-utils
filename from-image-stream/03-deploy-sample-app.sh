#!/bin/sh

if [ "$#" -lt 4 ]; then
  echo "Usage: $0 FROM_IMAGE_STREAM_FILE LOCAL_IMAGE_STREAM_NAMESPACE NAMESPACE GIT_URL [GIT_CONTEXT_DIR]" >&2
  exit 1
fi

FROM_IMAGE_STREAM_FILE=$1
LOCAL_IMAGE_STREAM_NAMESPACE=$2
NAMESPACE=$3
GIT_URL=$4
GIT_CONTEXT_DIR=$5

if [ ! -z ${GIT_CONTEXT_DIR} ]; then
CONTEXT_DIR_PARAM="--context-dir=${GIT_CONTEXT_DIR}"
fi

TOKEN=$(oc whoami -t)

if [ -z ${TOKEN} ]; then
  echo "You need to log as admin in your Openshift cluster first..."
  exit 1
fi

IMAGE_LIST=$(cat ${FROM_IMAGE_STREAM_FILE} | yq -r ".spec.tags[] | .from.name")
LAST_IMAGE=$(echo ${IMAGE_LIST} | awk '{print $(NF)}')
IMAGE_NAME=$(echo ${LAST_IMAGE} | awk -F'/' '{print $3}')

oc new-app ${LOCAL_IMAGE_STREAM_NAMESPACE}/${IMAGE_NAME}~${GIT_URL} ${CONTEXT_DIR_PARAM} -n ${NAMESPACE}