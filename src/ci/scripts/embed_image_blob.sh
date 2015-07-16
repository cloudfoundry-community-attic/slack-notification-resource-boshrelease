#!/bin/bash

image_resource=$1; shift
blob_name=$1; shift

if [[ "${blob_name}X" == "X" ]]; then
  echo "USAGE embed_image_blob.sh path/to/image/resource blob-name"
  exit 1
fi

ls -al ${image_resource}/*
