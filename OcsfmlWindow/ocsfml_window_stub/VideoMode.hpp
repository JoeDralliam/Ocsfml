#ifndef OCSFML_VIDEO_MODE_HPP_INCLUDED
#define OCSFML_VIDEO_MODE_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Window/VideoMode.hpp>

custom_struct_conversion(	 sf::VideoMode,
				 &sf::VideoMode::width,
				 &sf::VideoMode::height,
				 &sf::VideoMode::bitsPerPixel );

custom_struct_affectation(	 sf::VideoMode,
				 &sf::VideoMode::width,
				 &sf::VideoMode::height,
				 &sf::VideoMode::bitsPerPixel );


#endif
