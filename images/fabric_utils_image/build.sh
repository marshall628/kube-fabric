#!/bin/bash
ARCH=`uname -m | sed 's@i686@x86_64@'`
VERSION=1.0.5
# RELEASE=alpha
BASE_FOLDER=${PWD}
IMAGE_VERSION=${VERSION}

PEER_DOCKER_REPOSITORY=hyperledger/fabric-peer
if [ ! -z $RELEASE ]; then
	PEER_VERSION=${ARCH}-${VERSION}-${RELEASE}
else
	PEER_VERSION=${ARCH}-${VERSION}
fi

# Peer config path ocmes from Dockerfile.in in hyperledger repository
# Ref: https://github.com/hyperledger/fabric/blob/master/images/peer/Dockerfile.in
PEER_CFG_PATH=/etc/hyperledger/fabric

echo "Using image ${PEER_DOCKER_REPOSITORY}:${PEER_VERSION}"

docker run --rm -v ${BASE_FOLDER}/output/executable:/opt ${PEER_DOCKER_REPOSITORY}:${PEER_VERSION} cp /usr/local/bin/peer /opt
docker run --rm -v ${BASE_FOLDER}/output/peerconfig:/opt ${PEER_DOCKER_REPOSITORY}:${PEER_VERSION} cp -r ${PEER_CFG_PATH} /opt

docker build -f Dockerfile_fabric_utils -t marshall628/kubernetes_fabric_utils:x86_64-${IMAGE_VERSION} .

docker run --rm -v ${BASE_FOLDER}:/opt marshall628/kubernetes_fabric_utils:x86_64-${IMAGE_VERSION} rm -rf /opt/output
