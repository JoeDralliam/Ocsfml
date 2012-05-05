#include "Color.hpp"

#include <camlpp/stub_generator.hpp>

bool color_is_equal( sf::Color const& a, sf::Color const& b)
{
  return a == b;
}

bool color_is_not_equal( sf::Color const& a, sf::Color const& b)
{
  return a != b;
}

sf::Color color_add( sf::Color const& a, sf::Color const& b)
{
  return a + b;
}

sf::Color color_multiply( sf::Color const& a, sf::Color const& b)
{
  return a * b;
}

extern "C"
{
  camlpp__register_free_function2( color_is_equal )
  camlpp__register_free_function2( color_is_not_equal )
  camlpp__register_free_function2( color_add )
  camlpp__register_free_function2( color_multiply )
}


