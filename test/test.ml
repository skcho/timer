open Ppx_timer

let do_sth () =
  let rec f n = if n < 0 then () else f (n - 1) in
  f 500000000


let simple () =
  let f () =
    Timer.start "a" ;
    do_sth () ;
    Timer.start "b" ;
    do_sth () ;
    do_sth () ;
    Timer.stop ()
  in
  List.iter f [(); ()] ;
  Timer.flush ()


let simple_here () =
  let f () =
    Timer.start_here [%here ] ;
    do_sth () ;
    Timer.start_here [%here ] ;
    do_sth () ;
    do_sth () ;
    Timer.stop ()
  in
  List.iter f [(); ()] ;
  Timer.flush ()


module MyTimerA = Timer.Make (struct
  include Timer.Acc

  let timer_name = "my timer A"
end)

module MyTimerB = Timer.Make (struct
  include Timer.Acc

  let timer_name = "my timer B"
end)

let my_timer () =
  MyTimerA.start_here [%here ] ;
  MyTimerB.start_here [%here ] ;
  do_sth () ;
  MyTimerA.stop () ;
  do_sth () ;
  MyTimerB.stop () ;
  MyTimerA.flush () ;
  MyTimerB.flush ()


(* [%timer exp] is expanded to

   Timer.start_here [%here];
   let v = exp in
   Timer.stop ();
   v

   to calculate the evaluation time of exp. *)
let ppx_timer () =
  if [%timer do_sth ()] <> () then [%timer do_sth ()] else [%timer do_sth ()] ;
  Timer.flush ()


let test title f =
  prerr_endline ("TEST: " ^ title) ;
  f () ;
  prerr_newline ()


let () =
  test "simple timer" simple ;
  test "simple timer + ppx_here" simple_here ;
  test "multiple timers + ppx_here" my_timer ;
  test "ppx_timer (using ppx_here by default)" ppx_timer

