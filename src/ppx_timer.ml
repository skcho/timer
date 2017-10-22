open Ppx_core

module Timer = struct include Timer end

let timer_start ~loc =
  let open Ast_helper in
  Exp.apply
    (Exp.ident Asttypes.{txt= Longident.parse "Timer.start_here"; loc})
    [(Asttypes.Nolabel, Ppx_here_expander.lift_position ~loc)]

let timer_stop ~loc =
  let open Ast_helper in
  Exp.apply
    (Exp.ident Asttypes.{txt= Longident.parse "Timer.stop"; loc})
    [(Asttypes.Nolabel,
      Exp.construct
        Asttypes.{txt= Longident.parse "()"; loc}
        None)]

let timer =
  Extension.declare "timer" Extension.Context.expression
    Ast_pattern.(pstr ((pstr_eval __ nil) ^:: nil))
    (fun ~loc ~path:_ x ->
       let open Ast_helper in
       (Exp.sequence
          (timer_start ~loc)
          (Exp.let_ Nonrecursive
             [Vb.mk (Pat.var Asttypes.{txt= "__timer_v"; loc}) x]
             (Exp.sequence
                (timer_stop ~loc)
                (Exp.ident Asttypes.{txt= Longident.parse "__timer_v"; loc})))))

let () = Ppx_driver.register_transformation "timer" ~extensions:[ timer ]
