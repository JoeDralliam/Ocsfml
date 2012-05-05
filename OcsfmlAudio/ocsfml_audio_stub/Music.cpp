#include "Music.hpp"

#include "Time.hpp"

#include "SoundStream.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/std/string.hpp>

#define CAMLPP__CLASS_NAME() sf_Music
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_SoundStream );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method1( openFromFile );
  //	camlpp__register_method1( OpenFromMemory
  //	camlpp__register_method1( OpenFromStream, &sf::Music::OpenFromStream ) 
  //	/* Should not be implemented : it loads music from a different thread and calls Caml functions*/
  camlpp__register_method0( getDuration );
}
#undef CAMLPP__CLASS_NAME
