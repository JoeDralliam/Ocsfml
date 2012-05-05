#ifndef OCSFML_IP_ADDRESS_HPP_INCLUDED
#define OCSFML_IP_ADDRESS_HPP_INCLUDED

#include <camlpp/custom_class.hpp>

#include <SFML/Network/IpAddress.hpp>

typedef sf::IpAddress sf_IpAddress;
camlpp__preregister_custom_operations( sf_IpAddress )
camlpp__preregister_custom_class( sf_IpAddress )

#endif
