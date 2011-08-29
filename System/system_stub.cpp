/*
 * =====================================================================================
 *
 *       Filename:  system.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  29/08/2011 12:13:09
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


#include "system_stub.hpp"
#include <SFML/System/Clock.hpp>


typedef sf::Clock sf_Clock;

#define CAMLPP__CLASS_NAME() sf_Clock
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method0( GetElapsedTime, &sf::Clock::GetElapsedTime )
	camlpp__register_method0( Reset, &sf::Clock::Reset )
camlpp__custom_class_registered()


#include <SFML/System/Sleep.hpp>
extern "C"
{
	camlpp__register_overloaded_free_function1( sf_Sleep, &sf::Sleep )
}


#include <SFML/System/Thread.hpp>

typedef sf::Thread sf_Thread;
#define CAMLPP__CLASS_NAME() sf_Thread
camlpp__register_custom_class()
	camlpp__register_constructor1( create_from_function, std::function<void()> )
	camlpp__register_method0( Launch, &sf::Thread::Launch )
	camlpp__register_method0( Wait, &sf::Thread::Wait )
	camlpp__register_method0( Terminate, &sf::Thread::Terminate )
camlpp__custom_class_registered()


#include <SFML/System/Mutex.hpp>

typedef sf::Mutex sf_Mutex;
#define CAMLPP__CLASS_NAME() sf_Mutex
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method0( Lock, &sf::Mutex::Lock )
	camlpp__register_method0( Unlock, &sf::Mutex::Unlock )
camlpp__custom_class_registered()

/* lock ? */
/* thread local ? */
/* thread local ptr ? */
/*
#include <SFML/System/String.hpp>

typedef sf::String sf_String;
#define CAMLPP__CLASS_NAME() sf_String
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( create_from_ansi_char, char )
	camlpp__register_constructor1( create_from_utf32_char, sf::Uint32 )
	camlpp__register_constructor1( create_from_ansi_string, char* )
	camlpp__register_constructor1( create_from_sf_string, sf::String )
	camlpp__register_method0( to_ansi_string, ((std::string (sf::String::*)()) &sf::String::ToAnsiString) )
	camlpp__register_method1( affect_sf_string, (&sf::String::operator=));
	camlpp__register_method1( concat_sf_string, (&sf::String::operator+=));
	camlpp__register_method1( at_index, ((sf::Uint32 (sf::String::*)(std::size_t) const) &sf::String::operator[]) );
	camlpp__register_method

camlpp__custom_class_registered()
*/








