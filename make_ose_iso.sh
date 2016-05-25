#!/bin/bash -x

export SCRIPT_DIR=$(dirname $(realpath $0))

source ${SCRIPT_DIR}/settings.sh

${SCRIPT_DIR}/docker_save.sh
${SCRIPT_DIR}/repos_sync.sh
${SCRIPT_DIR}/repos_save.sh
${SCRIPT_DIR}/docs_save.sh

pushd ${STORAGE}
sudo rsync -avz --delete ${SCRIPT_DIR}/* ${SCRIPT_STORAGE}
sudo tar cvzf ${TMP_STORAGE}/ose_31.tar.gz ${REPO_STORAGE_TARS} ${IMAGE_STORAGE} ${DOCS_STORAGE}
popd

pushd ${TMP_STORAGE}
sudo rm ose31.part.*
sudo split -a 1 -b 3600M ${TMP_STORAGE}/ose_31.tar.gz ose31.part.
sudo rm ${TMP_STORAGE}/ose_31.tar.gz
popd

sudo rm ${ISO_STORAGE}/*.iso
for i in $(ls ${TMP_STORAGE});
do
	REALFILE=$(realpath ${TMP_STORAGE}/${i})
	sudo genisoimage -volid ${i} -joliet -rock -o ${ISO_STORAGE}/${i}.iso ${REALFILE}
done

aws s3 rm s3://ose-isomaker --recursive
aws s3 sync ${ISO_STORAGE} s3://ose-isomaker


sleep 300
sudo shutdown -h now 
