/*
 * =====================================================================================
 *
 *       Filename:  conversion_management.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 13:35:30
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef CONVERSION_MANAGEMENT_HPP_INCLUDED
#define CONVERSION_MANAGEMENT_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
}

#include <cassert>

namespace camlpp
{

  template<class T>
  struct conversion_management
  {
    conversion_management< T const* > cm;
    T from_value( value const& v)
    {
      return *cm.from_value(v);
    }
  };


  template<class T>
  struct conversion_management<T*>
  {
    T* from_value(value& v)
    {
      assert( Is_block( v ) ); 
      assert( Tag_val(v) == Abstract_tag );
      return reinterpret_cast<T*>(Field(v, 0));
    }
  };

  template<class T>
  struct conversion_management<T&>
  {
    conversion_management<T> cm;
    std::unique_ptr<T> ptr;
    T& from_value(value& v)
    {
      ptr.reset(new T( cm.from_value(v) ) );
      return *ptr;
    }
  };

  template<>
  struct conversion_management<char>
  {
    char from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<signed char>
  {
    char from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };


  template<>
  struct conversion_management<short>
  {
    short from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<int>
  {
    int from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };
  template<>
  struct conversion_management<long>
  {
    long from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<long long>
  {
    long long from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<unsigned char>
  {
    char from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<unsigned short>
  {
    unsigned short from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };
  template<>
  struct conversion_management<unsigned int>
  {
    unsigned int from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };
  template<>
  struct conversion_management<unsigned long>
  {
    unsigned long from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<unsigned long long>
  {
    unsigned long long from_value(value& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<bool>
  {
    bool from_value(value& v)
    {
      return Bool_val(v);
    }
  };

  template<>
  struct conversion_management<float>
  {
    float from_value(value& v)
    {
      assert( Tag_val( v ) == Double_tag );
      return Double_val(v);
    }
  };

  template<>
  struct conversion_management<double>
  {
    double from_value(value& v)
    {
      assert( Tag_val( v ) == Double_tag );
      return Double_val(v);
    }
  };

  template<>
  struct conversion_management<char*>
  {
    char* from_value(value& v)
    {
      assert( Tag_val( v ) == String_tag );
      return String_val(v);
    }
  };

  template<class T>
  struct conversion_management< T const& >: public conversion_management< T >
  {};

}

#endif
