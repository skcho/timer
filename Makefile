.PHONY: all install uninstall test clean

all:
	jbuilder build @install src/ppx_timer.cmxa

install:
	jbuilder install ppx_timer

uninstall:
	jbuilder uninstall ppx_timer

test:
	jbuilder build test/test.exe
	_build/default/test/test.exe

clean:
	jbuilder clean
