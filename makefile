all:
	make clean
	mkdir out
	gcc myservice.c -o out/myservice

install:
	cp out/myservice /usr/bin/myservice
	chmod +x /usr/bin/myservice
	cp myservice.sh /etc/init.d/myserviced
	chmod +x /etc/init.d/myserviced
	update-rc.d myserviced defaults
	service myserviced start

uninstall:
	-service myserviced stop
	-rm -r /usr/bin/myservice
	-update-rc.d myserviced remove
	-rm -r /etc/init.d/myserviced

installd:
	cp out/myservice /usr/bin/myservice
	chmod +x /usr/bin/myservice
	cp myserviced.service /etc/systemd/system/myserviced.service
	systemctl enable myserviced
	systemctl start myserviced

uninstalld:
	-systemctl stop myserviced
	-systemctl disable myserviced
	-rm -r /etc/systemd/system/myserviced.service
	-rm -r /usr/bin/myservice

debug:
	make
	out/myservice -d

run:
	make
	out/myservice

clean:
	-rm -rf out/