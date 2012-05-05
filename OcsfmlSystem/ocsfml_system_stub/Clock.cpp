#include "Clock.hpp"

#include <camlpp/custom_class.hpp>
#include <camlpp/custom_ops.hpp>
#include <camlpp/stub_generator.hpp>


#include <SFML/System/Clock.hpp>

typedef sf::Clock sf_Clock;

#define CAMLPP__CLASS_NAME() sf_Clock
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getElapsedTime );
  camlpp__register_method0( restart );
}
#undef CAMLPP__CLASS_NAME
