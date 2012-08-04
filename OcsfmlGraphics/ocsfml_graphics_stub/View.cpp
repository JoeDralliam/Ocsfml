#include "View.hpp"

#include "Vector.hpp"

#include "Rect.hpp"

#include <camlpp/custom_ops.hpp>


namespace
{
  sf::View* view_rectangle_constructor_helper( sf::FloatRect const& rec)
  {
    return new sf::View( rec );
  }
  
  sf::View* view_center_and_size_constructor_helper( sf::Vector2f const& center, sf::Vector2f const& size)
  {
    return new sf::View(center, size);
  }
}

typedef sf::View& (sf::View::*AffectType)(sf::View const&);

#define CAMLPP__CLASS_NAME() sf_View
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_external_constructor1( rectangle_constructor, &view_rectangle_constructor_helper, 0);
  camlpp__register_external_constructor2( center_and_size_constructor, &view_center_and_size_constructor_helper, 0);
  camlpp__register_constructor1( copy_constructor, sf::View const&, 0);
  camlpp__register_external_method1( affect,((AffectType)&sf::View::operator=), 0);
  camlpp__register_external_method2( setCenter, ((void (sf::View::*)(float, float)) &sf::View::setCenter), 0);
  camlpp__register_external_method1( setCenterV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::setCenter), 0);
  camlpp__register_external_method2( setSize, ((void (sf::View::*)(float, float)) &sf::View::setSize), 0);
  camlpp__register_external_method1( setSizeV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::setSize), 0);
  camlpp__register_method1( setRotation, 0);
  camlpp__register_method1( setViewport, 0);
  camlpp__register_method1( reset, 0);
  camlpp__register_method0( getCenter, 0);
  camlpp__register_method0( getSize, 0);
  camlpp__register_method0( getRotation, 0);
  camlpp__register_method0( getViewport, 0);
  camlpp__register_external_method2( move, ((void (sf::View::*)(float, float)) &sf::View::move), 0);
  camlpp__register_external_method1( moveV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::move), 0);
  camlpp__register_method1( rotate, 0);
  camlpp__register_method1( zoom, 0);
  //	camlpp__register_method0( GetMatrix, &sf::View::GetMatrix );
  //	camlpp__register_method0( GetInverseMatrix, &sf::View::GetInverseMatrix );
}
#undef CAMLPP__CLASS_NAME
