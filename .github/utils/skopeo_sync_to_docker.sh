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
   echo "skopeo sync $REGISTRY/$image to docker.io/apecloud"
   skopeo sync --all \
      --src-username "$DOCKER_USERNAME" \
      --src-password "$DOCKER_PASSWORD" \
      --dest-username "$DOCKER_USERNAME" \
      --dest-password "$DOCKER_PASSWORD" \
      --src docker \
      --dest docker \
      $REGISTRY/$image \
      docker.io/apecloud
done < $FILE_NAME
