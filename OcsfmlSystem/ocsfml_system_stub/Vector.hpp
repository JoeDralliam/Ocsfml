#ifndef OCSFML_VECTOR_HPP_INCLUDED
#define OCSFML_VECTOR_HPP_INCLUDED

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>
#include <camlpp/std/pair.hpp>
#include <camlpp/std/tuple.hpp>


#include <SFML/System/Vector2.hpp>
#include <SFML/System/Vector3.hpp>

namespace camlpp
{
  template<class T>
  struct conversion_management< sf::Vector2<T> >
  {
    conversion_management< T > cm;
    sf::Vector2<T> from_value( value const& v)
    {
      return sf::Vector2<T>( cm.from_value(Field(v, 0)), cm.from_value(Field(v, 1)) );
    }
  };

  template<class T>
  struct affectation_management< sf::Vector2<T> > 
  {
    static void affect( value& v, sf::Vector2<T> vec )
    {
      affectation_management< std::pair<T, T> >::affect( v, std::make_pair(vec.x, vec.y) );
    }
  };

  template<class T>
  struct conversion_management< sf::Vector3<T> >
  {
    conversion_management< T > cm;
    sf::Vector3<T> from_value( value const& v)
    {
      return sf::Vector3<T>( cm.from_value(Field(v, 0)), cm.from_value(Field(v, 1)), cm.from_value(Field(v,2)) );
    }
  };

  template<class T>
  struct affectation_management< sf::Vector3<T> >
  {
    static void affect( value& v, sf::Vector3<T> vec )
    {
      affectation_management< std::tuple<T, T, T> >::affect( v, std::make_tuple(vec.x, vec.y, vec.z) );
    }
  };
}

#endif
