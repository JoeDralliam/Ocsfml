#ifndef OCSFML_SENSOR_HPP_INCLUDED
#define OCSFML_SENSOR_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Window/Sensor.hpp>

custom_enum_conversion( sf::Sensor::Type );
custom_enum_affectation( sf::Sensor::Type );


#endif
