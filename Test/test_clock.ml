open OcsfmlSystem

let _ =
  let ck = new clock in
    ignore( ck#restart () ) ;
    sleep (Time.milliseconds 500) ;
    print_int (Time.as_milliseconds( ck#get_elapsed_time ())) ;
    ignore( ck#restart () );
    print_newline ();
    print_int (Time.as_milliseconds( ck#get_elapsed_time ())) ;
    print_newline () ;
    Gc.full_major ()

