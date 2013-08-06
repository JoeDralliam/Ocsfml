#ifndef OCSFML_INPUT_STREAM_HPP_INCLUDED
#define OCSFML_INPUT_STREAM_HPP_INCLUDED

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>
#include <camlpp/std/pair.hpp>

extern "C"
{
#include <caml/callback.h>
}

#include <SFML/System/InputStream.hpp>

#include "RawDataType.hpp"

class CamlInputStream : public sf::InputStream
{
  std::unique_ptr<value> inputStreamInst_;
public:
  CamlInputStream( value const& v ) : inputStreamInst_(new value(v) )
  {
    caml_register_generational_global_root( inputStreamInst_.get() );
  }

  CamlInputStream( CamlInputStream&& other ) : inputStreamInst_( std::move( other.inputStreamInst_ ) )
  {}				 

  /*CamlInputStream( CamlInputStream const& ) = delete;
    CamlInputStream& operator=( CamlInputStream const& ) = delete;*/
	
  virtual ~CamlInputStream()
  {
    caml_remove_generational_global_root( inputStreamInst_.get() );
  }

  virtual sf::Int64 read(void* data, sf::Int64 size)
  {
    CAMLparam0();
    CAMLlocal1(buffer);
    camlpp::affectation_management< RawDataType > am;


    intnat data_dim[] = { size };
    RawDataType data_ba(data, data_dim);

    am.affect(buffer, data_ba);
    sf::Int64 res = 
      Int_val( callback3( caml_get_public_method(*inputStreamInst_, 
						 hash_variant("read") ), 
			  *inputStreamInst_,
			  buffer,
			  Val_int( size ) ) );
    CAMLreturnT(sf::Int64, res);
  }
  
  virtual sf::Int64 seek(sf::Int64 position)
  {
    return Int_val( callback2( caml_get_public_method(*inputStreamInst_, 
						      hash_variant("seek") ), 
			       *inputStreamInst_, 
			       Val_int( position ) ) );
  }
  
  virtual sf::Int64 tell()
  {
    return Int_val( callback( caml_get_public_method(*inputStreamInst_, 
						     hash_variant("tell") ), 
			      *inputStreamInst_ ) );
  }
		
  virtual sf::Int64 getSize()
  {
    return Int_val( callback( caml_get_public_method(*inputStreamInst_, 
						     hash_variant("get_size") ), 
			      *inputStreamInst_ ) );
  }
};


namespace camlpp
{
  template<>
  struct conversion_management< CamlInputStream >
  {
    CamlInputStream from_value( value const& v)
    {
      return CamlInputStream(v);
    }
  };
  
  template<>
  class conversion_management< sf::InputStream& > : public conversion_management< CamlInputStream& >
  {};
}

#endif
