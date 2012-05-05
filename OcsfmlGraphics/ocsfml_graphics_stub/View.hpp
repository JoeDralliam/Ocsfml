#ifndef OCSFML_VIEW_HPP_INCLUDED
#define OCSFML_VIEW_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/View.hpp>

typedef sf::View sf_View;
camlpp__preregister_custom_operations( sf_View )
camlpp__preregister_custom_class( sf_View )

#endif
