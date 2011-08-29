external class clock : "sf_Clock" =
object
  constructor create : unit = "default_constructor"
  external method get_elapsed_time : unit -> int = "GetElapsedTime"
  external method reset : unit -> unit = "Reset"
end

external sleep : int -> unit = "sf_Sleep"
