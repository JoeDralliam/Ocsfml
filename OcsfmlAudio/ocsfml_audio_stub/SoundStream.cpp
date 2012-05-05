#include "SoundStream.hpp"

#include "SoundSource.hpp"

#define CAMLPP__CLASS_NAME() sf_SoundStream
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_SoundSource );
  camlpp__register_method0( play );
  camlpp__register_method0( pause );
  camlpp__register_method0( stop );
  camlpp__register_method0( getChannelCount );
  camlpp__register_method0( getSampleRate );
  camlpp__register_method0( getStatus );
  camlpp__register_method1( setPlayingOffset );
  camlpp__register_method0( getPlayingOffset );
  camlpp__register_method1( setLoop );
  camlpp__register_method0( getLoop );
}
#undef CAMLPP__CLASS_NAME
