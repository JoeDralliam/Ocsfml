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


external class musicCpp (Music) : "sf_Music" =
object
  constructor default : unit = "default_constructor"
  external method open_from_file : string -> bool = "OpenFromFile"
  external method get_duration : unit -> int = "GetDuration"

end

type samples_type = (int, int_16_signed_elt, Bigarray.c_layout) Bigarray.Array1.t

external class  sound_bufferCpp (SoundBuffer) : "sf_SoundBuffer" =
object auto (_ : 'a)
  constructor default : unit = "default_constructor"
  constructor copy : 'a -> 'a = "copy_constructor"
  external method load_from_file : string -> bool = "LoadFromFile"
  external method load_from_stream : System.input_stream -> bool = "LoadFromStream"
  external method load_from_samples :  samples_type -> int -> int -> bool = "LoadFromSamples"
  external method save_to_file : string -> bool = "SaveToFile"
  external method get_samples : unit -> samlpes_type = "GetSamples" 
  external method get_samples_count : unit -> count = "GetSamplesCount"
  external method get_sample_rate : unit -> int = "GetSampleRate"
  external method get_channels_count : unit -> int = "GetChannelsCount"
  external method get_duration : unit -> int = "GetDuration"
end

external class sound_recorder (SoundRecorder) : "sf_SoundRecorder" =
object
  external method start : ?sampleRate:int -> unit -> unit = "Start"
  external method stop : unit -> unit = "Stop"
  external method get_sample_rate : unit -> int = "GetSampleRate"
end

external cpp is_available : unit -> bool = "SoundRecorder_IsAvailable"
