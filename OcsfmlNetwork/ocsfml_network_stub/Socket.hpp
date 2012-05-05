#ifndef OCSFML_SOCKET_HPP_INCLUDED
#define OCSFML_SOCKET_HPP_INCLUDED

#include <camlpp/custom_class.hpp>
#include <camlpp/custom_conversion.hpp>

#include <SFML/Network/Socket.hpp>

custom_enum_conversion( sf::Socket::Status );
custom_enum_affectation( sf::Socket::Status );

typedef sf::Socket sf_Socket;
camlpp__preregister_custom_operations( sf_Socket )
camlpp__preregister_custom_class( sf_Socket )

#endif
