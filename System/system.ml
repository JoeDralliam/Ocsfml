external class clock : "sf_Clock" =
object
  constructor create : unit = "default_constructor"
  external method get_elapsed_time : unit -> int = "GetElapsedTime"
  external method reset : unit -> unit = "Reset"
end

external sleep : int -> unit = "sf_Sleep"

external class thread : "sf_Thread" =
object
  constructor create : (unit -> unit) -> unit = "create_from_function"
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
