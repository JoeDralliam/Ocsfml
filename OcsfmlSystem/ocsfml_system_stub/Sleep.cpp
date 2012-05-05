#include "Time.hpp"

#include <camlpp/stub_generator.hpp>

#include <SFML/System/Sleep.hpp>

extern "C"
{
  camlpp__register_overloaded_free_function1( sf_sleep, &sf::sleep)
}

