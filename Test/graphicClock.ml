open OcsfmlSystem
open OcsfmlWindow
open OcsfmlGraphics

let ( & ) f x = f x

let set_time s m h =
  let tm = Unix.localtime & Unix.time () in
  let sec = float_of_int tm.Unix.tm_sec in
  let min = (float_of_int tm.Unix.tm_min) +. (sec /. 60.) in
  let hour = (float_of_int (tm.Unix.tm_hour - 12)) +. (min /. (12.*.60.)) in
  s # set_rotation (sec *. 6. -. 90.) ;
  m # set_rotation (min *. 6. -. 90.) ; 
  h # set_rotation (hour *. 30. -. 90.) 

let _ =
  let app = new render_window (VideoMode.create ~w:400 ~h:400 ()) "Graphic Clock" in
  app # set_framerate_limit 60 ;
  let clock_center = 200., 200. in
  let radius = 150. in
  let clock_display = 
    let position = (fst clock_center) -. radius, (snd clock_center) -.radius in
      mk_circle_shape 
	~position
	~radius
	~fill_color:Color.white
	~outline_color:Color.black
	~outline_thickness:5. ()
  in
  let seconds = mk_text ~string:"Seconds !" ~color:(Color.rgb 255 125 0) () in
  let minutes = mk_text ~string:"Minutes !" ~color:Color.black () in
  let hours = mk_text ~string:"Hours !" ~color:Color.black () in 
  let update_time () = set_time seconds minutes hours in

  let place x w = 
    let rect = x # get_local_bounds in
    let factor = w /. rect.width in
    let delta_y = rect.height /. 2. in
      x # set_origin 0. delta_y ; 
      x # scale factor factor ;
      x # set_position_v clock_center 
  in

  let clean_all () = 
    hours # destroy ;
    minutes # destroy ;
    seconds # destroy ;
    clock_display # destroy ;
    app # destroy
  in


  let color = Color.rgb 125 125 125 in
  let display () = 
    app # clear ~color () ;
    app # draw clock_display ;
    app # draw seconds ;
    app # draw minutes ;
    app # draw hours ;
    app # display
  in

  let rec process_event () = 
    let open Event in
    match app # poll_event with
      | Some (Closed) | Some (KeyPressed { code = KeyCode.Escape ; _ }) ->
	  app # close
      | None -> () 
      | _ -> process_event ()
  in

  let run () =
    while app # is_open do
      update_time () ;
      display () ;
      process_event ()  
    done
  in

  place seconds (radius -. 5.) ;
  place minutes (radius -. 30.) ;
  place hours (radius -. 80.) ;
  run () ;

  clean_all ()
