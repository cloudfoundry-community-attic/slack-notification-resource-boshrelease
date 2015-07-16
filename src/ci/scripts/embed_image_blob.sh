#!/bin/bash

image_resource=$1; shift
blob_name=$1; shift

if [[ "${blob_name}X" == "X" ]]; then
  echo "USAGE embed_image_blob.sh path/to/image/resource blob-name"
  exit 1
fi

rootfs_tar=${image_resource}/rootfs.tar
if [[ ! -f ${rootfs_tar} ]]; then
  echo "USAGE embed_image_blob.sh path/to/image/resource blob-name"
  echo "ERROR: path/to/image/resource/rootfs.tar not found, enable with params: {rootfs: true}"
  exit 1
fi

set -ex

mkdir -p blobs/${blob_name}
cp ${rootfs_tar} blobs/${blob_name}/rootfs.tar

bosh -n upload blobs
git commit -a "added new ${blob_name} rootfs"
