dstfile = /etc/NetworkManager/dispatcher.d/unbound

install:
	install dispatch-unbound.pl $(dstfile)

uninstall:
	rm $(dstfile)
