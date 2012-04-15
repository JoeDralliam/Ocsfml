#ifndef OCSFML_WINDOW_STUB_HPP_INCLUDED
#define OCSFML_WINDOW_STUB_HPP_INCLUDED

#include <camlpp/custom_class.hpp>
#include <camlpp/custom_conversion.hpp>
#include <stdexcept>
#include <SFML/Window.hpp>

#include "ocsfml_system_stub.hpp"

custom_enum_conversion( sf::Keyboard::Key );
custom_enum_affectation( sf::Keyboard::Key );

custom_enum_conversion( sf::Mouse::Button );
custom_enum_affectation( sf::Mouse::Button );

custom_enum_conversion( sf::Joystick::Axis );
custom_enum_affectation( sf::Joystick::Axis );





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

template<>
struct AffectationManagement< sf::Event::MouseButtonEvent >
{
  static void affect( value & v, sf::Event::MouseButtonEvent e )
  {
    typedef  std::pair< sf::Mouse::Button, sf::Event::MouseMoveEvent > Ret;
	Ret r;
	r.first = e.button;
	r.second.x = e.x;
	r.second.y = e.y;
	AffectationManagement< Ret >::affect(v, r);
  }

  static void affect_field( value & v, int field, sf::Event::MouseButtonEvent e )
  {
	typedef  std::pair< sf::Mouse::Button, sf::Event::MouseMoveEvent > Ret;
	Ret r;
	r.first = e.button;
	r.second.x = e.x;
	r.second.y = e.y;
	AffectationManagement< Ret >::affect_field(v, field, r);
  }
};


template<>
struct AffectationManagement< sf::Event::MouseWheelEvent >
{
  static void affect( value & v, sf::Event::MouseWheelEvent e )
  {
    typedef  std::pair< int, sf::Event::MouseMoveEvent > Ret;
	Ret r;
	r.first = e.delta;
	r.second.x = e.x;
	r.second.y = e.y;
	AffectationManagement< Ret >::affect(v, r);
  }

  static void affect_field( value & v, int field, sf::Event::MouseWheelEvent e )
  {
	typedef  std::pair< int, sf::Event::MouseMoveEvent > Ret;
	Ret r;
	r.first = e.delta;
	r.second.x = e.x;
	r.second.y = e.y;
	AffectationManagement< Ret >::affect_field(v, field, r);
  }
};

custom_struct_affectation( 	sf::Event::JoystickConnectEvent, 
				&sf::Event::JoystickConnectEvent::joystickId );

custom_struct_affectation( 	sf::Event::JoystickMoveEvent, 
				&sf::Event::JoystickMoveEvent::joystickId, 
				&sf::Event::JoystickMoveEvent::axis,
				&sf::Event::JoystickMoveEvent::position );

custom_struct_affectation( 	sf::Event::JoystickButtonEvent, 
				&sf::Event::JoystickButtonEvent::joystickId, 
				&sf::Event::JoystickButtonEvent::button );

template<>
struct ConversionManagement<sf::Event>
{};

template<>
struct AffectationManagement< sf::Event >
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
				caml_cpp__affect_field( v, 0, e.size );
				break;
			case sf::Event::TextEntered:
				v = caml_alloc( 1, 1 );
				caml_cpp__affect_field( v, 0, e.text );
				break;
			case sf::Event::KeyPressed:
				v = caml_alloc( 1, 2 );
				caml_cpp__affect_field( v, 0, e.key );
				break;
			case sf::Event::KeyReleased:
				v = caml_alloc( 1, 3 );
				caml_cpp__affect_field( v, 0, e.key );
				break;
			case sf::Event::MouseWheelMoved:
				v = caml_alloc( 1, 4 );
				caml_cpp__affect_field( v, 0, e.mouseWheel );
				break;
        		case sf::Event::MouseButtonPressed:
				v = caml_alloc( 1, 5 );
				caml_cpp__affect_field( v, 0, e.mouseButton );
				break;
        		case sf::Event::MouseButtonReleased:
				v = caml_alloc( 1, 6 );
				caml_cpp__affect_field( v, 0, e.mouseButton );
				break;
        		case sf::Event::MouseMoved: 
				v = caml_alloc( 1, 7 );
				caml_cpp__affect_field( v, 0, e.mouseMove );
				break;
        		case sf::Event::JoystickButtonPressed:
				v = caml_alloc( 1, 8 );
				caml_cpp__affect_field( v, 0, e.joystickButton );
				break;
        		case sf::Event::JoystickButtonReleased:
				v = caml_alloc( 1, 9 );
				caml_cpp__affect_field( v, 0, e.joystickButton );
				break;
        		case sf::Event::JoystickMoved:
				v = caml_alloc( 1, 10 );
				caml_cpp__affect_field( v, 0, e.joystickMove );
				break;
        		case sf::Event::JoystickConnected:
				v = caml_alloc( 1, 11 );
				caml_cpp__affect_field( v, 0, e.joystickConnect );
				break;
        		case sf::Event::JoystickDisconnected:
				v = caml_alloc( 1, 12 );
				caml_cpp__affect_field( v, 0, e.joystickConnect );
				break;
		}
	}

	static void affect_field( value& v, int field, sf::Event const& e)
	{
	        CAMLparam0();
		CAMLlocal1( eventVal );
		affect( eventVal, e);
		Store_field(v, field, eventVal);
		CAMLreturn0;
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

custom_struct_conversion(	 sf::VideoMode,
				 &sf::VideoMode::width,
				 &sf::VideoMode::height,
				 &sf::VideoMode::bitsPerPixel );

custom_struct_affectation(	 sf::VideoMode,
				 &sf::VideoMode::width,
				 &sf::VideoMode::height,
				 &sf::VideoMode::bitsPerPixel );

custom_struct_conversion(	 sf::ContextSettings,
				 &sf::ContextSettings::depthBits,
				 &sf::ContextSettings::stencilBits,
				 &sf::ContextSettings::antialiasingLevel,
				 &sf::ContextSettings::majorVersion,
				 &sf::ContextSettings::minorVersion );

custom_struct_affectation(	 sf::ContextSettings,
				 &sf::ContextSettings::depthBits,
				 &sf::ContextSettings::stencilBits,
				 &sf::ContextSettings::antialiasingLevel,
				 &sf::ContextSettings::majorVersion,
				 &sf::ContextSettings::minorVersion );

unsigned long style_of_list_unsigned( std::list<unsigned long> const& lst );

typedef sf::Window sf_Window;
camlpp__preregister_custom_operations( sf_Window )
camlpp__preregister_custom_class( sf_Window );
#endif
