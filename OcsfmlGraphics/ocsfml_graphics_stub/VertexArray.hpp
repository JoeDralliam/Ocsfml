#ifndef OCSFML_VERTEX_ARRAY_HPP_INCLUDED
#define OCSFML_VERTEX_ARRAY_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/VertexArray.hpp>


typedef sf::VertexArray sf_VertexArray;
camlpp__preregister_custom_operations( sf_VertexArray )
camlpp__preregister_custom_class( sf_VertexArray )

#endif
