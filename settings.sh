#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath $0))

OLD_REGISTRY=registry.access.redhat.com
REGISTRY=ose-registry.example.com

STORAGE=/export/ose_iso
REPO_STORAGE=${STORAGE}/repos
REPO_STORAGE_TARS=${STORAGE}/repo_tars
IMAGE_STORAGE=${STORAGE}/images
DOCS_STORAGE=${STORAGE}/docs
TMP_STORAGE=${STORAGE}/tmp
ISO_STORAGE=${STORAGE}/iso
SCRIPT_STORAGE=${STORAGE}/scripts



for i in "${STORAGE} ${REPO_STORAGE} ${REPO_STORAGE_TARS} ${IMAGE_STORAGE} ${DOCS_STORAGE} ${TMP_STORAGE} ${ISO_STORAGE} ${SCRIPT_STORAGE}";
do
	if [[ ! -d ${i} ]]; 
	then
		sudo mkdir -p ${i}
	fi
done
