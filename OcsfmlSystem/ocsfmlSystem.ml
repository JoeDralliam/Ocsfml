exception LoadFailure

let do_if f = function
    | Some x -> f x
    | None -> ()

external class clockCpp (Clock): "sf_Clock" =
object
  constructor create : unit = "default_constructor"
  external method get_elapsed_time : unit -> int = "GetElapsedTime"
  external method reset : unit -> unit = "Reset"
end

class clock_bis () = 
  let ck = Clock.create () in 
    clockCpp ck

class clock =
  clock_bis ()

(*external cpp sleep : int -> unit = "sf_Sleep"

type func0 = unit -> unit

external class threadCpp (Thread) : "sf_Thread" =
object
  constructor create : func0 = "create_from_function"
  external method launch : unit -> unit = "Launch"
  external method wait : unit -> unit = "Wait"
  external method terminate : unit -> unit = "Terminate"
end

class thread f = 
  let th = Thread.create f in 
    threadCpp th

external class mutexCpp (Mutex) : "sf_Mutex" =
object
  constructor create : unit = "default_constructor"
  external method lock : unit -> unit = "Lock"
  external method unlock : unit -> unit = "Unlock"
end

class mutex_bis () = 
  let mu = Mutex.create () in 
    mutexCpp mu

class mutex =
  mutex_bis ()
*)
(* Note : New cpp workaround does implement thread *)

class virtual input_stream =
object
  method virtual read : int -> string * int
  method virtual seek : int -> int
  method virtual tell : unit -> int
  method virtual get_size : unit -> int
end
