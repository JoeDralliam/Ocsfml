#ifndef OCSFML_CONTEXT_SETTING_HPP_INCLUDED
#define OCSFML_CONTEXT_SETTING_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Window/ContextSettings.hpp>

custom_enum_conversion( sf::ContextSettings::Attribute );
custom_enum_affectation( sf::ContextSettings::Attribute );


custom_struct_conversion(	 sf::ContextSettings,
				 &sf::ContextSettings::depthBits,
				 &sf::ContextSettings::stencilBits,
				 &sf::ContextSettings::antialiasingLevel,
				 &sf::ContextSettings::majorVersion,
         &sf::ContextSettings::minorVersion,
         &sf::ContextSettings::attributeFlags);

custom_struct_affectation(	 sf::ContextSettings,
				 &sf::ContextSettings::depthBits,
				 &sf::ContextSettings::stencilBits,
				 &sf::ContextSettings::antialiasingLevel,
				 &sf::ContextSettings::majorVersion,
         &sf::ContextSettings::minorVersion,
         &sf::ContextSettings::attributeFlags);

#endif
