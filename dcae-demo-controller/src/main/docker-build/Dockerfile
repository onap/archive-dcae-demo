FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

ADD controller-install.sh /tmp/controller-install.sh
ADD controller.zip /tmp/controller.zip
ADD config.tar.gz /opt/app/dcae-controller-platform-server
ADD controller-startup.sh /opt/app/dcae-controller-platform-server/bin/controller-startup.sh
ADD controller-shutdown.sh /opt/app/dcae-controller-platform-server/bin/controller-shutdown.sh
ADD lib /opt/app/dcae-controller-platform-server/lib
ADD config /opt/app/dcae-controller-platform-server/config
ADD controller.makefile /opt/app/dcae-controller-platform-server/Makefile
ADD bash.setup.sh /root/bash.setup.sh

RUN /bin/bash /tmp/controller-install.sh

CMD ["/bin/bash", "-c", "/opt/app/dcae-controller-platform-server/bin/controller-startup.sh"]

