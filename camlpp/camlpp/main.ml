

type t = { x:float ; y:float }

external call_C : unit -> float*float = "test1__impl"

let (&>) f (x,y) = (f x,f y)

let _ = for i = 0 to 10000
	do 
		print_float &> (call_C ())
	done;;
