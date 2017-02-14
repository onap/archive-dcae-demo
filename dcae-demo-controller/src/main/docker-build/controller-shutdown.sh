#!/bin/bash

set -v

export JAVA_HOME=/opt/app/java/jdk/jdk170
export GROOVY_HOME=/opt/app/groovy/246
export PATH=$JAVA_HOME/bin:$GROOVY_HOME/bin:/opt/app/git/2.4.1/bin:$PATH

export ZONE=$(grep ZONE /opt/app/dcae-controller/config.yaml | sed s/ZONE:.//)

cd /opt/app/dcae-controller-platform-server

bin/dcae-controller.sh restart

bin/dcae-controller.sh undeploy-service-instance -i $ZONE -s vm-docker-host-1
bin/dcae-controller.sh undeploy-service-instance -i $ZONE -s vm-postgresql
bin/dcae-controller.sh undeploy-service-instance -i $ZONE -s vm-cdap-cluster
