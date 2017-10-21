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

module Make (T : InputS) : S

module Simple : InputS

module Acc : InputS

val start : string -> unit

val start_here : Lexing.position -> unit

val end_ : unit -> unit

val acc_start : string -> unit

val acc_start_here : Lexing.position -> unit

val acc_end : unit -> unit

val acc_flush : unit -> unit
