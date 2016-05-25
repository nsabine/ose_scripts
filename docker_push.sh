#!/bin/bash

# Re-tag the following images with the local docker registry
# and push them into the registry. Intended to be run following
# docker_load.sh

export SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/settings.sh

IMAGES=$(docker images | grep redhat | awk '{print $1}')
for i in ${IMAGES[@]}; do
	echo "image: $i"
done
exit


for i in ${IMAGES[@]}; 
do 
  IMAGEID=$(docker inspect --format='{{.Id}}' $i)
  VERSION='latest'
  IMAGE=$(echo ${i} |  cut -d\/ -f 2-3)
  TAGNAME=$REGISTRY/$IMAGE:$VERSION

  echo docker tag $IMAGEID $TAGNAME
  docker tag $IMAGEID $TAGNAME
  echo docker push $TAGNAME
  docker push $TAGNAME
done;

