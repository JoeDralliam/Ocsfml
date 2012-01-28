open OcsfmlSystem

let _ =
  let ck = new clock in
    ck#restart () ;
(*    sleep 500 ; *)
    print_int (Time.as_milliseconds( ck#get_elapsed_time ())) ;
    ck#restart ();
    print_newline ();
    print_int (Time.as_milliseconds( ck#get_elapsed_time ())) ;
    print_newline () ;
    (* ck#destroy ()*)
    Gc.full_major ()

