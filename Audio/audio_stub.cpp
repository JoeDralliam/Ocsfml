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

custom_enum_affectation( sf::SoundSource::Status );
custom_enum_conversion( sf::SoundSource::Status );

typedef sf::SoundSource sf_SoundSource;
#define CAMLPP__CLASS_NAME() sf_SoundSource
camlpp__register_custom_class()
	camlpp__register_constructor1( copy_constructor, sf::SoundSource const& )
	camlpp__register_method1( SetPitch, &sf::SoundSource::SetPitch )
	camlpp__register_method1( SetVolume, &sf::SoundSource::SetVolume )
	camlpp__register_method3( SetPosition,
				  ((void (sf::SoundSource::*)(float, float, float)) &sf::SoundSource::SetPosition) )
	camlpp__register_method1( SetPositionV,
				  ((void (sf::SoundSource::*)(sf::Vector3f const&)) &sf::SoundSource::SetPosition) )
	camlpp__register_method1( SetRelativeToListener, &sf::SoundSource::SetRelativeToListener )
	camlpp__register_method1( SetMinDistance, &sf::SoundSource::SetMinDistance )
	camlpp__register_method1( SetAttenuation, &sf::SoundSource::SetAttenuation )
	camlpp__register_method0( GetPitch, &sf::SoundSource::GetPitch )
	camlpp__register_method0( GetVolume, &sf::SoundSource::GetVolume )
	camlpp__register_method0( GetPosition, &sf::SoundSource::GetPosition )
	camlpp__register_method0( IsRelativeToListener, &sf::SoundSource::IsRelativeToListener )
	camlpp__register_method0( GetMinDistance, &sf::SoundSource::GetMinDistance )
	camlpp__register_method0( GetAttenuation, &sf::SoundSource::GetAttenuation )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

typedef sf::SoundStream sf_SoundStream;
#define CAMLPP__CLASS_NAME() sf_SoundStream
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_SoundSource )
	camlpp__register_method0( Play, &sf::SoundStream::Play )
	camlpp__register_method0( Pause, &sf::SoundStream::Pause )
	camlpp__register_method0( Stop, &sf::SoundStream::Stop )
	camlpp__register_method0( GetChannelsCount, &sf::SoundStream::GetChannelsCount )
	camlpp__register_method0( GetSampleRate, &sf::SoundStream::GetSampleRate )
	camlpp__register_method0( GetStatus, &sf::SoundStream::GetStatus )
	camlpp__register_method1( SetPlayingOffset, &sf::SoundStream::SetPlayingOffset )
	camlpp__register_method0( GetPlayingOffset, &sf::SoundStream::GetPlayingOffset )
	camlpp__register_method1( SetLoop, &sf::SoundStream::SetLoop )
	camlpp__register_method0( GetLopp, &sf::SoundStream::GetLoop )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


typedef sf::Music sf_Music;
#define CAMLPP__CLASS_NAME() sf_Music
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_SoundStream )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method1( OpenFromFile, &sf::Music::OpenFromFile )
//	camlpp__register_method1( OpenFromMemory
//	camlpp__register_method1( OpenFromStream, &sf::Music::OpenFromStream ) 
//	/* Should not be implemented : load music from a different stream and call Caml functions*/
	camlpp__register_method0( GetDuration, &sf::Music::GetDuration )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


bool sound_buffer_load_from_samples_helper( 	sf::SoundBuffer* buffer, 
						BigarrayInterface< sf::Int16, 1 > samples, 
						unsigned channelsCount, 
						unsigned int sampleRate )
{
	return buffer->LoadFromSamples( samples.data, samples.size[0], channelsCount, sampleRate );
}

BigarrayInterface< const sf::Int16, 1 > sound_buffer_get_samples_helper( sf::SoundBuffer* buffer )
{
	int size[1];
	size[0] = buffer->GetSamplesCount();
	return BigarrayInterface< const sf::Int16, 1>(buffer->GetSamples(), size);
}

typedef sf::SoundBuffer sf_SoundBuffer;
#define CAMLPP__CLASS_NAME() sf_SoundBuffer
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( copy_constructor, sf::SoundBuffer const& )
	camlpp__register_method1( LoadFromFile, &sf::SoundBuffer::LoadFromFile )
//	camlpp__register_method2( LoadFromMemory, &sf::SoundBuffer::LoadFromMemory )
	camlpp__register_method1( LoadFromStream, &sf::SoundBuffer::LoadFromStream )
	camlpp__register_method3( LoadFromSamples, &sound_buffer_load_from_samples_helper )
	camlpp__register_method1( SaveToFile, &sf::SoundBuffer::SaveToFile )
	camlpp__register_method0( GetSamples, &sound_buffer_get_samples_helper )
	camlpp__register_method0( GetSamplesCount, &sf::SoundBuffer::GetSamplesCount )
	camlpp__register_method0( GetSampleRate, &sf::SoundBuffer::GetSampleRate )
	camlpp__register_method0( GetChannelsCount, &sf::SoundBuffer::GetChannelsCount )
	camlpp__register_method0( GetDuration, &sf::SoundBuffer::GetDuration )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


void sound_recorder_start_helper( sf::SoundRecorder* rec, Optional< unsigned int >  sampleRate, UnitTypeHolder)
{
	rec->Start( sampleRate.isSome() ? sampleRate.get_value() : 44100 );
}

typedef sf::SoundRecorder sf_SoundRecorder;
#define CAMLPP__CLASS_NAME() sf_SoundRecorder
camlpp__register_custom_class()
	camlpp__register_method2( Start, &sound_recorder_start_helper)
	camlpp__register_method0( Stop, &sf::SoundRecorder::Stop )
	camlpp__register_method0( GetSampleRate, &sf::SoundRecorder::GetSampleRate ) 
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


extern "C"
{
	camlpp__register_overloaded_free_function0( SoundRecorder_IsAvailable, &sf::SoundRecorder::IsAvailable )
}


typedef sf::SoundBufferRecorder sf_SoundBufferRecorder;
#define CAMLPP__CLASS_NAME() sf_SoundBufferRecorder
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_SoundRecorder )
	camlpp__register_method0( GetBuffer, &sf::SoundBufferRecorder::GetBuffer );
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


Optional< sf::SoundBuffer const* > sound_get_buffer_helper( sf::Sound* snd )
{
	sf::SoundBuffer const* buf = snd->GetBuffer();
	if(buf)
	{
		return some( buf );
	}
	return none< sf::SoundBuffer const* >();
}

typedef sf::Sound sf_Sound;
#define CAMLPP__CLASS_NAME() sf_Sound
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_SoundSource )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( buffer_constructor, sf::SoundBuffer const&)
	camlpp__register_constructor1( copy_constructor, sf::Sound const& )
	camlpp__register_method0( Play, &sf::Sound::Play )
	camlpp__register_method0( Pause, &sf::Sound::Pause )
	camlpp__register_method0( Stop, &sf::Sound::Stop )
	camlpp__register_method1( SetBuffer, &sf::Sound::SetBuffer )
	camlpp__register_method1( SetLoop, &sf::Sound::SetLoop )
	camlpp__register_method1( SetPlayingOffset, &sf::Sound::SetPlayingOffset )
	camlpp__register_method0( GetBuffer, &sound_get_buffer_helper )
	camlpp__register_method0( GetLoop, &sf::Sound::GetLoop )
	camlpp__register_method0( GetPlayingOffset, &sf::Sound::GetPlayingOffset )
	camlpp__register_method0( GetStatus, &sf::Sound::GetStatus )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

