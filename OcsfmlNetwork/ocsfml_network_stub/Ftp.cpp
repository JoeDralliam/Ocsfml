#include "Ftp.hpp"

#include "Time.hpp"

#include "IpAddress.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>
#include <camlpp/std/string.hpp>
#include <camlpp/std/vector.hpp>


namespace
{
  sf::Ftp::Response* ftp_response_default_constructor_helper( camlpp::optional<sf::Ftp::Response::Status> a1,
							      camlpp::optional<std::string> a2, camlpp::unit )
  {
    return new sf::Ftp::Response( 	a1.get_value_no_fail( sf::Ftp::Response::InvalidResponse ),
					a2.get_value_no_fail( "" ) );
  }
}


#define CAMLPP__CLASS_NAME() sf_Ftp_Response
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_external_constructor3( default_constructor, &ftp_response_default_constructor_helper, 0 );
  camlpp__register_method0( getStatus, 0 );
  camlpp__register_method0( getMessage, 0 );
  camlpp__register_method0( isOk, 0 );
}
#undef CAMLPP__CLASS_NAME



#define CAMLPP__CLASS_NAME() sf_Ftp_DirectoryResponse
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Ftp_Response );
  camlpp__register_constructor1( default_constructor, const sf_Ftp_Response&, 0 );
  camlpp__register_method0( getDirectory, 0 );
}
#undef CAMLPP__CLASS_NAME


#define CAMLPP__CLASS_NAME() sf_Ftp_ListingResponse
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Ftp_Response );
  camlpp__register_constructor2(default_constructor, 
				const sf_Ftp_Response&, const std::vector<char>&, 0 );
  camlpp__register_method0( getFilenames, 0 );
}
#undef CAMLPP__CLASS_NAME


namespace
{
  sf::Ftp::Response ftp_connect_helper( 	sf::Ftp* obj, 
						camlpp::optional<unsigned short> port, 
						camlpp::optional<sf::Time> timeout, 
						const sf::IpAddress& server)
  {
    return obj->connect
      (
       server, 
       port.get_value_no_fail(21), 
       timeout.get_value_no_fail(sf::microseconds(0)) 
       );
  }

  sf::Ftp::Response ftp_login_helper( sf::Ftp* obj,
				      camlpp::optional< std::pair<std::string, std::string> > name_and_pswd,
				      camlpp::unit )
  {
    if(name_and_pswd.is_some())
      {
	return obj->login( 	name_and_pswd.get_value().first, 
				name_and_pswd.get_value().second );
      }
    return obj->login( );
  }

  sf::Ftp::Response ftp_download_helper( 	sf::Ftp* obj, camlpp::optional<sf::Ftp::TransferMode> mode,
						std::string const& remoteFile, 
						std::string const& localPath )
  {
    return obj->download(remoteFile, localPath,
			 mode.get_value_no_fail( sf::Ftp::Binary ) );
  }

  sf::Ftp::Response ftp_upload_helper( 	sf::Ftp* obj, camlpp::optional<sf::Ftp::TransferMode> mode,
					std::string const& localFile, 
					std::string const& remotePath )
  {
    return obj->upload(localFile, remotePath,
		       mode.get_value_no_fail( sf::Ftp::Binary ) );
  }
}


#define CAMLPP__CLASS_NAME() sf_Ftp
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_external_method3( connect, &ftp_connect_helper, camlpp::release_caml_runtime );
  camlpp__register_method0( disconnect, 0 );
  camlpp__register_external_method2( login, &ftp_login_helper, camlpp::release_caml_runtime );
  camlpp__register_method0( keepAlive, 0 );
  camlpp__register_method0( getWorkingDirectory, 0 );
    // la méthode ci dessous devrait avoir son premier param optionnel et donc rajouter unit à la fin
  camlpp__register_method1( getDirectoryListing, 0 );
  camlpp__register_method1( changeDirectory, 0 );
  camlpp__register_method0( parentDirectory, 0 );
  camlpp__register_method1( createDirectory, 0 );
  camlpp__register_method1( deleteDirectory, 0 );
  camlpp__register_method2( renameFile, 0 );
  camlpp__register_method1( deleteFile, 0 );
  camlpp__register_external_method3( download, &ftp_download_helper, camlpp::release_caml_runtime );
  camlpp__register_external_method3( upload,   &ftp_upload_helper,   camlpp::release_caml_runtime );
}
#undef CAMLPP__CLASS_NAME
