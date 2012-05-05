#ifndef OCSFML_SOUND_SOURCE_HPP_INCLUDED
#define OCSFML_SOUND_SOURCE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>
#include <camlpp/custom_conversion.hpp>

#include <SFML/Audio/SoundSource.hpp>

custom_enum_affectation(sf::SoundSource::Status );
custom_enum_conversion( sf::SoundSource::Status );

typedef sf::SoundSource sf_SoundSource;
camlpp__preregister_custom_class( sf_SoundSource )

#endif
