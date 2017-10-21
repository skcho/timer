module type InputS = sig
  val timer_name : string

  type data

  val init_data : data

  val mod_data_start : string -> data -> data

  val mod_data_end : data -> data

  val get_time_end : data -> (string * float) option

  val get_times_flush : data -> (string * float) list option
end

module type S = sig
  val start : string -> unit

  val start_here : Lexing.position -> unit

  val end_ : unit -> unit

  val flush : unit -> unit
end

module Make (T : InputS) : S = struct
  let print_time (name, t) =
    prerr_endline ("["^T.timer_name^"]"^name^":"^string_of_float t)

  let data_ref = ref T.init_data

  let end_ () =
    (match T.get_time_end !data_ref with
     | Some time -> print_time time
     | None -> ());
    data_ref := T.mod_data_end !data_ref

  let start name =
    end_ ();
    data_ref := T.mod_data_start name !data_ref

  let flush () =
    end_ ();
    (match T.get_times_flush !data_ref with
     | Some times -> List.iter print_time times
     | None -> ());
    data_ref := T.init_data

  let start_here pos =
    let fname = pos.Lexing.pos_fname in
    let lnum = pos.Lexing.pos_lnum in
    start (fname^":"^string_of_int lnum)
end

module Simple = struct
  let timer_name = "timer"

  type data = (string * float) option

  let init_data = None

  let mod_data_start name _ = Some (name, Sys.time ())

  let mod_data_end _ = None

  let get_time_end = function
    | None -> None
    | Some (name, start) -> Some (name, Sys.time () -. start)

  let get_times_flush _ = None
end

module Acc = struct

  let timer_name = "acc timer"

  module M = Map.Make (String)

  type data = {
    cur_opt : Simple.data;
    all : float M.t;
  }

  let init_data = {
    cur_opt = Simple.init_data;
    all = M.empty
  }

  let add_time name time all =
    let all_time = try M.find name all with Not_found -> 0.0 in
    M.add name (time +. all_time) all

  let add_cur_opt cur_opt all =
    match Simple.get_time_end cur_opt with
    | None -> all
    | Some (name, time) -> add_time name time all

  let mod_data_start title {cur_opt; all} =
    let all = add_cur_opt cur_opt all in
    {cur_opt = Some (title, Sys.time ()); all}

  let mod_data_end {cur_opt; all} =
    let all = add_cur_opt cur_opt all in
    let cur_opt = Simple.mod_data_end cur_opt in
    {cur_opt; all}

  let get_time_end _ = None

  let get_times_flush {all} =
    M.fold (fun name time acc -> (name, time) :: acc) all []
    |> List.rev
    |> fun x -> Some x
end

module SimpleTimer = Make (Simple)

let start = SimpleTimer.start

let start_here = SimpleTimer.start_here

let end_ = SimpleTimer.end_

module AccTimer = Make (Acc)

let acc_start = AccTimer.start

let acc_start_here = AccTimer.start_here

let acc_end = AccTimer.end_

let acc_flush = AccTimer.flush
