open OcsfmlSystem

let do_if f = function
    | Some x -> f x
    | None -> ()

module Listener =
struct

  external cpp set_global_volume : float -> unit = "Listener_setGlobalVolume"
  external cpp get_global_volume : unit -> float  = "Listener_getGlobalVolume"
  external cpp set_position : float -> float -> float -> unit = "Listener_setPosition"
  external cpp set_position_v : float * float * float -> unit = "Listener_setPositionV"
  external cpp get_position : unit -> float * float * float = "Listener_getPosition"
  external cpp set_direction : float -> float -> float -> unit  = "Listener_setDirection"
  external cpp set_direction_v : float * float * float -> unit = "Listener_setDirectionV"
  external cpp get_direction : unit -> float * float * float = "Listener_getDirection"

end


type status = Stopped | Paused | Playing


external class virtual sound_source : "sf_SoundSource" =
object auto (_:'a)
  (* constructor copy : 'a -> 'a = "copy_constructor" *)
  external method set_pitch : float -> unit = "setPitch"
  external method set_volume : float -> unit = "setVolume"
  external method set_position : float -> float -> float -> unit = "setPosition"
  external method set_position_v : float * float * float -> unit = "setPositionV"
  external method set_relative_to_listener : bool -> unit = "setRelativeToListener" 
  external method set_min_distance : float -> unit = "setMinDistance"
  external method set_attenuation : float -> unit = "setAttenuation"
  external method get_pitch : float = "getPitch"
  external method get_volume : float  = "getVolume"
  external method get_position : float * float * float = "getPosition"
  external method is_relative_to_listener : bool = "isRelativeToListener"	     
  external method get_min_distance : float = "getMinDistance"
  external method get_attenuation : float = "getAttenuation"
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
  external method play : unit  = "play"
  external method pause : unit = "pause"
  external method stop : unit = "stop"
  external method get_channel_count : int = "getChannelCount"
  external method get_sample_rate : int = "getSampleRate"
  external method get_status : status = "getStatus"	     
  external method set_playing_offset : Time.t -> unit = "setPlayingOffset"
  external method get_playing_offset : Time.t = "getPlayingOffset"
  external method set_loop : bool -> unit = "setLoop"
  external method get_loop : bool = "getLoop"
end

let mk_sound_stream ?playing_offset ?loop (t: #sound_stream) =
  do_if t#set_playing_offset playing_offset ;
  do_if t#set_loop loop

external class musicCpp (Music) : "sf_Music" =
object
  external inherit sound_stream : "sf_SoundStream"
  constructor default : unit = "default_constructor"
  external method open_from_file : string -> bool = "openFromFile"
  external method get_duration : Time.t = "getDuration"
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
  external method load_from_file : string -> bool = "loadFromFile"
  external method load_from_stream : input_stream -> bool = "loadFromStream" 
  external method load_from_samples :  samples_type -> int -> int -> bool = "loadFromSamples"
  external method save_to_file : string -> bool = "saveToFile"
  external method get_samples : samples_type = "getSamples" 
  external method get_sample_count : int = "getSampleCount"
  external method get_sample_rate : int = "getSampleRate"
  external method get_channel_count : int = "getChannelCount"
  external method get_duration : Time.t = "getDuration"
end

class sound_buffer_bis () = 
  let t = SoundBuffer.default () in 
    sound_bufferCpp t

class sound_buffer =
  sound_buffer_bis ()

let mk_sound_buffer tag =
  let sb = new sound_buffer in
    if match tag with
      | `File s -> sb#load_from_file s
      | `Stream s -> sb#load_from_stream s
      | `Samples (s,i,j) -> sb#load_from_samples s i j
    then sb
    else raise LoadFailure

external class virtual sound_recorder : "sf_SoundRecorder" =
object
  external method start : ?sampleRate:int -> unit -> unit = "start"
  external method stop : unit = "stop"
  external method get_sample_rate : int = "getSampleRate"
end

module SoundRecorder =
struct
  external cpp is_available : unit -> bool = "SoundRecorder_isAvailable"
end

external class sound_buffer_recorderCpp (SoundBufferRecorder) : "sf_SoundBufferRecorder" =
object 
  external inherit sound_recorder : "sf_SoundRecorder"
  constructor default : unit = "default_constructor"
  external method get_buffer : sound_buffer = "getBuffer"
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
  external method play : unit = "play"
  external method pause : unit = "pause" 
  external method stop : unit = "stop"
  external method set_buffer : sound_buffer -> unit = "setBuffer"
  external method set_loop : bool -> unit = "setLoop"
  external method set_playing_offset : Time.t -> unit = "setPlayingOffset"	     
  external method get_buffer : sound_buffer = "getBuffer"
  external method get_loop : bool = "getLoop"
  external method get_playing_offset : Time.t = "getPlayingOffset"
  external method get_status : status = "getStatus"
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
