#include "audio_stub.hpp"
#include <SFML/Audio.hpp>

extern "C"
{
	camlpp__register_overloaded_free_function1(	Listener_SetGlobalVolume, 
							&sf::Listener::SetGlobalVolume )
	camlpp__register_overloaded_free_function0(	Listener_GetGlobalVolume, 
							&sf::Listener::GetGlobalVolume )
	camlpp__register_overloaded_free_function3(  	Listener_SetPosition, 
	       						((void (*)(float, float, float)) &sf::Listener::SetPosition) )
	camlpp__register_overloaded_free_function1(	Listener_SetPositionV,
							((void (*)(sf::Vector3f const&)) &sf::Listener::SetPosition) )
	camlpp__register_overloaded_free_function0(	Listener_GetPosition,
							&sf::Listener::GetPosition )
	camlpp__register_overloaded_free_function3(  	Listener_SetDirection, 
	       						((void (*)(float, float, float)) &sf::Listener::SetDirection) )
	camlpp__register_overloaded_free_function1(	Listener_SetDirectionV,
							((void (*)(sf::Vector3f const&)) &sf::Listener::SetDirection) )
	camlpp__register_overloaded_free_function0(	Listener_GetDirection,
							&sf::Listener::GetDirection )
}





typedef sf::Music sf_Music;
#define CAMLPP__CLASS_NAME() sf_Music
camlpp__register_custom_class()

camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


