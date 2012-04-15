(** Audio I/O and sound management **)

(** The audio listener is the point in the scene from where all the sounds are heard.

    The audio listener defines the global properties of the audio environment, it defines where and how sounds and musics are heard.
    
    If OcsfmlGraphics.view is the eyes of the user, then Listener is his ears (by the way, they are often linked together -- same position, orientation, etc.).
    
    Listener is a simple interface, which allows to setup the listener in the 3D audio environment (position and direction), and to adjust the global volume.
    
    Because the listener is unique in the scene, Listener is a module.
    
    Usage example:
    {[
    (* Move the listener to the position (1, 0, -5) *)
    OcsfmlGraphics.Listener.set_position 1. 0. -5. ;
    
    (* Make it face the right axis (1, 0, 0) *)
    OcsfmlGraphics.Listener.set_direction 1. 0. 0. ;
    
    (* Reduce the global volume *)
    OcsfmlGraphics.Listener.set_global_volume 50.
    ]} *)
module Listener :
sig
  (** Change the global volume of all the sounds and musics.
      
      The volume is a number between 0 and 100; it is combined with the individual volume of each sound / music. The default value for the volume is 100 (maximum).*)
  val set_global_volume : float -> unit
    
  (** Get the current value of the global volume. 
      @return Current global volume, in the range [0, 100]*)
  val get_global_volume : unit -> float
    
  (** Set the position of the listener in the scene.
      
      The default listener's position is (0, 0, 0).*)
  val set_position : float -> float -> float -> unit
    
  (** Set the position of the listener in the scene.
      
      The default listener's position is (0, 0, 0).*)
  val set_position_v : float * float * float -> unit
    
  (** Get the current position of the listener in the scene. 
      @return Listener's position*)
  val get_position : unit -> float * float * float
    
    (** Set the orientation of the listener in the scene.
	
	The orientation defines the 3D axes of the listener (left, up, front) in the scene. The orientation vector doesn't have to be normalized. The default listener's orientation is (0, 0, -1).*)
  val set_direction : float -> float -> float -> unit

    (** Set the orientation of the listener in the scene.

	The orientation defines the 3D axes of the listener (left, up, front) in the scene. The orientation vector doesn't have to be normalized. The default listener's orientation is (0, 0, -1).*)
  val set_direction_v : float * float * float -> unit

    (** Get the current orientation of the listener in the scene. 
	@return Listener's orientation*)
  val get_direction : unit -> float * float * float
end

(** Enumeration of the sound source states. *)
type status = 
    Stopped (** Sound is not playing. *)
  | Paused (** Sound is paused. *)
  | Playing (** Sound is playing. *)


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
  val destroy : t -> unit
  val set_pitch : t -> float -> unit
  val set_volume : t -> float -> unit
  val set_position : t -> float -> float -> float -> unit
  val set_position_v : t -> float * float * float -> unit
  val set_relative_to_listener : t -> bool -> unit
  val set_min_distance : t -> float -> unit
  val set_attenuation : t -> float -> unit
  val get_pitch : t -> float
  val get_volume : t -> float
  val get_position : t -> float * float * float
  val is_relative_to_listener : t -> bool
  val get_min_distance : t -> float
  val get_attenuation : t -> float
end

(** Base class defining a sound's properties.
    
    OcsfmlAudio.sound_source is not meant to be used directly, it only serves as a common base for all audio objects that can live in the audio environment.
    
    It defines several properties for the sound: pitch, volume, position, attenuation, etc. All of them can be changed at any time with no impact on performances.*)
class sound_source :
  Sound_source.t ->
object
  (**/**)
  val t_sound_source : Sound_source.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the attenuation factor of the sound. 
      @return Attenuation factor of the sound. *)
  method get_attenuation : float

  (** Get the minimum distance of the sound. 
      @return Minimum distance of the sound*)
  method get_min_distance : float

  (** Get the pitch of the sound. 
      @return Pitch of the sound*)
  method get_pitch : float

  (** Get the 3D position of the sound in the audio scene. 
      @return Position of the sound. *)
  method get_position : float * float * float

  (** Get the volume of the sound. 
      @return Volume of the sound, in the range [0, 100]*)
  method get_volume : float

  (** Tell whether the sound's position is relative to the listener or is absolute. 
      @return True if the position is relative, false if it's absolute. *)
  method is_relative_to_listener : bool

  (**/**)
  method rep__sf_SoundSource : Sound_source.t
  (**/**)

  (** Set the attenuation factor of the sound.

      The attenuation is a multiplicative factor which makes the sound more or less loud according to its distance from the listener. An attenuation of 0 will produce a non-attenuated sound, i.e. its volume will always be the same whether it is heard from near or from far. On the other hand, an attenuation value such as 100 will make the sound fade out very quickly as it gets further from the listener. The default value of the attenuation is 1.*)
  method set_attenuation : float -> unit

  (** Set the minimum distance of the sound.

      The "minimum distance" of a sound is the maximum distance at which it is heard at its maximum volume. Further than the minimum distance, it will start to fade out according to its attenuation factor. A value of 0 ("inside the head of the listener") is an invalid value and is forbidden. The default value of the minimum distance is 1.*)
  method set_min_distance : float -> unit

  (** Set the pitch of the sound.

      The pitch represents the perceived fundamental frequency of a sound; thus you can make a sound more acute or grave by changing its pitch. A side effect of changing the pitch is to modify the playing speed of the sound as well. The default value for the pitch is 1.*)
  method set_pitch : float -> unit

  (** Set the 3D position of the sound in the audio scene.

      Only sounds with one channel (mono sounds) can be spatialized. The default position of a sound is (0, 0, 0).*)
  method set_position : float -> float -> float -> unit

  (** Set the 3D position of the sound in the audio scene.

      Only sounds with one channel (mono sounds) can be spatialized. The default position of a sound is (0, 0, 0).*)
  method set_position_v : float * float * float -> unit

  (** Make the sound's position relative to the listener or absolute.

      Making a sound relative to the listener will ensure that it will always be played the same way regardless the position of the listener. This can be useful for non-spatialized sounds, sounds that are produced by the listener, or sounds attached to it. The default value is false (position is absolute).*)
  method set_relative_to_listener : bool -> unit

  (** Set the volume of the sound.

      The volume is a value between 0 (mute) and 100 (full volume). The default value for the volume is 100.*)
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
  val destroy : t -> unit
  val to_sound_source : t -> Sound_source.t
  val play : t -> unit
  val pause : t -> unit
  val stop : t -> unit
  val get_channel_count : t -> int
  val get_sample_rate : t -> int
  val get_status : t -> status
  val set_playing_offset : t -> OcsfmlSystem.Time.t -> unit
  val get_playing_offset : t -> OcsfmlSystem.Time.t
  val set_loop : t -> bool -> unit
  val get_loop : t -> bool
end

(** Binding does not support custom streams yet.

    Abstract base class for streamed audio sources.
    
    Unlike audio buffers (see sf::SoundBuffer), audio streams are never completely loaded in memory.
    
    Instead, the audio data is acquired continuously while the stream is playing. This behaviour allows to play a sound with no loading delay, and keeps the memory consumption very low.
    
    Sound sources that need to be streamed are usually big files (compressed audio musics that would eat hundreds of MB in memory) or files that would take a lot of time to be received (sounds played over the network).
    
    sf::SoundStream is a base class that doesn't care about the stream source, which is left to the derived class. SFML provides a built-in specialization for big files (see sf::Music). *)
class sound_stream :
  Sound_stream.t ->
object
  inherit sound_source

  (**/**)
  val t_sound_stream : Sound_stream.t
  (**/**) 
  
  (**)
  method destroy : unit

  (** Return the number of channels of the stream.

      1 channel means a mono sound, 2 means stereo, etc.
      @return Number of channels *)
  method get_channel_count : int

  (** Tell whether or not the stream is in loop mode. 
      @return True if the stream is looping, false otherwise. *)
  method get_loop : bool

  (** Get the current playing position of the stream. 
      @return Current playing position, from the beginning of the stream. *)
  method get_playing_offset : OcsfmlSystem.Time.t

  (** Get the stream sample rate of the stream.

      The sample rate is the number of audio samples played per second. The higher, the better the quality.
      @return Sample rate, in number of samples per second *)
  method get_sample_rate : int

  (** Get the current status of the stream (stopped, paused, playing) 
      @return Current status *)
  method get_status : status

  (** Pause the audio stream.

      This function pauses the stream if it was playing, otherwise (stream already paused or stopped) it has no effect.*)
  method pause : unit

  (** Start or resume playing the audio stream.

      This function starts the stream if it was stopped, resumes it if it was paused, and restarts it from beginning if it was it already playing. This function uses its own thread so that it doesn't block the rest of the program while the stream is played.*)
  method play : unit

  (**/**)
  method rep__sf_SoundStream : Sound_stream.t
  (**/**)

  (** Set whether or not the stream should loop after reaching the end.

      If set, the stream will restart from beginning after reaching the end and so on, until it is stopped or setLoop(false) is called. The default looping state for streams is false.*)
  method set_loop : bool -> unit

  (** Change the current playing position of the stream.

      The playing position can be changed when the stream is either paused or playing.*)
  method set_playing_offset : OcsfmlSystem.Time.t -> unit

  (** Stop playing the audio stream.

      This function stops the stream if it was playing or paused, and does nothing if it was already stopped. It also resets the playing position (unlike pause()).*)
  method stop : unit
end

val mk_sound_stream :
  ?playing_offset:OcsfmlSystem.Time.t -> ?loop:bool -> #sound_stream -> unit


module Music :
sig
  type t
  val destroy : t -> unit
  val to_sound_stream : t -> Sound_stream.t
  val default : unit -> t
  val open_from_file : t -> string -> bool
  val get_duration : t -> OcsfmlSystem.Time.t
end


(** Streamed music played from an audio file.

    Musics are sounds that are streamed rather than completely loaded in memory.
    
    This is especially useful for compressed musics that usually take hundreds of MB when they are uncompressed: by streaming it instead of loading it entirely, you avoid saturating the memory and have almost no loading delay.
    
    Apart from that, a sf::Music has almost the same features as the sf::SoundBuffer / sf::Sound pair: you can play/pause/stop it, request its parameters (channels, sample rate), change the way it is played (pitch, volume, 3D position, ...), etc.
    
    As a sound stream, a music is played in its own thread in order not to block the rest of the program. This means that you can leave the music alone after calling play(), it will manage itself very well.

    Usage example:
    {[
    (* Declare a new music *)
    let music = new music in
    
    (* Open it from an audio file *)
    if not (music#open_from_file "music.ogg")
    then begin
    (** error...*)
    end
    
    // Change some parameters
    music#set_position 0. 1. 10. ; (* change its 3D position *)
    music#set_pitch 2. ;           (* increase the pitch     *)
    music#set_volume 50. ;         (* reduce the volume      *)
    music#set_loop true ;          (* make it loop           *)
    
    // Play it
    music#play
    ]}
*)
class music :
object
  inherit sound_stream 

  (**/**)  
  val t_musicCpp : Music.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the total duration of the music. 
      @return Music duration *)
  method get_duration : OcsfmlSystem.Time.t

  (** Open a music from an audio file.

      This function doesn't start playing the music (call play() to do so). Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
      @return True if loading succeeded, false if it failed*)
  method open_from_file : string -> bool

  (**/**)
  method rep__sf_Music : Music.t
  (**/**)
end

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
  val destroy : t -> unit
  val default : unit -> t 
  val load_from_file : t -> string -> bool
  val load_from_stream : t -> OcsfmlSystem.input_stream -> bool
  val load_from_samples : t -> samples_type -> int -> int -> bool
  val save_to_file : t -> string -> bool
  val get_samples : t -> samples_type
  val get_sample_count : t -> int
  val get_sample_rate : t -> int
  val get_channel_count : t -> int
  val get_duration : t -> OcsfmlSystem.Time.t
end

  
(** Storage for audio samples defining a sound.
    
    A sound buffer holds the data of a sound, which is an array of audio samples.
    
    A sample is a 16 bits signed integer that defines the amplitude of the sound at a given time. The sound is then restituted by playing these samples at a high rate (for example, 44100 samples per second is the standard rate used for playing CDs). In short, audio samples are like texture pixels, and a OcsfmlAudio.sound_buffer is similar to a OcsfmlGraphics.texture.
    
    A sound buffer can be loaded from a file (see load_from_file for the complete list of supported formats), from memory, from a custom stream (see OcsfmSystem.input_stream) or directly from an array of samples. It can also be saved back to a file.

    Sound buffers alone are not very useful: they hold the audio data but cannot be played. To do so, you need to use the OcsfmlAudio.sound class, which provides functions to play/pause/stop the sound as well as changing the way it is outputted (volume, pitch, 3D position, ...). This separation allows more flexibility and better performances: indeed a OcsfmlAudio.sound_buffer is a heavy resource, and any operation on it is slow (often too slow for real-time applications). On the other side, a OcsfmlAudio.Sound is a lightweight object, which can use the audio data of a sound buffer and change the way it is played without actually modifying that data. Note that it is also possible to bind several OcsfmlAudio.sound instances to the same OcsfmlAudio.sound_buffer.

    It is important to note that the OcsfmlAudio.sound instance doesn't copy the buffer that it uses, it only keeps a reference to it. Thus, a OcsfmlAudio.sound_buffer must not be destructed while it is used by a OcsfmlAudi.sound (i.e. never write a function that uses a local OcsfmlAudio.sound_buffer instance for loading a sound).
    
    Usage example:
    {[
    (* Declare a new sound buffer *)
    let buffer = new sound_buffer in
    
    (* Load it from a file *)
    if not (buffer#load_from_file "sound.wav")
    then (* error... *)
    
    (* Create a sound source and bind it to the buffer *)
    let sound1 = new sound in
    sound1#set_buffer buffer ;
    
    (* Play the sound *)
    sound1#play ;
    
    (* Create another sound source bound to the same buffer *)
    let sound2 = new sound in
    sound2#set_buffer buffer ;
    
    (* Play it with a higher pitch -- the first sound remains unchanged *)
    sound2#set_pitch 2 ;
    sound2#play
    ]}*)
class sound_buffer :
object
  (**/**)
  val t_sound_bufferCpp : SoundBuffer.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the number of channels used by the sound.

      If the sound is mono then the number of channels will be 1, 2 for stereo, etc.
      @return Number of channels*)
  method get_channel_count : int

  (** Get the total duration of the sound. 
      @return Sound duration*)
  method get_duration : OcsfmlSystem.Time.t

  (** Get the number of samples stored in the buffer.

      The array of samples can be accessed with the getSamples() function.
      @return Number of samples.*)
  method get_sample_count : int

  (** Get the sample rate of the sound.

      The sample rate is the number of samples played per second. The higher, the better the quality (for example, 44100 samples/s is CD quality).
      @return Sample rate (number of samples per second)*)
  method get_sample_rate : int

  (** Get the array of audio samples stored in the buffer.

      The format of the returned samples is 16 bits signed integer (sf::Int16). The total number of samples in this array is given by the getSampleCount() function.
      @return Bigarray of sound samples*)
  method get_samples : samples_type

  (** Load the sound buffer from a file.

      Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
      @return True if loading succeeded, false if it failed*)
  method load_from_file : string -> bool


  (** Load the sound buffer from an array of audio samples.

      The assumed format of the audio samples is 16 bits signed integer (sf::Int16).
      @return True if loading succeeded, false if it failed *)
  method load_from_samples : samples_type -> int -> int -> bool

  (** Load the sound buffer from a custom stream.

      Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
      @return True if loading succeeded, false if it failed*)
  method load_from_stream : OcsfmlSystem.input_stream -> bool

  (**/**)
  method rep__sf_SoundBuffer : SoundBuffer.t
  (**/**)

  (** Save the sound buffer to an audio file.

      Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
      @return True if saving succeeded, false if it failed*)
  method save_to_file : string -> bool
end

val mk_sound_buffer :
  [< `File of string
  | `Samples of samples_type * int * int
  | `Stream of OcsfmlSystem.input_stream ] ->
  sound_buffer


module Sound_recorder :
sig
  type t
  val destroy : t -> unit
  val start : t -> ?sampleRate:int -> unit -> unit
  val stop : t -> unit
  val get_sample_rate : t -> int
end


(** Abstract base class for capturing sound data.

    OcsfmlAudi.sound_recorder provides a simple interface to access the audio recording capabilities of the computer (the microphone).
    
    As an abstract base class, it only cares about capturing sound samples, the task of making something useful with them is left to the derived class. Note that SFML provides a built-in specialization for saving the captured data to a sound buffer (see OcsfmlAudio.sound_buffer_recorder). *)
class sound_recorder : Sound_recorder.t ->
object
  (**/**)
  val t_sound_recorder : Sound_recorder.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the sample rate.

      The sample rate defines the number of audio samples captured per second. The higher, the better the quality (for example, 44100 samples/sec is CD quality).
      @return Sample rate, in samples per second *)
  method get_sample_rate : int

  (**/**)
  method rep__sf_SoundRecorder : Sound_recorder.t
  (**/**)

  (** Start the capture.

      The {i sampleRate} parameter defines the number of audio samples captured per second. The higher, the better the quality (for example, 44100 samples/sec is CD quality). This function uses its own thread so that it doesn't block the rest of the program while the capture runs. Please note that only one capture can happen at the same time.
      @param sampleRate Desired capture rate, in number of samples per second *)
  method start : ?sampleRate:int -> unit -> unit

  (** Stop the capture. *)
  method stop : unit
end


module SoundRecorder :
sig
  (** Check if the system supports audio capture.

      This function should always be called before using the audio capture features. If it returns false, then any attempt to use OcsfmlAudio.sound_recorder or one of its derived classes will fail.*)
  val is_available : unit -> bool
end
  
(** Specialized sound_recorder which stores the captured audio data into a sound buffer.
    
    OcsfmlAudio.sound_buffer_recorder allows to access a recorded sound through a OcsfmlAudio.sound_buffer, so that it can be played, saved to a file, etc.
    
    It has the same simple interface as its base class (start, stop) and adds a function to retrieve the recorded sound buffer (get_buffer).
    
    As usual, don't forget to call the SoundRecorder.is_available() function before using this class (see OcsfmlAudio.SoundRecorder for more details about this).

    Usage example:
    {[
    if SoundRecorder.is_available ()
    then begin
        (* Record some audio data *)
        let recorder = new sound_buffer_recorder in
        recorder#start () ;
        ...
        recorder#stop ;
    
        (* Get the buffer containing the captured audio data *)
        let buffer = recorder#getBuffer in
    
        // Save it to a file (for example...)
        buffer#save_to_file "my_record.ogg"
    end
    ]} *)
module SoundBufferRecorder :
sig
  type t
  val destroy : t -> unit
  val to_sound_recorder : t -> Sound_recorder.t
  val default : unit -> t
  val get_buffer : t -> sound_buffer
end
class sound_buffer_recorder :
object
	inherit sound_recorder

  (**/**)
  val t_sound_buffer_recorderCpp : SoundBufferRecorder.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the sound buffer containing the captured audio data.

      The sound buffer is valid only after the capture has ended. This function provides a read-only access to the internal sound buffer, but it can be copied if you need to make any modification to it.*)
  method get_buffer : sound_buffer

  (**/**)
  method rep__sf_SoundBufferRecorder : SoundBufferRecorder.t
  (**/**)
end

module Sound :
sig
  type t
  val destroy : t -> unit
  val to_sound_source : t -> Sound_source.t
  val default : unit -> t
  val create_from_sound_buffer : sound_buffer -> t
  val play : t -> unit
  val pause : t -> unit
  val stop : t -> unit
  val set_buffer : t -> sound_buffer -> unit
  val set_loop : t -> bool -> unit
  val set_playing_offset : t -> OcsfmlSystem.Time.t -> unit
  val get_buffer : t -> sound_buffer
  val get_loop : t -> bool
  val get_playing_offset : t -> OcsfmlSystem.Time.t
  val get_status : t -> status
end

(** Regular sound that can be played in the audio environment.
    
    OcsfmlAudio.sound is the class to use to play sounds.
    
    It provides:
    
    - Control (play, pause, stop)
    - Ability to modify output parameters in real-time (pitch, volume, ...)
    - 3D spatial features (position, attenuation, ...).
    
    OcsfmlAudio.sound is perfect for playing short sounds that can fit in memory and require no latency, like foot steps or gun shots. For longer sounds, like background musics or long speeches, rather see OcsfmlAudio.music (which is based on streaming).
    
    In order to work, a sound must be given a buffer of audio data to play. Audio data (samples) is stored in OcsfmlAudio.sound_buffer, and attached to a sound with the set_buffer function. The buffer object attached to a sound must remain alive as long as the sound uses it. Note that multiple sounds can use the same sound buffer at the same time.
    
    Usage example:
    {[
    let buffer = new buffer in
    buffer#load_from_file "sound.wav" ;
    
    let sound = new sound in
    sound#set_buffer buffer ;
    sound#play ;
    ]}*)
class sound :
object
  (**)
  inherit sound_source

  (**/**)
  val t_soundCpp : Sound.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the audio buffer attached to the sound.
      @return Sound buffer attached to the sound *)
  method get_buffer : sound_buffer

  (** Tell whether or not the sound is in loop mode. 
      @return True if the sound is looping, false otherwise*)
  method get_loop : bool

  (** Get the current playing position of the sound. 
      @return Current playing position, from the beginning of the sound*)
  method get_playing_offset : OcsfmlSystem.Time.t

  (** Get the current status of the sound (stopped, paused, playing) 
      @return Current status of the sound *)
  method get_status : status

  (** Pause the sound.

      This function pauses the sound if it was playing, otherwise (sound already paused or stopped) it has no effect.*)
  method pause : unit

  (** Start or resume playing the sound.

      This function starts the stream if it was stopped, resumes it if it was paused, and restarts it from beginning if it was it already playing. This function uses its own thread so that it doesn't block the rest of the program while the sound is played.*)
  method play : unit

  (**/**)
  method rep__sf_Sound : Sound.t
  (**/**)

  (** Set the source buffer containing the audio data to play.

      It is important to note that the sound buffer is not copied, thus the sf::SoundBuffer instance must remain alive as long as it is attached to the sound.*)
  method set_buffer : sound_buffer -> unit

  (** Set whether or not the sound should loop after reaching the end.

      If set, the sound will restart from beginning after reaching the end and so on, until it is stopped or setLoop(false) is called. The default looping state for sound is false.*)
  method set_loop : bool -> unit

  (** Change the current playing position of the sound.

      The playing position can be changed when the sound is either paused or playing.*)
  method set_playing_offset : OcsfmlSystem.Time.t -> unit

  (** Stop playing the sound.

      This function stops the sound if it was playing or paused, and does nothing if it was already stopped. It also resets the playing position (unlike pause).*)
  method stop : unit
end


val mk_sound :
  ?loop:bool ->
  ?buffer:sound_buffer ->
  ?playing_offset:OcsfmlSystem.Time.t ->
  ?pitch:float ->
  ?volume:float ->
  ?position:float * float * float ->
  ?relative_to_listener:bool ->
  ?min_distance:float -> ?attenuation:float -> unit -> sound
