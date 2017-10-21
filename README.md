# timer

a simple timer for OCaml

## example

simple case

```ocaml
Timer.start "a"; (* Timer "a" starts. *)
...
Timer.start "b"; (* Timer "a" stops. Time of "a" is printed.
                    Timer "b" starts. *)
...
Timer.stop ()    (* Timer "b" stops. Time of "b" is printed. *)
```

timer for accumulated time

```ocaml
let foo x =
  Timer.acc_start "a"; (* Timer "a" starts. *)
  ...
  Timer.acc_start "b"; (* Timer "a" stops. Time of "a" is accumulated.
                          Timer "b" starts. *)
  ...
  Timer.acc_stop ()    (* Timer "b" stops. Time of "b" is accumulated. *)
in
List.iter foo l;
Timer.acc_flush        (* All accumulated times are printed. *)
```

See [test.ml](test.ml) for more cases.
