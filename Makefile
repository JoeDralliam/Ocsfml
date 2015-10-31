OCAMLBUILD=ocamlbuild -use-ocamlfind -j 4
OCAMLBUILD_DIR=$(shell ocamlc -where)/ocamlbuild

all:plugin byte native

plugin-hack:
	(mkdir _build &> /dev/null) ; \
	cp myocamlbuild.ml _build/myocamlbuild.ml && \
	cd _build && \
	ocamlfind ocamlopt -linkpkg -package ocamlbuildcpp-dev -package ocamlbuild myocamlbuild.ml $(OCAMLBUILD_DIR)/ocamlbuild.cmx -o myocamlbuild && \
	cd ..


plugin:
	$(OCAMLBUILD) -plugin-tag "package(ocamlbuildcpp-dev)" -just-plugin


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

doc:plugin
	$(OCAMLBUILD) -use-ocamlfind ocsfml.docdir/index.html

.PHONY:install uninstall
