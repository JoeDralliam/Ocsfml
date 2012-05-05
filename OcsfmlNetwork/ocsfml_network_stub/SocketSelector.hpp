#ifndef OCSFML_SOCKET_SELECTOR_HPP_INCLUDED
#define OCSFML_SOCKET_SELECTOR_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Network/SocketSelector.hpp>

typedef sf::SocketSelector sf_SocketSelector;
camlpp__preregister_custom_operations( sf_SocketSelector )
camlpp__preregister_custom_class( sf_SocketSelector )

#endif
