#!/usr/bin/env bash

set -eo pipefail

ALIYUN_USERNAME=$1
ALIYUN_PASSWORD=$2
FILE_NAME=$3
REGISTRY=$4

if [[ -z "$REGISTRY" ]]; then
    REGISTRY=docker.io
fi

while read -r image
do
   image_name=${image##*/}
   echo "skopeo copy $REGISTRY/$image to infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/$image_name"
   skopeo copy --all \
      --dest-username "$ALIYUN_USERNAME" \
      --dest-password "$ALIYUN_PASSWORD" \
      docker://$REGISTRY/$image \
      docker://registry.cn-hangzhou.aliyuncs.com/apecloud/$image_name
done < $FILE_NAME
