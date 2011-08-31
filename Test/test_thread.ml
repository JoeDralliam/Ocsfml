open System

let mtx = new mutex;;

let h () =
  for i = 0 to 10 do
	mtx#lock ();
	print_string "Bonjour";
	print_newline () ;
	flush stdout ;
	mtx#unlock ();
	sleep 50  
  done


let f () =
  for i = 0 to 10 do
	mtx#lock ();
	print_string "Bonsoir";
	print_newline () ;
	flush stdout ;
	mtx#unlock ();
	sleep 50
  done

let g s n () =
  for i = 0 to n do
    print_string s ;
    print_newline () ;
(*    flush stdout *)
  done

let _ =
  let t1 = new thread h
  and t2 = new thread f in 
    Gc.full_major () ;
    t1#launch () ;
    t2#launch () ;
(*    sleep 5000 ; *)
    t1#wait () ;
    t2#wait () ;
    t1#destroy () ;
    t2#destroy () 
