#include "Http.hpp"

#include "Time.hpp"

#include "IpAddress.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>
#include <camlpp/std/string.hpp>

namespace
{
  sf::Http::Request* http_request_constructor_helper(	camlpp::optional<std::string> uri,
							camlpp::optional<sf::Http::Request::Method> method,
					  		camlpp::optional<std::string> body, camlpp::unit )
  {
    return new sf::Http::Request( 	uri.get_value_no_fail( "/" ),
					method.get_value_no_fail( sf::Http::Request::Get ),
					body.get_value_no_fail( "" ) );
  }
}


#define CAMLPP__CLASS_NAME() sf_Http_Request
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_external_constructor4( default_constructor, &http_request_constructor_helper, 0);
  camlpp__register_method2( setField, 0 );
  camlpp__register_method1( setMethod, 0 );
  camlpp__register_method1( setUri, 0 );
  camlpp__register_method2( setHttpVersion, 0 );
  camlpp__register_method1( setBody, 0 );
}
#undef CAMLPP__CLASS_NAME



#define CAMLPP__CLASS_NAME() sf_Http_Response
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_method1( getField, 0 );
  camlpp__register_method0( getStatus, 0 );
  camlpp__register_method0( getMajorHttpVersion, 0 );
  camlpp__register_method0( getMinorHttpVersion, 0 );
  camlpp__register_method0( getBody, 0 );
}
#undef CAMLPP__CLASS_NAME


namespace
{
  void http_set_host_helper( sf::Http* obj, camlpp::optional<unsigned short> port, std::string const& host)
  {
    obj->setHost( host, port.get_value_no_fail( 0 ) );
  }

  sf::Http::Response http_send_request_helper( 	sf::Http* obj,
						camlpp::optional< sf::Time > timeout,
						sf::Http::Request const& request )
  {
    return obj->sendRequest
      ( 
       request, 
       timeout.get_value_no_fail(sf::microseconds(0)) 
	);
  }
}

#define CAMLPP__CLASS_NAME() sf_Http
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_constructor1( host_constructor, std::string, 0 );
  camlpp__register_constructor2( host_and_port_constructor, std::string, unsigned short, 0 );
  camlpp__register_external_method2( setHost, &http_set_host_helper, 0 );
  camlpp__register_external_method2( sendRequest, &http_send_request_helper, 0 );
}
#undef CAMLPP__CLASS_NAME
