#!/usr/bin/env bash

set -eo pipefail

ALIYUN_USERNAME=$1
ALIYUN_PASSWORD=$2
ALIYUN_USERNAME_NEW=$3
ALIYUN_PASSWORD_NEW=$4
FILE_NAME=$5
REGISTRY=$6

if [[ -z "$REGISTRY" ]]; then
    REGISTRY=registry.cn-hangzhou.aliyuncs.com
fi

while read -r image
do
   echo "skopeo sync $REGISTRY/$image to infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud"
   skopeo sync --all \
      --src-username "$ALIYUN_USERNAME" \
      --src-password "$ALIYUN_PASSWORD" \
      --dest-username "$ALIYUN_USERNAME_NEW" \
      --dest-password "$ALIYUN_PASSWORD_NEW" \
      --src docker \
      --dest docker \
      $REGISTRY/$image \
      infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud
done < $FILE_NAME
