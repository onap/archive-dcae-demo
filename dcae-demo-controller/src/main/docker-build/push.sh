#!/bin/bash

set -e
set -x

## ensure we are in the right directory.
cd $(dirname $(readlink -e $0))

GITROOT=../../..
VERSION=$(grep version $GITROOT/pom.xml | head -1 | sed 'sX</.*XX' | sed 's/.*>//')
VERSION2=$(echo $VERSION | cut -d . -f1,2)
DOCKER_REG=$1
TAG=$DOCKER_REG/openecomp/dcae-controller:$VERSION

docker tag dcae-controller:$VERSION $TAG
docker push $TAG


case $VERSION in
  *SNAPSHOT)
    TAG1=$DOCKER_REG/openecomp/dcae-controller:$VERSION-$(date +%Y%m%dT%H%M%S)
    docker tag dcae-controller:$VERSION $TAG1
    docker push $TAG1
    ;;
  *)
    TAG1=$DOCKER_REG/openecomp/dcae-controller:$VERSION-STAGING-$(date +%Y%m%dT%H%M%S)
    docker tag dcae-controller:$VERSION $TAG1
    docker push $TAG1
    TAG2=$DOCKER_REG/openecomp/dcae-controller:latest
    docker tag dcae-controller:$VERSION $TAG2
    docker push $TAG2
    TAG3=$DOCKER_REG/openecomp/dcae-controller:$VERSION2-STAGING-latest
    docker tag dcae-controller:$VERSION $TAG3
    docker push $TAG3
    ;;
esac

