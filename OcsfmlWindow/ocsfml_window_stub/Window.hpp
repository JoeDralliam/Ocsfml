#ifndef OCSFML_WINDOW_HPP_INCLUDED
#define OCSFML_WINDOW_HPP_INCLUDED

#include <list>

#include <camlpp/custom_class.hpp>

#include <SFML/Window/Window.hpp>

unsigned long style_of_list_unsigned( std::list<unsigned long> const& lst );

typedef sf::Window sf_Window;
camlpp__preregister_custom_operations( sf_Window )
camlpp__preregister_custom_class( sf_Window );

#endif
