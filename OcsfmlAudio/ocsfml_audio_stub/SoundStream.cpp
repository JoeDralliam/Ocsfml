#include "SoundStream.hpp"

#include "Time.hpp"

#include "SoundSource.hpp"

#define CAMLPP__CLASS_NAME() sf_SoundStream
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_SoundSource );
  camlpp__register_method0( play, 0 );
  camlpp__register_method0( pause, 0 );
  camlpp__register_method0( stop, 0 );
  camlpp__register_method0( getChannelCount, 0 );
  camlpp__register_method0( getSampleRate, 0 );
  camlpp__register_method0( getStatus, 0 );
  camlpp__register_method1( setPlayingOffset, 0 );
  camlpp__register_method0( getPlayingOffset, 0 );
  camlpp__register_method1( setLoop, 0 );
  camlpp__register_method0( getLoop, 0 );
}
#undef CAMLPP__CLASS_NAME
