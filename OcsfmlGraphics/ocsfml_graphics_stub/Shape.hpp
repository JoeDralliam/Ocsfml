#ifndef OCSFML_SHAPE_HPP_INCLUDED
#define OCSFML_SHAPE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Shape.hpp>

typedef sf::Shape sf_Shape;
camlpp__preregister_custom_class( sf_Shape );

#endif
