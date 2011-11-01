

external call_C : unit -> float*float = "test1__impl"

let (&>) f (x,y) = (f x,f y)

let _ = print_float &> (call_C ());;

