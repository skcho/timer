open Ppx_core
open Ast_helper
open Ast_pattern
open Asttypes
module Timer = Timer

let timer_start ~loc =
  Exp.apply
    (Exp.ident {txt= Longident.parse "Timer.start_here"; loc})
    [(Nolabel, Ppx_here_expander.lift_position ~loc)]


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
