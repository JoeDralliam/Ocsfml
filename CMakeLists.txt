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
set( DEV_MODE FALSE CACHE BOOL "")
set( CPP_DEV_MODE FALSE CACHE BOOL "")
set( CAML_DEV_MODE FALSE CACHE BOOL "")

set(CPP_COMPILER ${CMAKE_CXX_COMPILER})

if(MSVC_VERSION EQUAL 1600) #VC++ 2010
  include(Configuration/VC++2010.cmake)
elseif(CMAKE_COMPILER_IS_GNUCXX)
  include(Configuration/G++.cmake)
elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
  include(Configuration/Clang.cmake)
endif()
      
macro(correct_osx_framework module_name)
  if("${SFML_${module_name}}" MATCHES ".*/([^/]+)\\.framework$")
    string( REGEX REPLACE ".*/([^/]+)\\.framework$" "${SFML_${module_name}}/\\1" SFML_${module_name} "${SFML_${module_name}}" )
  endif()
endmacro()

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(DLL_EXTENSION "so")
 # set( COMPILATION_FLAGS "${COMPILATION_FLAGS}; A \"-arch\" ; A \"${CMAKE_OSX_ARCHITECTURES}\"")
 # set( LINKING_DLL_FLAGS "${LINKING_DLL_FLAGS}; A \"-arch\"; A \"${CMAKE_OSX_ARCHITECTURES}\"")
 correct_osx_framework( SYSTEM )
 correct_osx_framework( WINDOW )
 correct_osx_framework( GRAPHICS )
 correct_osx_framework( NETWORK )
 correct_osx_framework( AUDIO )
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

include_directories(
  ${EXTERNAL_CPP_INSTALL_PREFIX}
  ${OCAML_DIR}
  ${SFML_DIR}
  ${BOOST_DIR}
  )

add_subdirectory(camlpp)
add_subdirectory(OcsfmlSystem)
add_subdirectory(OcsfmlWindow)
add_subdirectory(OcsfmlGraphics)
add_subdirectory(OcsfmlAudio)
add_subdirectory(OcsfmlNetwork)
add_subdirectory(Test)

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


  

macro(ocsfml_library dir name)
  set(
    ${name} 
    _build/Ocsfml${dir}/ocsfml${dir}.cmi 
    _build/Ocsfml${dir}/dllocsfml${name}.${DLL_EXTENSION}  
    _build/Ocsfml${dir}/ocsfml${name}.cma 
    _build/Ocsfml${dir}/libocsfml${name}.${LIB_EXTENSION} 
    _build/Ocsfml${dir}/ocsfml${name}.cmxa 
    _build/Ocsfml${dir}/ocsfml${name}.${LIB_EXTENSION} 
    )
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

<<<<<<< HEAD
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
  COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/graphicClock.byte
  COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/graphicClock.native 
  #	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_audio.byte
  #	COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_audio.native
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )

if(${DEV_MODE})
  add_custom_target( 
    test_clock_byte
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_clock.byte
    )
  
  add_custom_target(
    test_clock_native
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_clock.native
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_pong_byte    
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_pong.byte
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_pong_native
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_pong.native
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_shader_byte
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_shader.byte
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_shader_native
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_shader.native 
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_sockets_byte
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_sockets.byte
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_sockets_native
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/test_sockets.native 
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_graphicsClock_byte
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/graphicClock.byte
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  
  add_custom_target(
    test_graphicsClock_native
    ${OCAMLBUILD_COMMAND} -use-ocamlfind Test/graphicClock.native 
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

endif()

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
  COMMAND ${CMAKE_COMMAND} -E copy _build/Test/graphicClock.native "${TESTS_INSTALL_PREFIX}/Test/"
  COMMAND ${CMAKE_COMMAND} -E copy _build/Test/graphicClock.byte "${TESTS_INSTALL_PREFIX}/Test/" 
  COMMAND ${CMAKE_COMMAND} -E copy_directory resources "${TESTS_INSTALL_PREFIX}/Test/resources"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )

add_custom_target(
  uninstall_tests
  ${CMAKE_COMMAND} -E remove_directory "${TESTS_INSTALL_PREFIX}/Test"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
=======
>>>>>>> b135c6fff3179e06caf16c7b15114e461f1268c8

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

add_custom_target(
  doc
  ocamlbuild -use-ocamlfind ocsfml.docdir/index.html
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
