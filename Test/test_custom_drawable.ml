open OcsfmlSystem
open OcsfmlWindow
open OcsfmlGraphics



let test_drawable () =
  let draw_func (target :#render_target) =
    let txt = mk_text ~string:"Hello Ocsfml !"
                      ~position:(50., 200.)
		      ~character_size:30
		      ~color:Color.blue
		      () in
    target#draw txt ;
    txt#destroy ()
  in

  let vm = VideoMode.({ width=400 ; height=400 ; bits_per_pixel=32 }) in
  let app = new render_window vm "Ocsfml Drawables" in
  
  let custom_drawable = new caml_drawable draw_func in

  let rec event_loop () =
    match app#poll_event () with
      | Some e ->
	Event.( match e with
	  | Closed | KeyPressed { code = KeyCode.Escape ; _ } -> 
	    app#close ()
	  | _ -> () ) ;
	event_loop ()
      | None -> () 
  in
  
  let draw_scene () =
    app#draw custom_drawable
  in

  let rec main_loop () = 
    event_loop () ;
    app#clear  () ; 
    draw_scene () ;
    app#display() ;
    if app#is_opened () then main_loop ()
  in
  main_loop() ;

  custom_drawable#destroy ();
  app#destroy ()

let _ = test_drawable ()
