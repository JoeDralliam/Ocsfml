

if(${DEV_MODE})
  add_custom_target(
    ocsfml_window
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlwindow.cma
    COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlwindow.cmxa
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()

if(${CPP_DEV_MODE})
  set(WINDOW_CPP_FILES ocsfml_window_stub.cpp)

  add_library(
    ocsfmlwindow SHARED
    ${WINDOW_CPP_FILES}
    )
endif()


if(${CAML_DEV_MODE})
  add_custom_target(
    infer_window
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlWindow.inferred.mli 
    COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlWindow/ocsfmlWindow.inferred.mli OcsfmlWindow/ocsfmlWindow.mli
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()