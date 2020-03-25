.PHONY: all install uninstall test clean

all:
	dune build

install:
	dune install timer

uninstall:
	dune uninstall timer

test:
	dune runtest

clean:
	dune clean
