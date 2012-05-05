#include "Transformable.hpp"

#include "Vector.hpp"

#include <camlpp/custom_ops.hpp>

typedef void (sf_Transformable::* Transfo2f)(float, float);
typedef void (sf_Transformable::* TransfoVf)(sf::Vector2f const&);


#define CAMLPP__CLASS_NAME() sf_Transformable
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor )
  camlpp__register_external_method2( setPosition, ((Transfo2f)&sf::Transformable::setPosition) );
  camlpp__register_external_method1( setPositionV, ((TransfoVf)&sf::Transformable::setPosition) );
  camlpp__register_external_method2( setScale, ((Transfo2f)&sf::Transformable::setScale) );
  camlpp__register_external_method1( setScaleV, ((TransfoVf)&sf::Transformable::setScale) );
  camlpp__register_external_method2( setOrigin, ((Transfo2f)&sf::Transformable::setOrigin) );
  camlpp__register_external_method1( setOriginV, ((TransfoVf)&sf::Transformable::setOrigin) );
  camlpp__register_method1( setRotation );
  camlpp__register_method0( getPosition );
  camlpp__register_method0( getScale );
  camlpp__register_method0( getOrigin );
  camlpp__register_method0( getRotation );
  camlpp__register_external_method2( move, ((Transfo2f)&sf::Transformable::move) );
  camlpp__register_external_method1( moveV, ((TransfoVf)&sf::Transformable::move) );
  camlpp__register_external_method2( scale, ((Transfo2f)&sf::Transformable::scale) );
  camlpp__register_external_method1( scaleV, ((TransfoVf)&sf::Transformable::scale) );
  camlpp__register_method1( rotate );
  camlpp__register_method0( getTransform );
  camlpp__register_method0( getInverseTransform );
}
#undef CAMLPP__CLASS_NAME

