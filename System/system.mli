module ClockCpp :
  sig
    type t_clockCpp
    external destroy : t_clockCpp -> unit = "sf_Clock_destroy__impl"
    external create : unit -> t_clockCpp = "sf_Clock_default_constructor__impl"
    external get_elapsed_time : t_clockCpp -> int = "sf_Clock_GetElapsedTime__impl"
    external reset : t_clockCpp -> unit = "sf_Clock_Reset__impl"
  end

class clockCpp :
  ClockCpp.t_clockCpp ->
  object
    method destroy : unit -> unit
    method get_elapsed_time : unit -> int
    method rep__sf_Clock : ClockCpp.t_clockCpp
    method reset : unit -> unit
  end

class clock : clockCpp

external sleep : int -> unit = "sf_Sleep__impl"

type func0 = unit -> unit

module ThreadCpp :
  sig
    type t_threadCpp
    external destroy : t_threadCpp -> unit = "sf_Thread_destroy__impl"
    external create : func0 -> t_threadCpp
      = "sf_Thread_create_from_function__impl"
    external launch : t_threadCpp -> unit = "sf_Thread_Launch__impl"
    external wait : t_threadCpp -> unit = "sf_Thread_Wait__impl"
    external terminate : t_threadCpp -> unit = "sf_Thread_Terminate__impl"
  end

class threadCpp :
  ThreadCpp.t_threadCpp ->
  object
    val t_threadCpp : ThreadCpp.t_threadCpp
    method destroy : unit -> unit
    method launch : unit -> unit
    method rep__sf_Thread : ThreadCpp.t_threadCpp
    method terminate : unit -> unit
    method wait : unit -> unit
  end

class thread : func0 -> threadCpp

module MutexCpp :
  sig
    type t_mutexCpp
    external destroy : t_mutexCpp -> unit = "sf_Mutex_destroy__impl"
    external create : unit -> t_mutexCpp
      = "sf_Mutex_default_constructor__impl"
    external lock : t_mutexCpp -> unit = "sf_Mutex_Lock__impl"
    external unlock : t_mutexCpp -> unit = "sf_Mutex_Unlock__impl"
  end

class mutexCpp :
  MutexCpp.t_mutexCpp ->
  object
    val t_mutexCpp : MutexCpp.t_mutexCpp
    method destroy : unit -> unit
    method lock : unit -> unit
    method rep__sf_Mutex : MutexCpp.t_mutexCpp
    method unlock : unit -> unit
  end

class mutex : mutexCpp

class virtual input_stream :
  object
    method virtual get_size : unit -> int
    method virtual read : int -> string * int
    method virtual seek : int -> int
    method virtual tell : unit -> int
  end
