(* simple timer *)

let str_of_pos x =
  let fname = x.Lexing.pos_fname in
  let lnum = x.Lexing.pos_lnum in
  fname^":"^string_of_int lnum

module Simple = struct

  let data = ref None

  let print_time_end title t =
    prerr_endline ("[timer]:"^title^" "^string_of_float t)

  let end_ () =
    match !data with
    | None -> ()
    | Some (prev_title, prev_t) ->
      print_time_end prev_title (Sys.time () -. prev_t);
      data := None

  let start title =
    end_ ();
    data := Some (title, Sys.time ())

  let start_here x = start (str_of_pos x)
end

(* timer for accumulation *)

module Acc = struct

  module M = Map.Make (String)

  let data = ref None

  let map = ref M.empty

  let acc_time title new_t =
    let t = try M.find title !map with Not_found -> 0.0 in
    map := M.add title (t +. new_t) !map

  let end_ () =
    match !data with
    | None -> ()
    | Some (prev_title, prev_t) ->
      acc_time prev_title (Sys.time () -. prev_t);
      data := None

  let start title =
    end_ ();
    data := Some (title, Sys.time ())

  let start_here x = start (str_of_pos x)

  let flush () =
    let print1 title t =
      prerr_endline ("[acc timer]:"^title^" "^string_of_float t)
    in
    end_ ();
    M.iter print1 !map;
    map := M.empty
end

let start = Simple.start

let end_ = Simple.end_

let start_here = Simple.start_here

let acc_start = Acc.start

let acc_end = Acc.end_

let acc_start_here = Acc.start_here

let acc_flush = Acc.flush
