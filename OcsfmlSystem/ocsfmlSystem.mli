(** Time management & input stream *)


type raw_data_type = (char, Bigarray.int8_signed_elt, Bigarray.c_layout) Bigarray.Array1.t

(** Raised when an object can't load its resources *)
exception LoadFailure

(** Module Time : time conversions utility *)
module Time :
sig
  (** Represents a time value 
      Time.t encapsulates a time value in a flexible way.
      
      It allows to define a time value either as a number of seconds, milliseconds or microseconds. It also works the other way round: you can read a time value as either a number of seconds, milliseconds or microseconds.
      
      By using such a flexible interface, the API doesn't impose any fixed type or resolution for time values, and let the user choose its own favorite representation.
      
      Time values support the usual mathematical operations: you can add or subtract two times, multiply or divide a time by a number, compare two times, etc.
      
      Since they represent a time span and not an absolute time value, times can also be negative.
      
      Usage example:
      {[
      let t1 = Time.seconds 0.1 in
      let milli = Time.as_milliseconds t1 in // 100
	
      let t2 = Time.milliseconds 30  in
      let micro = Time.as_microseconds t2 in // 30000
      
      let t3 = Time.microseconds -800000L in
      let sec = Time.as_seconds t3 in // -0.8
      
      let update elapsed =
          position := position +. speed *. (Time.as_seconds elapsed)
      
      update (Time.milliseconds 100)
      ]}
  *)
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
    
  val add : t -> t -> t
    
  val sub : t -> t -> t
    
  val mul : t -> int64 -> t
    
  val mul_float : t -> float -> t
    
  val div : t -> int64 -> t
    
  val div_float : t -> float -> t
end
  
(**/**)
(** Module Clock & class clock : basic time recording*)
module Clock : 
sig
  type t
  val destroy : t -> unit 
  val create : unit -> t
  val get_elapsed_time : t -> Time.t
  val restart : t -> Time.t
end
(**/**)
  
(** Utility class that measures the elapsed time. 
      clock is a lightweight class for measuring time.
    
    Its provides the most precise time that the underlying OS can achieve (generally microseconds or nanoseconds). It also ensures monotonicity, which means that the returned time can never go backward, even if the system time is changed.
    
    Usage example:
    {[
    let clock;= new clock in
    ...
    let time1 = clock#get_elapsed_time in
    ...
    let time2 = clock#restart in
    ]} 
    The time value returned by the clock can then be converted to a number of seconds, milliseconds or even microseconds. *)
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
    sleep is the best way to block a program or one of its threads, as it doesn't consume any CPU power.*)
val sleep : Time.t -> unit
  

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

