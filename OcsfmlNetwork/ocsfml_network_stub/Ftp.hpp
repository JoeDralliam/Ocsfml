#ifndef OCSFML_FTP_HPP_INCLUDED
#define OCSFML_FTP_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>
#include <camlpp/custom_class.hpp>

#include <SFML/Network/Ftp.hpp>

custom_enum_conversion( sf::Ftp::TransferMode );
custom_enum_affectation( sf::Ftp::TransferMode );

custom_enum_conversion( sf::Ftp::Response::Status );
custom_enum_affectation( sf::Ftp::Response::Status );


typedef sf::Ftp::Response sf_Ftp_Response;
camlpp__preregister_custom_operations( sf_Ftp_Response )
camlpp__preregister_custom_class( sf_Ftp_Response )


typedef sf::Ftp::DirectoryResponse sf_Ftp_DirectoryResponse;
camlpp__preregister_custom_operations( sf_Ftp_DirectoryResponse )
camlpp__preregister_custom_class( sf_Ftp_DirectoryResponse )


typedef sf::Ftp::ListingResponse sf_Ftp_ListingResponse;
camlpp__preregister_custom_operations( sf_Ftp_ListingResponse )
camlpp__preregister_custom_class( sf_Ftp_ListingResponse )


typedef sf::Ftp sf_Ftp;
camlpp__preregister_custom_operations( sf_Ftp )
camlpp__preregister_custom_class( sf_Ftp )


#endif
