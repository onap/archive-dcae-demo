#!/bin/bash

set -e
set -x

## ensure we are in the right directory.
cd $(dirname $(readlink -e $0))

GITROOT=../../../../..
VERSION=$(grep version $GITROOT/pom.xml | head -1 | sed 'sX</.*XX' | sed 's/.*>//')
USER=$1
PASSWORD=$2
DOCKER_REG=$3
TAG=$DOCKER_REG/dcae-controller:$VERSION

docker tag dcae-controller:$VERSION $TAG
docker login -u $USER -p $PASSWORD $DOCKER_REG
docker push $TAG

