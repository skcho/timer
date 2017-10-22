.PHONY: all timer install uninstall test clean

timer:
	jbuilder build @install src/timer.cmxa

install:
	jbuilder install timer

uninstall:
	jbuilder uninstall timer

test:
	jbuilder build test/test.exe
	_build/default/test/test.exe

clean:
	jbuilder clean
