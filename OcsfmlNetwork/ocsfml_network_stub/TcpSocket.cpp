#include "TcpSocket.hpp"

#include "RawDataType.hpp"

#include "IpAddress.hpp"
#include "Socket.hpp"
#include "Packet.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/cstring.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/std/pair.hpp>

namespace
{
  sf::Socket::Status tcpsocket_connect_helper( 	sf::TcpSocket* obj,
						camlpp::optional<sf::Time> timeout,
						sf::IpAddress const& remoteAddress,
						unsigned short remotePort )
  {
    return obj->connect( 	remoteAddress, remotePort,
				timeout.get_value_no_fail( sf::microseconds(0) ));
  }

  sf::Socket::Status tcpsocket_senddata_helper( sf::TcpSocket* obj, RawDataType d)
  {
    return obj->send( d.data, d.size[0] );
  }

  std::pair< sf::Socket::Status, intnat > tcpsocket_receivedata_helper( sf::TcpSocket* obj, RawDataType d)
  {
    size_t received;
    sf::Socket::Status stat = obj->receive( d.data, d.size[0], received );
    return std::pair< sf::Socket::Status, intnat >(stat, received );
  }

  sf::Socket::Status tcpsocket_sendstring_helper( sf::TcpSocket* obj, camlpp::c_string s)
  {
    return obj->send( s.string , s.size );
  }

  std::pair< sf::Socket::Status, intnat > tcpsocket_receivestring_helper( sf::TcpSocket* obj, camlpp::c_string s)
  {
    size_t received;
    sf::Socket::Status stat = obj->receive( s.string , s.size, received );
    return std::pair< sf::Socket::Status, intnat >(stat, received );
  }
}


typedef sf::Socket::Status (sf::TcpSocket::*TransferPacketTcp)(sf::Packet&);

#define CAMLPP__CLASS_NAME() sf_TcpSocket
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Socket );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getLocalPort );
  camlpp__register_method0( getRemoteAddress );
  camlpp__register_method0( getRemotePort );
  camlpp__register_external_method3( connect, &tcpsocket_connect_helper );
  camlpp__register_method0( disconnect );
  camlpp__register_external_method1( sendData, &tcpsocket_senddata_helper );
  camlpp__register_external_method1( receiveData, &tcpsocket_receivedata_helper );
  camlpp__register_external_method1( sendString, &tcpsocket_sendstring_helper );
  camlpp__register_external_method1( receiveString, &tcpsocket_receivestring_helper );
  camlpp__register_external_method1( sendPacket, ((TransferPacketTcp)&sf::TcpSocket::send) );
  camlpp__register_external_method1( receivePacket,((TransferPacketTcp)&sf::TcpSocket::receive) );
}
#undef CAMLPP__CLASS_NAME
