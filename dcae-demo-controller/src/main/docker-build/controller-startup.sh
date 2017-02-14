#!/bin/bash

set -v

apt-get install -y make 

export JAVA_HOME=/opt/app/java/jdk/jdk170
export GROOVY_HOME=/opt/app/groovy/246
export PATH=$JAVA_HOME/bin:$GROOVY_HOME/bin:/opt/app/git/2.4.1/bin:$PATH


cd /opt/app/dcae-controller-platform-server

export ZONE=$(grep ZONE /opt/app/dcae-controller/config.yaml | sed s/ZONE:.//)

OPENSTACK_KEYNAME=$(grep OPENSTACK-KEYNAME /opt/app/dcae-controller/config.yaml | sed s/OPENSTACK-KEYNAME:.//)
NETWORK=$(grep OPENSTACK-PRIVATE-NETWORK /opt/app/dcae-controller/config.yaml | sed s/OPENSTACK-PRIVATE-NETWORK:.//)

echo nameserver 10.0.0.1 >> /etc/resolv.conf

make gen-config sync restart

## need to do 2 syncs to get all references working.
make sync

cat OPENECOMP-DEMO-$ZONE/hosts >> /etc/hosts

## Add SSL CAs to Java 

(echo changeit ; echo yes ) | keytool -importcert -keystore /etc/ssl/certs/java/cacerts -alias simpledemo-root-ca -file config/simpledemo-root-ca.crt
(echo changeit ; echo yes ) | keytool -importcert -keystore /etc/ssl/certs/java/cacerts -alias simpledemo-server-ca -file config/simpledemo-server-ca.crt

bin/dcae-controller.sh undeploy-service-instance -i $ZONE -s vm-docker-host-1 &
bin/dcae-controller.sh undeploy-service-instance -i $ZONE -s vm-postgresql &
bin/dcae-controller.sh undeploy-service-instance -i $ZONE -s vm-cdap-cluster &

bin/dcae-controller.sh deploy-user -l $ZONE -p OPEN-ECOMP -u $OPENSTACK_KEYNAME

NETWORKPATH=/openstack/locations/$ZONE/projects/OPEN-ECOMP/networks/$NETWORK

sleep 1m
bin/dcae-controller.sh wait-for --timeout 300 --frequency 5 --path $NETWORKPATH --exists --verbose
bin/dcae-controller.sh deploy-service-instance -i $ZONE -s vm-docker-host-1 

sleep 1m
bin/dcae-controller.sh wait-for --timeout 300 --frequency 5 --path $NETWORKPATH --exists --verbose
bin/dcae-controller.sh deploy-service-instance -i $ZONE -s vm-postgresql  

sleep 2m
bin/dcae-controller.sh wait-for --timeout 300 --frequency 5 --path $NETWORKPATH --exists --verbose
bin/dcae-controller.sh deploy-service-instance -i $ZONE -s vm-cdap-cluster

bin/dcae-controller.sh wait-for --timeout 900 --path /services/vm-docker-host-1/instances/$ZONE --attribute healthTestStatus --match GREEN --verbose
bin/dcae-controller.sh wait-for --timeout 900 --path /services/vm-postgresql/instances/$ZONE --attribute healthTestStatus --match GREEN --verbose


bin/dcae-controller.sh deploy-service-instance -i $ZONE -s docker-databus-controller



bin/dcae-controller.sh wait-for --timeout 900 --path /services/vm-cdap-cluster/instances/$ZONE --attribute healthTestStatus --match GREEN --verbose
#bin/dcae-controller.sh wait-for --timeout 900 --path /services/vm-controller/instances/$ZONE --attribute healthTestStatus --match GREEN --verbose

bin/dcae-controller.sh deploy-service-instance -i $ZONE -s cdap-helloworld 
bin/dcae-controller.sh deploy-service-instance -i $ZONE -s cdap-tca-hi-lo
bin/dcae-controller.sh deploy-service-instance -i $ZONE -s docker-common-event


while [ 1 ]; do sleep 1d; done

