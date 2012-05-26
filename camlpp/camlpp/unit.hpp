#ifndef CAMLPP_UNIT_HPP_INCLUDED
#define CAMLPP_UNIT_HPP_INCLUDED


extern "C"
{
#include <caml/mlvalues.h>
}

#include "conversion_management.hpp"

namespace camlpp
{
  struct unit {};

  template<>
  struct conversion_management< unit >
  {
    unit from_value(value const& v)
    {
      assert( v == Val_unit );
      return unit();
    }	
  };
}

#endif
