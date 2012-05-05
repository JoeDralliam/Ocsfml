#include "ConvexShape.hpp"

#include "Vector.hpp"

#include "Shape.hpp"


#include <camlpp/custom_ops.hpp>

#define CAMLPP__CLASS_NAME() sf_ConvexShape
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Shape );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( point_constructor, int );
  camlpp__register_method1( setPointCount );
  camlpp__register_method2( setPoint );
}
#undef CAMLPP__CLASS_NAME
