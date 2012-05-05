#ifndef OCSFML_UDP_SOCKET_HPP_INCLUDED
#define OCSFML_UDP_SOCKET_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Network/UdpSocket.hpp>

typedef sf::UdpSocket sf_UdpSocket;
camlpp__preregister_custom_operations( sf_UdpSocket )
camlpp__preregister_custom_class( sf_UdpSocket )

#endif
