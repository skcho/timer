module type InputS = sig
  val timer_name : string

  type data

  val init_data : data

  val mod_data_start : string -> data -> data

  val mod_data_stop : data -> data

  val get_times_flush : data -> (string * float) list
end

module type S = sig
  val start : string -> unit

  val start_here : Lexing.position -> unit

  val stop : unit -> unit

  val flush : unit -> unit
end

module Make (T : InputS) : S = struct
  let print_time (name, t) =
    Printf.fprintf stderr "[%s] %s\t%.3f\n%!" T.timer_name name t


  let data_ref = ref T.init_data

  let stop () = data_ref := T.mod_data_stop !data_ref

  let start name =
    stop () ;
    data_ref := T.mod_data_start name !data_ref


  let flush () =
    stop () ;
    List.iter print_time (T.get_times_flush !data_ref) ;
    data_ref := T.init_data


  let start_here pos =
    let fname = pos.Lexing.pos_fname in
    let lnum = pos.Lexing.pos_lnum in
    start (fname ^ ":" ^ string_of_int lnum)

end

module Acc = struct
  let timer_name = "timer"

  module M = Map.Make (String)

  type data = {cur_opt: (string * float) option; all: float M.t}

  let init_data = {cur_opt= None; all= M.empty}

  let add_time name time all =
    let all_time =
      try M.find name all
      with Not_found -> 0.0
    in
    M.add name (time +. all_time) all


  let add_cur_opt cur_opt all =
    match cur_opt with
    | None -> all
    | Some (name, start) -> add_time name (Sys.time () -. start) all


  let mod_data_start title {cur_opt; all} =
    {cur_opt= Some (title, Sys.time ()); all = add_cur_opt cur_opt all}


  let mod_data_stop {cur_opt; all} =
    {cur_opt = None; all = add_cur_opt cur_opt all}


  let get_times_flush {all} =
    M.fold (fun name time acc -> (name, time) :: acc) all [] |> List.rev

end

include Make (Acc)
