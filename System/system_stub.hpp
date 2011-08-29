/*
 * =====================================================================================
 *
 *       Filename:  system.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  29/08/2011 12:09:03
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef OCSFML_SYSTEM_HPP_INCLUDED
#define OCSFML_SYSTEM_HPP_INCLUDED

#include <camlpp/custom_class.hpp>
#include <cstring>

#include <SFML/System/InputStream.hpp>

class CamlInputStream : public sf::InputStream
{
        std::unique_ptr<value> inputStreamInst_;
public:
        CamlInputStream( value& v ) : inputStreamInst_(new value(v) )
	{
	  caml_register_generational_global_root( inputStreamInst_.get() );
	}

        CamlInputStream( CamlInputStream&& other ) : inputStreamInst_( std::move( other.inputStreamInst_ ) )
        {}				 

	CamlInputStream( CamlInputStream const& ) = delete;
	CamlInputStream& operator=( CamlInputStream const& ) = delete;
	
	virtual ~CamlInputStream()
	{
	  caml_remove_generational_global_root( inputStreamInst_.get() );
	}

        virtual sf::Int64 Read(char* data, sf::Int64 size)
	{
	  CAMLparam0();
		CAMLlocal1( res );
		res = callback2( caml_get_public_method(*inputStreamInst_, 
							hash_variant("read") ), 
				 *inputStreamInst_, 
				 Val_int( size ) );
		ConversionManagement< std::pair<char*, sf::Int64> > cm;
		auto tup = cm.from_value( res );
		std::memcpy( data, tup.first, tup.second );
		CAMLreturnT(sf::Int64, tup.second);
	}

        virtual sf::Int64 Seek(sf::Int64 position)
	{
		return Int_val( callback2( caml_get_public_method(*inputStreamInst_, 
								  hash_variant("seek") ), 
					   *inputStreamInst_, 
					   Val_int( position ) ) );
	}
    
        virtual sf::Int64 Tell()
	{
		return Int_val( callback( caml_get_public_method(*inputStreamInst_, 
								 hash_variant("tell") ), 
					  *inputStreamInst_ ) );
	}
		
        virtual sf::Int64 GetSize()
	{
		return Int_val( callback( caml_get_public_method(*inputStreamInst_, 
								 hash_variant("tell") ), 
					  *inputStreamInst_ ) );
	}
};

template<>
class ConversionManagement< CamlInputStream >
{
	CamlInputStream from_value( value& v)
	{
	  return CamlInputStream(v);
	}
};

template<>
class ConversionManagement< sf::InputStream& > : public ConversionManagement< CamlInputStream& >
{};


#endif

