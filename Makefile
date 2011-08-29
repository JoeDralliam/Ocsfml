all: system # window graphics audio network

system:
	ocamlbuild -use-ocamlfind ocsfmlsystem.cma && \
	ocamlbuild -use-ocamlfind ocsfmlsystem.cmxa

window:
	ocamlbuild -use-ocamlfind ocsfmlwindow.cma && \
	ocamlbuild -use-ocamlfind ocsfmlwindow.cmxa

graphics:
	ocamlbuild -use-ocamlfind ocsfmlgraphics.cma && \
	ocamlbuild -use-ocamlfind ocsfmlgraphics.cmxa

audio:
	ocamlbuild -use-ocamlfind ocsfmlaudio.cma && \
	ocamlbuild -use-ocamlfind ocsfmlaudio.cmxa

network:
	ocamlbuild -use-ocamlfind ocsfmlnetwork.cma && \
	ocamlbuild -use-ocamlfind ocsfmlnetwork.cmxa

#test:
#	ocamlbuild -use-ocamlfind test.cmo

#install:
#	ocamlfind install pa_cpp_external META _build/pa_cpp_external.cmo

#uninstall:
#	ocamlfind remove pa_cpp_external

clean:
	ocamlbuild -clean