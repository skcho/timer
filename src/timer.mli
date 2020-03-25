module Key : sig
  type t
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

module Make (T : InputS) : S

module Acc : InputS

include S
