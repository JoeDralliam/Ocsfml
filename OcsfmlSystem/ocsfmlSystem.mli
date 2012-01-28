exception LoadFailure
val do_if : ('a -> unit) -> 'a option -> unit
module Time :
  sig
    type t
    val as_seconds : t -> float
    val as_milliseconds : t -> int
    val as_microseconds : t -> t
    val seconds : float -> t
    val milliseconds : int -> t
    val microseconds : int -> t
  end
module Clock :
  sig
    type t
    external destroy : t -> unit = "sf_Clock_destroy__impl"
    external create : unit -> t = "sf_Clock_default_constructor__impl"
    external get_elapsed_time : t -> Time.t = "sf_Clock_GetElapsedTime__impl"
    external restart : t -> Time.t = "sf_Clock_Restart__impl"
  end
class clockCpp :
  Clock.t ->
  object
    val t_clockCpp : Clock.t
    method destroy : unit -> unit
    method get_elapsed_time : unit -> Time.t
    method rep__sf_Clock : Clock.t
    method restart : unit -> Time.t
  end
class clock_bis : unit -> clockCpp
class clock : clock_bis
class virtual input_stream :
  object
    method virtual get_size : unit -> int
    method virtual read : int -> string * int
    method virtual seek : int -> int
    method virtual tell : unit -> int
  end
