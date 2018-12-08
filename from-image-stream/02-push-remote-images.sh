#!/bin/sh

# WATCH OUT!
# >>> curl -OL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && mv jq-linux64 jq && export PATH=$PATH:.

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 FROM_IMAGE_STREAM_FILE TO_NAMESPACE" >&2
  exit 1
fi

FROM_IMAGE_STREAM_FILE=$1
TO_NAMESPACE=$2

#oc login https://occon.enp.aramco.com.sa -u admin

TOKEN=$(oc whoami -t)

if [ -z ${TOKEN} ]; then
echo "You need to log as admin in your Openshift cluster first..."
exit 1
fi

## Troubleshooting
# $ openssl s_client -showcerts -verify 5 -connect docker-registry-default.apps.serverless-ccf7.openshiftworkshop.com:443 < /dev/null
# Copy last CERT content to a file 'ca.crt', then copy that file to /etc/pki/ca-trust/source/anchors/
# $ cp ca.crt /etc/pki/ca-trust/source/anchors/
# $ update-ca-trust extract
# Restart docker
# $ systemctl restart docker

oc new-project ${TO_NAMESPACE}

export REGISTRY_URL=$(oc get routes -n default | grep docker-registry | awk '{print $2}')
docker login $REGISTRY_URL -u $(oc whoami) -p $(oc whoami -t)

IMAGE_STREAM_NAME=$(cat ${FROM_IMAGE_STREAM_FILE} | jq -r '.metadata.name')

IMAGE_LIST=$(cat ${FROM_IMAGE_STREAM_FILE} | jq -r '.spec.tags[] | select(.from.kind == "DockerImage") | .from.name')

IMAGE_OBJ_LIST=$(cat ${FROM_IMAGE_STREAM_FILE} | jq -r '.spec.tags[] | select(.from.kind == "DockerImage") | @base64')

declare -a image_arr=(${IMAGE_OBJ_LIST})

echo "image_arr: ${image_arr}"

## now loop through the above array
for i in ${image_arr[@]}
do
   echo "Decompressing, saving, compressing $(echo $i | base64 --decode)"
   TAG=$(echo $i | base64 --decode | jq -r '.name')
   echo "TAG ${TAG}"

   FULL_IMAGE_NAME=$(echo $i | base64 --decode | jq -r '.from.name')
   echo "FULL_IMAGE_NAME ${FULL_IMAGE_NAME}"

   FILE_NAME=$(echo ${FULL_IMAGE_NAME} | sed 's@/@_@g' | sed 's@:@__@g')
   echo "FILE_NAME ${FILE_NAME}"

   IMAGE_NAME=$(echo $i |base64 --decode | awk -F'/' '{print $3}')
   echo "IMAGE_NAME ${IMAGE_NAME}"

   tar zxvf ${FILE_NAME}.tar.gz
   docker load -i ${FILE_NAME}.tar
   docker tag ${FULL_IMAGE_NAME} $REGISTRY_URL/${TO_NAMESPACE}/${IMAGE_STREAM_NAME}:${TAG}
   docker push $REGISTRY_URL/${TO_NAMESPACE}/${IMAGE_STREAM_NAME}:${TAG}
done