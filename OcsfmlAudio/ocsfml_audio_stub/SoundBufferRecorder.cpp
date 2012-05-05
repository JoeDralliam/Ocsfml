#include "SoundBufferRecorder.hpp"

#include "SoundRecorder.hpp"
#include "SoundBuffer.hpp"

#include <camlpp/custom_ops.hpp>

#define CAMLPP__CLASS_NAME() sf_SoundBufferRecorder
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_SoundRecorder );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getBuffer );
}
#undef CAMLPP__CLASS_NAME
