#include "SoundBuffer.hpp"

#include "InputStream.hpp"
#include "Time.hpp"
#include "RawDataType.hpp"

#include <camlpp/big_array.hpp>
#include <camlpp/std/string.hpp>

namespace
{
  bool sound_buffer_load_from_memory_helper( sf::SoundBuffer* buffer,
					     RawDataType memory)
  {
    return buffer->loadFromMemory(memory.data, memory.size[0]);
  }


  bool sound_buffer_load_from_samples_helper( 	sf::SoundBuffer* buffer, 
						camlpp::big_array< sf::Int16, 1 > samples, 
						unsigned channelsCount, 
						unsigned int sampleRate )
  {
    return buffer->loadFromSamples( samples.data, samples.size[0], channelsCount, sampleRate );
  }
  
  camlpp::big_array< const sf::Int16, 1 > sound_buffer_get_samples_helper( sf::SoundBuffer* buffer )
  {
    intnat size[1];
    size[0] = buffer->getSampleCount();
    return camlpp::big_array< const sf::Int16, 1>(buffer->getSamples(), size);
  }
}

#define CAMLPP__CLASS_NAME() sf_SoundBuffer
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_constructor1( copy_constructor, sf::SoundBuffer const&, 0 );
  camlpp__register_external_method1( affect, &sf::SoundBuffer::operator=, 0 );
  camlpp__register_method1( loadFromFile, camlpp::release_caml_runtime );
  camlpp__register_external_method1( loadFromMemory, &sound_buffer_load_from_memory_helper, 0);
  camlpp__register_method1( loadFromStream, 0);
  camlpp__register_external_method3( loadFromSamples, &sound_buffer_load_from_samples_helper, 0);
  camlpp__register_method1( saveToFile, camlpp::release_caml_runtime );
  camlpp__register_external_method0( getSamples, &sound_buffer_get_samples_helper, 0 );
  camlpp__register_method0( getSampleCount, 0 );
  camlpp__register_method0( getSampleRate, 0 );
  camlpp__register_method0( getChannelCount, 0 );
  camlpp__register_method0( getDuration, 0);
}
#undef CAMLPP__CLASS_NAME
