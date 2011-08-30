(** module System : contains all SFML/System class and functions *)


module Clock :
sig
  type t
  external destroy : t -> unit = "sf_Clock_destroy__impl"
  external create : unit -> t = "sf_Clock_default_constructor__impl"
  external get_elapsed_time : t -> int = "sf_Clock_GetElapsedTime__impl"
  external reset : t -> unit = "sf_Clock_Reset__impl"
end
  
class clock : 
object
  method destroy : unit -> unit
  method get_elapsed_time : unit -> int
  method rep__sf_Clock : Clock.t
  method reset : unit -> unit
end
  
external sleep : int -> unit = "sf_Sleep__impl"
  
type func0 = unit -> unit
  
module Thread :
sig
  type t
  external destroy : t -> unit = "sf_Thread_destroy__impl"
  external create : func0 -> t = "sf_Thread_create_from_function__impl"
  external launch : t -> unit = "sf_Thread_Launch__impl"
  external wait : t -> unit = "sf_Thread_Wait__impl"
  external terminate : t -> unit = "sf_Thread_Terminate__impl"
end
  
class thread : func0 -> 
object
  method destroy : unit -> unit
  method launch : unit -> unit
  method rep__sf_Thread : Thread.t
  method terminate : unit -> unit
  method wait : unit -> unit
end

module Mutex :
sig
  type t
  external destroy : t -> unit = "sf_Mutex_destroy__impl"
  external create : unit -> t = "sf_Mutex_default_constructor__impl"
  external lock : t -> unit = "sf_Mutex_Lock__impl"
  external unlock : t -> unit = "sf_Mutex_Unlock__impl"
end
  
class mutex : 
object
    method destroy : unit -> unit
    method lock : unit -> unit
    method rep__sf_Mutex : Mutex.t
    method unlock : unit -> unit
end

class virtual input_stream :
object
  method virtual get_size : unit -> int
  method virtual read : int -> string * int
  method virtual seek : int -> int
  method virtual tell : unit -> int
end
  
