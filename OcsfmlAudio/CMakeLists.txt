

if(${DEV_MODE})
  add_custom_target(
    ocsfml_audio
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlaudio.cma
    COMMAND ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlaudio.cmxa
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR} 
    )

endif()

if(${CPP_DEV_MODE})
  set(AUDIO_CPP_FILES ocsfml_audio_stub.cpp)

  add_library(
    ocsfmlaudio SHARED
    ${AUDIO_CPP_FILES}
    )
endif()


if(${CAML_DEV_MODE})
  add_custom_target(
    infer_audio
    ${OCAMLBUILD_COMMAND} -use-ocamlfind ocsfmlAudio.inferred.mli 
    COMMAND ${CMAKE_COMMAND} -E copy _build/OcsfmlAudio/ocsfmlAudio.inferred.mli OcsfmlAudio/ocsfmlAudio.mli
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()