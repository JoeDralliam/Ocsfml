open System

let _ =
  let ck = new clock (Clock.create ()) in
    ck#reset () ;
    sleep 500 ;
    print_int (ck#get_elapsed_time ()) ;
    ck#reset ();
    print_int (ck#get_elapsed_time ()) ;
    ck#destroy ();
