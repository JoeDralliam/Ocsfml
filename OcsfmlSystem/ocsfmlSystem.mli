exception LoadFailure
val do_if : ('a -> unit) -> 'a option -> unit
module Clock :
  sig
    type t
    external destroy : t -> unit = "sf_Clock_destroy__impl"
    external create : unit -> t = "sf_Clock_default_constructor__impl"
    external get_elapsed_time : t -> int = "sf_Clock_GetElapsedTime__impl"
    external reset : t -> unit = "sf_Clock_Reset__impl"
  end
class clockCpp :
  Clock.t ->
  object
    val t_clockCpp : Clock.t
    method destroy : unit -> unit
    method get_elapsed_time : unit -> int
    method rep__sf_Clock : Clock.t
    method reset : unit -> unit
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
