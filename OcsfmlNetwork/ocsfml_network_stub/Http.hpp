#ifndef OCSFML_HTTP_HPP_INCLUDED
#define OCSFML_HTTP_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>
#include <camlpp/custom_class.hpp>

#include <SFML/Network/Http.hpp>

custom_enum_conversion( sf::Http::Request::Method );
custom_enum_affectation( sf::Http::Request::Method );

custom_enum_conversion( sf::Http::Response::Status );
custom_enum_affectation( sf::Http::Response::Status );


typedef sf::Http::Request sf_Http_Request;
camlpp__preregister_custom_operations( sf_Http_Request )
camlpp__preregister_custom_class( sf_Http_Request )


typedef sf::Http::Response sf_Http_Response;
camlpp__preregister_custom_operations( sf_Http_Response )
camlpp__preregister_custom_class( sf_Http_Response )


typedef sf::Http sf_Http;
camlpp__preregister_custom_operations( sf_Http )
camlpp__preregister_custom_class( sf_Http )


#endif
