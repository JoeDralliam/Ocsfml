#include "Socket.hpp"

#include <camlpp/custom_ops.hpp>

#define CAMLPP__CLASS_NAME() sf_Socket
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_method1( setBlocking, 0);
  camlpp__register_method0( isBlocking,  0);
}
#undef CAMLPP__CLASS_NAME
