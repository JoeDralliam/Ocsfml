#include "Vector.hpp"

#include <camlpp/stub_generator.hpp>

#include <SFML/Audio/Listener.hpp>

extern "C"
{
  camlpp__register_overloaded_free_function1(Listener_setGlobalVolume, 
					     &sf::Listener::setGlobalVolume )
  camlpp__register_overloaded_free_function0(Listener_getGlobalVolume, 
					     &sf::Listener::getGlobalVolume )
  camlpp__register_overloaded_free_function3(Listener_setPosition, 
					     ((void (*)(float, float, float)) &sf::Listener::setPosition) )
  camlpp__register_overloaded_free_function1(Listener_setPositionV,
					     ((void (*)(sf::Vector3f const&)) &sf::Listener::setPosition) )
  camlpp__register_overloaded_free_function0(Listener_getPosition,
					     &sf::Listener::getPosition )
  camlpp__register_overloaded_free_function3(Listener_setDirection, 
					     ((void (*)(float, float, float)) &sf::Listener::setDirection) )
  camlpp__register_overloaded_free_function1(Listener_setDirectionV,
					     ((void (*)(sf::Vector3f const&)) &sf::Listener::setDirection) )
  camlpp__register_overloaded_free_function0(Listener_getDirection,
					     &sf::Listener::getDirection )
}
