#ifndef OCSFML_SOUND_RECORDER_HPP_INCLUDED
#define OCSFML_SOUND_RECORDER_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Audio/SoundRecorder.hpp>

typedef sf::SoundRecorder sf_SoundRecorder;
camlpp__preregister_custom_class( sf_SoundRecorder )

#endif
