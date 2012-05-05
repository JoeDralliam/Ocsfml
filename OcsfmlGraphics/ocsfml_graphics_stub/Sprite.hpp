#ifndef OCSFML_SPRITE_HPP_INCLUDED
#define OCSFML_SPRITE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Sprite.hpp>

typedef sf::Sprite sf_Sprite;
camlpp__preregister_custom_operations( sf_Sprite )
camlpp__preregister_custom_class( sf_Sprite )


#endif
