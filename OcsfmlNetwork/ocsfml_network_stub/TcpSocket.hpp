#ifndef OCSFML_TCP_SOCKET_HPP_INCLUDED
#define OCSFML_TCP_SOCKET_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Network/TcpSocket.hpp>

typedef sf::TcpSocket sf_TcpSocket;
camlpp__preregister_custom_operations( sf_TcpSocket )
camlpp__preregister_custom_class( sf_TcpSocket )

#endif
