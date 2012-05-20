#include "IpAddress.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/stub_generator.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>
#include <camlpp/std/string.hpp>

#define CAMLPP__CLASS_NAME() sf_IpAddress
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__DEFAULT_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_constructor1( string_constructor, std::string, camlpp::release_caml_runtime );
  camlpp__register_constructor4( bytes_constructor, sf::Uint8, sf::Uint8, sf::Uint8, sf::Uint8, camlpp::release_caml_runtime );
  camlpp__register_constructor1( integer_constructor, sf::Uint32, camlpp::release_caml_runtime );
  camlpp__register_constructor1( copy_constructor, sf::IpAddress const&, 0);
  camlpp__register_external_method1( affect, &sf::IpAddress::operator=, 0);
  camlpp__register_method0( toString, 0 );
  camlpp__register_method0( toInteger, 0 ); // perte de donnees possible (int caml sur 31 bits et non 32)
}
#undef CAMLPP__CLASS_NAME

sf::IpAddress ipaddress_get_public_address_helper( camlpp::optional<sf::Time> timeout, camlpp::unit )
{
  return sf::IpAddress::getPublicAddress( timeout.get_value_no_fail( sf::microseconds(0) ) );
}

extern "C"
{
  camlpp__register_overloaded_free_function0( sf_IpAddress_getLocalAddress,
					      &sf::IpAddress::getLocalAddress, 0 )
  camlpp__register_overloaded_free_function2( sf_IpAddress_getPublicAddress,
					      &ipaddress_get_public_address_helper, camlpp::release_caml_runtime )
}
