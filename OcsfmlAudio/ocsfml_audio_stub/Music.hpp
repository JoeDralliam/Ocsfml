#ifndef OCSFML_MUSIC_HPP_INCLUDED
#define OCSFML_MUSIC_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Audio/Music.hpp>

typedef sf::Music sf_Music;
camlpp__preregister_custom_operations( sf_Music )
camlpp__preregister_custom_class( sf_Music )

#endif
