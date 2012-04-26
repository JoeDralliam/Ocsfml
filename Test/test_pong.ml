open OcsfmlSystem
open OcsfmlWindow
open OcsfmlGraphics
open OcsfmlAudio
open Bigarray
let pi = 4.0 *. atan 1.0

let ( & ) f x = f x

(*
let icon = 
  Array2.of_array pixel_array_kind pixel_array_layout
    [|[|255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255|];
      [|255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255|];
      [|255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255|];
      [|255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255; 255; 0; 0; 255|]|]
*)

let test_pong () = 
  Random.self_init () ;

  let icon = new image (`File "resources/sfml_icon.png") in

  let game_width = 800 in
  let game_height = 600 in
  let paddle_sizeX = 25. in
  let paddle_sizeY = 100. in
  let ball_radius = 10. in
  
  let vm = VideoMode.create ~w:game_width ~h:game_height () in
  let app = new render_window vm  "Ocsfml - Pong" in
  app#set_icon icon#get_pixels_ptr ;
  let font = new font (`File "resources/sansation.ttf") in
  let ball_sound_buffer = new sound_buffer (`File "resources/ball.wav") in


  let pauseMessage = new text ~font ~character_size:40 ~position:(170.0, 150.0) ~color:Color.white
			     ~string:"Welcome to SFML pong!\nPress space to start the game" () in

  let left_paddle = new rectangle_shape ~size:(paddle_sizeX -. 3., paddle_sizeY -. 3.) 
					~outline_thickness:3.
					~outline_color:Color.black 
					~fill_color:(Color.rgb 100 100 200)
					~origin:(paddle_sizeX /. 2., paddle_sizeY /. 2.) () in
  (* ignore left_paddle#get_size ; *)
  let right_paddle = new rectangle_shape ~size:(paddle_sizeX -. 3., paddle_sizeY -. 3.) 
                                         ~outline_thickness:3. 
					 ~outline_color:Color.black 
					 ~fill_color:(Color.rgb 200 100 100)
					 ~origin:(paddle_sizeX /. 2., paddle_sizeY /. 2.) () in

  let ball = new circle_shape ~radius:(ball_radius -. 3.)
			      ~outline_thickness:3.
			      ~outline_color:Color.black
			      ~fill_color:Color.white
			      ~origin:(ball_radius /. 2., ball_radius /. 2.) () in

  let ball_sound = new sound ~buffer:ball_sound_buffer () in
  let ai_timer = new clock in
  let ai_time = 300 in
  let paddle_speed = 400.0 in
  let right_paddle_speed = ref 0.0 in

  let global_clock = new clock in
  let ball_speed = 400.0 in
  let ball_angle =
    let angle = acos ((Random.float 0.3) +. 0.7) in
      ref( if Random.bool () then angle +. pi else angle )
  in
  let is_playing = ref false in
  
  let rec event_loop () =
    match app#poll_event with
      | Some e ->
	let open Event in
	    begin
	      match e with
		| Closed 
		| KeyPressed { code = KeyCode.Escape ; _ } -> 
		  app#close 
		| KeyPressed { code = KeyCode.Space ; _ } when not !is_playing ->
		  begin
		    is_playing := true ;
		    let angle = acos ((Random.float 0.3) +. 0.7) in
		    ball_angle := if Random.bool () then angle +. pi else angle ;
		    
		      left_paddle#set_position (10. +. paddle_sizeX /. 2.) (float_of_int & game_height / 2 ) ;
		      right_paddle#set_position ((float_of_int game_width) -. 10. -. paddle_sizeX /. 2.) (float_of_int & game_height / 2 ) ;
		      ball#set_position (float_of_int & game_width / 2 ) (float_of_int & game_height / 2 )
		  end 
		| _ -> () 
	    end ;
	    event_loop ()
      | None -> () 
	in
	
  let update () =
    let interpolation = Time.as_seconds global_clock#restart in
      if !is_playing 
      then 
	begin
	  if Keyboard.is_key_pressed KeyCode.Up && (snd left_paddle#get_position) -. (paddle_sizeY /. 2.) > 5.0 
	  then left_paddle#move 0.0 (-. paddle_speed *. interpolation) ;
	  
	  
	  if Keyboard.is_key_pressed KeyCode.Down && (snd left_paddle#get_position) +. (paddle_sizeY /. 2.) < float_of_int game_height -. 5.0 
	  then left_paddle#move 0.0 (paddle_speed *. interpolation) ;
	  
	  if (!right_paddle_speed < 0.0 && (snd right_paddle#get_position ) -. (paddle_sizeY /. 2.) > 5.0) || 
	    (!right_paddle_speed > 0.0 && (snd right_paddle#get_position ) +. (paddle_sizeY /. 2. ) < float_of_int game_height -. 5.0)
	  then right_paddle#move 0.0 (!right_paddle_speed *. interpolation) ;
	  
	  let rgt_pos = right_paddle#get_position in
	  
	  let lft_pos = left_paddle#get_position in
	  
	      if Time.as_milliseconds ai_timer#get_elapsed_time > ai_time
	      then 
		begin
		  ignore ai_timer#restart ;
		  if (snd ball#get_position) +. ball_radius > snd rgt_pos +. (paddle_sizeY /. 2.)
		  then right_paddle_speed :=  paddle_speed
		  else if (snd ball#get_position ) -. ball_radius < snd rgt_pos -. (paddle_sizeY /. 2.)
		  then right_paddle_speed := -. paddle_speed
		  else right_paddle_speed := 0. ;
		end;
	    
	      (** Update Ball Position **)
	      let factor = ball_speed *. interpolation in
		ball#move ((cos !ball_angle) *. factor) ((sin !ball_angle) *. factor) ;
		
		let ball_pos = ball#get_position in
		  if fst ball_pos < 0.0
		  then 
		    begin
		      is_playing := false;
		      pauseMessage#set_string "You lost !\nPress space to restart or\nescape to exit"
		    end;
		  if fst ball_pos +. ball_radius > float_of_int game_width
		  then 
		    begin
		      is_playing := false;
		      pauseMessage#set_string "You won !\nPress space to restart or\nescape to exit"
		    end;
		  if snd ball_pos -. ball_radius < 0.0
		  then 
		    begin
		      ball_sound#play ; 
		      ball_angle := -. !ball_angle;
		      ball#set_position (fst ball_pos) (ball_radius +. 0.1)
		    end;
		  if snd ball_pos +. ball_radius > float_of_int game_height
		  then 
		    begin
		      ball_sound#play ;
		      ball_angle := -. !ball_angle;
		      ball#set_position (fst ball_pos)  (float_of_int game_height -. ball_radius -. 0.1)
		    end;
		  let ball_pos = ball#get_position in
		  (** Check collision between the paddles and the ball **)
		  if (fst ball_pos -. ball_radius < fst lft_pos +. paddle_sizeX /. 2.) &&
		     (fst ball_pos -. ball_radius >  fst lft_pos) &&
		     (snd ball_pos +. ball_radius >= snd lft_pos -. paddle_sizeY /. 2.) &&
           	     (snd ball_pos -. ball_radius <= snd lft_pos +. paddle_sizeY /. 2.)
		  then 
		    begin
		      if snd ball_pos > snd lft_pos 
		      then
			ball_angle := pi -. !ball_angle +. (float_of_int & Random.int 20) *. pi /. 180.
		      else
			ball_angle := pi -. !ball_angle -. (float_of_int & Random.int 20) *. pi /. 180. ;

		      ball_sound#play ; 
		      ball#set_position  (fst lft_pos +. ball_radius +. (paddle_sizeX /. 2.0) +. 0.1) (snd ball_pos)
		    end ;
		
		  if (fst ball_pos  +. ball_radius >  fst rgt_pos -. paddle_sizeX /. 2.0) &&
		     (fst ball_pos  +. ball_radius <   fst rgt_pos) &&
		     (snd ball_pos  +. ball_radius >= snd rgt_pos -. paddle_sizeY /. 2.0) &&
		     (snd ball_pos  -. ball_radius <= snd rgt_pos +. paddle_sizeY /. 2.0)
		  then 
		    begin
		      if snd ball_pos > snd rgt_pos 
		      then
			ball_angle := pi -. !ball_angle +. (Random.float 20.0) *. pi /. 180.
		      else
			ball_angle := pi -. !ball_angle -. (Random.float 20.0) *. pi /. 180. ;
		      ball_sound#play ;
		      ball#set_position (fst rgt_pos -. ball_radius -. (paddle_sizeX /. 2.) -. 0.1) (snd ball_pos)
		    end
	end
		
    in		
	
    let draw () =
      app#clear ~color:(Color.rgb 50 200 50) () ;

      if !is_playing
      then begin
	app#draw left_paddle ;
	app#draw right_paddle ;
	app#draw ball
      end
      else app#draw pauseMessage ;
    in
      
    let rec main_loop () =
      if app#is_open 
      then 

	begin
	  event_loop ();
	  update ();
	  draw ();
	  app#display ;
	  main_loop ()
	end
    in
      
      main_loop ();
      
    Gc.full_major () ;
    (* ball_sound#destroy ;
      ball#destroy ;
      right_paddle#destroy ;
      left_paddle#destroy ; 
      pauseMessage#destroy ;
    *)
       ball_sound_buffer#destroy ;
      font#destroy ;
      icon#destroy 
(*;
      app#destroy *)

let _ = test_pong ()
  

