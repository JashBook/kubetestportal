#!/bin/bash

set -eo pipefail

DOCKER_USERNAME=$1
DOCKER_PASSWORD=$2
ALIYUN_USERNAME=$3
ALIYUN_PASSWORD=$4
FILE_NAME=$5

while read -r line
do
   skopeo sync --all \
      --src-username "$DOCKER_USERNAME" \
      --src-password "$DOCKER_PASSWORD" \
      --dest-username "$ALIYUN_USERNAME" \
      --dest-password "$ALIYUN_PASSWORD" \
      --src docker \
      --dest docker \
      docker.io/$line \
      registry.cn-hangzhou.aliyuncs.com/apecloud

done < $FILE_NAME
