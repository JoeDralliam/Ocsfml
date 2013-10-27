#ifndef CONVERSION_MANAGEMENT_HPP_INCLUDED
#define CONVERSION_MANAGEMENT_HPP_INCLUDED

#include <cassert>
#include <memory>


extern "C"
{
#include <caml/mlvalues.h>
}

namespace camlpp
{
  template<class T>
  struct conversion_management
  {};


  template<class T>
  struct conversion_management<T*>
  {
    T* from_value(value const& v)
    {
      assert( Is_long( v ) ); 
      return reinterpret_cast<T*>(v - 1);
    }
  };

  template<class T>
  struct conversion_management<T&>
  {
    conversion_management<T*> cm;
    T& from_value(value const& v)
    {
      return *cm.from_value(v);
    }
  };

  template<>
  struct conversion_management<char>
  {
    char from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<signed char>
  {
    char from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };


  template<>
  struct conversion_management<short>
  {
    short from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<int>
  {
    int from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };
  template<>
  struct conversion_management<long>
  {
    long from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<long long>
  {
    long long from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<unsigned char>
  {
    char from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<unsigned short>
  {
    unsigned short from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };
  template<>
  struct conversion_management<unsigned int>
  {
    unsigned int from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };
  template<>
  struct conversion_management<unsigned long>
  {
    unsigned long from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<unsigned long long>
  {
    unsigned long long from_value(value const& v)
    {
      assert( Is_long( v ) );
      return Int_val(v);
    }
  };

  template<>
  struct conversion_management<bool>
  {
    bool from_value(value const& v)
    {
      return Bool_val(v);
    }
  };

  template<>
  struct conversion_management<float>
  {
    float from_value(value const& v)
    {
      assert( Tag_val( v ) == Double_tag );
      return Double_val(v);
    }
  };

  template<>
  struct conversion_management<double>
  {
    double from_value(value const& v)
    {
      assert( Tag_val( v ) == Double_tag );
      return Double_val(v);
    }
  };

  template<>
  struct conversion_management<char*>
  {
    char* from_value(value const& v)
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
