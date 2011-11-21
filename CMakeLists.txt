cmake_minimum_required(VERSION 2.8)

find_package( 
	SFML 
	COMPONENTS system window graphics audio network
)

find_package(
	Boost
	REQUIRED
)

set( SFML_DIR ${SFML_INCLUDE_DIR} CACHE PATH "SFML 'include' directory path" )
set( SFML_SYSTEM ${SFML_SYSTEM_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_WINDOW ${SFML_WINDOW_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_GRAPHICS ${SFML_GRAPHICS_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_AUDIO ${SFML_AUDIO_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( SFML_NETWORK ${SFML_NETWORK_LIBRARY_RELEASE} CACHE FILEPATH "SFML system library path" )
set( BOOST_DIR ${SFML_INCLUDE_DIR} CACHE PATH "Boost 'include' directory path" )
set( OCAML_DIR ${SFML_INCLUDE_DIR} CACHE PATH "Ocaml 'include' directory path (where 'caml' directory is)" )

message("${CMAKE_CXX_COMPILER_ID}")

if(MSVC_VERSION EQUAL 1600) #VC++ 2010
	set(MSVC_COMPATIBLE_COMPILER 1)
	set(GCC "g++")
	set(STDLIB "nostdlib")
	set(CMAKE_CXX_FLAGS "/nologo") #dummy flag
	configure_file( myocamlbuild_msvc.ml myocamlbuild.ml COPYONLY)
elseif(CMAKE_COMPILER_IS_GNUCXX)
	set(GCC_COMPATIBLE_COMPILER 1)
	set(GCC CMAKE_CXX_COMPILER)
	set(STDLIB "std++")
	set(CMAKE_CXX_FLAGS "-fpermissive")
	configure_file( myocamlbuild_gcc.ml myocamlbuild.ml COPYONLY)
elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
	set(GCC_COMPATIBLE_COMPILER 1)
	set(GCC "g++")
	set(STDLIB "c++")
	set(CMAKE_CXX_FLAGS "-stdlib=libc++")
	configure_file( myocamlbuild_gcc.ml myocamlbuild.ml COPYONLY)
endif()

configure_file( config.in config )

add_custom_target( 
	clear
	ocamlbuild -clean
)

add_custom_target( 
	system
	ocamlbuild -use-ocamlfind ocsfmlsystem.cma && ocamlbuild -use-ocamlfind ocsfmlsystem.cmxa
)

add_custom_target( 
	window
	ocamlbuild -use-ocamlfind ocsfmlwindow.cma && ocamlbuild -use-ocamlfind ocsfmlwindow.cmxa
)

add_custom_target( 
	graphics
	ocamlbuild -use-ocamlfind ocsfmlgraphics.cma && ocamlbuild -use-ocamlfind ocsfmlgraphics.cmxa
)

add_custom_target( 
	network
	ocamlbuild -use-ocamlfind ocsfmlnetwork.cma && ocamlbuild -use-ocamlfind ocsfmlnetwork.cmxa
)

add_custom_target( 
	audio
	ocamlbuild -use-ocamlfind ocsfmlaudio.cma && ocamlbuild -use-ocamlfind ocsfmlaudio.cmxa
)

add_custom_target( 
	clock
	ocamlbuild -use-ocamlfind Test/test_clock.native 
)

add_custom_target( 
	pong
	ocamlbuild -use-ocamlfind Test/test_pong.native 
)
