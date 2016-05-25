#!/bin/bash

export SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/settings.sh

pushd ${REPO_STORAGE}

sudo tar -cvzf ${REPO_STORAGE_TARS}/rhel-7-server-rpms.tar.gz  		rhel-7-server-rpms
sudo tar -cvzf ${REPO_STORAGE_TARS}/rhel-7-server-extras-rpms.tar.gz  		rhel-7-server-extras-rpms
sudo tar -cvzf ${REPO_STORAGE_TARS}/rhel-7-server-ose-3.2-rpms.tar.gz  		rhel-7-server-ose-3.2-rpms
sudo tar -cvzf ${REPO_STORAGE_TARS}/rhel-ha-for-rhel-7-server-rpms.tar.gz 	rhel-ha-for-rhel-7-server-rpms

popd
