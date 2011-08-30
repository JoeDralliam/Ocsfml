open System

let g s n () =
  for i = 0 to n do
    print_string s ;
    print_newline () ;
    flush stdout
  done

let _ =
  let t1 = new thread (g "bonjour" 1000)
  and t2 = new thread (g "bonsoir" 1000) in
    t1#launch () ;
    t2#launch () ;
    sleep 500 ;
    t1#wait () ;
    t2#wait () ;
    t1#destroy () ;
    t2#destroy () 
