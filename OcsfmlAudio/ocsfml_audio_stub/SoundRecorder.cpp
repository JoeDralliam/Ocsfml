#include "SoundRecorder.hpp"

#include <camlpp/stub_generator.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>

void sound_recorder_start_helper( sf::SoundRecorder* rec, camlpp::optional< unsigned int >  sampleRate, camlpp::unit)
{
  rec->start( sampleRate.get_value_no_fail( 44100 ) );
}

typedef sf::SoundRecorder sf_SoundRecorder;
#define CAMLPP__CLASS_NAME() sf_SoundRecorder
camlpp__register_preregistered_custom_class()
{
  camlpp__register_external_method2( start, &sound_recorder_start_helper, 0);
  camlpp__register_method0( stop, 0 );
  camlpp__register_method0( getSampleRate, 0 );
}
#undef CAMLPP__CLASS_NAME


extern "C"
{
	camlpp__register_overloaded_free_function0( SoundRecorder_isAvailable, &sf::SoundRecorder::isAvailable, 0 )
}
