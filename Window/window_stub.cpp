#include "window_stub.hpp"


extern "C"
{
	camlpp__register_overloaded_free_function1( Keyboard_IsKeyPressed, &sf::Keyboard::IsKeyPressed)
	


	camlpp__register_overloaded_free_function1( Mouse_IsButtonPressed, &sf::Mouse::IsButtonPressed)
	camlpp__register_overloaded_free_function0( Mouse_GetPosition, ((sf::Vector (*)()) &sf::Mouse::GetPosition) )
	camlpp__register_overloaded_free_function0( Mouse_GetRelativePosition, ((sf::Vector (*)(const sf::Window&)) &sf::Mouse::GetPosition) )
	camlpp__register_overloaded_free_function1( Mouse_SetPosition, ((void (*)(sf::Vector2i const&)) &sf::Mouse::SetPosition) )
	camlpp__register_overloaded_free_function2( Mouse_SetRelativePosition, ((void (*)(sf::Vector2i const&, sf::Window const&)) &sf::Mouse::SetPosition) )


	camlpp__register_overloaded_free_function1( Joystick_IsConnected, &sf::Joystick::IsConnected)
	camlpp__register_overloaded_free_function1( Joystick_GetButtonCount, &sf::Joystick::GetButtonCount)
	camlpp__register_overloaded_free_function2( Joystick_HasAxis, &sf::Joystick::HasAxis )
	camlpp__register_overloaded_free_function2( Joystick_IsButtonPressed, &sf::Joystick::IsButtonPressed)
	camlpp__register_overloaded_free_function2( Joystick_GetAxisPosition, &sf::Joystick::GetAxisPosition)
	camlpp__register_overloaded_free_function0( Joystick_Update, &sf::Joystick::Update )

}

bool VideoMode_IsValid( const VideoMode& v )
{
	return v.IsValid();
} 


extern "C"
{
	camlpp__register_free_function1( VideoMode_IsValid )
	camlpp__register_overloaded_free_function0( VideoMode_GetFullscreenModes, &sf::VideoMode::GetFullscreenModes)
	camlpp__register_overloaded_free_function0( VideoMode_GetDesktopMode, &sf::VideoMode::GetDesktopMode)
}





