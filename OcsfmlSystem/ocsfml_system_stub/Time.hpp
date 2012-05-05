#ifndef OCSFML_TIME_HPP_INCLUDED
#define OCSFML_TIME_HPP_INCLUDED

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>

#include <SFML/System/Time.hpp>

namespace camlpp
{
  template<>
  struct conversion_management< sf::Time >
  {
    sf::Time from_value( value & v)
    {
      return sf::microseconds( Int64_val(v));
    }
  };
  
  template<>
  struct affectation_management< sf::Time >
  {
    static void affect( value & v, sf::Time t )
    {
      v = caml_copy_int64(t.asMicroseconds());
    }
  };
}

#endif
