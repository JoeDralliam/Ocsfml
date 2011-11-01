open OcsfmlSystem

module Listener =
struct

  external cpp set_global_volume : float -> unit = "Listener_SetGlobalVolume"
  external cpp get_global_volume : unit -> float  = "Listener_GetGlobalVolume"
  external cpp set_position : float -> float -> float -> unit = "Listener_SetPosition"
  external cpp set_position_v : float * float * float -> unit = "Listener_SetPositionV"
  external cpp get_position : unit -> float * float * float = "Listener_GetPosition"
  external cpp set_direction : float -> float -> float -> unit  = "Listener_SetDirection"
  external cpp set_direction_v : float * float * float -> unit = "Listener_SetDirectionV"
  external cpp get_direction : unit -> float * float * float = "Listener_GetDirection"

end


type status = Stopped | Paused | Playing


external class virtual sound_source : "sf_SoundSource" =
object auto (_:'a)
  (* constructor copy : 'a -> 'a = "copy_constructor" *)
  external method set_pitch : float -> unit = "SetPitch"
  external method set_volume : float -> unit = "SetVolume"
  external method set_position : float -> float -> float -> unit = "SetPosition"
  external method set_position_v : float * float * float -> unit = "SetPositionV"
  external method set_relative_to_listener : bool -> unit = "SetRelativeToListener" 
  external method set_min_distance : float -> unit = "SetMinDistance"
  external method set_attenuation : float -> unit = "SetAttenuation"
  external method get_pitch : unit -> float = "GetPitch"
  external method get_volume : unit -> float  = "GetVolume"
  external method get_position : unit -> float * float * float = "GetPosition"
  external method is_relative_to_listener : unit -> bool = "IsRelativeToListener"	     
  external method get_min_distance : unit -> float = "GetMinDistance"
  external method get_attenuation : unit -> float = "GetAttenuation"
end

let mk_sound_source ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation (t: #sound_source) =
  do_if t#set_pitch pitch ;
  do_if t#set_volume volume ;
  do_if t#set_position_v position;
  do_if t#set_relative_to_listener relative_to_listener;
  do_if t#set_min_distance min_distance;
  do_if t#set_attenuation attenuation


external class virtual sound_stream : "sf_SoundStream" =
object 
  external inherit sound_source : "sf_SoundSource"
  external method play : unit -> unit  = "Play"
  external method pause : unit -> unit = "Pause"
  external method stop : unit -> unit = "Stop"
  external method get_channels_count : unit -> int = "GetChannelsCount"
  external method get_sample_rate : unit -> int = "GetSampleRate"
  external method get_status : unit -> status = "GetStatus"	     
  external method set_playing_offset : int -> unit = "SetPlayingOffset"
  external method get_playing_offset : unit -> int = "GetPlayingOffset"
  external method set_loop : bool -> unit = "SetLoop"
  external method get_loop : unit -> bool = "GetLoop"
end

let mk_sound_stream ?playing_offset ?loop (t: #sound_stream) =
  do_if t#set_playing_offset playing_offset ;
  do_if t#set_loop loop

external class musicCpp (Music) : "sf_Music" =
object
  external inherit sound_stream : "sf_SoundStream"
  constructor default : unit = "default_constructor"
  external method open_from_file : string -> bool = "OpenFromFile"
  external method get_duration : unit -> int = "GetDuration"
end

class music_bis () = 
  let t = Music.default () in 
    musicCpp t

class music =
  music_bis ()

let mk_music ?playing_offset ?loop ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation () =
  let t = new music in
    mk_sound_stream t ;
    mk_sound_source t ;
    t

type samples_type = (int, Bigarray.int16_signed_elt, Bigarray.c_layout) Bigarray.Array1.t

external class  sound_bufferCpp (SoundBuffer) : "sf_SoundBuffer" =
object auto (_ : 'a)
  constructor default : unit = "default_constructor"
  (* constructor copy : 'a -> 'a = "copy_constructor" *)
  external method load_from_file : string -> bool = "LoadFromFile"
  external method load_from_stream : input_stream -> bool = "LoadFromStream" 
  external method load_from_samples :  samples_type -> int -> int -> bool = "LoadFromSamples"
  external method save_to_file : string -> bool = "SaveToFile"
  external method get_samples : unit -> samples_type = "GetSamples" 
  external method get_samples_count : unit -> int = "GetSamplesCount"
  external method get_sample_rate : unit -> int = "GetSampleRate"
  external method get_channels_count : unit -> int = "GetChannelsCount"
  external method get_duration : unit -> int = "GetDuration"
end

class sound_buffer_bis () = 
  let t = SoundBuffer.default () in 
    sound_bufferCpp t

class sound_buffer =
  sound_buffer_bis ()

external class virtual sound_recorder : "sf_SoundRecorder" =
object
  external method start : ?sampleRate:int -> unit -> unit = "Start"
  external method stop : unit -> unit = "Stop"
  external method get_sample_rate : unit -> int = "GetSampleRate"
end

module SoundRecorder =
struct
  external cpp is_available : unit -> bool = "SoundRecorder_IsAvailable"
end

external class sound_buffer_recorderCpp (SoundBufferRecorder) : "sf_SoundBufferRecorder" =
object 
  external inherit sound_recorder : "sf_SoundRecorder"
  constructor default : unit = "default_constructor"
  external method get_buffer : unit -> sound_buffer = "GetBuffer"
end

class sound_buffer_recorder_bis () = 
  let t = SoundBufferRecorder.default () in
    sound_buffer_recorderCpp t

class sound_buffer_recorder =
  sound_buffer_recorder_bis ()

external class soundCpp (Sound) : "sf_Sound" =
object
  external inherit sound_source : "sf_SoundSource"
  constructor default : unit = "default_constructor"
  constructor create_from_sound_buffer : sound_buffer = "buffer_constructor"
   (* constructor copy *)
  external method play : unit -> unit = "Play"
  external method pause : unit -> unit = "Pause" 
  external method stop : unit -> unit = "Stop"
  external method set_buffer : sound_buffer -> unit = "SetBuffer"
  external method set_loop : bool -> unit = "SetLoop"
  external method set_playing_offset : int -> unit = "SetPlayingOffset"	     
  external method get_buffer : unit -> sound_buffer = "GetBuffer"
  external method get_loop : unit -> bool = "GetLoop"
  external method get_playing_offset : unit -> int = "GetPlayingOffset"
  external method get_status : unit -> status = "GetStatus"
end

class sound_bis () = 
  let t = Sound.default () in
    soundCpp t

class sound =
  sound_bis ()

let mk_sound ?loop ?buffer ?playing_offset ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation () =
  let t = new sound in
    mk_sound_source ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation t;
    do_if t#set_loop loop;
    do_if t#set_buffer buffer ;
    do_if t#set_playing_offset playing_offset ;
    t
