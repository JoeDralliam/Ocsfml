#ifndef OCSFML_SOUND_BUFFER_RECORDER_HPP_INCLUDED
#define OCSFML_SOUND_BUFFER_RECORDER_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Audio/SoundBufferRecorder.hpp>

typedef sf::SoundBufferRecorder sf_SoundBufferRecorder;
camlpp__preregister_custom_operations( sf_SoundBufferRecorder )
camlpp__preregister_custom_class( sf_SoundBufferRecorder )

#endif
