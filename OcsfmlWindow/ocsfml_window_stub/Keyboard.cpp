#include "Keyboard.hpp"

#include <camlpp/stub_generator.hpp>

extern "C" 
{
  camlpp__register_overloaded_free_function1( Keyboard_isKeyPressed, &sf::Keyboard::isKeyPressed, 0)
}
