cmake_minimum_required(VERSION 2.8)

find_package( 
	SFML 
	COMPONENTS system window graphics audio network
)

find_package(
	Boost
	REQUIRED
)

execute_process(
	COMMAND ocamlc -where
	OUTPUT_VARIABLE OCAML_LIB_DIR
)

set( SFML_DIR ${SFML_INCLUDE_DIR} CACHE PATH "SFML 'include' directory path" )
set( SFML_SYSTEM ${SFML_SYSTEM_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_WINDOW ${SFML_WINDOW_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_GRAPHICS ${SFML_GRAPHICS_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_AUDIO ${SFML_AUDIO_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_NETWORK ${SFML_NETWORK_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( BOOST_DIR ${Boost_INCLUDE_DIR} CACHE PATH "Boost 'include' directory path" )
set( OCAML_DIR ${OCAML_LIB_DIR} CACHE PATH "Ocaml 'include' directory path (where 'caml' directory is)" )
set( OCAMLPP_DIR ${CMAKE_SOURCE_DIR}/camlpp )

message("${CMAKE_CXX_COMPILER_ID}")

if(MSVC_VERSION EQUAL 1600) #VC++ 2010
	set(MSVC_COMPATIBLE_COMPILER 1)
	set(GCC "g++")
	set(STDLIB "nostdlib")
	set(OBJ_EXTENSION "obj")
	set(LIB_EXTENSION "lib")
	set(CMAKE_CXX_FLAGS "/nologo") #dummy flag
	configure_file( ${CMAKE_SOURCE_DIR}/myocamlbuild_msvc.ml ${CMAKE_SOURCE_DIR}/myocamlbuild.ml COPYONLY)
elseif(CMAKE_COMPILER_IS_GNUCXX)
	set(GCC_COMPATIBLE_COMPILER 1)
	set(GCC ${CMAKE_CXX_COMPILER})
	set(STDLIB "-lstdc++")
	set(OBJ_EXTENSION "o")
	set(LIB_EXTENSION "a")
	set(CMAKE_CXX_FLAGS "-fpermissive")
	configure_file( ${CMAKE_SOURCE_DIR}/myocamlbuild_gcc.ml ${CMAKE_SOURCE_DIR}/myocamlbuild.ml COPYONLY)
elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
	set(GCC_COMPATIBLE_COMPILER 1)
	set(GCC "g++")
	set(STDLIB "-lc++ -lstdc++")
	set(OBJ_EXTENSION "o")
	set(LIB_EXTENSION "a")
	set(CMAKE_CXX_FLAGS "-stdlib=libc++")
	configure_file( ${CMAKE_SOURCE_DIR}/myocamlbuild_gcc.ml ${CMAKE_SOURCE_DIR}/myocamlbuild.ml COPYONLY)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(DLL_EXTENSION "dylib")
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "-framework \\1" SFML_SYSTEM "${SFML_SYSTEM}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "-framework \\1" SFML_WINDOW "${SFML_WINDOW}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "-framework \\1" SFML_GRAPHICS "${SFML_GRAPHICS}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "-framework \\1" SFML_NETWORK "${SFML_NETWORK}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "-framework \\1" SFML_AUDIO "${SFML_AUDIO}" )
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(DLL_EXTENSION "so")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set(DLL_EXTENSION "dll")
endif()

configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlNetwork/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlAudio/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfml_window_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfml_window_stub.hpp COPYONLY)

configure_file(${CMAKE_SOURCE_DIR}/_tags.in ${CMAKE_SOURCE_DIR}/_tags)
configure_file(${CMAKE_SOURCE_DIR}/config.in ${CMAKE_SOURCE_DIR}/config )
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfmlsystem.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfmlsystem.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfmlwindow.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfmlwindow.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfmlgraphics.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfmlgraphics.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlAudio/ocsfmlaudio.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlAudio/ocsfmlaudio.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlNetwork/ocsfmlnetwork.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlNetwork/ocsfmlnetwork.cpplib)

add_custom_target( 
	clear
	ocamlbuild -clean
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(
	ocsfml
	ALL	ocamlbuild -use-ocamlfind ocsfmlsystem.cma
	COMMAND ocamlbuild -use-ocamlfind ocsfmlsystem.cmxa
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlwindow.cma
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlwindow.cmxa
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlgraphics.cma 
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlgraphics.cmxa
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlnetwork.cma
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlnetwork.cmxa
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlaudio.cma
	COMMAND	ocamlbuild -use-ocamlfind ocsfmlaudio.cmxa
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

#add_custom_target(
#	infer_system
#		ocamlbuild -use-ocamlfind ocsfmlSystem.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlSystem/ocsfmlSystem.inferred.mli OcsfmlSystem/ocsfmlSystem.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_window
#		ocamlbuild -use-ocamlfind ocsfmlWindow.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlWindow/ocsfmlWindow.inferred.mli OcsfmlWindow/ocsfmlWindow.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_graphics
#		ocamlbuild -use-ocamlfind ocsfmlGraphics.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlGraphics/ocsfmlGraphics.inferred.mli OcsfmlGraphics/ocsfmlGraphics.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_network
#		ocamlbuild -use-ocamlfind ocsfmlNetwork.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlNetwork/ocsfmlNetwork.inferred.mli OcsfmlNetwork/ocsfmlNetwork.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_audio
#	ocamlbuild -use-ocamlfind ocsfmlAudio.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlAudio/ocsfmlAudio.inferred.mli OcsfmlAudio/ocsfmlAudio.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

macro(ocsfml_library dir name)
	set(${name} _build/Ocsfml${dir}/ocsfml${dir}.cmi _build/Ocsfml${dir}/dllocsfml${name}.${DLL_EXTENSION}  _build/Ocsfml${dir}/ocsfml${name}.cma _build/Ocsfml${dir}/libocsfml${name}.${LIB_EXTENSION} _build/Ocsfml${dir}/ocsfml${name}.cmxa _build/Ocsfml${dir}/ocsfml${name}.${LIB_EXTENSION} )
endmacro()

ocsfml_library(System system) 
ocsfml_library(Window window) 
ocsfml_library(Graphics graphics) 
ocsfml_library(Audio audio) 
ocsfml_library(Network network)

add_custom_target(
  install
  ocamlfind install ocsfml META ${system} ${window} ${graphics} ${audio} ${network}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(
  uninstall
  ocamlfind remove "ocsfml"
)

add_custom_target(
	external_cpp
	ocamlbuild -use-ocamlfind ./camlpp/ExternalCpp/pa_cpp_external.cma
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)	

add_custom_target(
	install_external_cpp
	ocamlfind install "external_cpp" camlpp/ExternalCpp/META _build/camlpp/ExternalCpp/pa_cpp_external.cma _build/camlpp/ExternalCpp/pa_cpp_external.cmi _build/camlpp/ExternalCpp/synthese.cmi _build/camlpp/ExternalCpp/cppExternalAst.cmi
	COMMAND ${CMAKE_COMMAND} -E copy_directory ./camlpp/camlpp "/usr/local/include/camlpp"
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(
	uninstall_external_cpp
	ocamlfind remove "external_cpp"
	COMMAND ${CMAKE_COMMAND} -E remove_directory /usr/local/include/camlpp
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)


add_custom_target( 
	tests
	ocamlbuild -use-ocamlfind Test/test_clock.byte
	COMMAND ocamlbuild -use-ocamlfind Test/test_clock.native
	COMMAND ocamlbuild -use-ocamlfind Test/test_pong.byte
	COMMAND ocamlbuild -use-ocamlfind Test/test_pong.native
	COMMAND ocamlbuild -use-ocamlfind Test/test_shader.byte
	COMMAND ocamlbuild -use-ocamlfind Test/test_shader.native 
	COMMAND ocamlbuild -use-ocamlfind Test/test_sockets.byte
	COMMAND ocamlbuild -use-ocamlfind Test/test_sockets.native 
#	COMMAND ocamlbuild -use-ocamlfind Test/test_audio.byte
#	COMMAND ocamlbuild -use-ocamlfind Test/test_audio.native
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
