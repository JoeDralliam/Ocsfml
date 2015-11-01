#ifndef OCSFML_KEYBOARD_HPP_INCLUDED
#define OCSFML_KEYBOARD_HPP_INCLUDED

#include <camlpp/custom_conversion.hpp>

#include <SFML/Window/Keyboard.hpp>

namespace camlpp
{
  template<>
  struct affectation_management<sf::Keyboard::Key>
  {
    static void affect(value& v, sf::Keyboard::Key d)
    {
      v = Val_int(d + 1);
    }
  };

  template<>
  struct conversion_management<sf::Keyboard::Key>
  {
    sf::Keyboard::Key from_value( value const& v)
    {
      return static_cast<sf::Keyboard::Key>( Int_val( v ) - 1 );
    }
  };
}


#endif
