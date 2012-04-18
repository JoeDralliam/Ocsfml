#include "ocsfml_window_stub.hpp"
#include <camlpp/type_option.hpp>
#include <camlpp/custom_ops.hpp>


bool VideoMode_isValid( const sf::VideoMode& v )
{
  return v.isValid();
} 


extern "C"
{
  camlpp__register_free_function1( VideoMode_isValid )
  camlpp__register_overloaded_free_function0( VideoMode_getFullscreenModes, &sf::VideoMode::getFullscreenModes)
  camlpp__register_overloaded_free_function0( VideoMode_getDesktopMode, &sf::VideoMode::getDesktopMode)
}

typedef sf::Window sf_Window;

unsigned long style_of_list_unsigned( std::list<unsigned long> const& lst )
{
  unsigned long res = 0;
  for( auto it = lst.begin(); it != lst.end(); ++it)
    {
      res |= 1 << *it;
    }
  return res;
}

sf::Window* window_constructor_helper(Optional<std::list<unsigned long> > style , Optional<sf::ContextSettings> cs, sf::VideoMode vm, std::string const& title)
{
  unsigned long actualStyle =
    style.is_some() ? style_of_list_unsigned( style.get_value() ) : sf::Style::Default;
  sf::ContextSettings actualSettings = cs.get_value_no_fail( sf::ContextSettings() );
  return new sf::Window( vm, title, actualStyle, actualSettings );
}

void window_create_helper(sf::Window* window, Optional<std::list<unsigned long> > style , Optional<sf::ContextSettings> cs,  sf::VideoMode vm, std::string const& title)
{
  unsigned long actualStyle = 
    style.is_some() ? style_of_list_unsigned( style.get_value() ) : sf::Style::Default;
  sf::ContextSettings actualSettings = cs.get_value_no_fail( sf::ContextSettings() );
  window->create( vm, title, actualStyle, actualSettings );
}

Optional<sf::Event> window_poll_event_helper( sf::Window* window )
{
  sf::Event e;
  return (window->pollEvent( e ) ? some<sf::Event>( e ) : none<sf::Event>() );
}

Optional<sf::Event> window_wait_event_helper( sf::Window* window )
{
  sf::Event e;
  return (window->waitEvent( e ) ? some<sf::Event>( e ) : none<sf::Event>() );
}

bool window_set_active_helper( sf::Window* window, Optional<bool> active )
{
  return window->setActive( active.get_value_no_fail(true) );
}



#define CAMLPP__CLASS_NAME() sf_Window
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_external_constructor4( constructor_create, &window_constructor_helper);
  camlpp__register_external_method4( create, &window_create_helper );
  camlpp__register_method0( close );
  camlpp__register_method0( isOpen );
  camlpp__register_method0( getPosition );
  camlpp__register_method0( getSize );
  camlpp__register_method0( getSettings );
  camlpp__register_external_method0( pollEvent, &window_poll_event_helper );
  camlpp__register_external_method0( waitEvent, &window_wait_event_helper );
  camlpp__register_method1( setVerticalSyncEnabled );
  camlpp__register_method1( setMouseCursorVisible );
  camlpp__register_method1( setPosition );
  camlpp__register_method1( setSize );
  camlpp__register_method1( setTitle );
  camlpp__register_method1( setVisible );
  camlpp__register_method1( setKeyRepeatEnabled );
//	camlpp__register_method3( SetIcon, &sf::Window::SetIcon );
  camlpp__register_external_method1( setActive, &window_set_active_helper );
  camlpp__register_method0( display );
  camlpp__register_method1( setFramerateLimit );

  camlpp__register_method1( setJoystickThreshold );
}
#undef CAMLPP__CLASS_NAME	

typedef sf::Context sf_Context;
#define CAMLPP__CLASS_NAME() sf_Context
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method1( setActive);
}
#undef CAMLPP__CLASS_NAME	


typedef sf::Vector2i (*get_pos_type)();
typedef sf::Vector2i (*get_relative_pos_type)(const sf::Window&);
typedef void (*set_pos_type)(sf::Vector2i const&);
typedef void (*set_relative_pos_type)(sf::Vector2i const&, const sf::Window&);
extern "C"
{
  camlpp__register_overloaded_free_function1( Keyboard_isKeyPressed, &sf::Keyboard::isKeyPressed)
    
  camlpp__register_overloaded_free_function1( Mouse_isButtonPressed, &sf::Mouse::isButtonPressed)
  camlpp__register_overloaded_free_function0( Mouse_getPosition, ((get_pos_type) &sf::Mouse::getPosition) )
  camlpp__register_overloaded_free_function1( Mouse_getRelativePosition, ((get_relative_pos_type) &sf::Mouse::getPosition) )
  camlpp__register_overloaded_free_function1( Mouse_setPosition, ((set_pos_type) &sf::Mouse::setPosition) )
  camlpp__register_overloaded_free_function2( Mouse_setRelativePosition, ((set_relative_pos_type) &sf::Mouse::setPosition) )
  
  
  camlpp__register_overloaded_free_function1( Joystick_isConnected, &sf::Joystick::isConnected)
  camlpp__register_overloaded_free_function1( Joystick_getButtonCount, &sf::Joystick::getButtonCount)
  camlpp__register_overloaded_free_function2( Joystick_hasAxis, &sf::Joystick::hasAxis )
  camlpp__register_overloaded_free_function2( Joystick_isButtonPressed, &sf::Joystick::isButtonPressed)
  camlpp__register_overloaded_free_function2( Joystick_getAxisPosition, &sf::Joystick::getAxisPosition)
  camlpp__register_overloaded_free_function0( Joystick_update, &sf::Joystick::update )
}
