set(GCC_COMPATIBLE_COMPILER 1) 
set(TESTS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/share/Ocsfml")
set(LIB_MAKER "ar")
set(DLL_LINKER "${CMAKE_CXX_COMPILER}")
set(LINK_STDLIB_STA "A \"-cclib\" ; A \"-lstdc++\"")
set(LINK_STDLIB_DYN "A \"-cclib\" ; A \"-lstdc++\"")
set(OBJ_FLAG "-o")
set(LIB_FLAG "-q")
set(INCLUDEPATH_FLAG "-I")
set(OPTIMIZATION_LEVEL "-O3" )
set(COMPILATION_FLAGS "A \"${OPTIMIZATION_LEVEL}\" ; A \"-fvisibility=hidden\" ; A \"-fPIC\" ; A \"-I${EXTERNAL_CPP_INSTALL_PREFIX}\"; A \"-std=c++0x\" ; A \"-fpermissive\" ; A \"-c\"")
set(LINKING_LIB_FLAGS "A \"\"")
set(LINKING_DLL_FLAGS "A \"-shared\"")
set(MAKE_STATIC_COMMAND "make_archive")
set(OBJ_EXTENSION "o")
set(LIB_EXTENSION "a")
set(OCSFML_LINKPATH "A \"-L${OCAML_DIR}/site-lib/ocsfml\"")

if(${CPP_DEV_MODE})
  add_definitions(
    -fPIC -std=c++0x -fpermissive
    )
endif()
  