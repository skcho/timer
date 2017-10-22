# timer

a simple timer for OCaml

## install

```
opam pin add ppx_timer https://github.com/skcho/ppx_timer.git
```

## example

### basic

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

### using ppx

`[%timer exp]` is expanded to

```ocaml
Timer.start_here [%here];
let v = exp in
Timer.stop ();
v
```
to calculate the evaluation time of exp.

See [test.ml](test/test.ml) for examples.
