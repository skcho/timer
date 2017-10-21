let do_sth () =
  let rec f n = if n < 0 then () else f (n - 1) in
  f 500000000


let simple () =
  Timer.start "simple1" ;
  do_sth () ;
  Timer.start "simple2" ;
  do_sth () ;
  do_sth () ;
  Timer.end_ () ;
  ()


let here () =
  Timer.start_here [%here ] ;
  do_sth () ;
  Timer.start_here [%here ] ;
  do_sth () ;
  do_sth () ;
  Timer.end_ () ;
  ()


let acc () =
  let f () =
    Timer.acc_start_here [%here ] ;
    do_sth () ;
    Timer.acc_start_here [%here ] ;
    do_sth () ;
    do_sth () ;
    Timer.acc_end ()
  in
  List.iter f [(); ()] ;
  Timer.acc_flush ()


module MyTimer1 = Timer.Make (struct
  include Timer.Simple

  let timer_name = "timer1"
end)

module MyTimer2 = Timer.Make (struct
  include Timer.Simple

  let timer_name = "timer2"
end)

let my_timer () =
  MyTimer1.start_here [%here ] ;
  MyTimer2.start_here [%here ] ;
  do_sth () ;
  MyTimer1.end_ () ;
  do_sth () ;
  MyTimer2.end_ ()


let test title f =
  prerr_endline ("TEST: " ^ title) ;
  f () ;
  prerr_newline ()


let () =
  test "simple timer" simple ;
  test "simple timer + ppx_here" here ;
  test "accumulate timer + ppx_here" acc ;
  test "multiple timers + ppx_here" my_timer

