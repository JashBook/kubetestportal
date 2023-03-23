#!/usr/bin/env bash

set -eo pipefail

DOCKER_USERNAME=$1
DOCKER_PASSWORD=$2
FILE_NAME=$3
REGISTRY=$4

if [[ -z "$REGISTRY" ]]; then
    REGISTRY=docker.io
fi

while read -r image
do
   image_name=${image##*/}
   echo "skopeo copy $REGISTRY/$image to docker.io/apecloud/$image_name"
   skopeo copy --all \
      --dest-username "$DOCKER_USERNAME" \
      --dest-password "$DOCKER_PASSWORD" \
      docker://$REGISTRY/$image \
      docker://docker.io/apecloud/$image_name
done < $FILE_NAME
