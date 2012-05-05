#ifndef OCSFML_TRANSFORMABLE_HPP_INCLUDED
#define OCSFML_TRANSFORMABLE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Transformable.hpp>

typedef sf::Transformable sf_Transformable;
camlpp__preregister_custom_operations( sf_Transformable );
camlpp__preregister_custom_class( sf_Transformable );

#endif
