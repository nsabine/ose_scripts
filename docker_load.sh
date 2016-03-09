#!/bin/bash

# Loads all images stored in .tar files.  Intended to 
# import the files created by docker_save.sh

for gzfile in `find . -name "*.gz"`
do 
  echo -n "Decompressing: "
  ls ${gzfile}
  gunzip -k ${gzfile}
  tarfile=${gzfile%.*}
  docker load -i ${tarfile}
  rm -f ${tarfile}
done

