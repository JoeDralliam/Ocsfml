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
set( SFML_WINDOW ${SFML_WINDOW_LIBRARY_RELEASE} CACHE FILEPATH "SFML window library path" )
set( SFML_GRAPHICS ${SFML_GRAPHICS_LIBRARY_RELEASE} CACHE FILEPATH "SFML graphics library path" )
set( SFML_AUDIO ${SFML_AUDIO_LIBRARY_RELEASE} CACHE FILEPATH "SFML audio library path" )
set( SFML_NETWORK ${SFML_NETWORK_LIBRARY_RELEASE} CACHE FILEPATH "SFML network library path" )
set( BOOST_DIR ${Boost_INCLUDE_DIR} CACHE PATH "Boost 'include' directory path" )
set( OCAML_DIR ${OCAML_LIB_DIR} CACHE PATH "Ocaml 'include' directory path (where 'caml' directory is)" )

set(CPP_COMPILER ${CMAKE_CXX_COMPILER})

if(MSVC_VERSION EQUAL 1600) #VC++ 2010
	set(MSVC_COMPATIBLE_COMPILER 1) 
	set(EXTERNAL_CPP_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/Ocsfml/Include")
	set(TESTS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/Ocsfml/Test")
	set(LIB_MAKER "lib")
	set(DLL_LINKER "flexlink")
	set(LINK_STDLIB "S []")
	set(OBJ_FLAG "/Fo")
	set(LIB_FLAG "/OUT:")
	set(INCLUDEPATH_FLAG "/I")
	set(COMPILATION_FLAGS "A \"/MD\" ; A \"/I${EXTERNAL_CPP_INSTALL_PREFIX}\" ; A \"/EHsc\" ; A \"/c\"")
	set(LINKING_LIB_FLAGS "A \"/NODEFAULTLIB\" ; A \"/LIBPATH:./build\"")
	set(LINKING_DLL_FLAGS "A \"-chain\" ; A \"msvc\" ; A \"-L./build\"")
	set(MAKE_STATIC_COMMAND "make_library")
	set(OBJ_EXTENSION "obj")
	set(LIB_EXTENSION "lib")
	set(OCSFML_LINKPATH "A \"-L${OCAML_DIR}/site-lib/ocsfml\"")
elseif(CMAKE_COMPILER_IS_GNUCXX)
	set(GCC_COMPATIBLE_COMPILER 1) 
	set(TESTS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/share/Ocsfml")
	set(EXTERNAL_CPP_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/include/Ocsfml")
	set(LIB_MAKER "ar")
	set(DLL_LINKER "${CMAKE_CXX_COMPILER}")
	set(LINK_STDLIB "A \"-cclib\" ; A \"-lstdc++\"")
	set(OBJ_FLAG "-o")
	set(LIB_FLAG "-q")
	set(INCLUDEPATH_FLAG "-I")
	set(COMPILATION_FLAGS "A \"-fPIC\" ; A \"-O3\"; A \"-I${EXTERNAL_CPP_INSTALL_PREFIX}\"; A \"-std=c++0x\" ; A \"-fpermissive\" ; A \"-c\"")
	set(LINKING_LIB_FLAGS "A \"\"")
	set(LINKING_DLL_FLAGS "A \"-shared\"")
	set(MAKE_STATIC_COMMAND "make_archive")
	set(OBJ_EXTENSION "o")
	set(LIB_EXTENSION "a")
	set(OCSFML_LINKPATH "A \"-L${OCAML_DIR}/site-lib/ocsfml\"")
elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
	set(GCC_COMPATIBLE_COMPILER 1) 
	set(TESTS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/share/Ocsfml")
	set(EXTERNAL_CPP_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/include/Ocsfml")
	set(CPP_COMPILER ${CMAKE_CXX_COMPILER})
	set(LIB_MAKER "ar")
	set(DLL_LINKER "${CMAKE_CXX_COMPILER}")
	set(LINK_STDLIB "A \"-cclib\" ; A \"-lc++\"")
	set(OBJ_FLAG "-o")
	set(LIB_FLAG "-q")
	set(INCLUDEPATH_FLAG "-I")
	set(COMPILATION_FLAGS "A \"-fPIC\" ;A \"-O3\"; A \"-I${EXTERNAL_CPP_INSTALL_PREFIX}\";A \"-std=c++0x\" ;A \"-stdlib=libc++\"; A \"-c\"")
	set(LINKING_LIB_FLAGS "A \"\"")
	set(LINKING_DLL_FLAGS "A \"-shared\"; A \"-flat_namespace\" ; A\"-undefined\" ; A \"suppress\"")
	set(MAKE_STATIC_COMMAND "make_archive")
	set(OBJ_EXTENSION "o")
	set(LIB_EXTENSION "a")
	set(OCSFML_LINKPATH "A \"-L${OCAML_DIR}/site-lib/ocsfml\"")
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(DLL_EXTENSION "so")
 # set( COMPILATION_FLAGS "${COMPILATION_FLAGS}; A \"-arch\" ; A \"${CMAKE_OSX_ARCHITECTURES}\"")
 # set( LINKING_DLL_FLAGS "${LINKING_DLL_FLAGS}; A \"-arch\"; A \"${CMAKE_OSX_ARCHITECTURES}\"")
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "${SFML_SYSTEM}/\\1" SFML_SYSTEM "${SFML_SYSTEM}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "${SFML_WINDOW}/\\1" SFML_WINDOW "${SFML_WINDOW}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "${SFML_GRAPHICS}/\\1" SFML_GRAPHICS "${SFML_GRAPHICS}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "${SFML_NETWORK}/\\1" SFML_NETWORK "${SFML_NETWORK}" )
  STRING( REGEX REPLACE ".*/([^/]+)\\.framework$" "${SFML_AUDIO}/\\1" SFML_AUDIO "${SFML_AUDIO}" )
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(DLL_EXTENSION "so")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set(DLL_EXTENSION "dll")
endif()


configure_file( ${CMAKE_SOURCE_DIR}/myocamlbuild.ml.in ${CMAKE_SOURCE_DIR}/myocamlbuild.ml)

configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlNetwork/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfml_system_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlAudio/ocsfml_system_stub.hpp COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfml_window_stub.hpp ${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfml_window_stub.hpp COPYONLY)

configure_file(${CMAKE_SOURCE_DIR}/_tags.in ${CMAKE_SOURCE_DIR}/_tags)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfmlsystem.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlSystem/ocsfmlsystem.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfmlwindow.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlWindow/ocsfmlwindow.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfmlgraphics.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlGraphics/ocsfmlgraphics.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlAudio/ocsfmlaudio.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlAudio/ocsfmlaudio.cpplib)
configure_file(${CMAKE_SOURCE_DIR}/OcsfmlNetwork/ocsfmlnetwork.cpplib.in ${CMAKE_SOURCE_DIR}/OcsfmlNetwork/ocsfmlnetwork.cpplib)

set(OCAMLBUILD_COMMAND "ocamlbuild")

add_custom_target( 
	clear
	${OCAMLBUILD_COMMAND} -clean
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(
	ocsfml
	ALL	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlsystem.cma
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlsystem.cmxa
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlwindow.cma
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlwindow.cmxa
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlgraphics.cma 
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlgraphics.cmxa
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlnetwork.cma
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlnetwork.cmxa
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlaudio.cma
	COMMAND	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlaudio.cmxa
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

#add_custom_target(
#	infer_system
#		${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlSystem.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlSystem/ocsfmlSystem.inferred.mli OcsfmlSystem/ocsfmlSystem.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_window
#		${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlWindow.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlWindow/ocsfmlWindow.inferred.mli OcsfmlWindow/ocsfmlWindow.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_graphics
#		${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlGraphics.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlGraphics/ocsfmlGraphics.inferred.mli OcsfmlGraphics/ocsfmlGraphics.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_network
#		${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlNetwork.inferred.mli 
#	COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlNetwork/ocsfmlNetwork.inferred.mli OcsfmlNetwork/ocsfmlNetwork.mli
#	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#)

#add_custom_target(
#	infer_audio
#	${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlAudio.inferred.mli 
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
	${OCAMLBUILD_COMMAND} -use-ocamlfind ./camlpp/ExternalCpp/pa_cpp_external.cma
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)	

add_custom_target(
	install_external_cpp
	ocamlfind install "external_cpp" camlpp/ExternalCpp/META _build/camlpp/ExternalCpp/pa_cpp_external.cma _build/camlpp/ExternalCpp/pa_cpp_external.cmi _build/camlpp/ExternalCpp/synthese.cmi _build/camlpp/ExternalCpp/cppExternalAst.cmi
	COMMAND ${CMAKE_COMMAND} -E copy_directory ./camlpp/camlpp "${EXTERNAL_CPP_INSTALL_PREFIX}/camlpp"
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(
	uninstall_external_cpp
	ocamlfind remove "external_cpp"
	COMMAND ${CMAKE_COMMAND} -E remove_directory "${EXTERNAL_CPP_INSTALL_PREFIX}/camlpp"
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)


add_custom_target( 
	tests
	${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_clock.byte
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_clock.native
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_pong.byte
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_pong.native
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_shader.byte
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_shader.native 
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_sockets.byte
	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_sockets.native 
#	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_audio.byte
#	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_audio.native
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)


add_custom_target(
	install_tests
	${CMAKE_COMMAND} -E make_directory "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_clock.native "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_clock.byte "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_pong.native "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_pong.byte "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_shader.native "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_shader.byte "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_sockets.native "${TESTS_INSTALL_PREFIX}/Test/"
	COMMAND ${CMAKE_COMMAND} -E copy _build/Test/test_sockets.byte "${TESTS_INSTALL_PREFIX}/Test/" 
	COMMAND ${CMAKE_COMMAND} -E copy_directory resources "${TESTS_INSTALL_PREFIX}/Test/resources"
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(
        uninstall_tests
	${CMAKE_COMMAND} -E remove_directory "${TESTS_INSTALL_PREFIX}/Test"
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(
        uninstall_ocsfml
	${CMAKE_COMMAND} -E remove_directory "${TESTS_INSTALL_PREFIX}"
	COMMAND ${CMAKE_COMMAND} -E remove_directory "${EXTERNAL_CPP_INSTALL_PREFIX}/camlpp"
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_dependencies(
        uninstall_ocsfml
	uninstall_external_cpp
	uninstall
	uninstall_tests
)