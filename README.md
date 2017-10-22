# timer

a simple timer for OCaml

## install

```
opam pin add ppx_timer https://github.com/skcho/ppx_timer.git
```

## example

```ocaml
open Ppx_timer

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

See [test.ml](test/test.ml) for more cases.
