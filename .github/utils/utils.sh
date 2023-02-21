#!/usr/bin/env bash

set -eo pipefail

images=$1
images_list=$2

for image in `echo "$images" | sed 's/|/ /g'`; do
   echo "$image" > $images_list
done