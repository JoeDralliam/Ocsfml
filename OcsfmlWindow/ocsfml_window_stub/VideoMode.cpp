#include "VideoMode.hpp"

#include <camlpp/stub_generator.hpp>
#include <camlpp/std/vector.hpp>

bool VideoMode_isValid( const sf::VideoMode& v )
{
  return v.isValid();
} 


extern "C"
{
  camlpp__register_free_function1( VideoMode_isValid, 0)
  camlpp__register_overloaded_free_function0( VideoMode_getFullscreenModes, &sf::VideoMode::getFullscreenModes, 0)
  camlpp__register_overloaded_free_function0( VideoMode_getDesktopMode,     &sf::VideoMode::getDesktopMode,     0)
}
