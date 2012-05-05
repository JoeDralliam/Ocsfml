#ifndef OCSFML_PACKET_HPP_INCLUDED
#define OCSFML_PACKET_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Network/Packet.hpp>

typedef sf::Packet sf_Packet;
camlpp__preregister_custom_operations( sf_Packet )
camlpp__preregister_custom_class( sf_Packet )

#endif
