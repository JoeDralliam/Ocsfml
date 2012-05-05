#ifndef OCSEML_CIRCLE_SHAPE_HPP_INCLUDED
#define OCSEML_CIRCLE_SHAPE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/CircleShape.hpp>

typedef sf::CircleShape sf_CircleShape;
camlpp__preregister_custom_operations( sf_CircleShape )
camlpp__preregister_custom_class( sf_CircleShape )

#endif
