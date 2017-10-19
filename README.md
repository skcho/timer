# timer

a simple timer for OCaml

## use

simple case

```ocaml
Timer.start "a"; (* timer "a" start *)
...
Timer.start "b"; (* timer "a" end + print "a" time + timer "b" start *)
...
Timer.end_ () (* timer "b" end + print "b" time *)
```

timer for loop

```ocaml
let foo x =
  Timer.acc_start "a"; (* timer "a" start *)
  ...
  Timer.acc_end () (* timer "a" end + the time is accumulated *)
in
iter foo l;
Timer.acc_flush (* print accumulated "a" time *)
```
