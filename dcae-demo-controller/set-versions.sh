#!/bin/bash

#set -e
#set -v

## go to location with clone GIT repositories
cd $(dirname $(dirname $(dirname $0)))

VERSION=$1



## handle POM files with no parent
for file in $(find dcae-* -name pom.xml); do
   if [ "$(grep -c '<parent>' $file)" == "0" ]; then
     ( cd $(dirname $file) ;  mvn versions:set versions:commit -DnewVersion=$VERSION -DprocessDependencies=false )
   fi
done 

find . -name pom.xml.versionsBackup -delete

## handle complete build pom
FILE=dcae-org.openecomp.dcae.controller/pom-complete-build.xml
sed -i "sX<version>.*</version><!--VERSION-->X<version>$VERSION</version><!--VERSION-->X" $FILE

