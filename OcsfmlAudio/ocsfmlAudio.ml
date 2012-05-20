open OcsfmlSystem
  
let do_if f = function | Some x -> f x | None -> ()
  
module Listener =
struct
  external set_global_volume : float -> unit =
    "Listener_setGlobalVolume__impl"
      
  external get_global_volume : unit -> float =
    "Listener_getGlobalVolume__impl"
      
  external set_position : float -> float -> float -> unit =
    "Listener_setPosition__impl"
      
  external set_position_v : (float * float * float) -> unit =
    "Listener_setPositionV__impl"
      
  external get_position : unit -> (float * float * float) =
    "Listener_getPosition__impl"
      
  external set_direction : float -> float -> float -> unit =
    "Listener_setDirection__impl"
      
  external set_direction_v : (float * float * float) -> unit =
    "Listener_setDirectionV__impl"
      
  external get_direction : unit -> (float * float * float) =
    "Listener_getDirection__impl"
      
end
  
type status = | Stopped | Paused | Playing

module SoundSource =
struct
  type t
    
  external destroy : t -> unit = "sf_SoundSource_destroy__impl"
	    
  external set_pitch : t -> float -> unit = "sf_SoundSource_setPitch__impl"
	    
  external set_volume : t -> float -> unit =
	    "sf_SoundSource_setVolume__impl"
	      
  external set_position : t -> float -> float -> float -> unit =
	    "sf_SoundSource_setPosition__impl"
	      
  external set_position_v : t -> (float * float * float) -> unit =
	    "sf_SoundSource_setPositionV__impl"
	      
  external set_relative_to_listener : t -> bool -> unit =
	    "sf_SoundSource_setRelativeToListener__impl"
	      
  external set_min_distance : t -> float -> unit =
	    "sf_SoundSource_setMinDistance__impl"
	      
  external set_attenuation : t -> float -> unit =
	    "sf_SoundSource_setAttenuation__impl"
	      
  external get_pitch : t -> float = "sf_SoundSource_getPitch__impl"
	    
  external get_volume : t -> float = "sf_SoundSource_getVolume__impl"
	    
  external get_position : t -> (float * float * float) =
	    "sf_SoundSource_getPosition__impl"
	      
  external is_relative_to_listener : t -> bool =
	    "sf_SoundSource_isRelativeToListener__impl"
	      
  external get_min_distance : t -> float =
	    "sf_SoundSource_getMinDistance__impl"
	      
  external get_attenuation : t -> float =
	    "sf_SoundSource_getAttenuation__impl"
	      
end
  
class sound_source_base t =
object ((_ : 'a))
  val t_sound_source = (t : SoundSource.t)
  method rep__sf_SoundSource = t_sound_source
  method destroy = SoundSource.destroy t_sound_source
  method set_pitch : float -> unit =
    fun p1 -> SoundSource.set_pitch t_sound_source p1
  method set_volume : float -> unit =
    fun p1 -> SoundSource.set_volume t_sound_source p1
  method set_position : float -> float -> float -> unit =
    fun p1 p2 p3 -> SoundSource.set_position t_sound_source p1 p2 p3
  method set_position_v : (float * float * float) -> unit =
    fun p1 -> SoundSource.set_position_v t_sound_source p1
  method set_relative_to_listener : bool -> unit =
    fun p1 -> SoundSource.set_relative_to_listener t_sound_source p1
  method set_min_distance : float -> unit =
    fun p1 -> SoundSource.set_min_distance t_sound_source p1
  method set_attenuation : float -> unit =
    fun p1 -> SoundSource.set_attenuation t_sound_source p1
  method get_pitch : float = SoundSource.get_pitch t_sound_source
  method get_volume : float = SoundSource.get_volume t_sound_source
  method get_position : (float * float * float) =
    SoundSource.get_position t_sound_source
  method is_relative_to_listener : bool =
    SoundSource.is_relative_to_listener t_sound_source
  method get_min_distance : float =
    SoundSource.get_min_distance t_sound_source
  method get_attenuation : float =
    SoundSource.get_attenuation t_sound_source
end
  

class sound_source_init ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation t =
object (self)
  inherit sound_source_base t

  initializer do_if self#set_pitch pitch
  initializer do_if self#set_volume volume
  initializer do_if self#set_position_v position
  initializer do_if self#set_relative_to_listener relative_to_listener
  initializer do_if self#set_min_distance min_distance
  initializer do_if self#set_attenuation attenuation
end

class sound_source = sound_source_init
    
module SoundStream =
struct
  type t
    
  external destroy : t -> unit = "sf_SoundStream_destroy__impl"
      
  external to_sound_source : t -> SoundSource.t =
      "upcast__sf_SoundSource_of_sf_SoundStream__impl"
	
  external play : t -> unit = "sf_SoundStream_play__impl"
      
  external pause : t -> unit = "sf_SoundStream_pause__impl"
      
  external stop : t -> unit = "sf_SoundStream_stop__impl"
      
  external get_channel_count : t -> int =
      "sf_SoundStream_getChannelCount__impl"
	
  external get_sample_rate : t -> int =
      "sf_SoundStream_getSampleRate__impl"
	
  external get_status : t -> status = "sf_SoundStream_getStatus__impl"
      
  external set_playing_offset : t -> Time.t -> unit =
      "sf_SoundStream_setPlayingOffset__impl"
	
  external get_playing_offset : t -> Time.t =
      "sf_SoundStream_getPlayingOffset__impl"
	
  external set_loop : t -> bool -> unit = "sf_SoundStream_setLoop__impl"
      
  external get_loop : t -> bool = "sf_SoundStream_getLoop__impl"
      
end
  
class sound_stream_base ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation t =
object ((self : 'self))
  val t_sound_stream = (t : SoundStream.t)
  method rep__sf_SoundStream = t_sound_stream
  method destroy = SoundStream.destroy t_sound_stream

  inherit sound_source_init ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation (SoundStream.to_sound_source t)

  method play : unit = SoundStream.play t_sound_stream
  method pause : unit = SoundStream.pause t_sound_stream
  method stop : unit = SoundStream.stop t_sound_stream
  method get_channel_count : int =
    SoundStream.get_channel_count t_sound_stream
  method get_sample_rate : int =
    SoundStream.get_sample_rate t_sound_stream
  method get_status : status = SoundStream.get_status t_sound_stream
  method set_playing_offset : Time.t -> unit =
    fun p1 -> SoundStream.set_playing_offset t_sound_stream p1
  method get_playing_offset : Time.t =
    SoundStream.get_playing_offset t_sound_stream
  method set_loop : bool -> unit =
    fun p1 -> SoundStream.set_loop t_sound_stream p1
  method get_loop : bool = SoundStream.get_loop t_sound_stream
end

class sound_stream_init ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?playing_offset ?loop t =
object (self)
  inherit sound_stream_base ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation t

  initializer do_if self#set_playing_offset playing_offset
  initializer do_if self#set_loop loop
end
  
class sound_stream = sound_stream_init

module Music =
struct
  type t
    
  external destroy : t -> unit = "sf_Music_destroy__impl"
      
  external to_sound_stream : t -> SoundStream.t =
      "upcast__sf_SoundStream_of_sf_Music__impl"
	
  external default : unit -> t = "sf_Music_default_constructor__impl"
      
  external open_from_file : t -> string -> bool =
      "sf_Music_openFromFile__impl"
	
  external get_duration : t -> Time.t = "sf_Music_getDuration__impl"
      
end
  
class music_base ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?playing_offset ?loop t =
object ((self : 'self))
  val t_music_base = (t : Music.t)
  method rep__sf_Music = t_music_base
  method destroy = Music.destroy t_music_base

  inherit sound_stream_init ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?playing_offset ?loop (Music.to_sound_stream t)

  method open_from_file : string -> bool =
    fun p1 -> Music.open_from_file t_music_base p1
  method get_duration : Time.t = Music.get_duration t_music_base
end
						   
class music ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?playing_offset ?loop () = 
  let t = Music.default () 
  in music_base ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?playing_offset ?loop t

type samples_type = (int, Bigarray.int16_signed_elt, Bigarray.c_layout) Bigarray.Array1.t

module SoundBuffer =
struct
  type t
        
  external destroy : t -> unit = "sf_SoundBuffer_destroy__impl"
	    
  external default : unit -> t = "sf_SoundBuffer_default_constructor__impl"
	    
  external copy : t -> t = "sf_SoundBuffer_copy_constructor__impl"

  external affect : t -> t -> t = "sf_SoundBuffer_affect__impl"

  external load_from_file : t -> string -> bool =
	    "sf_SoundBuffer_loadFromFile__impl"
	      
  external load_from_stream : t -> input_stream -> bool =
	    "sf_SoundBuffer_loadFromStream__impl"
	      
  external load_from_samples : t -> samples_type -> int -> int -> bool =
	    "sf_SoundBuffer_loadFromSamples__impl"
	      
  external save_to_file : t -> string -> bool =
	    "sf_SoundBuffer_saveToFile__impl"
	      
  external get_samples : t -> samples_type =
	    "sf_SoundBuffer_getSamples__impl"
	      
  external get_sample_count : t -> int =
	    "sf_SoundBuffer_getSampleCount__impl"
	      
  external get_sample_rate : t -> int =
	    "sf_SoundBuffer_getSampleRate__impl"
	      
  external get_channel_count : t -> int =
	    "sf_SoundBuffer_getChannelCount__impl"
	      
  external get_duration : t -> Time.t = "sf_SoundBuffer_getDuration__impl"
	    
end
  
class sound_buffer_base t =
object ((_ : 'self))
  val t_sound_buffer_base = (t : SoundBuffer.t)
  method rep__sf_SoundBuffer = t_sound_buffer_base
  method destroy = SoundBuffer.destroy t_sound_buffer_base
  method affect : 'self -> unit =
    fun p1 -> ignore (SoundBuffer.affect t_sound_buffer_base p1#rep__sf_SoundBuffer)
  method load_from_file : string -> bool =
    fun p1 -> SoundBuffer.load_from_file t_sound_buffer_base p1
  method load_from_stream : input_stream -> bool =
    fun p1 -> SoundBuffer.load_from_stream t_sound_buffer_base p1
  method load_from_samples : samples_type -> int -> int -> bool =
    fun p1 p2 p3 ->
      SoundBuffer.load_from_samples t_sound_buffer_base p1 p2 p3
  method save_to_file : string -> bool =
    fun p1 -> SoundBuffer.save_to_file t_sound_buffer_base p1
  method get_samples : samples_type =
    SoundBuffer.get_samples t_sound_buffer_base
  method get_sample_count : int =
    SoundBuffer.get_sample_count t_sound_buffer_base
  method get_sample_rate : int =
    SoundBuffer.get_sample_rate t_sound_buffer_base
  method get_channel_count : int =
    SoundBuffer.get_channel_count t_sound_buffer_base
  method get_duration : Time.t = SoundBuffer.get_duration t_sound_buffer_base
end
  
    
class sound_buffer_init tag t =
object (self)
  inherit sound_buffer_base t

  initializer
    if
      match tag with
	| `File s -> self#load_from_file s
	| `Stream s -> self#load_from_stream s
	| `Samples (s, i, j) -> self#load_from_samples s i j
	| `Copy _ | `None -> true
    then ()
    else raise LoadFailure
end

class sound_buffer tag = 
  let t = match tag with
    | `Copy other -> SoundBuffer.copy other#rep__sf_SoundBuffer
    | _ -> SoundBuffer.default ()
  in sound_buffer_init tag t
  
    
module SoundRecorder =
struct
  type t
    
  external destroy : t -> unit = "sf_SoundRecorder_destroy__impl"
      
  external start : t -> ?sampleRate: int -> unit -> unit =
      "sf_SoundRecorder_start__impl"
	
  external stop : t -> unit = "sf_SoundRecorder_stop__impl"
      
  external get_sample_rate : t -> int =
      "sf_SoundRecorder_getSampleRate__impl"
	

  external is_available : unit -> bool = "SoundRecorder_isAvailable__impl"
end
  
class sound_recorder_base t =
object ((self : 'self))
  val t_sound_recorder = (t : SoundRecorder.t)
  method rep__sf_SoundRecorder = t_sound_recorder
  method destroy = SoundRecorder.destroy t_sound_recorder
  method start : ?sampleRate: int -> unit -> unit =
    fun ?sampleRate p1 ->
      SoundRecorder.start t_sound_recorder ?sampleRate p1
  method stop : unit = SoundRecorder.stop t_sound_recorder
  method get_sample_rate : int =
    SoundRecorder.get_sample_rate t_sound_recorder
end

class sound_recorder = sound_recorder_base
  
module SoundBufferRecorder =
struct
  type t
    
  external destroy : t -> unit = "sf_SoundBufferRecorder_destroy__impl"
      
  external to_sound_recorder : t -> SoundRecorder.t =
      "upcast__sf_SoundRecorder_of_sf_SoundBufferRecorder__impl"
	
  external default : unit -> t =
      "sf_SoundBufferRecorder_default_constructor__impl"
	
  external get_buffer : t -> sound_buffer =
      "sf_SoundBufferRecorder_getBuffer__impl"
	
end
  
class sound_buffer_recorder_base t =
object ((self : 'self))
  val t_sound_buffer_recorder_base = (t : SoundBufferRecorder.t)
  method rep__sf_SoundBufferRecorder = t_sound_buffer_recorder_base
  method destroy = SoundBufferRecorder.destroy t_sound_buffer_recorder_base

  inherit sound_recorder (SoundBufferRecorder.to_sound_recorder t)

  method get_buffer : sound_buffer =
    SoundBufferRecorder.get_buffer t_sound_buffer_recorder_base
end
  
    
class sound_buffer_recorder_bis () =
  let t = SoundBufferRecorder.default ()
  in sound_buffer_recorder_base t
       
class sound_buffer_recorder = sound_buffer_recorder_bis ()
  
module Sound =
struct
  type t
    
  external destroy : t -> unit = "sf_Sound_destroy__impl"
      
  external to_sound_source : t -> SoundSource.t =
      "upcast__sf_SoundSource_of_sf_Sound__impl"
	
  external default : unit -> t = "sf_Sound_default_constructor__impl"
      
  external create_from_sound_buffer : sound_buffer -> t =
      "sf_Sound_buffer_constructor__impl"
	
  external play : t -> (* constructor copy *) unit = "sf_Sound_play__impl"
      
  external pause : t -> unit = "sf_Sound_pause__impl"
      
  external stop : t -> unit = "sf_Sound_stop__impl"
      
  external set_buffer : t -> sound_buffer -> unit =
      "sf_Sound_setBuffer__impl"
	
  external set_loop : t -> bool -> unit = "sf_Sound_setLoop__impl"
      
  external set_playing_offset : t -> Time.t -> unit =
      "sf_Sound_setPlayingOffset__impl"
	
  external get_buffer : t -> sound_buffer = "sf_Sound_getBuffer__impl"
      
  external get_loop : t -> bool = "sf_Sound_getLoop__impl"
      
  external get_playing_offset : t -> Time.t =
      "sf_Sound_getPlayingOffset__impl"
	
  external get_status : t -> status = "sf_Sound_getStatus__impl"
      
end
  
class sound_base ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation t =
object ((self : 'self))
  val t_sound_base = (t : Sound.t)
  method rep__sf_Sound = t_sound_base
  method destroy = Sound.destroy t_sound_base
  
  inherit sound_source_init ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation (Sound.to_sound_source t)
  
  method play : unit = Sound.play t_sound_base
  method pause : unit = Sound.pause t_sound_base
  method stop : unit = Sound.stop t_sound_base
  method set_buffer : sound_buffer -> unit =
    fun p1 -> Sound.set_buffer t_sound_base p1
  method set_loop : bool -> unit = fun p1 -> Sound.set_loop t_sound_base p1
  method set_playing_offset : Time.t -> unit =
    fun p1 -> Sound.set_playing_offset t_sound_base p1
  method get_buffer : sound_buffer = Sound.get_buffer t_sound_base
  method get_loop : bool = Sound.get_loop t_sound_base
  method get_playing_offset : Time.t = Sound.get_playing_offset t_sound_base
  method get_status : status = Sound.get_status t_sound_base
end
  
class sound_init ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?loop ?buffer ?playing_offset t =
object (self)
  inherit sound_base ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation t

  initializer do_if self#set_loop loop
  initializer do_if self#set_buffer buffer
  initializer do_if self#set_playing_offset playing_offset
end						  

class sound ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?loop ?buffer ?playing_offset() =
  let t = Sound.default ()
  in sound_init ?pitch ?volume ?position ?relative_to_listener ?min_distance ?attenuation ?loop ?buffer ?playing_offset t

