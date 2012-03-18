
if(${DEV_MODE})
  add_custom_target(
    ocsfml_network
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlnetwork.cma
    COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlnetwork.cmxa
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}   
    )
endif()

if(${CPP_DEV_MODE})
  set(NETWORK_CPP_FILES ocsfml_network_stub.cpp)

  add_library(
    ocsfmlnetwork SHARED
    ${NETWORK_CPP_FILES}
    )
endif()

if(${CAML_DEV_MODE})
    add_custom_target(
    infer_network
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlNetwork.inferred.mli 
    COMMAND	${CMAKE_COMMAND} -E copy _build/OcsfmlNetwork/ocsfmlNetwork.inferred.mli OcsfmlNetwork/ocsfmlNetwork.mli
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

endif()