#include "TcpListener.hpp"

#include "Socket.hpp"
#include "TcpSocket.hpp"

#include <camlpp/custom_ops.hpp>

#define CAMLPP__CLASS_NAME() sf_TcpListener
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Socket );
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_method0( getLocalPort, 0);
  camlpp__register_method1( listen, 0);
  camlpp__register_method0( close,  0);
  camlpp__register_method1( accept, 0);
}
#undef CAMLPP__CLASS_NAME

