#include "SoundSource.hpp"

#include "Vector.hpp"

#define CAMLPP__CLASS_NAME() sf_SoundSource
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor1( copy_constructor, sf::SoundSource const& );
  camlpp__register_method1( setPitch );
  camlpp__register_method1( setVolume );
  camlpp__register_external_method3( setPosition,
				     ((void (sf::SoundSource::*)(float, float, float)) &sf::SoundSource::setPosition) );
  camlpp__register_external_method1( setPositionV,
				     ((void (sf::SoundSource::*)(sf::Vector3f const&)) &sf::SoundSource::setPosition) );
  camlpp__register_method1( setRelativeToListener );
  camlpp__register_method1( setMinDistance );
  camlpp__register_method1( setAttenuation );
  camlpp__register_method0( getPitch );
  camlpp__register_method0( getVolume );
  camlpp__register_method0( getPosition );
  camlpp__register_method0( isRelativeToListener );
  camlpp__register_method0( getMinDistance );
  camlpp__register_method0( getAttenuation );
}
#undef CAMLPP__CLASS_NAME
