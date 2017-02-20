#!/bin/bash

set -e
set -x

## ensure we are in the right directory.
cd $(dirname $(readlink -e $0))

GITROOT=../../..
VERSION=$(grep version $GITROOT/pom.xml | head -1 | sed 'sX</.*XX' | sed 's/.*>//')
DOCKER_REG=$1
TAG=$DOCKER_REG/dcae-controller:$VERSION

docker tag dcae-controller:$VERSION $TAG
docker push $TAG

