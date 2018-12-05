#!/bin/sh

# WATCH OUT!
# >>> brew install python-yq
# >>> curl -OL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && mv jq-linux64 jq && export PATH=$PATH:.

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FROM_IMAGE_STREAM_FILE" >&2
  exit 1
fi

FROM_IMAGE_STREAM_FILE=$1

IMAGE_LIST=$(cat ${FROM_IMAGE_STREAM_FILE} | yq -r ".spec.tags[] | .from.name")

declare -a arr=(${IMAGE_LIST})

## now loop through the above array
for i in ${arr[@]}
do
   echo "Pulling, saving, compressing $i"
   docker pull $i
   FILE_NAME=$(echo $i | sed 's@/@_@g' | sed 's@:@__@g')
   docker save -o ${FILE_NAME}.tar $i
   tar zcvf ${FILE_NAME}.tar.gz ${FILE_NAME}.tar 
done