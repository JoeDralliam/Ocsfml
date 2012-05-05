#ifndef OCSFML_RECTANGLE_SHAPE_HPP_INCLUDED
#define OCSFML_RECTANGLE_SHAPE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/RectangleShape.hpp>

typedef sf::RectangleShape sf_RectangleShape;
camlpp__preregister_custom_operations( sf_RectangleShape );
camlpp__preregister_custom_class( sf_RectangleShape );

#endif
