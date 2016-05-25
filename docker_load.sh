#!/bin/bash

# Loads all images stored in .tar files.  Intended to 
# import the files created by docker_save.sh

export SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/settings.sh

for i in `find . -name "*.gz"`
do 
  echo -n "Decompressing: "
  ls ${i}
  gunzip ${i}
done

for i in `find . -name "*.tar"`
do 
  echo -n "Loading file: "
  ls ${i}
  docker load -i ${i}
done;
