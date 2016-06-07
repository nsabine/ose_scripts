#!/bin/bash -x

export SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/settings.sh

repos=$(${SCRIPT_DIR}/docker_list_images.py | egrep  '^rhel|^openshift3|^rhscl/')

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
  
  VERSIONSTRING=$(docker images | grep $r | awk '{print $1 ":" $2}'| sort | uniq)

  echo sudo docker save -o ${IMAGE_STORAGE}/${r}.tar $VERSIONSTRING
  sudo docker save -o ${IMAGE_STORAGE}/${r}.tar $VERSIONSTRING
  sudo rm -f ${IMAGE_STORAGE}/${r}.tar.gz
  sudo gzip ${IMAGE_STORAGE}/${r}.tar
  underscore=$(echo ${r} | sed s^/^_^g)
  curl -k -f -v -T ${IMAGE_STORAGE}/${r}.tar.gz https://10.0.93.8/file/satelite6/${underscore}.tar.gz

done
