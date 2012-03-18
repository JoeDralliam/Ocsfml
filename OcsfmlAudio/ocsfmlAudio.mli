val do_if : ('a -> unit) -> 'a option -> unit
module Listener :
  sig
    external set_global_volume : float -> unit
      = "Listener_setGlobalVolume__impl"
    external get_global_volume : unit -> float
      = "Listener_getGlobalVolume__impl"
    external set_position : float -> float -> float -> unit
      = "Listener_setPosition__impl"
    external set_position_v : float * float * float -> unit
      = "Listener_setPositionV__impl"
    external get_position : unit -> float * float * float
      = "Listener_getPosition__impl"
    external set_direction : float -> float -> float -> unit
      = "Listener_setDirection__impl"
    external set_direction_v : float * float * float -> unit
      = "Listener_setDirectionV__impl"
    external get_direction : unit -> float * float * float
      = "Listener_getDirection__impl"
  end
type status = Stopped | Paused | Playing
module Sound_source :
  sig
    type t
    class type sound_source_class_type =
      object
        val t_sound_source : t
        method destroy : unit
        method get_attenuation : float
        method get_min_distance : float
        method get_pitch : float
        method get_position : float * float * float
        method get_volume : float
        method is_relative_to_listener : bool
        method rep__sf_SoundSource : t
        method set_attenuation : float -> unit
        method set_min_distance : float -> unit
        method set_pitch : float -> unit
        method set_position : float -> float -> float -> unit
        method set_position_v : float * float * float -> unit
        method set_relative_to_listener : bool -> unit
        method set_volume : float -> unit
      end
    external destroy : t -> unit = "sf_SoundSource_destroy__impl"
    external set_pitch : t -> float -> unit = "sf_SoundSource_setPitch__impl"
    external set_volume : t -> float -> unit
      = "sf_SoundSource_setVolume__impl"
    external set_position : t -> float -> float -> float -> unit
      = "sf_SoundSource_setPosition__impl"
    external set_position_v : t -> float * float * float -> unit
      = "sf_SoundSource_setPositionV__impl"
    external set_relative_to_listener : t -> bool -> unit
      = "sf_SoundSource_setRelativeToListener__impl"
    external set_min_distance : t -> float -> unit
      = "sf_SoundSource_setMinDistance__impl"
    external set_attenuation : t -> float -> unit
      = "sf_SoundSource_setAttenuation__impl"
    external get_pitch : t -> float = "sf_SoundSource_getPitch__impl"
    external get_volume : t -> float = "sf_SoundSource_getVolume__impl"
    external get_position : t -> float * float * float
      = "sf_SoundSource_getPosition__impl"
    external is_relative_to_listener : t -> bool
      = "sf_SoundSource_isRelativeToListener__impl"
    external get_min_distance : t -> float
      = "sf_SoundSource_getMinDistance__impl"
    external get_attenuation : t -> float
      = "sf_SoundSource_getAttenuation__impl"
  end
class sound_source :
  Sound_source.t ->
  object
    val t_sound_source : Sound_source.t
    method destroy : unit
    method get_attenuation : float
    method get_min_distance : float
    method get_pitch : float
    method get_position : float * float * float
    method get_volume : float
    method is_relative_to_listener : bool
    method rep__sf_SoundSource : Sound_source.t
    method set_attenuation : float -> unit
    method set_min_distance : float -> unit
    method set_pitch : float -> unit
    method set_position : float -> float -> float -> unit
    method set_position_v : float * float * float -> unit
    method set_relative_to_listener : bool -> unit
    method set_volume : float -> unit
  end
val mk_sound_source :
  ?pitch:float ->
  ?volume:float ->
  ?position:float * float * float ->
  ?relative_to_listener:bool ->
  ?min_distance:float -> ?attenuation:float -> #sound_source -> unit
module Sound_stream :
  sig
    type t
    external destroy : t -> unit = "sf_SoundStream_destroy__impl"
    external to_sound_source : t -> Sound_source.t
      = "upcast__sf_SoundSource_of_sf_SoundStream__impl"
    external play : t -> unit = "sf_SoundStream_play__impl"
    external pause : t -> unit = "sf_SoundStream_pause__impl"
    external stop : t -> unit = "sf_SoundStream_stop__impl"
    external get_channel_count : t -> int
      = "sf_SoundStream_getChannelCount__impl"
    external get_sample_rate : t -> int
      = "sf_SoundStream_getSampleRate__impl"
    external get_status : t -> status = "sf_SoundStream_getStatus__impl"
    external set_playing_offset : t -> OcsfmlSystem.Time.t -> unit
      = "sf_SoundStream_setPlayingOffset__impl"
    external get_playing_offset : t -> OcsfmlSystem.Time.t
      = "sf_SoundStream_getPlayingOffset__impl"
    external set_loop : t -> bool -> unit = "sf_SoundStream_setLoop__impl"
    external get_loop : t -> bool = "sf_SoundStream_getLoop__impl"
  end
class sound_stream :
  Sound_stream.t ->
  object
    val t_sound_source : Sound_source.t
    val t_sound_stream : Sound_stream.t
    method destroy : unit
    method get_attenuation : float
    method get_channel_count : int
    method get_loop : bool
    method get_min_distance : float
    method get_pitch : float
    method get_playing_offset : OcsfmlSystem.Time.t
    method get_position : float * float * float
    method get_sample_rate : int
    method get_status : status
    method get_volume : float
    method is_relative_to_listener : bool
    method pause : unit
    method play : unit
    method rep__sf_SoundSource : Sound_source.t
    method rep__sf_SoundStream : Sound_stream.t
    method set_attenuation : float -> unit
    method set_loop : bool -> unit
    method set_min_distance : float -> unit
    method set_pitch : float -> unit
    method set_playing_offset : OcsfmlSystem.Time.t -> unit
    method set_position : float -> float -> float -> unit
    method set_position_v : float * float * float -> unit
    method set_relative_to_listener : bool -> unit
    method set_volume : float -> unit
    method stop : unit
  end
val mk_sound_stream :
  ?playing_offset:OcsfmlSystem.Time.t -> ?loop:bool -> #sound_stream -> unit
module Music :
  sig
    type t
    external destroy : t -> unit = "sf_Music_destroy__impl"
    external to_sound_stream : t -> Sound_stream.t
      = "upcast__sf_SoundStream_of_sf_Music__impl"
    external default : unit -> t = "sf_Music_default_constructor__impl"
    external open_from_file : t -> string -> bool
      = "sf_Music_openFromFile__impl"
    external get_duration : t -> OcsfmlSystem.Time.t
      = "sf_Music_getDuration__impl"
  end
class musicCpp :
  Music.t ->
  object
    val t_musicCpp : Music.t
    val t_sound_source : Sound_source.t
    val t_sound_stream : Sound_stream.t
    method destroy : unit
    method get_attenuation : float
    method get_channel_count : int
    method get_duration : OcsfmlSystem.Time.t
    method get_loop : bool
    method get_min_distance : float
    method get_pitch : float
    method get_playing_offset : OcsfmlSystem.Time.t
    method get_position : float * float * float
    method get_sample_rate : int
    method get_status : status
    method get_volume : float
    method is_relative_to_listener : bool
    method open_from_file : string -> bool
    method pause : unit
    method play : unit
    method rep__sf_Music : Music.t
    method rep__sf_SoundSource : Sound_source.t
    method rep__sf_SoundStream : Sound_stream.t
    method set_attenuation : float -> unit
    method set_loop : bool -> unit
    method set_min_distance : float -> unit
    method set_pitch : float -> unit
    method set_playing_offset : OcsfmlSystem.Time.t -> unit
    method set_position : float -> float -> float -> unit
    method set_position_v : float * float * float -> unit
    method set_relative_to_listener : bool -> unit
    method set_volume : float -> unit
    method stop : unit
  end
class music_bis : unit -> musicCpp
class music : music_bis
val mk_music :
  ?playing_offset:'a ->
  ?loop:'b ->
  ?pitch:'c ->
  ?volume:'d ->
  ?position:'e ->
  ?relative_to_listener:'f ->
  ?min_distance:'g -> ?attenuation:'h -> unit -> music
type samples_type =
    (int, Bigarray.int16_signed_elt, Bigarray.c_layout) Bigarray.Array1.t
module SoundBuffer :
  sig
    type t
    class type sound_bufferCpp_class_type =
      object
        val t_sound_bufferCpp : t
        method destroy : unit
        method get_channel_count : int
        method get_duration : OcsfmlSystem.Time.t
        method get_sample_count : int
        method get_sample_rate : int
        method get_samples : samples_type
        method load_from_file : string -> bool
        method load_from_samples : samples_type -> int -> int -> bool
        method load_from_stream : OcsfmlSystem.input_stream -> bool
        method rep__sf_SoundBuffer : t
        method save_to_file : string -> bool
      end
    external destroy : t -> unit = "sf_SoundBuffer_destroy__impl"
    external default : unit -> t = "sf_SoundBuffer_default_constructor__impl"
    external load_from_file : t -> string -> bool
      = "sf_SoundBuffer_loadFromFile__impl"
    external load_from_stream : t -> OcsfmlSystem.input_stream -> bool
      = "sf_SoundBuffer_loadFromStream__impl"
    external load_from_samples : t -> samples_type -> int -> int -> bool
      = "sf_SoundBuffer_loadFromSamples__impl"
    external save_to_file : t -> string -> bool
      = "sf_SoundBuffer_saveToFile__impl"
    external get_samples : t -> samples_type
      = "sf_SoundBuffer_getSamples__impl"
    external get_sample_count : t -> int
      = "sf_SoundBuffer_getSampleCount__impl"
    external get_sample_rate : t -> int
      = "sf_SoundBuffer_getSampleRate__impl"
    external get_channel_count : t -> int
      = "sf_SoundBuffer_getChannelCount__impl"
    external get_duration : t -> OcsfmlSystem.Time.t
      = "sf_SoundBuffer_getDuration__impl"
  end
class sound_bufferCpp :
  SoundBuffer.t ->
  object
    val t_sound_bufferCpp : SoundBuffer.t
    method destroy : unit
    method get_channel_count : int
    method get_duration : OcsfmlSystem.Time.t
    method get_sample_count : int
    method get_sample_rate : int
    method get_samples : samples_type
    method load_from_file : string -> bool
    method load_from_samples : samples_type -> int -> int -> bool
    method load_from_stream : OcsfmlSystem.input_stream -> bool
    method rep__sf_SoundBuffer : SoundBuffer.t
    method save_to_file : string -> bool
  end
class sound_buffer_bis : unit -> sound_bufferCpp
class sound_buffer : sound_buffer_bis
val mk_sound_buffer :
  [< `File of string
   | `Samples of samples_type * int * int
   | `Stream of OcsfmlSystem.input_stream ] ->
  sound_buffer
module Sound_recorder :
  sig
    type t
    external destroy : t -> unit = "sf_SoundRecorder_destroy__impl"
    external start : t -> ?sampleRate:int -> unit -> unit
      = "sf_SoundRecorder_start__impl"
    external stop : t -> unit = "sf_SoundRecorder_stop__impl"
    external get_sample_rate : t -> int
      = "sf_SoundRecorder_getSampleRate__impl"
  end
class sound_recorder :
  Sound_recorder.t ->
  object
    val t_sound_recorder : Sound_recorder.t
    method destroy : unit
    method get_sample_rate : int
    method rep__sf_SoundRecorder : Sound_recorder.t
    method start : ?sampleRate:int -> unit -> unit
    method stop : unit
  end
module SoundRecorder :
  sig
    external is_available : unit -> bool = "SoundRecorder_isAvailable__impl"
  end
module SoundBufferRecorder :
  sig
    type t
    external destroy : t -> unit = "sf_SoundBufferRecorder_destroy__impl"
    external to_sound_recorder : t -> Sound_recorder.t
      = "upcast__sf_SoundRecorder_of_sf_SoundBufferRecorder__impl"
    external default : unit -> t
      = "sf_SoundBufferRecorder_default_constructor__impl"
    external get_buffer : t -> sound_buffer
      = "sf_SoundBufferRecorder_getBuffer__impl"
  end
class sound_buffer_recorderCpp :
  SoundBufferRecorder.t ->
  object
    val t_sound_buffer_recorderCpp : SoundBufferRecorder.t
    val t_sound_recorder : Sound_recorder.t
    method destroy : unit
    method get_buffer : sound_buffer
    method get_sample_rate : int
    method rep__sf_SoundBufferRecorder : SoundBufferRecorder.t
    method rep__sf_SoundRecorder : Sound_recorder.t
    method start : ?sampleRate:int -> unit -> unit
    method stop : unit
  end
class sound_buffer_recorder_bis : unit -> sound_buffer_recorderCpp
class sound_buffer_recorder : sound_buffer_recorder_bis
module Sound :
  sig
    type t
    external destroy : t -> unit = "sf_Sound_destroy__impl"
    external to_sound_source : t -> Sound_source.t
      = "upcast__sf_SoundSource_of_sf_Sound__impl"
    external default : unit -> t = "sf_Sound_default_constructor__impl"
    external create_from_sound_buffer : sound_buffer -> t
      = "sf_Sound_buffer_constructor__impl"
    external play : t -> unit = "sf_Sound_play__impl"
    external pause : t -> unit = "sf_Sound_pause__impl"
    external stop : t -> unit = "sf_Sound_stop__impl"
    external set_buffer : t -> sound_buffer -> unit
      = "sf_Sound_setBuffer__impl"
    external set_loop : t -> bool -> unit = "sf_Sound_setLoop__impl"
    external set_playing_offset : t -> OcsfmlSystem.Time.t -> unit
      = "sf_Sound_setPlayingOffset__impl"
    external get_buffer : t -> sound_buffer = "sf_Sound_getBuffer__impl"
    external get_loop : t -> bool = "sf_Sound_getLoop__impl"
    external get_playing_offset : t -> OcsfmlSystem.Time.t
      = "sf_Sound_getPlayingOffset__impl"
    external get_status : t -> status = "sf_Sound_getStatus__impl"
  end
class soundCpp :
  Sound.t ->
  object
    val t_soundCpp : Sound.t
    val t_sound_source : Sound_source.t
    method destroy : unit
    method get_attenuation : float
    method get_buffer : sound_buffer
    method get_loop : bool
    method get_min_distance : float
    method get_pitch : float
    method get_playing_offset : OcsfmlSystem.Time.t
    method get_position : float * float * float
    method get_status : status
    method get_volume : float
    method is_relative_to_listener : bool
    method pause : unit
    method play : unit
    method rep__sf_Sound : Sound.t
    method rep__sf_SoundSource : Sound_source.t
    method set_attenuation : float -> unit
    method set_buffer : sound_buffer -> unit
    method set_loop : bool -> unit
    method set_min_distance : float -> unit
    method set_pitch : float -> unit
    method set_playing_offset : OcsfmlSystem.Time.t -> unit
    method set_position : float -> float -> float -> unit
    method set_position_v : float * float * float -> unit
    method set_relative_to_listener : bool -> unit
    method set_volume : float -> unit
    method stop : unit
  end
class sound_bis : unit -> soundCpp
class sound : sound_bis
val mk_sound :
  ?loop:bool ->
  ?buffer:sound_buffer ->
  ?playing_offset:OcsfmlSystem.Time.t ->
  ?pitch:float ->
  ?volume:float ->
  ?position:float * float * float ->
  ?relative_to_listener:bool ->
  ?min_distance:float -> ?attenuation:float -> unit -> sound
