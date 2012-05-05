#ifndef OCSFML_TEXTURE_HPP_INCLUDED
#define OCSFML_TEXTURE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>
#include <camlpp/custom_conversion.hpp>

#include <SFML/Graphics/Texture.hpp>

custom_enum_conversion( sf::Texture::CoordinateType );
custom_enum_affectation(sf::Texture::CoordinateType );

typedef sf::Texture sf_Texture;
camlpp__preregister_custom_class( sf_Texture )


#endif
