/*
 * =====================================================================================
 *
 *       Filename:  type_option.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  27/08/2011 15:53:47
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef TYPE_OPTION_HPP_INCLUDED
#define TYPE_OPTION_HPP_INCLUDED

#include "affectation_management.hpp"
#include "conversion_management.hpp"
#include <memory>

template< class T >
class Optional
{
	std::unique_ptr<T> val_;
	ConversionManagement<T> cm_;
public:
	Optional( value const& v ) : val_()
	{
		if( Is_block( v ) )
		{
			val_.reset(new T( cm_.from_value( Field(v,0) ) ));
		}
		else
		{
			assert( v == Val_int( 0 ) );
		}
	}
	
	Optional( std::unique_ptr< T > ptr ) : val_( std::move( ptr ) )
	{}

  	Optional( Optional const& other) : val_( other.val_ ? new T(*other.val_) : 0)
	{}

	bool is_none() const
	{
		return !val_;
	}

	bool is_some() const
	{
		return (bool)val_;
	}

	T& get_value()
	{
		assert( is_some() );
		return *val_;
	}

	T const& get_value() const
	{
		assert( is_some() );
		return *val_;
	}
	
	T const& get_value_no_fail( T const& t) const
	{
		if(is_some())
		{
			return *val_;
		}
		return t;
	}
};

template<class T>
class Optional<T&>
{
	std::unique_ptr<T*> val_;
	ConversionManagement<T*> cm_;
public:
	Optional( value const& v ) : val_()
	{
		if( Is_block( v ) )
		{
			val_.reset(new T*( cm_.from_value( Field(v,0) ) ));
		}
		else
		{
			assert( v == Val_int( 0 ) );
		}
	}
	
	Optional( std::unique_ptr< T* > ptr ) : val_( std::move( ptr ) )
	{}

  	Optional( Optional const& other) : val_( other.val_ ? new T*(*other.val_) : 0)
	{}

	bool is_none() const
	{
		return !val_;
	}

	bool is_some() const
	{
		return (bool)val_;
	}

	T& get_value()
	{
		assert( is_some() );
		return **val_;
	}

	T const& get_value() const
	{
		assert( is_some() );
		return **val_;
	}
	
	T const& get_value_no_fail( T const& t) const
	{
		if(is_some())
		{
			return **val_;
		}
		return t;
	}

};

template<class T>
Optional< T > some ( T t )
{
	return Optional< T >( std::unique_ptr<T>(new T(std::forward< T >( t ) ) ) );
}

template<class T>
Optional< T > none ()
{
	return Optional< T >( std::unique_ptr< T >() );
}

template<class T>
struct ConversionManagement< Optional< T > >
{
	Optional< T > from_value( value const& v )
	{
		return Optional< T >( v );
	}
};

template<class T>
struct AffectationManagement< Optional< T > >
{
	static void affect( value& v, Optional< T > const& opt )
	{
		if( opt.is_none() )
		{
			v = Val_int( 0 );
		}
		else
		{
			v = caml_alloc_tuple(1);
			AffectationManagement< T >::affect_field(v, 0, opt.get_value() );
		}
	}
};


#endif

