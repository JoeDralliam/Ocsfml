#include "Shape.hpp"

#include "Vector.hpp"

#include "Color.hpp"
#include "Drawable.hpp"
#include "Rect.hpp"
#include "Texture.hpp"
#include "Transformable.hpp"


#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>

namespace
{
  void shape_set_texture_helper( sf::Shape* shape, camlpp::optional<sf::Texture const*> texture, camlpp::optional<bool> resetRect, camlpp::unit)
  {
    shape->setTexture( 	texture.get_value_no_fail( 0 ),
			resetRect.get_value_no_fail( false ) );
  }
}


#define CAMLPP__CLASS_NAME() sf_Shape
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_inheritance_relationship( sf_Transformable );
  camlpp__register_external_method3( setTexture, &shape_set_texture_helper );
  camlpp__register_method1( setTextureRect );
  camlpp__register_method1( setFillColor );
  camlpp__register_method1( setOutlineColor );
  camlpp__register_method1( setOutlineThickness );
  camlpp__register_method0( getTexture );
  camlpp__register_method0( getTextureRect );
  camlpp__register_method0( getFillColor );
  camlpp__register_method0( getOutlineColor );
  camlpp__register_method0( getOutlineThickness );
  camlpp__register_method0( getPointCount ); // pure virtual
  camlpp__register_method1( getPoint ); // pure virtual
  camlpp__register_method0( getLocalBounds );
  camlpp__register_method0( getGlobalBounds );
}
#undef CAMLPP__CLASS_NAME
