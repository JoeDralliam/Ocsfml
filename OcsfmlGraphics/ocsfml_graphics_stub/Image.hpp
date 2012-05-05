#ifndef OCSFML_IMAGE_HPP_INCLUDED
#define OCSFML_IMAGE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Image.hpp>

typedef sf::Image sf_Image;
camlpp__preregister_custom_operations( sf_Image );
camlpp__preregister_custom_class( sf_Image );

#endif
