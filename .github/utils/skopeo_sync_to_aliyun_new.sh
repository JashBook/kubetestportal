#!/usr/bin/env bash

set -eo pipefail

DOCKER_USERNAME=$1
DOCKER_PASSWORD=$2
ALIYUN_USERNAME=$3
ALIYUN_PASSWORD=$4
FILE_NAME=$5
REGISTRY=$6

if [[ -z "$REGISTRY" ]]; then
    REGISTRY=docker.io
fi

while read -r image
do
   echo "skopeo sync $REGISTRY/$image to infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud"
   skopeo sync --all \
      --src-username "$DOCKER_USERNAME" \
      --src-password "$DOCKER_PASSWORD" \
      --dest-username "$ALIYUN_USERNAME" \
      --dest-password "$ALIYUN_PASSWORD" \
      --src docker \
      --dest docker \
      $REGISTRY/$image \
      infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud
done < $FILE_NAME
