#ifndef TYPE_OPTION_HPP_INCLUDED
#define TYPE_OPTION_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
}

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>
#include <camlpp/field_affectation_management.hpp>

#include <memory>

namespace camlpp
{
  template< class T >
  class optional
  {
    std::unique_ptr<T> val_;
    conversion_management<T> cm_;
  public:
    optional( value const& v ) : val_()
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
	
    optional( std::unique_ptr< T > ptr ) : val_( std::move( ptr ) )
    {}

    optional( optional const& other) : val_( other.val_ ? new T(*other.val_) : 0)
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
  class optional<T&>
  {
    std::unique_ptr<T*> val_;
    conversion_management<T*> cm_;
  public:
    optional( value const& v ) : val_()
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
	
    optional( std::unique_ptr< T* > ptr ) : val_( std::move( ptr ) )
    {}

    optional( optional const& other) : val_( other.val_ ? new T*(*other.val_) : 0)
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
  optional< T > some ( T t )
  {
    return optional< T >( std::unique_ptr<T>(new T(std::forward< T >( t ) ) ) );
  }

  template<class T>
  optional< T > none ()
  {
    return optional< T >( std::unique_ptr< T >() );
  }

  template<class T>
  struct conversion_management< optional< T > >
  {
    optional< T > from_value( value const& v )
    {
      return optional< T >( v );
    }
  };

  template<class T>
  struct affectation_management< optional< T > >
  {
    static void affect( value& v, optional< T > const& opt )
    {
      if( opt.is_none() )
	{
	  v = Val_int( 0 );
	}
      else
	{
	  v = caml_alloc_tuple(1);
	  field_affectation_management< T >::affect_field(v, 0, opt.get_value() );
	}
    }
  };
}


#endif

