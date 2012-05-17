#include "Transformable.hpp"

#include "Vector.hpp"

#include <camlpp/custom_ops.hpp>

typedef void (sf_Transformable::* Transfo2f)(float, float);
typedef void (sf_Transformable::* TransfoVf)(sf::Vector2f const&);


#define CAMLPP__CLASS_NAME() sf_Transformable
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0)
  camlpp__register_external_method2( setPosition,  ((Transfo2f)&sf::Transformable::setPosition), 0);
  camlpp__register_external_method1( setPositionV, ((TransfoVf)&sf::Transformable::setPosition), 0);
  camlpp__register_external_method2( setScale,     ((Transfo2f)&sf::Transformable::setScale),    0);
  camlpp__register_external_method1( setScaleV,    ((TransfoVf)&sf::Transformable::setScale),    0);
  camlpp__register_external_method2( setOrigin,    ((Transfo2f)&sf::Transformable::setOrigin),   0);
  camlpp__register_external_method1( setOriginV,   ((TransfoVf)&sf::Transformable::setOrigin),   0);
  camlpp__register_method1( setRotation, 0);
  camlpp__register_method0( getPosition, 0);
  camlpp__register_method0( getScale, 0);
  camlpp__register_method0( getOrigin, 0);
  camlpp__register_method0( getRotation, 0);
  camlpp__register_external_method2( move,   ((Transfo2f)&sf::Transformable::move),  0);
  camlpp__register_external_method1( moveV,  ((TransfoVf)&sf::Transformable::move),  0);
  camlpp__register_external_method2( scale,  ((Transfo2f)&sf::Transformable::scale), 0);
  camlpp__register_external_method1( scaleV, ((TransfoVf)&sf::Transformable::scale), 0);
  camlpp__register_method1( rotate, 0);
  camlpp__register_method0( getTransform, 0);
  camlpp__register_method0( getInverseTransform, 0);
}
#undef CAMLPP__CLASS_NAME

