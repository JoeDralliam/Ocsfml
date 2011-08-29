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

#include <SFML/System/InputStream.hpp>

class CamlInputStream : public sf::InputStream
{
	value inputStreamInst_;
public:
	CamlInputStream( value& v ) : inputSreamInst_( v )
	{
		caml_register_generational_global_root( &inputStreamInst_ );
	}

	CamlInputStream( CamlInputStream const& ) = delete;
	CamlInputStream& operator=( CamlInputStream const& ) = delete;
	
	virtual ~CamlInputStream()
	{
		caml_remove_generational_global_root( &inputStreamInst_ );
	}

	virtual Int64 Read(char* data, Int64 size)
	{
		CAMLparam0;
		CAMLlocal1( res );
		res = callback2( caml_get_public_method(inputStreamInst_, 
							hash_variant("read") ), 
				 inputStreamInst_, 
				 Val_int( size ) );
		auto tup = ConversionManagement< std::pair<char*, Int64> >::from_value( res );
		memcopy( data, tup->first, tup->second );
		return tup->second;
	}

	virtual Int64 Seek(Int64 position)
	{
		return Int_val( callback2( caml_get_public_method(inputStreamInst_, 
								  hash_variant("seek") ), 
					   inputStreamInst_, 
					   Val_int( position ) ) );
	}
    
	virtual Int64 Tell()
	{
		return Int_val( callback( caml_get_public_method(inputStreamInst_, 
								 hash_variant("tell") ), 
					  inputStreamInst_ ) );
	}
		
	virtual Int64 GetSize()
	{
		return Int_val( callback( caml_get_public_method(inputStreamInst_, 
								 hash_variant("tell") ), 
					  inputStreamInst_ ) );
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
9{};


#define

