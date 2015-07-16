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

if [[ "${access_key_id}X" == "X" || "${secret_access_key}" == "X" ]]; then
  echo "USAGE embed_image_blob.sh path/to/image/resource blob-name"
  echo "MISSING \$access_key_id and/or \$secret_access_key"
  exit 1
fi

if [[ -z "$(git config --global user.name)" ]]
then
  git config --global user.name "Concourse Bot"
  git config --global user.email "concourse-bot@starkandwayne.com"
fi

cat > config/private.yml << EOS
---
blobstore:
  s3:
    access_key_id: ${access_key_id}
    secret_access_key: ${secret_access_key}
EOS

set -ex

mkdir -p blobs/${blob_name}
cp ${rootfs_tar} blobs/${blob_name}/rootfs.tar

bosh -n upload blobs
git commit -a -m "added new ${blob_name} rootfs"
