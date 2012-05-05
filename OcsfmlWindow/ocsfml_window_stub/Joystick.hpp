#ifndef OCSFML_JOYSTICK_HPP_INCLUDED
#define OCSFML_JOYSTICK_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Window/Joystick.hpp>

custom_enum_conversion( sf::Joystick::Axis );
custom_enum_affectation( sf::Joystick::Axis );


#endif
