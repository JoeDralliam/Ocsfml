#include "Window.hpp"

#include "ContextSettings.hpp"
#include "Event.hpp"
#include "Vector.hpp"
#include "VideoMode.hpp"



#include <camlpp/big_array.hpp>
#include <camlpp/cstring.hpp>
#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/std/list.hpp>
#include <camlpp/std/string.hpp>


typedef sf::Window sf_Window;
namespace
{
  sf::Window* window_constructor_helper(camlpp::optional<std::list<unsigned long> > style , camlpp::optional<sf::ContextSettings> cs, sf::VideoMode vm, std::string const& title)
  {
    unsigned long actualStyle =
      style.is_some() ? style_of_list_unsigned( style.get_value() ) : sf::Style::Default;
    sf::ContextSettings actualSettings = cs.get_value_no_fail( sf::ContextSettings() );
    return new sf::Window( vm, title, actualStyle, actualSettings );
  }
  
  void window_create_helper(sf::Window* window, camlpp::optional<std::list<unsigned long> > style , camlpp::optional<sf::ContextSettings> cs,  sf::VideoMode vm, std::string const& title)
  {
    unsigned long actualStyle = 
      style.is_some() ? style_of_list_unsigned( style.get_value() ) : sf::Style::Default;
    sf::ContextSettings actualSettings = cs.get_value_no_fail( sf::ContextSettings() );
    window->create( vm, title, actualStyle, actualSettings );
  }
  
  camlpp::optional<sf::Event> window_poll_event_helper( sf::Window* window )
  {
    sf::Event e;
    return (window->pollEvent( e ) ? camlpp::some<sf::Event>( e ) : camlpp::none<sf::Event>() );
  }
  
  camlpp::optional<sf::Event> window_wait_event_helper( sf::Window* window )
  {
    sf::Event e;
    return (window->waitEvent( e ) ? camlpp::some<sf::Event>( e ) : camlpp::none<sf::Event>() );
  }
  
  bool window_set_active_helper( sf::Window* window, camlpp::optional<bool> active )
  {
    return window->setActive( active.get_value_no_fail(true) );
  }
  
  
  void window_set_icon_helper( sf::Window* window, camlpp::big_array< sf::Uint8, 3 > const& pixels )
  {
    assert( pixels.size[2] == 4 );
    window->setIcon( pixels.size[0], pixels.size[1], pixels.data );
  }

  void window_set_title_helper( sf::Window* window, camlpp::c_string title)
  {
    window->setTitle(std::string(title.string, title.size));
  }
}


#define CAMLPP__CLASS_NAME() sf_Window
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_external_constructor4( constructor_create, &window_constructor_helper, 0);
  camlpp__register_external_method4( create, &window_create_helper, 0);
  camlpp__register_method0( close, 0);
  camlpp__register_method0( isOpen, 0);
  camlpp__register_method0( getPosition, 0);
  camlpp__register_method0( getSize, 0);
  camlpp__register_method0( getSettings, 0);
  camlpp__register_external_method0( pollEvent, &window_poll_event_helper, camlpp::release_caml_runtime );
  camlpp__register_external_method0( waitEvent, &window_wait_event_helper, camlpp::release_caml_runtime );
  camlpp__register_method1( setVerticalSyncEnabled, 0);
  camlpp__register_method1( setMouseCursorVisible, 0);
  camlpp__register_method1( setPosition, 0);
  camlpp__register_method1( setSize, 0);
  camlpp__register_external_method1( setTitle, &window_set_title_helper, 0);
  camlpp__register_method1( setVisible, 0);
  camlpp__register_method1( setKeyRepeatEnabled, 0);
  camlpp__register_external_method1( setIcon, &window_set_icon_helper, 0);
  camlpp__register_external_method1( setActive, &window_set_active_helper, 0);
  camlpp__register_method0( display, 0);
  camlpp__register_method1( setFramerateLimit, 0);
  camlpp__register_method1( setJoystickThreshold, 0);
}
#undef CAMLPP__CLASS_NAME
