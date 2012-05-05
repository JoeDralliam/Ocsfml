#ifndef OCSFML_TRANSFORM_HPP_INCLUDED
#define OCSFML_TRANSFORM_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Transform.hpp>

typedef sf::Transform sf_Transform;
camlpp__preregister_custom_operations( sf_Transform );
camlpp__preregister_custom_class( sf_Transform );

#endif
