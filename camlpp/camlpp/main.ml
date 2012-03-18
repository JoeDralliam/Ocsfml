

type t = { x:float ; y:float }

external call_C : unit -> float*float = "test1__impl"
external test2 : (unit -> unit) -> unit = "test2__impl"
external test2bis : unit -> unit = "test2bis__impl"
external test3 : unit -> unit = "test3"
let (&>) f (x,y) = (f x,f y)

let hello_world () =
  print_string "hello world !"

let _ = test2 hello_world ;
  for i = 10 to 1000
  do
    print_string "c" ;
    if (i-(i/200)*200) = 0 
    then print_newline ()
  done ;
  test2bis () ;
  print_string "exiting\n"

