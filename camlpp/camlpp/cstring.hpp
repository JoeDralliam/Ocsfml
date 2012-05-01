#ifndef CSTRING_HPP_INCLUDED
#define CSTRING_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
}

#include <camlpp/conversion_management.hpp>

namespace camlpp
{
  struct c_string
  {
    char* string;
    size_t size;
  };
  
  
  template<>
  struct conversion_management<c_string>
  {
    c_string from_value(value& v)
    {
      assert( Tag_val( v ) == String_tag );
      c_string s = { String_val(v), string_length(v) };
      return s;
  }
  };
}



#endif
