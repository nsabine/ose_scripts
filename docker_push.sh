#!/bin/bash

# Re-tag the following images with the local docker registry
# and push them into the registry. Intended to be run following
# docker_load.sh

SOURCE_REGISTRY=registry.access.redhat.com
DESTINATION_REGISTRY=ose-registry.example.com

IMAGES=$(docker images | awk -v SRC="${SOURCE_REGISTRY}" '$0 ~ SRC {printf "%s:%s\n",$1,$2}')

for i in ${IMAGES[@]}; 
do 
  IMAGE=$(echo ${i} |  cut -d\/ -f 2-3)
  TAGNAME=${DESTINATION_REGISTRY}/${IMAGE}

  echo docker tag ${i} $TAGNAME
  #docker tag ${i} $TAGNAME
  echo docker push $TAGNAME
  #docker push $TAGNAME
done;

