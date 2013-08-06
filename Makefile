all:plugin byte native

plugin:
	ocamlbuild -ocamlc "ocamlfind ocamlc -linkpkg -package ocamlbuildcpp" -ocamlopt "ocamlfind ocamlopt -linkpkg -package ocamlbuildcpp" -just-plugin OcsfmlSystem/ocsfmlsystem.cma


native:system-nat window-nat graphics-nat audio-nat network-nat


system-nat:
	ocamlbuild -use-ocamlfind ocsfmlsystem.cmxa

window-nat:
	ocamlbuild -use-ocamlfind ocsfmlwindow.cmxa

graphics-nat:
	ocamlbuild -use-ocamlfind ocsfmlgraphics.cmxa

audio-nat:
	ocamlbuild -use-ocamlfind ocsfmlaudio.cmxa

network-nat:
	ocamlbuild -use-ocamlfind ocsfmlnetwork.cmxa



byte:system-byte window-byte graphics-byte audio-byte network-byte


system-byte:
	ocamlbuild -use-ocamlfind ocsfmlsystem.cma

window-byte:
	ocamlbuild -use-ocamlfind ocsfmlwindow.cma

graphics-byte:
	ocamlbuild -use-ocamlfind ocsfmlgraphics.cma

audio-byte:
	ocamlbuild -use-ocamlfind ocsfmlaudio.cma

network-byte:
	ocamlbuild -use-ocamlfind ocsfmlnetwork.cma



install:
	ocamlfind install ocsfml META _build/Ocsfml*/*ocsfml*.*

uninstall:
	ocamlfind remove "ocsfml"


clean:
	ocamlbuild -clean

examples:
	ocamlbuild -use-ocamlfind -lflag -custom Test/test_clock.byte
	ocamlbuild -use-ocamlfind Test/test_clock.native
	ocamlbuild -use-ocamlfind -lflag -custom Test/test_pong.byte
	ocamlbuild -use-ocamlfind Test/test_pong.native
	ocamlbuild -use-ocamlfind -lflag -custom Test/test_shader.byte
	ocamlbuild -use-ocamlfind Test/test_shader.native 
	ocamlbuild -use-ocamlfind -lflag -custom Test/test_sockets.byte
	ocamlbuild -use-ocamlfind Test/test_sockets.native 
	ocamlbuild -use-ocamlfind -lflag -custom Test/graphicClock.byte
	ocamlbuild -use-ocamlfind Test/graphicClock.native

.PHONY:install uninstall
