#ifndef OCSFML_BLEND_MODE_HPP_INCLUDED
#define OCSFML_BLEND_MODE_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Graphics/BlendMode.hpp>

custom_enum_conversion( sf::BlendMode::Factor );
custom_enum_affectation( sf::BlendMode::Factor );
custom_enum_conversion( sf::BlendMode::Equation );
custom_enum_affectation( sf::BlendMode::Equation );



custom_struct_affectation( sf::BlendMode,
			   &sf::BlendMode::colorSrcFactor,
			   &sf::BlendMode::colorDstFactor,
			   &sf::BlendMode::colorEquation,
			   &sf::BlendMode::alphaSrcFactor,
			   &sf::BlendMode::alphaDstFactor,
			   &sf::BlendMode::alphaEquation);


custom_struct_conversion( sf::BlendMode,
			  &sf::BlendMode::colorSrcFactor,
			  &sf::BlendMode::colorDstFactor,
			  &sf::BlendMode::colorEquation,
			  &sf::BlendMode::alphaSrcFactor,
			  &sf::BlendMode::alphaDstFactor,
			  &sf::BlendMode::alphaEquation);

#endif
