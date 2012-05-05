#include "Mouse.hpp"
#include "Window.hpp"
#include "Vector.hpp"

#include <camlpp/stub_generator.hpp>

typedef sf::Vector2i (*get_pos_type)();
typedef sf::Vector2i (*get_relative_pos_type)(const sf::Window&);
typedef void (*set_pos_type)(sf::Vector2i const&);
typedef void (*set_relative_pos_type)(sf::Vector2i const&, const sf::Window&);

extern "C"
{    
  camlpp__register_overloaded_free_function1( Mouse_isButtonPressed, &sf::Mouse::isButtonPressed)
  camlpp__register_overloaded_free_function0( Mouse_getPosition, ((get_pos_type) &sf::Mouse::getPosition) )
  camlpp__register_overloaded_free_function1( Mouse_getRelativePosition, ((get_relative_pos_type) &sf::Mouse::getPosition) )
  camlpp__register_overloaded_free_function1( Mouse_setPosition, ((set_pos_type) &sf::Mouse::setPosition) )
  camlpp__register_overloaded_free_function2( Mouse_setRelativePosition, ((set_relative_pos_type) &sf::Mouse::setPosition) )
}
