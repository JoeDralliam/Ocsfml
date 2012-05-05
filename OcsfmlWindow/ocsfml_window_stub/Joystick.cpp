#include "Joystick.hpp"

#include <camlpp/stub_generator.hpp>

extern "C"
{
  camlpp__register_overloaded_free_function1( Joystick_isConnected, &sf::Joystick::isConnected)
  camlpp__register_overloaded_free_function1( Joystick_getButtonCount, &sf::Joystick::getButtonCount)
  camlpp__register_overloaded_free_function2( Joystick_hasAxis, &sf::Joystick::hasAxis )
  camlpp__register_overloaded_free_function2( Joystick_isButtonPressed, &sf::Joystick::isButtonPressed)
  camlpp__register_overloaded_free_function2( Joystick_getAxisPosition, &sf::Joystick::getAxisPosition)
  camlpp__register_overloaded_free_function0( Joystick_update, &sf::Joystick::update )
}

