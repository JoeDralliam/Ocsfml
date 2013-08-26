all:plugin-hack byte native

plugin-hack:
	(mkdir _build &> /dev/null) && \
	cp myocamlbuild.ml _build/myocamlbuild.ml && \
	cd _build && \
	ocamlfind ocamlopt -linkpkg -package ocamlbuildcpp -package ocamlbuild myocamlbuild.ml /home/joedralliam/.opam/4.02.0dev+trunk/lib/ocaml/ocamlbuild/ocamlbuild.cmx -o myocamlbuild && \
	cd ..


plugin:
	ocamlbuild -classic-display -verbose 10 -plugin-tag "package(ocamlbuildcpp)" -just-plugin


native:system-nat window-nat graphics-nat audio-nat network-nat


system-nat:
	ocamlbuild OcsfmlSystem/ocsfmlsystem.cmxa

window-nat:
	ocamlbuild OcsfmlWindow/ocsfmlwindow.cmxa

graphics-nat:
	ocamlbuild OcsfmlGraphics/ocsfmlgraphics.cmxa

audio-nat:
	ocamlbuild OcsfmlAudio/ocsfmlaudio.cmxa

network-nat:
	ocamlbuild OcsfmlNetwork/ocsfmlnetwork.cmxa



byte:system-byte window-byte graphics-byte audio-byte network-byte


system-byte:
	ocamlbuild OcsfmlSystem/ocsfmlsystem.cma

window-byte:
	ocamlbuild OcsfmlWindow/ocsfmlwindow.cma

graphics-byte:
	ocamlbuild OcsfmlGraphics/ocsfmlgraphics.cma

audio-byte:
	ocamlbuild OcsfmlAudio/ocsfmlaudio.cma

network-byte:
	ocamlbuild OcsfmlNetwork/ocsfmlnetwork.cma



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
	ocamlbuild -use-ocamlfind -lflag -custom Test/test_audio.byte
	ocamlbuild -use-ocamlfind Test/test_audio.native 
	ocamlbuild -use-ocamlfind -lflag -custom Test/graphicClock.byte
	ocamlbuild -use-ocamlfind Test/graphicClock.native


doc:plugin-hack
	ocamlbuild -use-ocamlfind ocsfml.docdir/index.html

.PHONY:install uninstall
