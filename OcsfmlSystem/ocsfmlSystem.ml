type raw_data_type = (char, Bigarray.int8_signed_elt, Bigarray.c_layout) Bigarray.Array1.t

exception LoadFailure


let do_if f = function
    | Some x -> f x
    | None -> ()


module Time =
struct
  type t = int64
      
  let as_seconds (time:t) =
    (Int64.to_float time) /. 1000000.
      
  let as_milliseconds (time:t) =
    (Int64.to_int time) / 1000
      
  let as_microseconds (time:t) =
    time
      
  let seconds s =
    Int64.of_float (s *. 1000000.)
      
  let milliseconds m = 
    Int64.of_int (m * 1000)
      
  let microseconds m =
    m
end

external class clockCpp (Clock): "sf_Clock" =
object
  constructor create : unit = "default_constructor"
  external method get_elapsed_time : Time.t = "getElapsedTime"
  external method restart : Time.t = "restart"
end

class clock_bis () = 
  let ck = Clock.create () in 
    clockCpp ck

class clock =
  clock_bis ()

external cpp sleep : Time.t -> unit = "sf_sleep"
(*
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
  method virtual tell : int
  method virtual get_size : int
end
