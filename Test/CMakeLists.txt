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
