open Window
open Graphics
open Audio
open Math

let pi = 4.0 *. atan 1.0

let load_sound_buffer file_name =
	let sound_buffer = new sound_buffer in
		if sound_buffer#load_from_file file_name
		then sound_buffer
		else failwith ("Could not load sound buffer " ^ file_name)
in

let load_texture file_name =
	let texture = new texture in
		if texture#load_from_file file_name
		then texture
		else failwith ("Could not load texture " ^ file_name)
in

let load_font file_name  =
	let font = new font in
		if font#load_from_file file_name
		then font
		else failwith ("Could not load font " ^ file_name)
in


let ball_sound_buffer = load_sound_buffer "resources/ball.wav" in
let background_texture = load_texture "resources/background.jpg" in
let left_paddle_texture = load_texture "resources/paddle_left.png" in
let right_paddle_texture = load_texture "resources/paddle_right.png" in
let ball_texture = load_texture "resources/ball.png" in
let font = load_font "resources/sansation.ttf" in


let free_resources =
	ball_sound_buffer#destroy ();
	background_texture#destroy ();
	left_paddle_texture#destroy ();
	right_paddle_texture#destroy ();
	ball_texture#destroy ();
	font#destroy ()



let test_pong =
	let init_app =
		let vm = VideoMode.({ width=800 ; height=600 ; bits_per_pixel=32 }) in
			new render_window vm "Ocsfml - Pong"
	in
	
	let app = init_app () in
	
	
	let endText = new text in
		endText#set_font font;
		endText#set_character_size 50;
		endText#move 150.0 200.0;
		endText#set_color (rgb 50 50 250)
	let background = new spriteCpp (Sprite.create_from_texture background_texture) in
   	let left_paddle = new spriteCpp (Sprite.create_from_texture left_paddle_texture) in
    let right_paddle = new spriteCpp (Sprite.create_from_texture right_paddle_texture) in
    let ball = new spriteCpp (Sprite.create_from_texture ball_texture) in
	let ball_sound = new soundCpp (Sprite.create_from_sound_buffer ball_sound_buffer
	
	left_paddle#move 10.0 ((((app#get_view ())#get_size ()).second -. (left_paddle#get_size ()).second) /. 2.0) ;
	right_paddle#move 	(((app#get_view ())#get_size ()).first -. (right_paddle#get_size ()).first -. 10.0) 
						((((app#get_view ())#get_size ()).second -. (right_paddle#get_size ()).second) /. 2.0) ;
	ball#move 	((((app#get_view ())#get_size ()).first -. (ball#get_size ()).first) /. 2.0)
				((((app#get_view ())#get_size ()).second -. (ball#get_size ()).second) /. 2.0)
	
	let ai_timer = new clock in
	let ai_time = 0.1 in
	let left_paddle_speed = new 400.0 in
	let right_paddle_speed = new 400.0 in
	
	let ball_speed = new 400.0 in
	let ball_angle = in (* TODO *)
	
	let is_playing = new true in

	let rec event_loop =
		match app#poll_event () with
			| Some e ->
				Event.( match e with
					| Closed | KeyPressed { code = KeyCode.Escape ; _ } -> app#close ()
					| _ -> () ) ;
				event_loop ()
			| None -> () 
	in

	let update =
		if is_playing 
		then begin
			if is_key_pressed KeyCode.Up && ((left_paddle#get_position ()).second > 5.0) 
			then left_paddle#move 0.0 (-!left_paddle_speed *. (app#get_frame_time ()) /. 1000.0) ;
			if is_key_pressed KeyCode.Down && ((left_paddle#get_position ()).second > ((app#get_view ())#get_size()).second -. (left_paddle#get_size ()).second -. 5.0) 
			then left_paddle#move 0.0 (!left_paddle_speed *. (app#get_frame_time ()) /. 1000.0) ;
		
			if 	(!right_paddle_speed < 0.0 && ((right_paddle#get_position ()).second > 5.0) || 
				(!right_paddle_speed > 0.0 && ((right_paddle#get_position ()).second > ((app#get_view ())#get_size()).second -. (right_paddle#get_size ()).second -. 5.0)
			then right_paddle#move 0.0 (!right_paddle_speed *. (app#get_frame_time ()) /. 1000.0) ;
		
			if ai_timer.get_elapsed_time () > ai_time
			then begin
				ai_timer#reset ();
				if	((!right_paddle_speed < 0) && 
					((ball#get_position ().second +. ball#get_size ().second) > (right_paddle#get_position ().second +. right_paddle#get_size ().second))
				then right_paddle_speed := -!right_paddle_speed;
				if	((!right_paddle_speed > 0) &&
					((ball#get_position ().second) < (right_paddle#get_position ().second))
				then right_paddle_speed := -!right_paddle_speed
			end
			let factor = !ball_speed *. window#get_frame_time () /. 1000.0
			ball
		end
		
	in			
	
	let draw =  
	in

	let rec main_loop =
		event_loop ();
		update ();
		draw ();
		app#display;
		main_loop ()
	in
	
	main_loop ()

	

let _ = test_pong ();free_resources()
