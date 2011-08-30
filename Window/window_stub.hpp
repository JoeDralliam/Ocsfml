#ifndef OCSFML_WINDOW_STUB_HPP_INCLUDED
#define OCSFML_WINDOW_STUB_HPP_INCLUDED

#include <caml/custom_class.hpp>


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
				&sf::Event::JoystickMoveEvent::Axis )

custom_struct_affectation( 	sf::Event::JoystickButtonEvent, 
				&sf::Event::JoystickButtonEvent::JoystickId, 
				&sf::Event::JoystickButtonEvent::Button )

template<>
struct AffectationManagement< sf::Event >
{
	void affect( value& v, sf::Event const& e)
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
				Affectation( v, e.Size );
				break;
			case sf::Event::TextEntered:
				caml_cpp_affect( v, e.Text );
				break;
			case sf::Event::
		}
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



#endif
