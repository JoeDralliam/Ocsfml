#include "Joystick.hpp"

#include <camlpp/stub_generator.hpp>

extern "C"
{
  camlpp__register_overloaded_free_function1( Joystick_isConnected,     &sf::Joystick::isConnected,     0)
  camlpp__register_overloaded_free_function1( Joystick_getButtonCount,  &sf::Joystick::getButtonCount,  0)
  camlpp__register_overloaded_free_function2( Joystick_hasAxis,         &sf::Joystick::hasAxis,         0)
  camlpp__register_overloaded_free_function2( Joystick_isButtonPressed, &sf::Joystick::isButtonPressed, 0)
  camlpp__register_overloaded_free_function2( Joystick_getAxisPosition, &sf::Joystick::getAxisPosition, 0)
  camlpp__register_overloaded_free_function0( Joystick_update,          &sf::Joystick::update,          0)
}

