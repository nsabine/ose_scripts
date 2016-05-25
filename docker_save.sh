#!/bin/bash -x

export SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/settings.sh

#repos=$(${SCRIPT_DIR}/docker_list_images.py | egrep -v "beta|rhcloud")
#repos=$( docker images | awk '{print $1}' | sort -u | grep redhat.com)
repos=$(${SCRIPT_DIR}/docker_list_images.py | egrep  '^rhel|^openshift3')

for r in $repos;
do
  SAVE_DIR=$(dirname ${IMAGE_STORAGE}/$r)
  sudo mkdir -p ${SAVE_DIR}
  CLEANEXIT=1
  TRIES=1
  while [ ${CLEANEXIT} -ne 0 -a ${TRIES} -lt 4 ]; 
  do
    docker pull -a registry.access.redhat.com/$r
    CLEANEXIT=$?
    ((TRIES++))
  done
  IMAGEID=$(docker images | grep ${r} | head -n 1 | awk '{print $3}')
  VERSIONS=$(docker images | grep ${IMAGEID} | awk '{print $2}')
  VERSIONSTRING=""
  for v in ${VERSIONS};
  do
    VERSIONSTRING="${VERSIONSTRING} ${r}:${v}"
  done
  echo "VERSION STRING: ${VERSIONSTRING}"

  sudo docker save -o ${IMAGE_STORAGE}/${r}.tar ${VERSIONSTRING}
  sudo rm ${IMAGE_STORAGE}/${r}.tar.gz
  sudo gzip ${IMAGE_STORAGE}/${r}.tar
done
