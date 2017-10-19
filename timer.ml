(* simple timer *)

module Simple = struct

  let data = ref None

  let print_time_start title =
    prerr_endline ("Timer start:"^title)

  let print_time_end title t =
    prerr_endline ("Timer end:"^title^" "^string_of_float t)

  let end_ () =
    match !data with
    | None -> ()
    | Some (prev_title, prev_t) ->
      print_time_end prev_title (Sys.time () -. prev_t);
      data := None

  let start title =
    end_ ();
    data := Some (title, Sys.time ());
    print_time_start title
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

  let flush () =
    let print1 title t =
      prerr_endline ("Acc Timer:"^title^" "^string_of_float t)
    in
    end_ ();
    M.iter print1 !map;
    map := M.empty
end

let start = Simple.start

let end_ = Simple.end_

let acc_start = Acc.start

let acc_end = Acc.end_

let acc_flush = Acc.flush
