#include "Context.hpp"

typedef sf::Context sf_Context;
#define CAMLPP__CLASS_NAME() sf_Context
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_method1( setActive, 0);
}
#undef CAMLPP__CLASS_NAME	

