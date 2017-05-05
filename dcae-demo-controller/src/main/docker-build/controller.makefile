
restart: stop start
gen-config:
	bin/dcae-controller.sh rackspace-substitute --from OPENECOMP-DEMO-$(BASE) --to OPENECOMP-DEMO-$(ZONE) --file /opt/app/dcae-controller/config.yaml
	java -cp 'lib/*' org.openecomp.dcae.controller.operation.utils.GenControllerConfiguration $(ZONE) . GITLINK OPENECOMP-DEMO
sync:
	bin/dcae-controller.sh sync-configuration --environment OPENECOMP-DEMO-$(ZONE)
sync-careful:
	bin/dcae-controller.sh stop
	rm -r data/resources/databus*
	rm -r data/resources/services/vm-*/instances/*/steps
	rm -r data/resources/services/docker-*/instances/*
	rm -r data/resources/services/cdap-*/instances/*
	bin/dcae-controller.sh sync-configuration --environment OPENECOMP-DEMO-$(ZONE)
start:
	bin/dcae-controller.sh start
start-debug:
	bin/controller-platform-server-controller start -Djavax.net.debug=all
stop:
	bin/dcae-controller.sh stop
console:
	bin/dcae-controller.sh console
S=3600
wait:
	@GROOVY_HOME=/opt/app/groovy/246 bin/dcae-controller.sh wait-for --timeout $S --path /services/docker-common-event/instances/$(ZONE) --attribute healthTestStatus --match GREEN
	@GROOVY_HOME=/opt/app/groovy/246 bin/dcae-controller.sh wait-for --timeout 300 --path /services/cdap-tca-hi-lo/instances/$(ZONE) --attribute healthTestStatus --match GREEN
status:
	@GROOVY_HOME=/opt/app/groovy/246 bin/dcae-controller.sh report -n /reports/dcae/service-instances | cut -d\| -f 2,3,4,5,6 | grep DEP | grep -v cells | cut -c1-120
	@GROOVY_HOME=/opt/app/groovy/246 bin/dcae-controller.sh report -n /reports/dcae/vms | cut -d\| -f 4,8 | grep zldc | grep -v cells
	@cat logs/error.log | cut -d\| -f 4,5,13 | sort | uniq -c
