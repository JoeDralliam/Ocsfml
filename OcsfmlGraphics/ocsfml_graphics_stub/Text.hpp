#ifndef OCSFML_TEXT_HPP_INCLUDED
#define OCSFML_TEXT_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>
#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Text.hpp>

custom_enum_affectation(sf::Text::Style );
custom_enum_conversion( sf::Text::Style );

typedef sf::Text sf_Text;
camlpp__preregister_custom_operations( sf_Text )
camlpp__preregister_custom_class( sf_Text )

#endif
