AC_INIT(ocsfml,2.00-alpha)
AC_PREREQ(2.58)
#AM_AUTOMAKE_INIT([1.10 foreign])
CONFIGURE_ARGS=$*
AC_CONFIG_MACRO_DIR([m4])
AC_CANONICAL_HOST
AC_PROG_CC
AC_PROG_CXX


if test "x" = "x${OS}" ; then
   case $host in
      *-linux-*) OS="linux" ;;
      *-apple-*) OS="mac" ;;
      *win*) OS="windows" ;;
   esac
fi

if test "x" = "x${CXX_TOOLCHAIN}" ; then
   case $CXX in
      g++) CXX_TOOLCHAIN="gcc" ;;
      clang++) CXX_TOOLCHAIN="clang" ;;
      cl*) CXX_TOOLCHAIN="msvc" ;;
   esac
fi

if test "${USE_SFML_STATIC_LIBRARIES}" = "true" ; then
   LIBPOSTFIX = "-s"
else
   USE_SFML_STATIC_LIBRARIES="false"
fi

MODULES="SYSTEM WINDOW GRAPHICS AUDIO NETWORK"
for module in $MODULES
do
   option_name="SFML_${module}"
   if test "x" = "x${!option_name}" ; then
      case $OS in
           linux | mac) export $option_name="-lsfml-${module,,}${LIBPOSTFIX}" ;;
           windows) export $option_name="sfml-${module,,}${LIBPOSTFIX}.lib" ;;
      esac
   fi
done


case ${CXX_TOOLCHAIN} in
     gcc | clang) LIB_EXTENSION="a" ;;
     msvc) LIB_EXTENSION="lib" ;;
esac

case ${OS} in
     linux | mac) LIB_EXTENSION="so" ;;
     windows) LIB_EXTENSION="dll" ;;
esac

AC_SUBST(OS)
AC_SUBST(CXX_TOOLCHAIN)
AC_SUBST(SFML_SYSTEM)
AC_SUBST(SFML_WINDOW)
AC_SUBST(SFML_GRAPHICS)
AC_SUBST(SFML_AUDIO)
AC_SUBST(SFML_NETWORK)
AC_SUBST(USE_SFML_STATIC_LIBRARIES)
AC_SUBST(OPTIONS)
AC_SUBST(LIB_EXTENSION)
AC_SUBST(DLL_EXTENSION)


AC_CONFIG_FILES([
        ../Makefile:Makefile.in
        ../options:options.in
        ../_tags:_tags.in
])
AC_OUTPUT
