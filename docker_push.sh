#!/bin/bash

# Re-tag the following images with the local docker registry
# and push them into the registry. Intended to be run following
# docker_load.sh

export SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/settings.sh

for line in $(docker images | grep $OLD_REGISTRY)
do
  IMAGE=$(echo $line | awk '{print $1}')
  VERS=$(echo $line | awk '{print $2}')
  HASH=$(echo $line | awk '{print $3}')

  NEW_TAG=$(echo $IMAGE | sed s/${OLD_REGISTRY}/${REGISTRY}/)

  # tag new registry server
  docker tag -f $HASH $NEW_TAG:$VERS

  # push to registry, retry if any errors
  RET=1
  while [ $RET -ne 0 ]
  do
    docker push $NEW_TAG:$VERS
    RET=$?
  done

  # finally, remove existing tag
  docker rmi $IMAGE:$VERS

done
