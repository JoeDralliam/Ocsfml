external class clock : "sf_Clock" =
object
  constructor create : unit = "default_constructor"
  external method get_elapsed_time : unit -> int = "GetElapsedTime"
  external method reset : unit -> unit = "Reset"
end

external sleep : int -> unit = "sf_Sleep"

type func0 = unit -> unit

external class thread : "sf_Thread" =
object
  constructor create : func0 = "create_from_function"
  external method launch : unit -> unit = "Launch"
  external method wait : unit -> unit = "Wait"
  external method terminate : unit -> unit = "Terminate"
end

external class mutex : "sf_Mutex" =
object
  constructor create : unit = "default_constructor"
  external method lock : unit -> unit = "Lock"
  external method unlock : unit -> unit = "Unlock"
end

class virtual input_stream =
object
  method virtual read : int -> string * int
  method virtual seek : int -> int
  method virtual tell : unit -> int
  method virtual get_size : unit -> int
end
