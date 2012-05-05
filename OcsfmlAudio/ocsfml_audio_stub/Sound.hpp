#ifndef OCSFML_SOUND_HPP_INCLUDED
#define OCSFML_SOUND_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Audio/Sound.hpp>

typedef sf::Sound sf_Sound;
camlpp__preregister_custom_operations( sf_Sound )
camlpp__preregister_custom_class( sf_Sound )

#endif
