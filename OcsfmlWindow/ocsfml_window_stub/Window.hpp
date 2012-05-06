#ifndef OCSFML_WINDOW_HPP_INCLUDED
#define OCSFML_WINDOW_HPP_INCLUDED

#include <list>

#include <camlpp/custom_class.hpp>

#include <SFML/Window/Window.hpp>

inline unsigned long style_of_list_unsigned( std::list<unsigned long> const& lst )
{
  unsigned long res = 0;
  for( auto it = lst.begin(); it != lst.end(); ++it)
    {
      res |= 1 << *it;
    }
  return res;
}


typedef sf::Window sf_Window;
camlpp__preregister_custom_operations( sf_Window )
camlpp__preregister_custom_class( sf_Window );

#endif
