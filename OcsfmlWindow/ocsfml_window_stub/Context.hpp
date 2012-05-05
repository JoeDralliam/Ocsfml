#ifndef OCSFML_CONTEXT_HPP_INCLUDED
#define OCSFML_CONTEXT_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Window/Context.hpp>

typedef sf::Context sf_Context;
camlpp__preregister_custom_class( sf_Context );

#endif
