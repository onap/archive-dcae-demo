
set -e

apt-get update ; apt-get install -y maven openjdk-7-jdk curl dnsutils zip telnet

### GROOVY
(cd /opt/app ; curl -Lo apache-groovy-binary-2.4.6.zip https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.6.zip )
(cd /opt/app ; unzip apache-groovy-binary-2.4.6.zip )
mkdir -p /opt/app/groovy
ln -s /opt/app/groovy-2.4.6 /opt/app/groovy/246

### JAVA
mkdir -p /opt/app/java/jdk
ln -s /usr /opt/app/java/jdk/jdk170

mkdir -p /opt/app/dcae-controller-platform-server

(cd /opt/app/dcae-controller-platform-server ; unzip -o /tmp/controller.zip)

chmod +x /opt/app/dcae-controller-platform-server/bin/*
