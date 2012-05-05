#ifndef OCSFML_RECT_HPP_INCLUDED
#define OCSFML_RECT_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Graphics/Rect.hpp>

custom_struct_affectation(	 sf::FloatRect,
				&sf::FloatRect::left,
				&sf::FloatRect::top,
				&sf::FloatRect::width,
				&sf::FloatRect::height ); 

custom_struct_conversion(	 sf::FloatRect,
				&sf::FloatRect::left,
				&sf::FloatRect::top,
				&sf::FloatRect::width,
				&sf::FloatRect::height );

custom_struct_affectation(	 sf::IntRect,
				&sf::IntRect::left,
				&sf::IntRect::top,
				&sf::IntRect::width,
				&sf::IntRect::height );

custom_struct_conversion(	 sf::IntRect,
				&sf::IntRect::left,
				&sf::IntRect::top,
				&sf::IntRect::width,
				&sf::IntRect::height );


#endif
