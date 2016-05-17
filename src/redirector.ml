let server_src = Logs.Src.create "server" ~doc:"HTTP-to-HTTPS redirector"
module S_log = (val Logs.src_log server_src : Logs.LOG)

module Make (Clock: V1.CLOCK) (S: Cohttp_lwt.Server) = struct

  let redirect _request uri =
    let new_uri = Uri.with_scheme uri (Some "https") in
    let to_port = Key_gen.toport () in
    let new_uri = Uri.with_port new_uri (Some to_port) in
    let headers =
      Cohttp.Header.init_with "location" (Uri.to_string new_uri)
    in
    S.respond ~headers ~status:`Moved_permanently ~body:`Empty ()

  let serve dispatch =
    let callback (_, cid) request _body =
      let uri = Cohttp.Request.uri request in
      let cid = Cohttp.Connection.to_string cid in
      S_log.info (fun f -> f  "[%s] serving %s." cid (Uri.to_string uri));
      dispatch request uri
    in
    let conn_closed (_,cid) =
      let cid = Cohttp.Connection.to_string cid in
      S_log.info (fun f -> f "[%s] closing" cid);
    in
    S.make ~conn_closed ~callback ()

  (* entrypoint *)
  module Logs_reporter = Mirage_logs.Make(Clock)
  let start _clock http =
    Logs.(set_level (Some Info));
    Logs_reporter.(create () |> run) @@ fun () ->
    let from_port = Key_gen.fromport () in
    http (`TCP from_port) @@ serve redirect

end
