#include "ocsfml_network_stub.hpp"
#include <SFML/Network.hpp>

#include <camlpp/type_option.hpp>
#include <camlpp/custom_conversion.hpp>
#include <camlpp/custom_class.hpp>
#include <camlpp/stub_generator.hpp>
#include <camlpp/unit.hpp>

typedef sf::IpAddress sf_IpAddress;
#define CAMLPP__CLASS_NAME() sf_IpAddress
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( string_constructor, std::string )
	camlpp__register_constructor4( bytes_constructor, sf::Uint8, sf::Uint8, sf::Uint8, sf::Uint8 )
	camlpp__register_constructor1( integer_constructor, sf::Uint32 )
	camlpp__register_method0( ToString, &sf::IpAddress::ToString )
	camlpp__register_method0( ToInteger, &sf::IpAddress::ToInteger )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

sf::IpAddress ipaddress_get_public_address_helper( Optional<sf::Uint32> timeout, UnitTypeHolder )
{
	return sf::IpAddress::GetPublicAddress( timeout.get_value_no_fail( 0 ) );
}

extern "C"
{
	camlpp__register_overloaded_free_function0( sf_IpAddress_GetLocalAddress,
						 &sf::IpAddress::GetLocalAddress )
	camlpp__register_overloaded_free_function2( sf_IpAddress_GetPublicAddress,
						 &ipaddress_get_public_address_helper )
}
//TODO: Implement comparison operators ==, !=, <, ...

// Note : N'oublie pas d'implémenter du coté caml les deux constantes IpAddress::None (constructeur par défaut) et IpAddress::LocalHost

custom_enum_conversion( sf::Ftp::TransferMode );
custom_enum_affectation( sf::Ftp::TransferMode );

custom_enum_conversion( sf::Ftp::Response::Status );
custom_enum_affectation( sf::Ftp::Response::Status );

sf::Ftp::Response* ftp_response_default_constructor_helper( Optional<sf::Ftp::Response::Status> a1,
							  Optional<std::string> a2, UnitTypeHolder )
{
	return new sf::Ftp::Response( 	a1.get_value_no_fail( sf::Ftp::Response::InvalidResponse ),
					a2.get_value_no_fail( "" ) );
}

typedef sf::Ftp::Response sf_Ftp_Response;
#define CAMLPP__CLASS_NAME() sf_Ftp_Response
camlpp__register_custom_class()
/* les deux derniers paramètres devraient être optionnels non ? (donc rajouter unit derrière) */
	camlpp__register_external_constructor3( default_constructor, ftp_response_default_constructor_helper )
	camlpp__register_method0( GetStatus, &sf::Ftp::Response::GetStatus )
	camlpp__register_method0( GetMessage, &sf::Ftp::Response::GetMessage )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


typedef sf::Ftp::DirectoryResponse sf_Ftp_DirectoryResponse;
#define CAMLPP__CLASS_NAME() sf_Ftp_DirectoryResponse
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Ftp_Response )
	camlpp__register_constructor1( default_constructor, const sf_Ftp_Response& )
	camlpp__register_method0( GetDirectory, &sf::Ftp::DirectoryResponse::GetDirectory )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

typedef sf::Ftp::ListingResponse sf_Ftp_ListingResponse;
#define CAMLPP__CLASS_NAME() sf_Ftp_ListingResponse
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Ftp_Response )
	camlpp__register_constructor2( 	default_constructor, 
					const sf_Ftp_Response&, const std::vector<char>& )
	camlpp__register_method0( GetFilenames , &sf::Ftp::ListingResponse::GetFilenames )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


sf::Ftp::Response ftp_connect_helper( 	sf::Ftp* obj, 
					Optional<unsigned short> port, 
					Optional<sf::Uint32> timeout, 
					const sf::IpAddress& server)
{
	return obj->Connect( server, port.get_value_no_fail(21), timeout.get_value_no_fail(0) );
}

sf::Ftp::Response ftp_login_helper( sf::Ftp* obj,
				    Optional< std::pair<std::string, std::string> > name_and_pswd,
				    UnitTypeHolder )
{
	if(name_and_pswd.is_some())
	{
		return obj->Login( 	name_and_pswd.get_value().first, 
					name_and_pswd.get_value().second );
	}
	return obj->Login( );
}

sf::Ftp::Response ftp_download_helper( 	sf::Ftp* obj, Optional<sf::Ftp::TransferMode> mode,
					std::string const& remoteFile, 
					std::string const& localPath )
{
	return obj->Download( 	remoteFile, localPath,
				mode.get_value_no_fail( sf::Ftp::Binary ) );
}

sf::Ftp::Response ftp_upload_helper( 	sf::Ftp* obj, Optional<sf::Ftp::TransferMode> mode,
					std::string const& localFile, 
					std::string const& remotePath )
{
	return obj->Upload( 	localFile, remotePath,
				mode.get_value_no_fail( sf::Ftp::Binary ) );
}

typedef sf::Ftp sf_Ftp;
#define CAMLPP__CLASS_NAME() sf_Ftp
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method3( Connect, &ftp_connect_helper )
	camlpp__register_method0( Disconnect, &sf::Ftp::Disconnect )
	camlpp__register_method2( Login, &ftp_login_helper )
	camlpp__register_method0( KeepAlive, &sf::Ftp::KeepAlive )
	camlpp__register_method0( GetWorkingDirectory, &sf::Ftp::GetWorkingDirectory )
// la méthode ci dessous devrait avoir son premier param optionnel et donc rajouter unit à la fin
	camlpp__register_method1( GetDirectoryListing, &sf::Ftp::GetDirectoryListing )
	camlpp__register_method1( ChangeDirectory, &sf::Ftp::ChangeDirectory )
	camlpp__register_method0( ParentDirectory, &sf::Ftp::ParentDirectory )
	camlpp__register_method1( CreateDirectory, &sf::Ftp::CreateDirectory )
	camlpp__register_method1( DeleteDirectory, &sf::Ftp::DeleteDirectory )
	camlpp__register_method2( RenameFile, &sf::Ftp::RenameFile )
	camlpp__register_method1( DeleteFile, &sf::Ftp::DeleteFile )
	camlpp__register_method3( Download, &ftp_download_helper )
	camlpp__register_method3( Upload, &ftp_upload_helper )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME



custom_enum_conversion( sf::Http::Request::Method );
custom_enum_affectation( sf::Http::Request::Method );

custom_enum_conversion( sf::Http::Response::Status );
custom_enum_affectation( sf::Http::Response::Status );



sf::Http::Request* http_request_constructor_helper(	Optional<std::string> uri,
							Optional<sf::Http::Request::Method> method,
					  		Optional<std::string> body, UnitTypeHolder )
{
	return new sf::Http::Request( 	uri.get_value_no_fail( "/" ),
					method.get_value_no_fail( sf::Http::Request::Get ),
					body.get_value_no_fail( "" ) );
}

typedef sf::Http::Request sf_Http_Request;
#define CAMLPP__CLASS_NAME() sf_Http_Request
camlpp__register_custom_class()
	camlpp__register_external_constructor4( default_constructor, &http_request_constructor_helper)
	camlpp__register_method2( SetField, &sf::Http::Request::SetField )
	camlpp__register_method1( SetMethod, &sf::Http::Request::SetMethod )
	camlpp__register_method1( SetUri, &sf::Http::Request::SetUri )
	camlpp__register_method2( SetHttpVersion, &sf::Http::Request::SetHttpVersion )
	camlpp__register_method1( SetBody, &sf::Http::Request::SetBody )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


typedef sf::Http::Response sf_Http_Response;
#define CAMLPP__CLASS_NAME() sf_Http_Response
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method1( GetField, &sf::Http::Response::GetField )
	camlpp__register_method0( GetStatus, &sf::Http::Response::GetStatus )
	camlpp__register_method0( GetMajorHttpVersion, &sf::Http::Response::GetMajorHttpVersion )
	camlpp__register_method0( GetMinorHttpVersion, &sf::Http::Response::GetMinorHttpVersion )
	camlpp__register_method0( GetBody, &sf::Http::Response::GetBody )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

void http_set_host_helper( sf::Http* obj, Optional<unsigned short> port, std::string const& host)
{
	obj->SetHost( host, port.get_value_no_fail( 0 ) );
}

sf::Http::Response http_send_request_helper( 	sf::Http* obj,
						Optional< sf::Uint32 > timeout,
						sf::Http::Request const& request )
{
	return obj->SendRequest( request, timeout.get_value_no_fail( 0 ) );
}

typedef sf::Http sf_Http;
#define CAMLPP__CLASS_NAME() sf_Http
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( host_constructor, std::string ) 
	camlpp__register_constructor2( host_and_port_constructor, std::string, unsigned short )
	camlpp__register_method2( SetHost, &http_set_host_helper )
	camlpp__register_method2( SendRequest, &http_send_request_helper )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


bool packet_is_valid_helper( sf::Packet* packet)
{
	return *packet;
}

typedef sf::Int8 sf_Int8;
typedef sf::Int16 sf_Int16;
typedef sf::Int32 sf_Int32;
typedef sf::Uint8 sf_Uint8;
typedef sf::Uint16 sf_Uint16;
typedef sf::Uint32 sf_Uint32;
typedef std::string std_string;

#define STORE_FUNCTION_ACCESS_ADDRESS( type ) \
  void packet_write_ ## type ## _helper (sf::Packet* obj, type data)	\
  {									\
    (*obj) << data;							\
  } \
  type packet_read_  ## type ## _helper (sf::Packet* obj) \
  { \
    type data;					\
    (*obj) >> data;				\
    return data;				\
  }

STORE_FUNCTION_ACCESS_ADDRESS(bool) 
STORE_FUNCTION_ACCESS_ADDRESS(sf_Int8 )
STORE_FUNCTION_ACCESS_ADDRESS(sf_Uint8 )
STORE_FUNCTION_ACCESS_ADDRESS(sf_Int16 )
STORE_FUNCTION_ACCESS_ADDRESS(sf_Uint16 )
STORE_FUNCTION_ACCESS_ADDRESS(sf_Int32 )
STORE_FUNCTION_ACCESS_ADDRESS(sf_Uint32 )
STORE_FUNCTION_ACCESS_ADDRESS(double ) // Caml floats are doubles
STORE_FUNCTION_ACCESS_ADDRESS(std_string )


typedef sf::Packet sf_Packet;
#define CAMLPP__CLASS_NAME() sf_Packet
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
//	camlpp__register_method2( Append, ) ???
	camlpp__register_method0( Clear, &sf::Packet::Clear )
//	camlpp__register_method0( GetData, ) ???
	camlpp__register_method0( GetDataSize, &sf::Packet::GetDataSize )
	camlpp__register_method0( EndOfPacket, &sf::Packet::EndOfPacket )
	camlpp__register_method0( IsValid, &packet_is_valid_helper )

// Note : these method should not return an sf::Packet in caml
// Pourquoi ne pas rajouter read_X_ref : X ref -> packet (ce qui permettrait d'enchainer les appels)
// aprés réflexion on peut déja le faire (cf: ocsfmlNetwork.ml)
	camlpp__register_method0( ReadBool, packet_read_bool_helper) 
	camlpp__register_method0( ReadInt8, packet_read_sf_Int8_helper)
	camlpp__register_method0( ReadUint8, packet_read_sf_Uint8_helper )
	camlpp__register_method0( ReadInt16, packet_read_sf_Int16_helper )
	camlpp__register_method0( ReadUint16, packet_read_sf_Uint16_helper )
	camlpp__register_method0( ReadInt32, packet_read_sf_Int32_helper )
	camlpp__register_method0( ReadUint32, packet_read_sf_Uint32_helper )
	camlpp__register_method0( ReadFloat, packet_read_double_helper ) // Caml floats are doubles
	camlpp__register_method0( ReadString, packet_read_std_string_helper )

	camlpp__register_method1( WriteBool, packet_write_bool_helper ) 
	camlpp__register_method1( WriteInt8, packet_write_sf_Int8_helper)
	camlpp__register_method1( WriteUint8, packet_write_sf_Uint8_helper )
	camlpp__register_method1( WriteInt16, packet_write_sf_Int16_helper)
	camlpp__register_method1( WriteUint16, packet_write_sf_Uint16_helper )
	camlpp__register_method1( WriteInt32, packet_write_sf_Int32_helper )
	camlpp__register_method1( WriteUint32, packet_write_sf_Uint32_helper )
	camlpp__register_method1( WriteFloat, packet_write_double_helper ) // Caml floats are doubles
	camlpp__register_method1( WriteString, packet_write_std_string_helper )

camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

custom_enum_conversion( sf::Socket::Status );
custom_enum_affectation( sf::Socket::Status );

// Dont forget the Socket::AnyPort constant ( 0 )

typedef sf::Socket sf_Socket;
#define CAMLPP__CLASS_NAME() sf_Socket
camlpp__register_custom_class()
// Note : No public constructors
	camlpp__register_method1( SetBlocking, &sf::Socket::SetBlocking )
	camlpp__register_method0( IsBlocking, &sf::Socket::IsBlocking )	
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


bool socketselector_wait_helper( sf::SocketSelector* obj,
				 Optional<sf::Uint32> timeout, UnitTypeHolder )
{
	return obj->Wait( timeout.get_value_no_fail( 0 ) );
}

typedef sf::SocketSelector sf_SocketSelector;
#define CAMLPP__CLASS_NAME() sf_SocketSelector
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( copy_constructor, sf::SocketSelector const& )
	camlpp__register_method1( Add, &sf::SocketSelector::Add )
	camlpp__register_method1( Remove, &sf::SocketSelector::Remove )
	camlpp__register_method0( Clear, &sf::SocketSelector::Clear )
	camlpp__register_method2( Wait, &socketselector_wait_helper )
	camlpp__register_method1( IsReady, &sf::SocketSelector::IsReady )
	camlpp__register_method1( Affect, &sf::SocketSelector::operator= )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


sf::Socket::Status tcpsocket_connect_helper( 	sf::TcpSocket* obj,
						Optional<sf::Uint32> timeout,
						sf::IpAddress const& remoteAddress,
						unsigned short remotePort )
{
	return obj->Connect( 	remoteAddress, remotePort,
				timeout.get_value_no_fail( 0 ) );
}

typedef sf::TcpSocket sf_TcpSocket;


typedef sf::Socket::Status (sf::TcpSocket::*TransferPacketTcp)(sf::Packet&);

#define CAMLPP__CLASS_NAME() sf_TcpSocket
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Socket )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method0( GetLocalPort, &sf::TcpSocket::GetLocalPort )
        camlpp__register_method0( GetRemoteAddress, &sf::TcpSocket::GetRemoteAddress )
	camlpp__register_method0( GetRemotePort, &sf::TcpSocket::GetRemotePort )
	camlpp__register_method3( Connect, &tcpsocket_connect_helper )
	camlpp__register_method0( Disconnect, &sf::TcpSocket::Disconnect )
//	camlpp__register_method2( SendData
//	camlpp__register_method2( ReceiveData                 // third param should be returned
	camlpp__register_method1( SendPacket, ((TransferPacketTcp)&sf::TcpSocket::Send) )
	camlpp__register_method1( ReceivePacket,((TransferPacketTcp)&sf::TcpSocket::Receive) )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

typedef sf::TcpListener sf_TcpListener;
#define CAMLPP__CLASS_NAME() sf_TcpListener
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Socket )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method0( GetLocalPort, &sf::TcpListener::GetLocalPort )
	camlpp__register_method1( Listen, &sf::TcpListener::Listen )
	camlpp__register_method0( Close, &sf::TcpListener::Close )
	camlpp__register_method1( Accept, &sf::TcpListener::Accept )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME




// Dont forget UdpSocket::MaxDatagramSize constant !


typedef sf::Socket::Status (sf::UdpSocket::*TransferPacketUdp)(	sf::Packet&, 
								sf::IpAddress const&,
								unsigned short);


std::pair< sf::Socket::Status, unsigned short /*  remote port */ >
udpsocket_receive_packet_helper( sf::UdpSocket* obj, sf::Packet& packet, sf::IpAddress& remoteIp)
{
	unsigned short remotePort;
	sf::Socket::Status status( obj->Receive( packet, remoteIp, remotePort ) );
	return std::make_pair( status, remotePort );
}

typedef sf::UdpSocket sf_UdpSocket;
#define CAMLPP__CLASS_NAME() sf_UdpSocket
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Socket )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method0( GetLocalPort, &sf::UdpSocket::GetLocalPort )
	camlpp__register_method1( Bind, &sf::UdpSocket::Bind )
	camlpp__register_method0( Unbind, &sf::UdpSocket::Unbind )
//	camlpp__register_method4( SendData
//	camlpp__register_method?( ReceiveData
	camlpp__register_method3( SendPacket, ((TransferPacketUdp)&sf::UdpSocket::Send) )
	camlpp__register_method2( ReceivePacket, &udpsocket_receive_packet_helper )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME




