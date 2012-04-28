#ifndef CSTRING_HPP_INCLUDED
#define CSTRING_HPP_INCLUDED

#include "conversion_management.hpp"

struct CString
{
  char* string;
  size_t size;
};


template<>
struct ConversionManagement<CString>
{
  CString from_value(value& v)
  {
    assert( Tag_val( v ) == String_tag );
    CString s = { String_val(v), string_length(v) };
    return s;
  }
};




#endif
