#include "Sound.hpp"

#include "SoundSource.hpp"
#include "SoundBuffer.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>

namespace
{
  camlpp::optional< sf::SoundBuffer const* > sound_get_buffer_helper( sf::Sound* snd )
  {
    sf::SoundBuffer const* buf = snd->getBuffer();
    if(buf)
      {
	return camlpp::some( buf );
      }
    return camlpp::none< sf::SoundBuffer const* >();
  }
}

#define CAMLPP__CLASS_NAME() sf_Sound
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_SoundSource );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( buffer_constructor, sf::SoundBuffer const&);
  camlpp__register_constructor1( copy_constructor, sf::Sound const& );
  camlpp__register_method0( play );
  camlpp__register_method0( pause );
  camlpp__register_method0( stop );
  camlpp__register_method1( setBuffer );
  camlpp__register_method1( setLoop );
  camlpp__register_method1( setPlayingOffset );
  camlpp__register_external_method0( getBuffer, &sound_get_buffer_helper );
  camlpp__register_method0( getLoop );
  camlpp__register_method0( getPlayingOffset );
  camlpp__register_method0( getStatus );
}
#undef CAMLPP__CLASS_NAME

