open System

let mtx = new mutex;;

let h () =
  for i = 0 to 10 do
	print_string "Bonjour";
  done


let f () =
  for i = 0 to 10 do
	print_string "Bonsoir";
  done

let g s n () =
  for i = 0 to n do
    print_string (s^"\n") ;
    sleep 10
(*    flush stdout *)
  done

let _ =
  let t1 = new thread (g "Bonjour" 10)
  and t2 = new thread (g "Bonsoir" 10) in 
    Gc.full_major () ;
    t1#launch () ;
    t2#launch () ;
(*    sleep 5000 *)
    t1#wait () ;
    t2#wait () ;
    t1#destroy () ;
    t2#destroy ()
