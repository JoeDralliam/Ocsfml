open OcsfmlSystem

let _ =
  let ck = new clock in
    ck#reset () ;
    sleep 500 ;
    print_int (ck#get_elapsed_time ()) ;
    ck#reset ();
    print_newline ();
    print_int (ck#get_elapsed_time ()) ;
    print_newline () ;
    (* ck#destroy ()*)
    Gc.full_major ()

