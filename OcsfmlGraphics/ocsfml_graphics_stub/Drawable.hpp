#ifndef OCSFML_DRAWABLE_HPP_INCLUDED
#define OCSFML_DRAWABLE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Drawable.hpp>

typedef sf::Drawable sf_Drawable;
camlpp__preregister_custom_operations( sf_Drawable );
camlpp__preregister_custom_class( sf_Drawable );

#endif
