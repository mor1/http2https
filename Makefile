.PHONY: all

all: mir-http2https

configure: $(wildcard src/*.ml)
	cd src && mirage configure --dhcp=true --unix $${MIRFLAGS}
build: $(wildcard src/*.ml)
	cd src && make

distclean:
	mirage clean -f src/config.ml
	$(RM) runner.tar.gz mir-http2https.tar.gz

clean:
	cd src && ( [ -r Makefile -a \! -z Makefile ] && make clean || true )
	$(RM) log mir-http2https.tar.gz runner.tar.gz
	$(RM) -r docker-unikernel-runner
