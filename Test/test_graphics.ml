open Window
open Graphics


let rec event_loop app = 
  match app#poll_event () with
    | Some e -> (
	Event.(
	  match e with
	    | Closed | KeyPressed { code = KeyCode.Escape ; _ } -> app#close () 
	    | _ -> () );
	event_loop app )
    | None -> ()


let hello_world = 
  let t = new text in
    t#set_string "hello_world" ;
    t#set_character_size 65 ;
    t#set_style [ Bold ] ;
    t#set_position 50.0 150.0 ;
    t

let draw (app:#render_window) =
  app#clear () ;  
  app#draw hello_world ; 
  app#display ()
  

let rec main_loop app =
  if app#is_opened () 
  then begin
    event_loop app ;
    draw app ;
    main_loop app
  end


let graphics_test () =
  let vm = VideoMode.( { width=600; height=400; bits_per_pixel=32 } ) in
  let app = new render_window vm "OCSFML2" in
    ignore(app#get_view ()) ;
    main_loop app ;
    app#destroy ()


let _ = graphics_test (); hello_world#destroy ()
