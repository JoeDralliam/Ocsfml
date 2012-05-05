#ifndef OCSFML_COLOR_HPP_INCLUDED
#define OCSFML_COLOR_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Graphics/Color.hpp>

custom_struct_affectation(	 sf::Color,
				&sf::Color::r,
				&sf::Color::g,
				&sf::Color::b,
				&sf::Color::a );

custom_struct_conversion(	 sf::Color,
				&sf::Color::r,
				&sf::Color::g,
				&sf::Color::b,
				&sf::Color::a );


#endif
