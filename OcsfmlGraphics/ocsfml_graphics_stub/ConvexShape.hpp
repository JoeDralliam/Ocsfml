#ifndef OCSFML_CONVEX_SHAPE_HPP_INCLUDED
#define OCSFML_CONVEX_SHAPE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/ConvexShape.hpp>

typedef sf::ConvexShape sf_ConvexShape;
camlpp__preregister_custom_operations( sf_ConvexShape )
camlpp__preregister_custom_class( sf_ConvexShape )

#endif
