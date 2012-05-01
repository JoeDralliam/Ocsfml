#include "ocsfml_audio_stub.hpp"
#include <camlpp/custom_ops.hpp>
#include <camlpp/big_array.hpp>
#include <camlpp/unit.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/std/string.hpp>

#include <SFML/Audio.hpp>

extern "C"
{
  camlpp__register_overloaded_free_function1(Listener_setGlobalVolume, 
					     &sf::Listener::setGlobalVolume )
  camlpp__register_overloaded_free_function0(Listener_getGlobalVolume, 
					     &sf::Listener::getGlobalVolume )
  camlpp__register_overloaded_free_function3(Listener_setPosition, 
					     ((void (*)(float, float, float)) &sf::Listener::setPosition) )
  camlpp__register_overloaded_free_function1(Listener_setPositionV,
					     ((void (*)(sf::Vector3f const&)) &sf::Listener::setPosition) )
  camlpp__register_overloaded_free_function0(Listener_getPosition,
					     &sf::Listener::getPosition )
  camlpp__register_overloaded_free_function3(Listener_setDirection, 
					     ((void (*)(float, float, float)) &sf::Listener::setDirection) )
  camlpp__register_overloaded_free_function1(Listener_setDirectionV,
					     ((void (*)(sf::Vector3f const&)) &sf::Listener::setDirection) )
  camlpp__register_overloaded_free_function0(Listener_getDirection,
					     &sf::Listener::getDirection )
}

custom_enum_affectation(sf::SoundSource::Status );
custom_enum_conversion( sf::SoundSource::Status );

typedef sf::SoundSource sf_SoundSource;
#define CAMLPP__CLASS_NAME() sf_SoundSource
camlpp__register_custom_class()
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

typedef sf::SoundStream sf_SoundStream;
#define CAMLPP__CLASS_NAME() sf_SoundStream
camlpp__register_custom_class()
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


typedef sf::Music sf_Music;
#define CAMLPP__CLASS_NAME() sf_Music
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
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


bool sound_buffer_load_from_samples_helper( 	sf::SoundBuffer* buffer, 
						camlpp::big_array< sf::Int16, 1 > samples, 
						unsigned channelsCount, 
						unsigned int sampleRate )
{
  return buffer->loadFromSamples( samples.data, samples.size[0], channelsCount, sampleRate );
}

camlpp::big_array< const sf::Int16, 1 > sound_buffer_get_samples_helper( sf::SoundBuffer* buffer )
{
  int size[1];
  size[0] = buffer->getSampleCount();
  return camlpp::big_array< const sf::Int16, 1>(buffer->getSamples(), size);
}

typedef sf::SoundBuffer sf_SoundBuffer;
#define CAMLPP__CLASS_NAME() sf_SoundBuffer
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( copy_constructor, sf::SoundBuffer const& );
  camlpp__register_external_method1( affect, &sf::SoundBuffer::operator= );
  camlpp__register_method1( loadFromFile );
  //	camlpp__register_method2( LoadFromMemory, &sf::SoundBuffer::LoadFromMemory );
  camlpp__register_method1( loadFromStream );
  camlpp__register_external_method3( loadFromSamples, &sound_buffer_load_from_samples_helper );
  camlpp__register_method1( saveToFile );
  camlpp__register_external_method0( getSamples, &sound_buffer_get_samples_helper );
  camlpp__register_method0( getSampleCount );
  camlpp__register_method0( getSampleRate );
  camlpp__register_method0( getChannelCount );
  camlpp__register_method0( getDuration );
}
#undef CAMLPP__CLASS_NAME


void sound_recorder_start_helper( sf::SoundRecorder* rec, camlpp::optional< unsigned int >  sampleRate, camlpp::unit)
{
  rec->start( sampleRate.get_value_no_fail( 44100 ) );
}

typedef sf::SoundRecorder sf_SoundRecorder;
#define CAMLPP__CLASS_NAME() sf_SoundRecorder
camlpp__register_custom_class()
{
  camlpp__register_external_method2( start, &sound_recorder_start_helper);
  camlpp__register_method0( stop );
  camlpp__register_method0( getSampleRate );
}
#undef CAMLPP__CLASS_NAME


extern "C"
{
	camlpp__register_overloaded_free_function0( SoundRecorder_isAvailable, &sf::SoundRecorder::isAvailable )
}


typedef sf::SoundBufferRecorder sf_SoundBufferRecorder;
#define CAMLPP__CLASS_NAME() sf_SoundBufferRecorder
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_SoundRecorder );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getBuffer );
}
#undef CAMLPP__CLASS_NAME


camlpp::optional< sf::SoundBuffer const* > sound_get_buffer_helper( sf::Sound* snd )
{
  sf::SoundBuffer const* buf = snd->getBuffer();
  if(buf)
    {
      return camlpp::some( buf );
    }
  return camlpp::none< sf::SoundBuffer const* >();
}

typedef sf::Sound sf_Sound;
#define CAMLPP__CLASS_NAME() sf_Sound
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
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

