open Ppx_core
open Ast_helper
open Ast_pattern
open Asttypes
module Timer = Timer

let lift_position ~loc p =
  let lid_of s = {txt= Longident.parse ("Lexing."^s); loc} in
  let str_of s = Exp.constant (Pconst_string (s, None)) in
  let int_of i = Exp.constant (Pconst_integer (Caml.string_of_int i, None)) in
  Exp.record
    [ (lid_of "pos_fname", str_of p.pos_fname)
    ; (lid_of "pos_lnum", int_of p.pos_lnum)
    ; (lid_of "pos_bol", int_of p.pos_bol)
    ; (lid_of "pos_cnum", int_of p.pos_cnum) ]
    None

let lift_location ~loc = lift_position ~loc loc.loc_start

let timer_start ~loc =
  Exp.apply
    (Exp.ident {txt= Longident.parse "Timer.start_here"; loc})
    [(Nolabel, lift_location ~loc)]


let timer_stop ~loc =
  Exp.apply
    (Exp.ident {txt= Longident.parse "Timer.stop"; loc})
    [(Nolabel, Exp.construct {txt= Longident.parse "()"; loc} None)]


let timer =
  Extension.declare "timer" Extension.Context.expression
    Ast_pattern.(pstr (pstr_eval __ nil ^:: nil)) (fun ~loc ~path:_ x ->
      Exp.sequence (timer_start ~loc)
        (Exp.let_ Nonrecursive
           [Vb.mk (Pat.var {txt= "__timer_v"; loc}) x]
           (Exp.sequence (timer_stop ~loc)
              (Exp.ident {txt= Longident.parse "__timer_v"; loc}))) )


let () = Ppx_driver.register_transformation "timer" ~extensions:[timer]
