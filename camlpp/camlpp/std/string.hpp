#ifndef CAMLPP_STD_STRING_HPP_INCLUDED
#define CAMLPP_STD_STRING_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/alloc.h>
}

#include <string>

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>

namespace camlpp
{
  template<>
  struct affectation_management<std::string>
  {
    static void affect(value& v, std::string const& str)
    {
      v = caml_copy_string( str.c_str() );
    }
  };
  
  template<>
  struct conversion_management<std::string>
  {
    std::string from_value(value& v)
    {
      assert( Tag_val( v ) == String_tag );
      return std::string( String_val(v), caml_string_length(v) );
    }
  };
}
  
#endif
