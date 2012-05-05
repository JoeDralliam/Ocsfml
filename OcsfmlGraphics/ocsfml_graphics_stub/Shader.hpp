#ifndef OCSFML_SHADER_HPP_INCLUDED
#define OCSFML_SHADER_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Graphics/Shader.hpp>

typedef sf::Shader sf_Shader;
camlpp__preregister_custom_operations( sf_Shader )
camlpp__preregister_custom_class( sf_Shader )

#endif
