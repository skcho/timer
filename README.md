# timer

a simple timer for OCaml

## example

```ocaml
let foo x =
  Timer.start "a"; (* Timer "a" starts. *)
  ...
  Timer.start "b"; (* Timer "a" stops. Time of "a" is accumulated.
                      Timer "b" starts. *)
  ...
  Timer.stop ()    (* Timer "b" stops. Time of "b" is accumulated. *)
in
List.iter foo l;
Timer.flush        (* All accumulated times are printed. *)
```

See [test.ml](test.ml) for more cases.
