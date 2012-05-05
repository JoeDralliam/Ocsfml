#ifndef OCSFML_SOUND_BUFFER_HPP_INCLUDED
#define OCSFML_SOUND_BUFFER_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Audio/SoundBuffer.hpp>

typedef sf::SoundBuffer sf_SoundBuffer;
camlpp__preregister_custom_class( sf_SoundBuffer )

#endif
