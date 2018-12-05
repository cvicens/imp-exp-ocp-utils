#!/bin/sh

if [ "$#" -lt 5 ]; then
  echo "Usage: $0 FROM_IMAGE_STREAM_FILE LOCAL_IMAGE_STREAM_NAMESPACE NAMESPACE APP_NAME GIT_URL [GIT_CONTEXT_DIR]" >&2
  exit 1
fi

FROM_IMAGE_STREAM_FILE=$1
LOCAL_IMAGE_STREAM_NAMESPACE=$2
NAMESPACE=$3
APP_NAME=$4
GIT_URL=$5
GIT_CONTEXT_DIR=$6

if [ ! -z ${GIT_CONTEXT_DIR} ]; then
CONTEXT_DIR_PARAM="--context-dir=${GIT_CONTEXT_DIR}"
fi

TOKEN=$(oc whoami -t)

if [ -z ${TOKEN} ]; then
  echo "You need to log as admin in your Openshift cluster first..."
  exit 1
fi

IMAGE_LIST=$(cat ${FROM_IMAGE_STREAM_FILE} | jq -r '.spec.tags[] | select(.from.kind == "DockerImage") | .from.name')
LAST_IMAGE=$(echo ${IMAGE_LIST} | awk '{print $(NF)}')
IMAGE_NAME=$(echo ${LAST_IMAGE} | awk -F'/' '{print $3}')

oc new-project ${NAMESPACE}

if [ "${LOCAL_IMAGE_STREAM_NAMESPACE}" != "openshift" ]; then
  oc policy add-role-to-user \
    system:image-puller system:serviceaccount:${NAMESPACE}:default \
    --namespace=${LOCAL_IMAGE_STREAM_NAMESPACE}
fi

oc new-app ${LOCAL_IMAGE_STREAM_NAMESPACE}/${IMAGE_NAME}~${GIT_URL} ${CONTEXT_DIR_PARAM} --name ${APP_NAME} -n ${NAMESPACE}
oc expose svc ${APP_NAME}