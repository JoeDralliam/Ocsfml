

type t = { x:float ; y:float }

external test1 : (unit -> unit) -> unit = "test1__impl"
external test2 : (unit -> unit) -> unit = "test2__impl"
external test2bis : unit -> unit = "test2bis__impl"

let ponct = ref '.'

let hello_world () =
  print_string "And now...\n" ;
  ponct := '!'

let _ = 
  test2 hello_world ;
  for i = 1 to 100000
  do
    print_char !ponct ;
    if (i-(i/190)*190) = 0 
    then print_newline ()
  done ;
  test2bis () ;
  print_string "exiting\n"

