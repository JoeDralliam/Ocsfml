#include "SoundSource.hpp"

#include "Vector.hpp"

#define CAMLPP__CLASS_NAME() sf_SoundSource
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor1( copy_constructor, sf::SoundSource const&, 0);
  camlpp__register_method1( setPitch, 0);
  camlpp__register_method1( setVolume, 0 );
  camlpp__register_external_method3( setPosition,
				     ((void (sf::SoundSource::*)(float, float, float)) &sf::SoundSource::setPosition), 0 );
  camlpp__register_external_method1( setPositionV,
				     ((void (sf::SoundSource::*)(sf::Vector3f const&)) &sf::SoundSource::setPosition), 0 );
  camlpp__register_method1( setRelativeToListener, 0 );
  camlpp__register_method1( setMinDistance, 0 );
  camlpp__register_method1( setAttenuation, 0 );
  camlpp__register_method0( getPitch, 0 );
  camlpp__register_method0( getVolume, 0 );
  camlpp__register_method0( getPosition, 0 );
  camlpp__register_method0( isRelativeToListener, 0 );
  camlpp__register_method0( getMinDistance, 0 );
  camlpp__register_method0( getAttenuation, 0 );
}
#undef CAMLPP__CLASS_NAME
