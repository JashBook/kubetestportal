#!/usr/bin/env bash

set -eo pipefail

images=$1
images_list=$2

rm -f $images_list
touch $images_list

for image in `echo "$images" | sed 's/|/ /g'`; do
   echo "$image" >> $images_list
done