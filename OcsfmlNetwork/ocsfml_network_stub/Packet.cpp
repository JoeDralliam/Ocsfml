#include "Packet.hpp"

#include "RawDataType.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/std/string.hpp>

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

namespace
{
  STORE_FUNCTION_ACCESS_ADDRESS(bool) 
  STORE_FUNCTION_ACCESS_ADDRESS(sf_Int8 )
  STORE_FUNCTION_ACCESS_ADDRESS(sf_Uint8 )
  STORE_FUNCTION_ACCESS_ADDRESS(sf_Int16 )
  STORE_FUNCTION_ACCESS_ADDRESS(sf_Uint16 )
  STORE_FUNCTION_ACCESS_ADDRESS(sf_Int32 )
  STORE_FUNCTION_ACCESS_ADDRESS(sf_Uint32 )
  STORE_FUNCTION_ACCESS_ADDRESS(double ) // Caml floats are doubles
  STORE_FUNCTION_ACCESS_ADDRESS(std_string )

  bool packet_is_valid_helper( sf::Packet* packet)
  {
    return *packet;
  }


  void packet_append_helper( sf::Packet* packet, RawDataType data )
  {
    packet->append( data.data, data.size[0] );
  }

  RawDataType packet_getdata_helper( sf::Packet* packet )
  {
    intnat dim[1] = { packet->getDataSize() };
    return RawDataType( packet->getData(), dim );
  }
}

#define CAMLPP__CLASS_NAME() sf_Packet
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_external_method1( append, &packet_append_helper, 0 );
  camlpp__register_method0( clear, 0 );
  camlpp__register_external_method0( getData, &packet_getdata_helper, 0);
  camlpp__register_method0( getDataSize, 0 );
  camlpp__register_method0( endOfPacket, 0 );
  camlpp__register_external_method0( isValid, &packet_is_valid_helper, 0 );
  
  camlpp__register_external_method0( readBool,   packet_read_bool_helper,       0);
  camlpp__register_external_method0( readInt8,   packet_read_sf_Int8_helper,    0);
  camlpp__register_external_method0( readUint8,  packet_read_sf_Uint8_helper,   0);
  camlpp__register_external_method0( readInt16,  packet_read_sf_Int16_helper,   0);
  camlpp__register_external_method0( readUint16, packet_read_sf_Uint16_helper,  0);
  camlpp__register_external_method0( readInt32,  packet_read_sf_Int32_helper,   0);
  camlpp__register_external_method0( readUint32, packet_read_sf_Uint32_helper,  0);
  camlpp__register_external_method0( readFloat,  packet_read_double_helper,     0); // Caml floats are doubles
  camlpp__register_external_method0( readString, packet_read_std_string_helper, 0);
  
  camlpp__register_external_method1( writeBool,   packet_write_bool_helper,       0);
  camlpp__register_external_method1( writeInt8,   packet_write_sf_Int8_helper,    0);
  camlpp__register_external_method1( writeUint8,  packet_write_sf_Uint8_helper,   0);
  camlpp__register_external_method1( writeInt16,  packet_write_sf_Int16_helper,   0);
  camlpp__register_external_method1( writeUint16, packet_write_sf_Uint16_helper,  0);
  camlpp__register_external_method1( writeInt32,  packet_write_sf_Int32_helper,   0);
  camlpp__register_external_method1( writeUint32, packet_write_sf_Uint32_helper,  0);
  camlpp__register_external_method1( writeFloat,  packet_write_double_helper,     0); // Caml floats are doubles
  camlpp__register_external_method1( writeString, packet_write_std_string_helper, 0);  
}
#undef CAMLPP__CLASS_NAME
