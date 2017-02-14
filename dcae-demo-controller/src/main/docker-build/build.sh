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
  tar cfz - OPENECOMP-DEMO OPENECOMP-DEMO-RACKSPACE 
) > config.tar.gz

if [ "$1" == "nobuild" ]; then exit; fi

## build Docker

docker build -t dcae-controller:$VERSION .

