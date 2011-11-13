open OcsfmlSystem
open OcsfmlWindow
open OcsfmlGraphics
open OcsfmlAudio

let pi = 4.0 *. atan 1.0
(*
let load_sound_buffer file_name =
	let sound_buffer = new sound_bufferCpp (SoundBuffer.default ()) in
		if sound_buffer#load_from_file file_name
		then sound_buffer
		else failwith ("Could not load sound buffer " ^ file_name)


let load_texture file_name =
	let texture = new textureCpp (Texture.default ()) in
		if texture#load_from_file file_name
		then texture
		else failwith ("Could not load texture " ^ file_name)


let load_font file_name  =
	let font = new fontCpp (Font.default ()) in
		if font#load_from_file file_name
		then font
		else failwith ("Could not load font " ^ file_name) *) 

let test_pong () = 
  Random.self_init () ;
  
  let vm = VideoMode.({ width=800 ; height=600 ; bits_per_pixel=32 }) in
  let app = new render_window vm  "Ocsfml - Pong" in
	
  let font = mk_font (`File "resources/sansation.ttf") in
  let ball_texture = mk_texture (`File "resources/ball.png") in
  let background_texture = mk_texture (`File "resources/background.jpg") in
  let left_paddle_texture = mk_texture (`File "resources/paddle_left.png") in 
  let right_paddle_texture = mk_texture (`File "resources/paddle_right.png") in
  let ball_sound_buffer = mk_sound_buffer (`File "resources/ball.wav") in


  let endText = mk_text ~font ~character_size:50 ~position:(150.0, 200.0) ~color:(Color.rgb 50 50 250) () in

  let background = mk_sprite ~texture:background_texture () in
  let left_paddle = mk_sprite ~texture:left_paddle_texture () in
  let right_paddle = mk_sprite ~texture:right_paddle_texture () in
  let ball =  mk_sprite ~texture:ball_texture () in
  let ball_sound = mk_sound ~buffer:ball_sound_buffer () in

  let view = app#get_view () in
  let app_size = view#get_size () in
  let lft_size = left_paddle#get_size () in
  let rgt_size = right_paddle#get_size () in
  let ball_size = ball#get_size () in
    
  let middle project x1 x2 = (project x1 -. project x2) /. 2.0 in

    left_paddle#move 10.0 (middle snd app_size lft_size);
    right_paddle#move (fst app_size -. fst rgt_size -. 10.0) (middle snd app_size rgt_size);
    ball#move (middle fst app_size ball_size) (middle snd app_size ball_size) ; 
	
    let ai_timer = new clock in
    let ai_time = 100 in
    let left_paddle_speed = ref 400.0 in
    let right_paddle_speed = ref 400.0 in
	
    let ball_speed = ref 400.0 in
    let ball_angle =
      let angle = acos ((Random.float 0.3) +. 0.7) in
	ref( if Random.bool () then angle +. pi else angle )
    in
	
    let is_playing = ref true in

    let rec event_loop () =
      match app#poll_event () with
	| Some e ->
	    Event.( match e with
		      | Closed 
		      | KeyPressed { code = KeyCode.Escape ; _ } -> 
			  app#close ()
		      | _ -> () ) ;
	    event_loop ()
	| None -> () 
    in

    let update () =
      if !is_playing 
      then 
	begin
	  let interpolation = float_of_int (app#get_frame_time ()) in
	    
	    if is_key_pressed KeyCode.Up && (snd (left_paddle#get_position ()) > 5.0) 
	    then left_paddle#move 0.0 (-. !left_paddle_speed *. interpolation /. 1000.0) ;
	    
	  
	    if is_key_pressed KeyCode.Down && (snd (left_paddle#get_position ()) < (snd app_size -. snd lft_size -. 5.0)) 
	    then left_paddle#move 0.0 (!left_paddle_speed *. interpolation /. 1000.0) ;
		
	    if (!right_paddle_speed < 0.0 && (snd (right_paddle#get_position ()) > 5.0)) || 
	      (!right_paddle_speed > 0.0 && (snd (right_paddle#get_position ()) < (snd app_size -. snd rgt_size -. 5.0)))
	    then right_paddle#move 0.0 (!right_paddle_speed *. interpolation /. 1000.0) ;
	  
	    let rgt_pos = right_paddle#get_position () in
			  
	    let lft_pos = left_paddle#get_position () in

	      if ai_timer#get_elapsed_time () > ai_time
	      then 
		begin
		  ai_timer#reset ();
		  if (!right_paddle_speed < 0.0) && 
		    ((snd (ball#get_position ()) +. snd ball_size ) > (snd rgt_pos +. snd rgt_size))
		  then right_paddle_speed := -. !right_paddle_speed;
		  if (!right_paddle_speed > 0.0) &&
		    (snd (ball#get_position ()) < snd rgt_pos)
		  then right_paddle_speed := -. !right_paddle_speed
		end;
	    
	      (** Update Ball Position **)
	      let factor = !ball_speed *. interpolation /. 1000.0 in
		ball#move ((cos !ball_angle) *. factor) ((sin !ball_angle) *. factor) ;
		
		let ball_pos = ball#get_position () in
		  if fst ball_pos < 0.0
		  then 
		    begin
		      is_playing := false;
		      endText#set_string "You lost!\n(press escape to exit)"
		    end;
		  if (fst ball_pos +. fst ball_size) > fst app_size
		  then 
		    begin
		      is_playing := false;
		      endText#set_string "You won!\n(press escape to exit)"
		    end;
		  if snd ball_pos < 0.0
		  then 
		    begin
		      ball_sound#play (); 
		      ball_angle := -. !ball_angle;
		      ball#set_y 0.1
		    end;
		  if (snd ball_pos +. snd ball_size) > snd app_size
		  then 
		    begin
		      ball_sound#play ();
		      ball_angle := -. !ball_angle;
		      ball#set_y  (snd app_size -. snd ball_size -. 0.1)
		    end;
		
		  (** Check collision between the paddles and the ball **)
		  if (fst ball_pos  < (fst lft_pos +. fst lft_size)) &&
		    (fst ball_pos  > (fst lft_pos +. (fst lft_size /. 2.0))) &&
		    ((snd ball_pos +. snd ball_size) >= snd lft_pos) &&
           	    (snd ball_pos	<= (snd lft_pos +. snd lft_size))
		  then 
		    begin
		      ball_sound#play (); 
		      ball_angle := pi -. !ball_angle;
		      ball#set_x  (fst lft_pos +. fst ball_size +. 0.1)
		    end ;
		
		  if ((fst ball_pos  +. fst ball_size)  >  fst rgt_pos) &&
		    ((fst ball_pos  +. fst ball_size)  <  (fst rgt_pos +. (fst rgt_size /. 2.0))) &&
		    ((snd ball_pos  +. snd ball_size)  >= snd rgt_pos) &&
		    (snd ball_pos <= (snd rgt_pos +. snd rgt_size))
		  then 
		    begin
		      ball_sound#play ();
		      ball_angle := pi -. !ball_angle;
		      ball#set_x  (fst rgt_pos -. fst ball_size -. 0.1)
		    end
	end
		
    in			
	
    let draw () =
      app#clear () ;
      app#draw background ;
      app#draw left_paddle ;
      app#draw right_paddle ;
      app#draw ball ;
      if not !is_playing
      then app#draw endText
    in
      
    let rec main_loop () =
      if app#is_opened()
      then 
	begin
	  event_loop ();
	  update ();
	  draw ();
	  app#display ();
	  main_loop ()
	end
    in
      
      main_loop ();
      ai_timer#destroy ();
      ball_sound#destroy ();
      ball#destroy ();
      right_paddle#destroy ();
      left_paddle#destroy ();
      background#destroy ();
      endText#destroy ();
      ball_sound_buffer#destroy ();
      left_paddle_texture#destroy ();
      right_paddle_texture#destroy ();
      ball_texture#destroy ();
      font#destroy () ;
      app#destroy () ;
      background_texture#destroy ()

let _ = test_pong ()
  

