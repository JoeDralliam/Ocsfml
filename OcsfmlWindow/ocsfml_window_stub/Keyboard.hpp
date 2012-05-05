#ifndef OCSFML_KEYBOARD_HPP_INCLUDED
#define OCSFML_KEYBOARD_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Window/Keyboard.hpp>

custom_enum_conversion( sf::Keyboard::Key );
custom_enum_affectation( sf::Keyboard::Key );


#endif
