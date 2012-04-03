(** Time management & input stream *)


(** Raised when an object can't load its resources *)
exception LoadFailure

(** Module Time : time conversions utility *)
module Time :
  sig
    (** Represents a time value **)
    type t 

    (** Return the time value as a number of seconds 
	@return Time in seconds *)
    val as_seconds : t -> float

    (** Return the time value as a number of milliseconds
	@return Time in milliseconds *)
    val as_milliseconds : t -> int

    (** Return the time value as a number of microseconds
	@return Time in microseconds *)
    val as_microseconds : t -> int64

    (** Construct a time value from a number of seconds
	@return Time value constructed from the amount of seconds *)
    val seconds : float -> t

    (** Construct a time value from a number of milliseconds
	@return Time value constructed from the amount of milliseconds *)
    val milliseconds : int -> t

    (** Construct a time value from a number of microseconds
	@return Time value constructed from the amount of microseconds *)
    val microseconds : int64 -> t
  end


(** Module Clock & class clock : basic time recording*)
module Clock : 
  sig
    (**/**)
    type t
    external destroy : t -> unit = "sf_Clock_destroy__impl"
    external create : unit -> t = "sf_Clock_default_constructor__impl"
    external get_elapsed_time : t -> Time.t = "sf_Clock_getElapsedTime__impl"
    external restart : t -> Time.t = "sf_Clock_restart__impl"
  end

(** Utility class that measures the elapsed time. *)
class clock : 
object
  (**/**)
  val t_clockCpp : Clock.t

  (**/**)    
  method destroy : unit

  (** Get the elapsed time.
      This function returns the time elapsed since the last call to restart (or the construction of the instance if restart has not been called). *)
  method get_elapsed_time : Time.t
  
  (**/**)
  method rep__sf_Clock : Clock.t
  (**/**)

  (** Restart the clock.
      This function puts the time counter back to zero. It also returns the time elapsed since the clock was started. *)
  method restart : Time.t
end


(** Make the current thread sleep for a given duration.
    sf::sleep is the best way to block a program or one of its threads, as it doesn't consume any CPU power.*)
external sleep : Time.t -> unit = "sf_sleep__impl" 
  

(** Common interface for all input streams
    currently doesn't work properly (not used anywhere)
 *)
class virtual input_stream :
object 
  method virtual get_size : int
  method virtual read : int -> string * int
  method virtual seek : int -> int
  method virtual tell : int
end

