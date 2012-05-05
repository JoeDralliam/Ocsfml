#include "UdpSocket.hpp"

#include "RawDataType.hpp"

#include "IpAddress.hpp"
#include "Socket.hpp"
#include "Packet.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/cstring.hpp>
#include <camlpp/std/tuple.hpp>


typedef sf::Socket::Status (sf::UdpSocket::*TransferPacketUdp)(	sf::Packet&, 
								sf::IpAddress const&,
								unsigned short);


namespace
{
  std::pair< sf::Socket::Status, unsigned short /*  remote port */ >
  udpsocket_receivepacket_helper( sf::UdpSocket* obj, sf::Packet& packet, sf::IpAddress& remoteIp)
  {
    unsigned short remotePort;
    sf::Socket::Status status( obj->receive( packet, remoteIp, remotePort ) );
    return std::make_pair( status, remotePort );
  }


  std::tuple< sf::Socket::Status, intnat /*bytes receveid*/, unsigned short /* remote port */ > 
  udpsocket_receivedata_helper( sf::UdpSocket* obj, RawDataType d, sf::IpAddress& remoteIp)
  {
    std::size_t received;
    unsigned short remotePort;
    sf::Socket::Status stat = obj->receive(d.data, d.size[0], received, remoteIp, remotePort);
    return std::make_tuple( stat, received, remotePort);
  }


  sf::Socket::Status udpsocket_senddata_helper( sf::UdpSocket* obj, RawDataType d, sf::IpAddress const& remoteIp, unsigned short remotePort)
  {
    return obj->send( d.data, d.size[0], remoteIp, remotePort);
  }

  std::tuple< sf::Socket::Status, intnat /*bytes receveid*/, unsigned short /* remote port */ > 
  udpsocket_receivestring_helper( sf::UdpSocket* obj, camlpp::c_string s, sf::IpAddress& remoteIp)
  {
    std::size_t received;
    unsigned short remotePort;
    sf::Socket::Status stat = obj->receive(s.string , s.size, received, remoteIp, remotePort);
    return std::make_tuple( stat, received, remotePort);
  }

  sf::Socket::Status udpsocket_sendstring_helper( sf::UdpSocket* obj, camlpp::c_string s, sf::IpAddress const& remoteIp, unsigned short remotePort)
  {
    return obj->send( s.string, s.size, remoteIp, remotePort);
  }
}


#define CAMLPP__CLASS_NAME() sf_UdpSocket
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Socket );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getLocalPort );
  camlpp__register_method1( bind );
  camlpp__register_method0( unbind );
  camlpp__register_external_method3( sendData, &udpsocket_senddata_helper);
  camlpp__register_external_method2( receiveData, &udpsocket_receivedata_helper );
  camlpp__register_external_method3( sendString, &udpsocket_sendstring_helper);
  camlpp__register_external_method2( receiveString, &udpsocket_receivestring_helper );
  camlpp__register_external_method3( sendPacket, ((TransferPacketUdp)&sf::UdpSocket::send) );
  camlpp__register_external_method2( receivePacket, &udpsocket_receivepacket_helper );
}
#undef CAMLPP__CLASS_NAME
