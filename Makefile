OCAMLBUILD=ocamlbuild -use-ocamlfind
OCAMLBUILD_DIR=$(shell ocamlbuild -where)

all:plugin-hack byte native

plugin-hack:
	(mkdir _build &> /dev/null) && \
	cp myocamlbuild.ml _build/myocamlbuild.ml && \
	cd _build && \
	ocamlfind ocamlopt -linkpkg -package ocamlbuildcpp -package ocamlbuild myocamlbuild.ml $(OCAMLBUILD_DIR)/ocamlbuild.cmx -o myocamlbuild && \
	cd ..


plugin:
	ocamlbuild -classic-display -verbose 10 -plugin-tag "package(ocamlbuildcpp)" -just-plugin


native:system-nat window-nat graphics-nat audio-nat network-nat


system-nat:
	$(OCAMLBUILD) OcsfmlSystem/ocsfmlsystem.cmxa

window-nat:
	$(OCAMLBUILD) OcsfmlWindow/ocsfmlwindow.cmxa

graphics-nat:
	$(OCAMLBUILD) OcsfmlGraphics/ocsfmlgraphics.cmxa

audio-nat:
	$(OCAMLBUILD) OcsfmlAudio/ocsfmlaudio.cmxa

network-nat:
	$(OCAMLBUILD) OcsfmlNetwork/ocsfmlnetwork.cmxa



byte:system-byte window-byte graphics-byte audio-byte network-byte


system-byte:
	$(OCAMLBUILD) OcsfmlSystem/ocsfmlsystem.cma

window-byte:
	$(OCAMLBUILD) OcsfmlWindow/ocsfmlwindow.cma

graphics-byte:
	$(OCAMLBUILD) OcsfmlGraphics/ocsfmlgraphics.cma

audio-byte:
	$(OCAMLBUILD) OcsfmlAudio/ocsfmlaudio.cma

network-byte:
	$(OCAMLBUILD) OcsfmlNetwork/ocsfmlnetwork.cma



install:
	ocamlfind install ocsfml META _build/Ocsfml*/*ocsfml*.*

uninstall:
	ocamlfind remove "ocsfml"


clean:
	$(OCAMLBUILD) -clean

examples:
	$(OCAMLBUILD) -lflag -custom Test/test_clock.byte
	$(OCAMLBUILD) Test/test_clock.native
	$(OCAMLBUILD) -lflag -custom Test/test_pong.byte
	$(OCAMLBUILD) Test/test_pong.native
	$(OCAMLBUILD) -lflag -custom Test/test_shader.byte
	$(OCAMLBUILD) Test/test_shader.native 
	$(OCAMLBUILD) -lflag -custom Test/test_sockets.byte
	$(OCAMLBUILD) Test/test_sockets.native 
	$(OCAMLBUILD) -lflag -custom Test/test_audio.byte
	$(OCAMLBUILD) Test/test_audio.native 
	$(OCAMLBUILD) -lflag -custom Test/graphicClock.byte
	$(OCAMLBUILD) Test/graphicClock.native


doc:plugin-hack
	$(OCAMLBUILD) -use-ocamlfind ocsfml.docdir/index.html

.PHONY:install uninstall
