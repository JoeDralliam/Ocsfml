#include "ocsfml_network_stub.hpp"
#include <SFML/Network.hpp>

#include <camlpp/type_option.hpp>
#include <camlpp/custom_conversion.hpp>
#include <camlpp/custom_class.hpp>
#include <camlpp/custom_ops.hpp>
#include <camlpp/stub_generator.hpp>
#include <camlpp/unit.hpp>

typedef sf::IpAddress sf_IpAddress;
#define CAMLPP__CLASS_NAME() sf_IpAddress
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__DEFAULT_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( string_constructor, std::string );
  camlpp__register_constructor4( bytes_constructor, sf::Uint8, sf::Uint8, sf::Uint8, sf::Uint8 );
  camlpp__register_constructor1( integer_constructor, sf::Uint32 );
  camlpp__register_method0( toString );
  camlpp__register_method0( toInteger ); // perte de données possible (int caml sur 31 bits et non 32)
}
#undef CAMLPP__CLASS_NAME

sf::IpAddress ipaddress_get_public_address_helper( Optional<sf::Time> timeout, UnitTypeHolder )
{
  return sf::IpAddress::getPublicAddress( timeout.get_value_no_fail( sf::microseconds(0) ) );
}

extern "C"
{
  camlpp__register_overloaded_free_function0( sf_IpAddress_getLocalAddress,
					      &sf::IpAddress::getLocalAddress )
  camlpp__register_overloaded_free_function2( sf_IpAddress_getPublicAddress,
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
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
/* les deux derniers paramètres devraient être optionnels non ? (donc rajouter unit derrière) */
  camlpp__register_external_constructor3( default_constructor, &ftp_response_default_constructor_helper );
  camlpp__register_method0( getStatus );
  camlpp__register_method0( getMessage );
}
#undef CAMLPP__CLASS_NAME


typedef sf::Ftp::DirectoryResponse sf_Ftp_DirectoryResponse;
#define CAMLPP__CLASS_NAME() sf_Ftp_DirectoryResponse
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Ftp_Response );
  camlpp__register_constructor1( default_constructor, const sf_Ftp_Response& );
  camlpp__register_method0( getDirectory );
}
#undef CAMLPP__CLASS_NAME

typedef sf::Ftp::ListingResponse sf_Ftp_ListingResponse;
#define CAMLPP__CLASS_NAME() sf_Ftp_ListingResponse
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Ftp_Response );
  camlpp__register_constructor2(default_constructor, 
				const sf_Ftp_Response&, const std::vector<char>& );
  camlpp__register_method0( getFilenames );
}
#undef CAMLPP__CLASS_NAME


sf::Ftp::Response ftp_connect_helper( 	sf::Ftp* obj, 
					Optional<unsigned short> port, 
					Optional<sf::Time> timeout, 
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
				    Optional< std::pair<std::string, std::string> > name_and_pswd,
				    UnitTypeHolder )
{
  if(name_and_pswd.is_some())
    {
      return obj->login( 	name_and_pswd.get_value().first, 
				name_and_pswd.get_value().second );
    }
  return obj->login( );
}

sf::Ftp::Response ftp_download_helper( 	sf::Ftp* obj, Optional<sf::Ftp::TransferMode> mode,
					std::string const& remoteFile, 
					std::string const& localPath )
{
  return obj->download(remoteFile, localPath,
		       mode.get_value_no_fail( sf::Ftp::Binary ) );
}

sf::Ftp::Response ftp_upload_helper( 	sf::Ftp* obj, Optional<sf::Ftp::TransferMode> mode,
					std::string const& localFile, 
					std::string const& remotePath )
{
	return obj->upload(localFile, remotePath,
			   mode.get_value_no_fail( sf::Ftp::Binary ) );
}

typedef sf::Ftp sf_Ftp;
#define CAMLPP__CLASS_NAME() sf_Ftp
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
	camlpp__register_constructor0( default_constructor )
	camlpp__register_external_method3( connect, &ftp_connect_helper )
	camlpp__register_method0( disconnect )
	camlpp__register_external_method2( login, &ftp_login_helper )
	camlpp__register_method0( keepAlive )
	camlpp__register_method0( getWorkingDirectory )
// la méthode ci dessous devrait avoir son premier param optionnel et donc rajouter unit à la fin
	camlpp__register_method1( getDirectoryListing )
	camlpp__register_method1( changeDirectory )
	camlpp__register_method0( parentDirectory )
	camlpp__register_method1( createDirectory )
	camlpp__register_method1( deleteDirectory )
	camlpp__register_method2( renameFile )
	camlpp__register_method1( deleteFile )
	camlpp__register_external_method3( download, &ftp_download_helper )
	camlpp__register_external_method3( upload, &ftp_upload_helper )
}
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
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_external_constructor4( default_constructor, &http_request_constructor_helper);
  camlpp__register_method2( setField );
  camlpp__register_method1( setMethod );
  camlpp__register_method1( setUri );
  camlpp__register_method2( setHttpVersion );
  camlpp__register_method1( setBody );
}
#undef CAMLPP__CLASS_NAME


typedef sf::Http::Response sf_Http_Response;
#define CAMLPP__CLASS_NAME() sf_Http_Response
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method1( getField );
  camlpp__register_method0( getStatus );
  camlpp__register_method0( getMajorHttpVersion );
  camlpp__register_method0( getMinorHttpVersion );
  camlpp__register_method0( getBody );
}
#undef CAMLPP__CLASS_NAME

void http_set_host_helper( sf::Http* obj, Optional<unsigned short> port, std::string const& host)
{
  obj->setHost( host, port.get_value_no_fail( 0 ) );
}

sf::Http::Response http_send_request_helper( 	sf::Http* obj,
						Optional< sf::Time > timeout,
						sf::Http::Request const& request )
{
  return obj->sendRequest
    ( 
     request, 
     timeout.get_value_no_fail(sf::microseconds(0)) 
    );
}

typedef sf::Http sf_Http;
#define CAMLPP__CLASS_NAME() sf_Http
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( host_constructor, std::string );
  camlpp__register_constructor2( host_and_port_constructor, std::string, unsigned short );
  camlpp__register_external_method2( setHost, &http_set_host_helper );
  camlpp__register_external_method2( sendRequest, &http_send_request_helper );
}
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

#define STORE_FUNCTION_ACCESS_ADDRESS( type )				\
  void packet_write_ ## type ## _helper (sf::Packet* obj, type data)	\
  {									\
    (*obj) << data;							\
  }									\
  type packet_read_  ## type ## _helper (sf::Packet* obj)		\
  {									\
    type data;								\
    (*obj) >> data;							\
    return data;							\
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
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  //	camlpp__register_method2( Append, ) ???
  camlpp__register_method0( clear );
  //	camlpp__register_method0( GetData, ) ???
  camlpp__register_method0( getDataSize );
  camlpp__register_method0( endOfPacket );
  camlpp__register_external_method0( isValid, &packet_is_valid_helper );
  
// Note : these methods should not return an sf::Packet in caml
// Pourquoi ne pas rajouter read_X_ref : X ref -> packet (ce qui permettrait d'enchainer les appels)
// aprés réflexion on peut déja le faire (cf: ocsfmlNetwork.ml)
  camlpp__register_external_method0( readBool, packet_read_bool_helper) ;
  camlpp__register_external_method0( readInt8, packet_read_sf_Int8_helper);
  camlpp__register_external_method0( readUint8, packet_read_sf_Uint8_helper );
  camlpp__register_external_method0( readInt16, packet_read_sf_Int16_helper );
  camlpp__register_external_method0( readUint16, packet_read_sf_Uint16_helper );
  camlpp__register_external_method0( readInt32, packet_read_sf_Int32_helper );
  camlpp__register_external_method0( readUint32, packet_read_sf_Uint32_helper );
  camlpp__register_external_method0( readFloat, packet_read_double_helper ); // Caml floats are doubles
  camlpp__register_external_method0( readString, packet_read_std_string_helper );
  
  camlpp__register_external_method1( writeBool, packet_write_bool_helper );
  camlpp__register_external_method1( writeInt8, packet_write_sf_Int8_helper);
  camlpp__register_external_method1( writeUint8, packet_write_sf_Uint8_helper );
  camlpp__register_external_method1( writeInt16, packet_write_sf_Int16_helper);
  camlpp__register_external_method1( writeUint16, packet_write_sf_Uint16_helper );
  camlpp__register_external_method1( writeInt32, packet_write_sf_Int32_helper );
  camlpp__register_external_method1( writeUint32, packet_write_sf_Uint32_helper );
  camlpp__register_external_method1( writeFloat, packet_write_double_helper ); // Caml floats are doubles
  camlpp__register_external_method1( writeString, packet_write_std_string_helper );  
}
#undef CAMLPP__CLASS_NAME

custom_enum_conversion( sf::Socket::Status );
custom_enum_affectation( sf::Socket::Status );

// Dont forget the Socket::AnyPort constant ( 0 )

typedef sf::Socket sf_Socket;
#define CAMLPP__CLASS_NAME() sf_Socket
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
// Note : No public constructors
  camlpp__register_method1( setBlocking );
  camlpp__register_method0( isBlocking );
}
#undef CAMLPP__CLASS_NAME


bool socketselector_wait_helper( sf::SocketSelector* obj,
				 Optional<sf::Time> timeout, UnitTypeHolder )
{
  return obj->wait( timeout.get_value_no_fail( sf::microseconds(0) ) );
}

typedef sf::SocketSelector sf_SocketSelector;
#define CAMLPP__CLASS_NAME() sf_SocketSelector
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( copy_constructor, sf::SocketSelector const& );
  camlpp__register_method1( add );
  camlpp__register_method1( remove );
  camlpp__register_method0( clear );
  camlpp__register_external_method2( wait, &socketselector_wait_helper );
  camlpp__register_method1( isReady );
  camlpp__register_external_method1( affect, &sf::SocketSelector::operator= );
}
#undef CAMLPP__CLASS_NAME


sf::Socket::Status tcpsocket_connect_helper( 	sf::TcpSocket* obj,
						Optional<sf::Time> timeout,
						sf::IpAddress const& remoteAddress,
						unsigned short remotePort )
{
	return obj->connect( 	remoteAddress, remotePort,
				timeout.get_value_no_fail( sf::microseconds(0) ));
}

typedef sf::TcpSocket sf_TcpSocket;


typedef sf::Socket::Status (sf::TcpSocket::*TransferPacketTcp)(sf::Packet&);

#define CAMLPP__CLASS_NAME() sf_TcpSocket
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Socket );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getLocalPort );
  camlpp__register_method0( getRemoteAddress );
  camlpp__register_method0( getRemotePort );
  camlpp__register_external_method3( connect, &tcpsocket_connect_helper );
  camlpp__register_method0( disconnect );
  //	camlpp__register_method2( SendData
  //	camlpp__register_method2( ReceiveData                 // third param should be returned
  camlpp__register_external_method1( sendPacket, ((TransferPacketTcp)&sf::TcpSocket::send) );
  camlpp__register_external_method1( receivePacket,((TransferPacketTcp)&sf::TcpSocket::receive) );
}
#undef CAMLPP__CLASS_NAME

typedef sf::TcpListener sf_TcpListener;
#define CAMLPP__CLASS_NAME() sf_TcpListener
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Socket );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getLocalPort );
  camlpp__register_method1( listen );
  camlpp__register_method0( close );
  camlpp__register_method1( accept );
}
#undef CAMLPP__CLASS_NAME




// Dont forget UdpSocket::MaxDatagramSize constant !


typedef sf::Socket::Status (sf::UdpSocket::*TransferPacketUdp)(	sf::Packet&, 
								sf::IpAddress const&,
								unsigned short);


std::pair< sf::Socket::Status, unsigned short /*  remote port */ >
udpsocket_receive_packet_helper( sf::UdpSocket* obj, sf::Packet& packet, sf::IpAddress& remoteIp)
{
  unsigned short remotePort;
  sf::Socket::Status status( obj->receive( packet, remoteIp, remotePort ) );
  return std::make_pair( status, remotePort );
}

typedef sf::Socket::Status (sf::UdpSocket::*TransferDataUdp)( const char* data, 
							      std::size_t size, 
							      const sf::IpAddress& remoteAddress, 
							      unsigned short remotePort);

std::tuple< sf::Socket::Status, unsigned short, std::string > 
udpsocket_receive_data_helper( sf::UdpSocket* obj, std::size_t size, sf::IpAddress& remoteIp)
{
  char* dataBuffer = new char[size];
  std::size_t received;
  unsigned short remotePort;
  sf::Socket::Status stat = obj->receive(dataBuffer, size, received, remoteIp, remotePort);
  std::string s(dataBuffer, dataBuffer+received);
  delete[] dataBuffer;
  return std::make_tuple( stat, remotePort, s );
}


typedef sf::UdpSocket sf_UdpSocket;
#define CAMLPP__CLASS_NAME() sf_UdpSocket
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Socket );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getLocalPort );
  camlpp__register_method1( bind );
  camlpp__register_method0( unbind );
  camlpp__register_external_method4( sendData, (TransferDataUdp)&sf::UdpSocket::send);
  camlpp__register_external_method2( receiveData, &udpsocket_receive_data_helper );
  camlpp__register_external_method3( sendPacket, ((TransferPacketUdp)&sf::UdpSocket::send) );
  camlpp__register_external_method2( receivePacket, &udpsocket_receive_packet_helper );
}
#undef CAMLPP__CLASS_NAME




