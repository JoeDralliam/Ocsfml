#include "SocketSelector.hpp"

#include "Time.hpp"

#include "Socket.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>

namespace
{
  bool socketselector_wait_helper( sf::SocketSelector* obj,
				   camlpp::optional<sf::Time> timeout, camlpp::unit )
  {
    return obj->wait( timeout.get_value_no_fail( sf::microseconds(0) ) );
  }
}


#define CAMLPP__CLASS_NAME() sf_SocketSelector
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_constructor1( copy_constructor, sf::SocketSelector const&, 0);
  camlpp__register_method1( add,    0);
  camlpp__register_method1( remove, 0);
  camlpp__register_method0( clear,  0);
  camlpp__register_external_method2( wait, &socketselector_wait_helper, 0);
  camlpp__register_method1( isReady, 0);
  camlpp__register_external_method1( affect, &sf::SocketSelector::operator=, 0);
}
#undef CAMLPP__CLASS_NAME
