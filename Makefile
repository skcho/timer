.PHONY: all test clean

all:
	ocamlbuild -use-ocamlfind test.native

test: all
	./test.native

clean:
	ocamlbuild -clean
