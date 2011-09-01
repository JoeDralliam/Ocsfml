#include "window_stub.hpp"
#include <camlpp/type_option.hpp>

extern "C"
{
	camlpp__register_overloaded_free_function1( Keyboard_IsKeyPressed, &sf::Keyboard::IsKeyPressed)
	


	camlpp__register_overloaded_free_function1( Mouse_IsButtonPressed, &sf::Mouse::IsButtonPressed)
	camlpp__register_overloaded_free_function0( Mouse_GetPosition, ((sf::Vector2i (*)()) &sf::Mouse::GetPosition) )
	camlpp__register_overloaded_free_function1( Mouse_GetRelativePosition, ((sf::Vector2i (*)(const sf::Window&)) &sf::Mouse::GetPosition) )
	camlpp__register_overloaded_free_function1( Mouse_SetPosition, ((void (*)(sf::Vector2i const&)) &sf::Mouse::SetPosition) )
	camlpp__register_overloaded_free_function2( Mouse_SetRelativePosition, ((void (*)(sf::Vector2i const&, sf::Window const&)) &sf::Mouse::SetPosition) )


	camlpp__register_overloaded_free_function1( Joystick_IsConnected, &sf::Joystick::IsConnected)
	camlpp__register_overloaded_free_function1( Joystick_GetButtonCount, &sf::Joystick::GetButtonCount)
	camlpp__register_overloaded_free_function2( Joystick_HasAxis, &sf::Joystick::HasAxis )
	camlpp__register_overloaded_free_function2( Joystick_IsButtonPressed, &sf::Joystick::IsButtonPressed)
	camlpp__register_overloaded_free_function2( Joystick_GetAxisPosition, &sf::Joystick::GetAxisPosition)
	camlpp__register_overloaded_free_function0( Joystick_Update, &sf::Joystick::Update )

}

bool VideoMode_IsValid( const sf::VideoMode& v )
{
	return v.IsValid();
} 


extern "C"
{
	camlpp__register_free_function1( VideoMode_IsValid )
	camlpp__register_overloaded_free_function0( VideoMode_GetFullscreenModes, &sf::VideoMode::GetFullscreenModes)
	camlpp__register_overloaded_free_function0( VideoMode_GetDesktopMode, &sf::VideoMode::GetDesktopMode)
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
	unsigned long actualStyle =  style.isSome() ? style_of_list_unsigned( style.get_value() )
						    : sf::Style::Default;
	sf::ContextSettings actualSettings = cs.isSome() ? cs.get_value() : sf::ContextSettings();
	return new sf::Window( vm, title, actualStyle, actualSettings );
}

void window_create_helper(sf::Window* window, Optional<std::list<unsigned long> > style , Optional<sf::ContextSettings> cs,  sf::VideoMode vm, std::string const& title)
{
	unsigned long actualStyle = style.isSome() ? style_of_list_unsigned( style.get_value() )
						   : sf::Style::Default;
	sf::ContextSettings actualSettings = cs.isSome() ? cs.get_value() : sf::ContextSettings();
	window->Create( vm, title, actualStyle, actualSettings );
}

Optional<sf::Event> window_poll_event_helper( sf::Window* window )
{
	sf::Event e;
	return (window->PollEvent( e ) ? some<sf::Event>( e ) : none<sf::Event>() );
}

Optional<sf::Event> window_wait_event_helper( sf::Window* window )
{
	sf::Event e;
	return (window->WaitEvent( e ) ? some<sf::Event>( e ) : none<sf::Event>() );
}

bool window_set_active_helper( sf::Window* window, Optional<bool> active )
{
	return window->SetActive( active.isSome() ?  active.get_value() : true );
}

#define CAMLPP__CLASS_NAME() sf_Window
camlpp__register_preregistered_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_external_constructor4( constructor_create, &window_constructor_helper)
	camlpp__register_method4( Create, &window_create_helper )
	camlpp__register_method0( Close, &sf::Window::Close )
	camlpp__register_method0( IsOpened, &sf::Window::IsOpened )
	camlpp__register_method0( GetWidth, &sf::Window::GetWidth )
	camlpp__register_method0( GetHeight, &sf::Window::GetHeight )
	camlpp__register_method0( GetSettings, &sf::Window::GetSettings )
	camlpp__register_method0( PollEvent, &window_poll_event_helper )
	camlpp__register_method0( WaitEvent, &window_wait_event_helper )
	camlpp__register_method1( EnableVerticalSync, &sf::Window::EnableVerticalSync )
	camlpp__register_method1( ShowMouseCursor, &sf::Window::ShowMouseCursor )
        camlpp__register_method2( SetPosition, &sf::Window::SetPosition )
	camlpp__register_method2( SetSize, &sf::Window::SetSize )
	camlpp__register_method1( SetTitle, &sf::Window::SetTitle )
	camlpp__register_method1( Show, &sf::Window::Show )
	camlpp__register_method1( EnableKeyRepeat, &sf::Window::EnableKeyRepeat )
//	camlpp__register_method3( SetIcon, &sf::Window::SetIcon )
	camlpp__register_method1( SetActive, &window_set_active_helper )
	camlpp__register_method0( Display, &sf::Window::Display )
	camlpp__register_method1( SetFramerateLimit, &sf::Window::SetFramerateLimit )
	camlpp__register_method0( GetFrameTime, &sf::Window::GetFrameTime )
	camlpp__register_method1( SetJoystickThreshold, &sf::Window::SetJoystickThreshold )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME	

typedef sf::Context sf_Context;
#define CAMLPP__CLASS_NAME() sf_Context
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method1( SetActive, &sf::Context::SetActive )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME	


