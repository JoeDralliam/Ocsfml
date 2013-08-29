type raw_data_type =
    (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

exception LoadFailure
  
let do_if f = function | Some x -> f x | None -> ()
  
module Time =
struct
  type t = int64
      
  let as_seconds (time : t) = (Int64.to_float time) /. 1000000.
    
  let as_milliseconds (time : t) = Int64.to_int (Int64.div time 1000L)
    
  let as_microseconds (time : t) = time
    
  let seconds s = Int64.of_float (s *. 1000000.)
    
  let milliseconds m = Int64.mul (Int64.of_int m)  1000L
    
  let microseconds m = m
    
  let add = Int64.add
    
  let sub = Int64.sub
    
  let mul = Int64.mul
    
  let mul_float t scl = Int64.of_float ((Int64.to_float t) *. scl)
    
  let div = Int64.div
    
  let div_float t scl = Int64.of_float ((Int64.to_float t) /. scl)
    
end
  
module Clock =
struct
  type t
    
  external destroy : t -> unit = "sf_Clock_destroy__impl"
      
  external create : unit -> t = "sf_Clock_default_constructor__impl"
      
  external get_elapsed_time : t -> Time.t = "sf_Clock_getElapsedTime__impl"
      
  external restart : t -> Time.t = "sf_Clock_restart__impl"
      
end
  
class clock_base t =
object ((self : 'self))
  val t_clockCpp = (t : Clock.t)
  method rep__sf_Clock = t_clockCpp
  
  method destroy = Clock.destroy t_clockCpp
  
  method get_elapsed_time : Time.t = Clock.get_elapsed_time t_clockCpp

  method restart : Time.t = Clock.restart t_clockCpp
end
  
class clock_bis () = 
  let ck = Clock.create () in clock_base ck
						   
class clock = clock_bis ()


external sleep : Time.t -> unit = "sf_sleep__impl"
  
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
object method virtual read : raw_data_type -> int -> int
       method virtual seek : int -> int
       method virtual tell : int
       method virtual get_size : int
end
  

