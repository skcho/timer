module Key = struct
  type t = Str of string | Pos of Lexing.position

  let compare = compare

  let string_of = function
    | Str s -> s
    | Pos {Lexing.pos_fname; pos_lnum; pos_bol; pos_cnum} ->
      Printf.sprintf "%s:%d:%d" pos_fname pos_lnum (pos_cnum - pos_bol)

end

module type InputS = sig
  val timer_name : string

  type data

  val init_data : data

  val mod_data_start : Key.t -> data -> data

  val mod_data_stop : data -> data

  val get_times_flush : data -> (Key.t * float) list
end

module type S = sig
  val start : string -> unit

  val start_here : Lexing.position -> unit

  val stop : unit -> unit

  val flush : unit -> unit
end

module Make (T : InputS) : S = struct
  let print_time (key, t) =
    let name = Key.string_of key in
    Printf.fprintf stderr "[%s] %s\t%.3f\n%!" T.timer_name name t


  let data_ref = ref T.init_data

  let stop () = data_ref := T.mod_data_stop !data_ref

  let start_common key =
    stop () ;
    data_ref := T.mod_data_start key !data_ref


  let start name = start_common (Key.Str name)

  let start_here pos = start_common (Key.Pos pos)

  let flush () =
    stop () ;
    List.iter print_time (T.get_times_flush !data_ref) ;
    data_ref := T.init_data

end

module Acc = struct
  let timer_name = "timer"

  module M = Map.Make (Key)

  type data = {cur_opt: (Key.t * float) option; all: float M.t}

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
    {cur_opt= Some (title, Sys.time ()); all= add_cur_opt cur_opt all}


  let mod_data_stop {cur_opt; all} =
    {cur_opt= None; all= add_cur_opt cur_opt all}


  let get_times_flush {all} =
    M.fold (fun name time acc -> (name, time) :: acc) all [] |> List.rev

end

include Make (Acc)
