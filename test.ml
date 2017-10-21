let do_sth () =
  let rec f n = if n < 0 then () else f (n - 1) in
  f 500000000

let simple () =
  Timer.start "simple1";
  do_sth ();
  Timer.start "simple2";
  do_sth ();
  do_sth ();
  Timer.end_ ();
  ()

let here () =
  Timer.start_here [%here];
  do_sth ();
  Timer.start_here [%here];
  do_sth ();
  do_sth ();
  Timer.end_ ();
  ()

let acc () =
  let f () =
    Timer.acc_start_here [%here];
    do_sth ();
    Timer.acc_start_here [%here];
    do_sth ();
    do_sth ();
    Timer.acc_end ()
  in
  List.iter f [(); ()];
  Timer.acc_flush ()

let () = simple ()

let () = here ()

let () = acc ()
