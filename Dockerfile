FROM ocaml/opam:alpine

RUN opam config exec -- opam depext -i mirage

COPY ["src","Makefile","opam", "http2https/"]
RUN sudo chown -R opam http2https
WORKDIR /home/opam/http2https

RUN opam config exec -- opam pin add -n http2https .
RUN opam config exec -- opam depext -u http2https
RUN opam config exec -- opam depext \
         functoria lwt mirage-clock-unix mirage-conduit mirage-console \
         mirage-http mirage-logs mirage-net-unix mirage-types mirage-types-lwt \
         mirage-unix nocrypto tcpip
RUN opam config exec -- opam install --yes \
         functoria lwt mirage-clock-unix mirage-conduit mirage-console \
         mirage-http mirage-logs mirage-net-unix mirage-types mirage-types-lwt \
         mirage-unix nocrypto tcpip

ARG FROMP
ARG TOP
RUN opam config exec -- mirage configure --net=direct --unix -p $FROMP -r $TOP
RUN opam config exec -- make build

CMD tar -C /home/opam/http2https -czh -f - mir-http2https
