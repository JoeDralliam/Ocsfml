#ifndef OCSFML_WINDOW_STUB_HPP_INCLUDED
#define OCSFML_WINDOW_STUB_HPP_INCLUDED

#include <caml/custom_class.hpp>

#include <SFML/Window/Event.hpp>
#include <SFML/Window/VideoMode.hpp>


custom_enum_conversion( sf::Keyboard::Key );
custom_enum_affectation( sf::Keyboard::Key );

custom_enum_conversion( sf::Mouse::Button );
custom_enum_affectation( sf::Mouse::Button );

custom_enum_conversion( sf::Joystick::Axis );
custom_enum_affectation( sf::Joystick::Axis );





custom_struct_affectation( 	sf::Event::SizeEvent, 
				&sf::Event::SizeEvent::Width, 
				&sf::Event::SizeEvent::Height )

custom_struct_affectation( 	sf::Event::KeyEvent, 
				&sf::Event::KeyEvent::Code, 
				&sf::Event::KeyEvent::Alt,
				&sf::Event::KeyEvent::Control,
				&sf::Event::KeyEvent::Shift,
				&sf::Event::KeyEvent::System )

custom_struct_affectation( 	sf::Event::TextEvent, 
				&sf::Event::TextEvent::Unicode )


custom_struct_affectation( 	sf::Event::MouseMoveEvent, 
				&sf::Event::MouseMoveEvent::X, 
				&sf::Event::MouseMoveEvent::Y )

custom_struct_affectation( 	sf::Event::MouseButtonEvent, 
				&sf::Event::MouseButtonEvent::Button, 
				&sf::Event::MouseButtonEvent::X,
				&sf::Event::MouseButtonEvent::Y )

custom_struct_affectation( 	sf::Event::MouseWheelEvent, 
				&sf::Event::MouseWheelEvent::Delta,
				&sf::Event::MouseWheelEvent::X,
				&sf::Event::MouseWheelEvent::Y )

custom_struct_affectation( 	sf::Event::JoystickConnectEvent, 
				&sf::Event::JoystickConnectEvent::JoystickId )

custom_struct_affectation( 	sf::Event::JoystickMoveEvent, 
				&sf::Event::JoystickMoveEvent::JoystickId, 
				&sf::Event::JoystickMoveEvent::Axis,
				&sf::Event::JoystickMoveEvent::Position )

custom_struct_affectation( 	sf::Event::JoystickButtonEvent, 
				&sf::Event::JoystickButtonEvent::JoystickId, 
				&sf::Event::JoystickButtonEvent::Button )



template<>
struct AffectationManagement< sf::Event >
{
	static void affect( value& v, sf::Event const& e)
	{
		switch( e.Type )
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
				caml_cpp__affect_field( v, 0, e.Size );
				break;
			case sf::Event::TextEntered:
				v = caml_alloc( 1, 1 );
				caml_cpp__affect_field( v, 0, e.Text );
				break;
			case sf::Event::KeyPressed:
				v = caml_alloc( 1, 2 );
				caml_cpp__affect_field( v, 0, e.Key );
				break;
			case sf::Event::KeyReleased:
				v = caml_alloc( 1, 3 );
				caml_cpp__affect_field( v, 0, e.Key );
				break;
			case sf::Event::MouseWheelMoved:
				v = caml_alloc( 1, 4 );
				caml_cpp__affect_field( v, 0, e.MouseWheel );
				break;
        		case sf::Event::MouseButtonPressed:
				v = caml_alloc( 1, 5 );
				caml_cpp__affect_field( v, 0, e.MouseButton );
				break;
        		case sf::Event::MouseButtonReleased:
				v = caml_alloc( 1, 6 );
				caml_cpp__affect_field( v, 0, e.MouseButton );
				break;
        		case sf::Event::MouseMoved: 
				v = caml_alloc( 1, 7 );
				caml_cpp__affect_field( v, 0, e.MouseMove );
				break;
        		case sf::Event::JoystickButtonPressed:
				v = caml_alloc( 1, 8 );
				caml_cpp__affect_field( v, 0, e.JoystickButton );
				break;
        		case sf::Event::JoystickButtonReleased:
				v = caml_alloc( 1, 9 );
				caml_cpp__affect_field( v, 0, e.JoystickButton );
				break;
        		case sf::Event::JoystickMoved:
				v = caml_alloc( 1, 10 );
				caml_cpp__affect_field( v, 0, e.JoystickMove );
				break;
        		case sf::Event::JoystickConnected:
				v = caml_alloc( 1, 11 );
				caml_cpp__affect_field( v, 0, e.JoysticConnect );
				break;
        		case sf::Event::JoystickDisconnected:
				v = caml_alloc( 1, 12 );
				caml_cpp__affect_field( v, 0, e.JoystickConnect );
				break;
		}
	}

	static void affect_field( value& v, int field, sf::Event const& e)
	{
		CAMLparam0;
		CAMLlocal1( eventVal ):
		affect( eventVal, e);
		Store_field(v, field, eventVal);
		CAMLreturn0;
	}
private:
	int constant_index( sf::Event const& e )
	{
		switch( e.Type )
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
				&sf::VideoMode::Width,
				&sf::VideoMode::Height,
				&sf::VideoMode::BitsPerPixel )

custom_struct_affectation(	 sf::VideoMode,
				&sf::VideoMode::Width,
				&sf::VideoMode::Height,
				&sf::VideoMode::BitsPerPixel )


#endif
