open Mirage

(** Configure keys *)

let fromport_key =
  let doc = Key.Arg.info
              ~doc:"TCP port to listen on."
              ~docv:"FROM-PORT"
              ~env:"HTTP2HTTPS_PORT"
              ["p"; "port"]
  in
  Key.(create "fromport" Arg.(opt ~stage:`Both int 80 doc))

let toport_key =
  let doc = Key.Arg.info
              ~doc:"TCP port to redirect to."
              ~docv:"TO-PORT"
              ~env:"HTTP2HTTPS_REDIRECT"
              ["r"; "redirect"]
  in
  Key.(create "toport" Arg.(opt ~stage:`Both int 443 doc))

let uri_key =
  let doc = Key.Arg.info
              ~doc:"Target URI to redirect requests to."
              ~docv:"URI"
              ~env:"HTTP2HTTPS_URI"
              ["u"; "uri"]
  in
  Key.(create "uri" Arg.(opt ~stage:`Both string "https://localhost/" doc))

let keys = Key.([
    abstract fromport_key; abstract toport_key; abstract uri_key
  ])

(** Configure unikernel *)

let unikernel = foreign ~keys "Redirector.Make" (clock @-> http @-> job)

let stack = generic_stackv4 default_console tap0
let http = http_server (conduit_direct stack)

let () =
  let tracing = None (* mprof_trace ~size:10000 () *) in
  register
    ?tracing "http2https" [
      unikernel $ default_clock $ http
    ]
