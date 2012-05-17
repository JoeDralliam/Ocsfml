#include "VertexArray.hpp"

#include "Drawable.hpp"
#include "Primitive.hpp"
#include "Rect.hpp"
#include "Vertex.hpp"

#include <camlpp/custom_ops.hpp>

typedef sf::Vertex const& (sf::VertexArray::*GetAtIndexFunc)(unsigned int) const;

namespace
{
  void vertex_array_set_at_index_helper(sf::VertexArray* va, unsigned int i, sf::Vertex const& v)
  {
    (*va)[i] = v;
  }
}

#define CAMLPP__CLASS_NAME() sf_VertexArray
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_method0( getVertexCount, 0);
  camlpp__register_external_method2( setAtIndex , &vertex_array_set_at_index_helper, 0);
  camlpp__register_external_method1( getAtIndex , ((GetAtIndexFunc)&sf::VertexArray::operator[]), 0);
  camlpp__register_method0( clear, 0);
  camlpp__register_method1( resize, 0);
  camlpp__register_method1( append, 0);
  camlpp__register_method1( setPrimitiveType, 0);
  camlpp__register_method0( getPrimitiveType, 0);
  camlpp__register_method0( getBounds, 0);
}
#undef CAMLPP__CLASS_NAME
