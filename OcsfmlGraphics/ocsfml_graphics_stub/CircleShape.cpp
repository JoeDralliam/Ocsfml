#include "CircleShape.hpp"

#include "Shape.hpp"


#include <camlpp/custom_ops.hpp>


#define CAMLPP__CLASS_NAME() sf_CircleShape
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Shape );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( radius_constructor, float );
  camlpp__register_method1( setRadius );
  camlpp__register_method0( getRadius );
  camlpp__register_method1( setPointCount );
}
#undef CAMLPP__CLASS_NAME
