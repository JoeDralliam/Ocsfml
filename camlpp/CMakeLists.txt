add_subdirectory(camlpp)

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
