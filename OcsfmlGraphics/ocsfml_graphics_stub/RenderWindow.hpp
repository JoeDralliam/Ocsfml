#ifndef OCSFML_RENDER_WINDOW_HPP_INCLUDED
#define OCSFML_RENDER_WINDOW_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/RenderWindow.hpp>

typedef sf::RenderWindow sf_RenderWindow;
camlpp__preregister_custom_operations( sf_RenderWindow )
camlpp__preregister_custom_class( sf_RenderWindow )

#endif
