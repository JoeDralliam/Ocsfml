#ifndef OCSFML_RENDER_TEXTURE_HPP_INCLUDED
#define OCSFML_RENDER_TEXTURE_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/RenderTexture.hpp>

typedef sf::RenderTexture sf_RenderTexture;
camlpp__preregister_custom_operations( sf_RenderTexture )
camlpp__preregister_custom_class( sf_RenderTexture )

#endif
