open System
open Window
open Graphics
open Audio

let pi = 4.0 *. atan 1.0

let load_sound_buffer file_name =
	let sound_buffer = new sound_buffer in
		if sound_buffer#load_from_file file_name
		then sound_buffer
		else failwith ("Could not load sound buffer " ^ file_name)


let load_texture file_name =
	let texture = new texture in
		if texture#load_from_file file_name
		then texture
		else failwith ("Could not load texture " ^ file_name)


let load_font file_name  =
	let font = new font in
		if font#load_from_file file_name
		then font
		else failwith ("Could not load font " ^ file_name)



let ball_sound_buffer = load_sound_buffer "resources/ball.wav"
let background_texture = load_texture "resources/background.jpg"
let left_paddle_texture = load_texture "resources/paddle_left.png"
let right_paddle_texture = load_texture "resources/paddle_right.png"
let ball_texture = load_texture "resources/ball.png"
let font = load_font "resources/sansation.ttf"


let free_resources =
	ball_sound_buffer#destroy ();
	background_texture#destroy ();
	left_paddle_texture#destroy ();
	right_paddle_texture#destroy ();
	ball_texture#destroy ();
	font#destroy ()



let _ =

	let init_app title =
		let vm = VideoMode.({ width=800 ; height=600 ; bits_per_pixel=32 })
		new render_window vm title
	in

	Random.self_init () ;
	let app = init_app "Ocsfml - Pong" in
	
	
	let endText = new text in
		endText#set_font font;
		endText#set_character_size 50;
		endText#move 150.0 200.0;
		endText#set_color (Color.rgb 50 50 250) ;
	let background = new spriteCpp (Sprite.create_from_texture background_texture) in
   	let left_paddle = new spriteCpp (Sprite.create_from_texture left_paddle_texture) in
    let right_paddle = new spriteCpp (Sprite.create_from_texture right_paddle_texture) in
	let ball_sound = new soundCpp (Sound.create_from_sound_buffer ball_sound_buffer) in
	
	left_paddle#move 10.0 ((((app#get_view ())#get_size ()).second -. (left_paddle#get_size ()).second) /. 2.0) ;
	right_paddle#move 	(((app#get_view ())#get_size ()).first -. (right_paddle#get_size ()).first -. 10.0) 
						((((app#get_view ())#get_size ()).second -. (right_paddle#get_size ()).second) /. 2.0) ;
	ball#move 	((((app#get_view ())#get_size ()).first -. (ball#get_size ()).first) /. 2.0)
			((((app#get_view ())#get_size ()).second -. (ball#get_size ()).second) /. 2.0) ;
	
	let ai_timer = new clock in
	let ai_time = 0.1 in
	let left_paddle_speed = ref 400.0 in
	let right_paddle_speed = ref 400.0 in
	
	let ball_speed = ref 400.0 in
	let ball_angle =
		let angle = acos ((Random.float 0.3) +. 0.7) in
		ref( if Random.bool () then angle +. pi else angle )
	in
	
	let is_playing = ref true in

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
			then left_paddle#move 0.0 (-. !left_paddle_speed *. (app#get_frame_time ()) /. 1000.0) ;
			if is_key_pressed KeyCode.Down && ((left_paddle#get_position ()).second > ((app#get_view ())#get_size()).second -. (left_paddle#get_size ()).second -. 5.0) 
			then left_paddle#move 0.0 (!left_paddle_speed *. (app#get_frame_time ()) /. 1000.0) ;
		
			if 	(!right_paddle_speed < 0.0 && ((right_paddle#get_position ()).second > 5.0)) || 
				(!right_paddle_speed > 0.0 && ((right_paddle#get_position ()).second > ((app#get_view ())#get_size()).second -. (right_paddle#get_size ()).second -. 5.0))
			then right_paddle#move 0.0 (!right_paddle_speed *. (app#get_frame_time ()) /. 1000.0) ;
		
			if ai_timer.get_elapsed_time () > ai_time
			then begin
				ai_timer#reset ();
				if	(!right_paddle_speed < 0) && 
					((ball#get_position ().second +. ball#get_size ().second) > (right_paddle#get_position ().second +. right_paddle#get_size ().second))
				then right_paddle_speed := -. !right_paddle_speed;
				if	(!right_paddle_speed > 0) &&
					((ball#get_position ().second) < (right_paddle#get_position ().second))
				then right_paddle_speed := -. !right_paddle_speed
			end;

			(** Update Ball Position **)
			let factor = !ball_speed *. window#get_frame_time () /. 1000.0 in
			ball#move (cos !ballAngle) *. factor (sin !ballAngle) *. factor ;
			if ball#get_position ().first < 0.0
			then begin
				!is_playing = false;
				endText#set_text "You lost!\n(press escape to exit)"
			end;
			if (ball#get_position ().first + ball#get_size ().first) > app#get_view ()#get_size ().first
			then begin
				!is_playing = false;
				endText#set_text "You lost!\n(press escape to exit)"
			end;
			if ball#get_position ().second < 0.0
			then begin
				ball_sound#play ();
				ballAngle := -. !ballAngle;
				ball#set_y 0.1
			end;
			if (ball#get_position ().second +. ball#get_size ().second) > app#get_view()#get_size().second
			then begin
				ball_sound#play ();
				ballAngle := -. !ballAngle;
				ball#set_y  app#get_view ()#get_size ().second -. ball#get_size ().second -. 0.1
			end;

			(** Check collision between the paddles and the ball **)
			if 	(ball#get_position ().first  < left_paddle#get_position ().first +. left_paddle#get_size ().first) &&
				(ball#get_position ().first  > left_paddle#get_position ().first +. (left_paddle#get_size().first /. 2.0)) &&
				(ball#get_position ().second +. ball#get_size ().second >= left_paddle#get_position ().second) &&
                (ball#get_position ().second 						    <= left_paddle#get_position ().second +. left_paddle#get_size().second)
			then begin
				ball_sound#play ();
				ballAngle := pi -. !ballAngle;
				ball#set_y  left_paddle#get_position ().first +. ball#get_size ().first +. 0.1
			end ;

			if 	(ball#get_position ().first  +. ball#get_size ().first  >  right_paddle#get_position ().first) &&
				(ball#get_position ().first  +. ball#get_size ().first  <  right_paddle#get_position ().first +. (right_paddle#get_size().first /. 2.0)) &&
				(ball#get_position ().second +. ball#get_size ().second >= right_paddle#get_position ().second) &&
                (ball#get_position ().second 						    <= right_paddle#get_position ().second +. right_paddle#get_size().second)
			then begin
				ball_sound#play ();
				ballAngle := pi -. !ballAngle;
				ball#set_y  right_paddle#get_position ().first -. ball#get_size ().first -. 0.1
			end
		end
		
	in			
	
	let draw =
		app#draw background ;
		app#draw leftPaddle ;
		app#draw rightPaddle ;
		app#draw ball ;
		if not !is_playing
		then app#draw endText
	in

	let rec main_loop =
		event_loop ();
		update ();
		draw ();
		app#display;
		main_loop ()
	in
	
	main_loop ();
	ai_timer#destroy ();
	ball_sound#destroy ();
	right_paddle#destroy ();
	left_paddle#destroy ();
	background#destroy ();
	endText#destroy ();
	free_resources () ;;
