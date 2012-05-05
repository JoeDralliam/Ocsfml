#ifndef OCSFML_SOUND_STREAM_HPP_INCLUDED
#define OCSFML_SOUND_STREAM_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Audio/SoundStream.hpp>

typedef sf::SoundStream sf_SoundStream;
camlpp__preregister_custom_class( sf_SoundStream )

#endif
