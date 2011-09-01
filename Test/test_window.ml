open Window

let rec boucle_evenement app =
  match app#poll_event () with
    | Some e -> (
	Event.(
	  match e with
	    | Closed | KeyPressed { code = KeyCode.Escape ; _ } -> app#close () 
	    | _ -> () );
	boucle_evenement app )
    | None -> ()
	
let dessiner app = app#display ()

let rec boucle_principale app =
  if app#is_opened () 
  then begin
    boucle_evenement app ;
    dessiner app ;
    boucle_principale app
  end


let window_test () =
  let window = new window (Window.create_init (VideoMode.get_desktop_mode ()) "SF2ML2") in
    boucle_principale window ;
    window#destroy ()

let _ = window_test()





