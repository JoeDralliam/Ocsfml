.PHONY: all system window graphics audio network camlpp install_camlpp uninstall_camlpp test_clock test_window clean doc

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

camlpp:
	ocamlbuild -use-ocamlfind ./camlpp/ExternalCpp/pa_cpp_external.cma

install_camlpp:
	ocamlfind install "external_cpp" camlpp/ExternalCpp/META \
	_build/camlpp/ExternalCpp/pa_cpp_external.cma \
	_build/camlpp/ExternalCpp/pa_cpp_external.cmi \
	_build/camlpp/ExternalCpp/synthese.cmi \
	_build/camlpp/ExternalCpp/cppExternalAst.cmi && \
	cp -R ./camlpp/camlpp /usr/local/include/camlpp

uninstall_camlpp:
	ocamlfind remove "external_cpp" && \
	rm -R /usr/local/include/camlpp

test_clock:
	ocamlbuild -use-ocamlfind Test/test_clock.native

#test_thread:
#	ocamlbuild -use-ocamlfind Test/test_thread.native

test_window:
	ocamlbuild -use-ocamlfind Test/test_window.native

test_graphics:
	ocamlbuild -use-ocamlfind Test/test_graphics.native

test_audio:
	ocamlbuild -use-ocamlfind Test/test_audio.native

doc:
	ocamlbuild -use-ocamlfind sfml.docdir/index.html

#test:
#	ocamlbuild -use-ocamlfind test.cmo

#install:
#	ocamlfind install pa_cpp_external META _build/pa_cpp_external.cmo

#uninstall:
#	ocamlfind remove pa_cpp_external

clean:
	ocamlbuild -clean

