#ifndef OCSFML_RENDER_TARGET_HPP_INCLUDED
#define OCSFML_RENDER_TARGET_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/RenderTarget.hpp>

typedef sf::RenderTarget sf_RenderTarget;
camlpp__preregister_custom_class( sf_RenderTarget )

#endif
