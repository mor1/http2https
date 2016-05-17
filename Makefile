.PHONY: all

all: mir-http2https

configure: $(wildcard src/*.ml)
	cd src && mirage configure --dhcp=true --unix $${MIRFLAGS}
build: $(wildcard src/*.ml)
	cd src && make

## build runner container
docker-unikernel-runner:
	$(RM) -r docker-unikernel-runner
	git clone http://github.com/mor1/docker-unikernel-runner
	cd docker-unikernel-runner && git checkout mirage-unix
mir-runner: docker-unikernel-runner
	cd docker-unikernel-runner && $(MAKE) mir-runner

mir-http2https.tar.gz: Dockerfile.builder
	docker build -t mir-http2https-builder -f Dockerfile.builder .
	docker run --rm mir-http2https-builder > mir-http2https.tar.gz

mir-http2https: mir-http2https.tar.gz mir-runner
	docker build -t mir-http2https -f Dockerfile.runner .

FROMP=80
TOP=443
run:
	docker run -d --name http2https \
	  --device=/dev/net/tun:/dev/net/tun --cap-add=NET_ADMIN \
	  -p $(FROMP):$(FROMP) -p $(TOP):$(TOP) \
	  -- mir-http2https

distclean:
	mirage clean -f src/config.ml
	$(RM) runner.tar.gz

clean:
	cd src && ( [ -r Makefile -a \! -z Makefile ] && make clean || true )
	$(RM) log mir-http2https.tar.gz
	$(RM) -r docker-unikernel-runner
