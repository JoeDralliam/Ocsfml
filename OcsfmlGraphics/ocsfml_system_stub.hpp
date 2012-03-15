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

#include <SFML/System.hpp>

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

	/*CamlInputStream( CamlInputStream const& ) = delete;
	CamlInputStream& operator=( CamlInputStream const& ) = delete;*/
	
	virtual ~CamlInputStream()
	{
	  caml_remove_generational_global_root( inputStreamInst_.get() );
	}

        virtual sf::Int64 read(char* data, sf::Int64 size)
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

template<>
struct ConversionManagement< CamlInputStream >
{
	CamlInputStream from_value( value & v)
	{
	  return CamlInputStream(v);
	}
};

template<>
class ConversionManagement< sf::InputStream& > : public ConversionManagement< CamlInputStream& >
{};

template<>
struct ConversionManagement< sf::Time >
{
  sf::Time from_value( value & v)
  {
    return sf::microseconds( Int64_val(v));
  }
};

template<>
struct AffectationManagement< sf::Time >
{
  static void affect( value & v, sf::Time t )
  {
    v = caml_copy_int64(t.asMicroseconds());
  }

  static void affect_field( value & v, int field, sf::Time t )
  {
    v = caml_copy_int64(t.asMicroseconds());
  }
};

template<class T>
struct ConversionManagement< sf::Vector2<T> >
{
  ConversionManagement< T > cm;
  sf::Vector2<T> from_value( value const& v)
  {
    return sf::Vector2<T>( cm.from_value(Field(v, 0)), cm.from_value(Field(v, 1)) );
  }
};

template<class T>
struct AffectationManagement< sf::Vector2<T> > 
{
  static void affect( value& v, sf::Vector2<T> vec )
  {
	AffectationManagement< std::pair<T, T> >::affect( v, std::make_pair(vec.x, vec.y) );
  }

  static void affect_field( value& v, int field, sf::Vector2<T> vec )
  {
	AffectationManagement< std::pair<T, T> >::affect_field( v, field, std::make_pair(vec.x, vec.y) );
  }
};



template<class T>
struct ConversionManagement< sf::Vector3<T> >
{
  ConversionManagement< T > cm;
  sf::Vector3<T> from_value( value const& v)
  {
    return sf::Vector3<T>( cm.from_value(Field(v, 0)), cm.from_value(Field(v, 1)), cm.from_value(Field(v,2)) );
  }
};

template<class T>
struct AffectationManagement< sf::Vector3<T> >
{
  static void affect( value& v, sf::Vector3<T> vec )
  {
    v = caml_alloc_tuple( 3 );
    AffectationManagement< T >::affect_field(v, 0, vec.x );
    AffectationManagement< T >::affect_field(v, 1, vec.y );
    AffectationManagement< T >::affect_field(v, 2, vec.z );
  }

  static void affect_field( value& v, int field, sf::Vector3<T> vec )
  {
    CAMLparam0();
    CAMLlocal1( vecVal );
    affect( vecVal, vec );
    Store_field(v, field, vecVal);
    CAMLreturn0;
  }
};







#endif

