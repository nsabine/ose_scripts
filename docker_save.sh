#!/bin/bash -x

repos=$(docker images | tail -n+2 | awk '{print $1}' | sort -u)

for r in $repos;
do
  mkdir -p $(dirname $r)
  docker save -o ${r}.tar $r
  gzip ${r}.tar
done
