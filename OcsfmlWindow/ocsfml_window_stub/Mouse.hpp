#ifndef OCSFML_MOUSE_HPP_INCLUDED
#define OCSFML_MOUSE_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Window/Mouse.hpp>

custom_enum_conversion( sf::Mouse::Button );
custom_enum_affectation( sf::Mouse::Button );


#endif
