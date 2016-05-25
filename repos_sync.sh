#!/bin/bash -x

export SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/settings.sh

syncrepo() {
  REPONAME=$1
  sudo reposync -n -m -l -p ${REPO_STORAGE}/${REPONAME}/ -r ${REPONAME} | grep -v Skipping
  repomanage -k 2 --old ${REPO_STORAGE}/${REPONAME} | xargs sudo rm 
  sudo createrepo_c --workers 2 --update -g ${REPO_STORAGE}/${REPONAME}/${REPONAME}/comps.xml ${REPO_STORAGE}/${REPONAME}/
}

cleanrepos() {
  sudo yum clean all
}

cleanrepos

syncrepo rhel-7-server-rpms
syncrepo rhel-7-server-extras-rpms
syncrepo rhel-7-server-ose-3.2-rpms
syncrepo rhel-ha-for-rhel-7-server-rpms

cleanrepos

exit 0
