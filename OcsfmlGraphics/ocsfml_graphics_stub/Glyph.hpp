#ifndef OCSFML_GLYPH_HPP_INCLUDED
#define OCSFML_GLYPH_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Graphics/Glyph.hpp>

#include "Vector.hpp"

#include "Rect.hpp"

custom_struct_affectation(sf::Glyph,
			  &sf::Glyph::advance,
			  &sf::Glyph::bounds,
			  &sf::Glyph::textureRect );

custom_struct_conversion(sf::Glyph,
			 &sf::Glyph::advance,
			 &sf::Glyph::bounds,
			 &sf::Glyph::textureRect );


#endif
