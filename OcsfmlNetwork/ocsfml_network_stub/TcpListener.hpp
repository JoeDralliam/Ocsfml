#ifndef OCSFML_TCP_LISTENER_HPP_INCLUDED
#define OCSFML_TCP_LISTENER_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Network/TcpListener.hpp>

typedef sf::TcpListener sf_TcpListener;
camlpp__preregister_custom_operations( sf_TcpListener )
camlpp__preregister_custom_class( sf_TcpListener )

#endif
