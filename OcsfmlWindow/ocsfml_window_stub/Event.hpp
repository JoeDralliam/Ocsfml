#ifndef OCSFML_EVENT_HPP_INCLUDED
#define OCSFML_EVENT_HPP_INCLUDED

#include "Keyboard.hpp"
#include "Joystick.hpp"
#include "Mouse.hpp"

#include <stdexcept>

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>
#include <camlpp/custom_conversion.hpp>
#include <camlpp/std/pair.hpp>

#include <SFML/Window/Event.hpp>

custom_struct_affectation( 	sf::Event::SizeEvent, 
				&sf::Event::SizeEvent::width, 
				&sf::Event::SizeEvent::height );

custom_struct_affectation( 	sf::Event::KeyEvent, 
				&sf::Event::KeyEvent::code, 
				&sf::Event::KeyEvent::alt,
				&sf::Event::KeyEvent::control,
				&sf::Event::KeyEvent::shift,
				&sf::Event::KeyEvent::system );

custom_struct_affectation( 	sf::Event::TextEvent, 
				&sf::Event::TextEvent::unicode );


custom_struct_affectation( 	sf::Event::MouseMoveEvent, 
				&sf::Event::MouseMoveEvent::x, 
				&sf::Event::MouseMoveEvent::y );


namespace camlpp
{
  template<>
  struct affectation_management< sf::Event::MouseButtonEvent >
  {
    static void affect( value & v, sf::Event::MouseButtonEvent e )
    {
      typedef  std::pair< sf::Mouse::Button, sf::Event::MouseMoveEvent > Ret;
      Ret r;
      r.first = e.button;
      r.second.x = e.x;
      r.second.y = e.y;
      affectation_management< Ret >::affect(v, r);
    }
  };


  template<>
  struct affectation_management< sf::Event::MouseWheelEvent >
  {
    static void affect( value & v, sf::Event::MouseWheelEvent e )
    {
      typedef  std::pair< int, sf::Event::MouseMoveEvent > Ret;
      Ret r;
      r.first = e.delta;
      r.second.x = e.x;
      r.second.y = e.y;
      affectation_management< Ret >::affect(v, r);
    }
  
  };

  template<>
  struct affectation_management< sf::Event::JoystickConnectEvent >
  {
    static void affect( value & v, sf::Event::JoystickConnectEvent e )
    {
      v = Val_int( e.joystickId );
    }
  };
}


custom_struct_affectation( 	sf::Event::JoystickMoveEvent, 
				&sf::Event::JoystickMoveEvent::joystickId, 
				&sf::Event::JoystickMoveEvent::axis,
				&sf::Event::JoystickMoveEvent::position );

custom_struct_affectation( 	sf::Event::JoystickButtonEvent, 
				&sf::Event::JoystickButtonEvent::joystickId, 
				&sf::Event::JoystickButtonEvent::button );

namespace camlpp
{

  template<>
  struct affectation_management< sf::Event >
  {
    static void affect( value& v, sf::Event const& e)
    {
      switch( e.type )
	{
	case sf::Event::Closed:
	case sf::Event::LostFocus:
	case sf::Event::GainedFocus:
	case sf::Event::MouseEntered:
	case sf::Event::MouseLeft:
	  v = Val_int( constant_index( e ));
	  break;
	case sf::Event::Resized:
	  v = caml_alloc( 1, 0 );
	  affect_field( v, 0, e.size );
	  break;
	case sf::Event::TextEntered:
	  v = caml_alloc( 1, 1 );
	  affect_field( v, 0, e.text );
	  break;
	case sf::Event::KeyPressed:
	  v = caml_alloc( 1, 2 );
	  affect_field( v, 0, e.key );
	  break;
	case sf::Event::KeyReleased:
	  v = caml_alloc( 1, 3 );
	  affect_field( v, 0, e.key );
	  break;
	case sf::Event::MouseWheelMoved:
	  v = caml_alloc( 1, 4 );
	  affect_field( v, 0, e.mouseWheel );
	  break;
	case sf::Event::MouseButtonPressed:
	  v = caml_alloc( 1, 5 );
	  affect_field( v, 0, e.mouseButton );
	  break;
	case sf::Event::MouseButtonReleased:
	  v = caml_alloc( 1, 6 );
	  affect_field( v, 0, e.mouseButton );
	  break;
	case sf::Event::MouseMoved: 
	  v = caml_alloc( 1, 7 );
	  affect_field( v, 0, e.mouseMove );
	  break;
	case sf::Event::JoystickButtonPressed:
	  v = caml_alloc( 1, 8 );
	  affect_field( v, 0, e.joystickButton );
	  break;
	case sf::Event::JoystickButtonReleased:
	  v = caml_alloc( 1, 9 );
	  affect_field( v, 0, e.joystickButton );
	  break;
	case sf::Event::JoystickMoved:
	  v = caml_alloc( 1, 10 );
	  affect_field( v, 0, e.joystickMove );
	  break;
	case sf::Event::JoystickConnected:
	  v = caml_alloc( 1, 11 );
	  affect_field( v, 0, e.joystickConnect );
	  break;
	case sf::Event::JoystickDisconnected:
	  v = caml_alloc( 1, 12 );
	  affect_field( v, 0, e.joystickConnect );
	  break;
	default:
	  throw std::runtime_error("Unknwown error while converting sf::Event to value");
	}
    }
  private:
    static int constant_index( sf::Event const& e )
    {
      switch( e.type )
	{
	case sf::Event::Closed:
	  return 0;
	case sf::Event::LostFocus:
	  return 1;
	case sf::Event::GainedFocus:
	  return 2;
	case sf::Event::MouseEntered:
	  return 3;
	case sf::Event::MouseLeft:
	  return 4;
	default:
	  break;
	}
      throw std::runtime_error("Unknwown error while converting sf::Event to value");
    }
  };
}


#endif
