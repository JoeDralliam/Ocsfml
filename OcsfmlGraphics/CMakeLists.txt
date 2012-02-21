

if(${DEV_MODE})
  add_custom_target(
    ocsfml_graphics
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlgraphics.cma
    COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlgraphics.cmxa
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}   
    )
endif()

if(${CPP_DEV_MODE})
  set(GRAPHICS_CPP_FILES ocsfml_graphics_stub.cpp)

  add_library(
    ocsfmlgraphics SHARED
    ${GRAPHICS_CPP_FILES}
    )
endif()


if(${CAML_DEV_MODE})
  add_custom_target(
    infer_graphics
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlGraphics.inferred.mli 
    COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlGraphics/ocsfmlGraphics.inferred.mli OcsfmlGraphics/ocsfmlGraphics.mli
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()