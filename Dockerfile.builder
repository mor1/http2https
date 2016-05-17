FROM ocaml/opam:alpine

RUN opam config exec -- opam depext -i mirage

COPY ["src","Makefile","opam", "http2https/"]
RUN sudo chown -R opam http2https
WORKDIR /home/opam/http2https

RUN opam config exec -- opam pin add -n http2https .
RUN opam config exec -- opam depext http2https
RUN opam config exec -- mirage configure --net=direct --unix
RUN opam config exec -- make build

CMD tar -C /home/opam/http2https -czh -f - mir-http2https
