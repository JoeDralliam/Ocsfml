

type t = { x:float ; y:float }

external test1 : (unit -> unit) -> unit = "test1__impl"
external test2 : (unit -> unit) -> unit = "test2__impl"
external test2bis : unit -> unit = "test2bis__impl"


let hello_world () =
  print_endline "hello world !" ;
  flush stdout

let _ = 
  test2 hello_world ;
  for i = 1 to 20000
  do
    print_string "." ;
    if (i-(i/215)*215) = 0 
    then print_newline ()
  done ;
  test2bis () ;
  print_string "exiting\n"

