#ifndef OCSFML_VERTEX_HPP_INCLUDED
#define OCSFML_VERTEX_HPP_INCLUDED

#include "Vertex.hpp"

#include "Color.hpp"

#include <camlpp/custom_conversion.hpp>

#include <SFML/Graphics/Vertex.hpp>

custom_struct_affectation(sf::Vertex,
			  &sf::Vertex::position,
			  &sf::Vertex::color,
			  &sf::Vertex::texCoords );

custom_struct_conversion(sf::Vertex,
			 &sf::Vertex::position,
			 &sf::Vertex::color,
			 &sf::Vertex::texCoords );

#endif
