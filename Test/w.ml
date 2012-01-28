open OcsfmlWindow
open OcsfmlGraphics

let _ =
  let app = new render_window (VideoMode.create ~w:400 ~h:400 ()) "Graphic Clock" in
  let clock_center = 200., 200. in
  let clock = 
    let radius = 100. in
    let position = (fst clock_center) -. radius, (snd clock_center) -.radius in
      mk_circle_shape 
	~position
	~radius
	~fill_color:Color.white
	~outline_color:Color.black
	~outline_thickness:5. ()
  in
  let minutes = mk_text ~string:"Minutes !" ~color:Color.black () in
  let hours = mk_text ~string:"Hours !" ~color:Color.black () in
    

  let place x w = 
    let rect = x # get_local_bounds () in
    let factor = w /. rect.width in
      Printf.printf "%f" factor ;
    let delta_y = rect.height /. 2. in
      x # set_origin 0. delta_y ; 
      x # scale factor factor;
      x # set_position_v clock_center ; 
      x # set_rotation (-90.)
  in

  let color = Color.rgb 125 125 125 in
  let display () = 
    app # clear ~color () ;
    app # draw clock ;
    app # draw minutes ;
    app # draw hours ;
    app # display ()
  in

  let rec process_event () = 
    let open Event in
      match app # poll_event () with
	| Some (Closed) | Some (KeyPressed { code = KeyCode.Escape ; _ }) ->
	    app # close ()
	| None -> () 
	| _ -> process_event ()
  in

  let run () =
    let i = ref 0 in
      while app # is_open () do
	minutes # rotate 6. ;
	incr i ;
	if !i = 12  
	then ( i := 0 ; hours # rotate 6. ) ;
	Unix.sleep 1 ;
	display () ;
	process_event () 
      done
  in

    place minutes 90. ;
    place hours 50. ;
    run ()
