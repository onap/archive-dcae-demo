#!/bin/bash

set -e
set -x

## ensure we are in the right directory.
cd $(dirname $(readlink -e $0))

ROOT=../../..

## setup files

rm -rf lib/
mkdir -p lib

# copy core controller ZIP file

cp $ROOT/target/assembly/lib/*zip controller.zip
VERSION=$(grep version $ROOT/pom.xml | head -1 | sed 'sX</.*XX' | sed 's/.*>//')

# copy JAR required by controller
cp $ROOT/target/assembly/lib/*.jar lib/

# copy configuration files for controller
( 
  cd $ROOT/..
  tar cfz - OPENECOMP-DEMO OPENECOMP-DEMO-* 
) > config.tar.gz

if [ "$1" == "nobuild" ]; then exit; fi

## build Docker

docker_build="docker build -t dcae-controller:$VERSION ."
if [ $http_proxy ]; then
    docker_build+=" --build-arg http_proxy=$http_proxy"
fi
if [ $https_proxy ]; then
    docker_build+=" --build-arg https_proxy=$https_proxy"
fi
eval $docker_build
