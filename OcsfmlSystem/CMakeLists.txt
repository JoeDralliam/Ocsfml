
if(${DEV_MODE})
  add_custom_target(
    ocsfml_system
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlsystem.cma
    COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlsystem.cmxa
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()

if(${CPP_DEV_MODE})
  set(SYSTEM_CPP_FILES ocsfml_system_stub.cpp)

  add_library(
    ocsfmlsystem SHARED
    ${SYSTEM_CPP_FILES}
    )
endif()


if(${CAML_DEV_MODE})
  add_custom_target(
    infer_system
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlSystem.inferred.mli 
    COMMAND ${CMAKE_COMMAND} -E copy _build/OcsfmlSystem/ocsfmlSystem.inferred.mli OcsfmlSystem/ocsfmlSystem.mli
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()
