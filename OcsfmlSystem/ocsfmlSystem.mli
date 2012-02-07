
(** Raised when an object can't load its resources *)
exception LoadFailure

(** module Time : time conversions utility *)
module Time :
  sig
    type t 
    val as_seconds : t -> float
    val as_milliseconds : t -> int
    val as_microseconds : t -> int64
    val seconds : float -> t
    val milliseconds : int -> t
    val microseconds : int64 -> t
  end


(** Module Clock & class clock : basic time recording*)

module Clock : 
  sig
    type t
    external destroy : t -> unit = "sf_Clock_destroy__impl"
    external create : unit -> t = "sf_Clock_default_constructor__impl"
    external get_elapsed_time : t -> Time.t = "sf_Clock_GetElapsedTime__impl"
    external restart : t -> Time.t = "sf_Clock_Restart__impl"
  end

class clock : 
  object
    val t_clockCpp : Clock.t
    method destroy : unit -> unit
    method get_elapsed_time : Time.t
    method rep__sf_Clock : Clock.t
    method restart : Time.t
  end


(** sleep s : wait during time s before waking up *)

external sleep : Time.t -> unit = "sf_Sleep__impl" 


(** common interface for all input streams
 *  currently doesn't work properly (not used anywhere)
 *)

class virtual input_stream :
object 
  method virtual get_size : int
  method virtual read : int -> string * int
  method virtual seek : int -> int
  method virtual tell : int
end

