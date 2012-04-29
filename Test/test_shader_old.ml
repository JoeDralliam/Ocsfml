open OcsfmlSystem
open OcsfmlWindow
open OcsfmlGraphics

let ( & ) f x = f x

class virtual effect (myName :string)  =
object (this)
  inherit drawable ~overloaded:`draw (Drawable.inherits ())
  val mutable myIsLoaded = false
  method virtual private on_load : bool
  method virtual private on_update : float -> float -> float -> unit
  method virtual private on_draw : render_target -> render_states -> unit
  method get_name = myName
  method load = myIsLoaded <- this#on_load
  method update time x y = if myIsLoaded then this#on_update time x y
  method draw target states =
    if myIsLoaded
    then this#on_draw target states
    else
      begin
	let error = new text ~string:"Shader not\nsupported"
          ~position:(320.,200.)
          ~character_size:36 () in
	target#draw error
      end
  method virtual destroy : unit
    
end
let make_effects () =
  let pixelate =
object
  inherit effect "pixelate"
  val myTexture = new texture `None
  val mySprite = new sprite ()
  val myShader = new shader ()

  method destroy =
    myTexture#destroy
      (* mySprite#destroy ;
	 myShader#destroy *)

  method private on_load =
    if myTexture#load_from_file "resources/background.jpg"
    then
      begin
	mySprite#set_texture myTexture;
	if myShader#load_from_file ~fragment:"resources/pixelate.frag" ()
	then
	  begin
            myShader#set_current_texture "texture" ;
            true
	  end
	else false
      end
    else false

  method private on_update time x y =
    myShader#set_parameter "pixel_threshold" & (x +. y) /. 30.

  method private on_draw target states =
    states.shader <- myShader ;
    target#draw ~render_states:states mySprite
end
  in
  let wave_blur =
object
  inherit effect "wave + blur"
  val myText = new text ()
  val myShader = new shader ()

  method destroy = ()
    (*    myText#destroy ;
	  myShader#destroy *)

  method private on_load =
    myText#set_string
      "Praesent suscipit augue in velit pulvinar hendrerit varius purus aliquam.\n\
   Mauris mi odio, bibendum quis fringilla a, laoreet vel orci. Proin vitae vulputate tortor.\n\
   Praesent cursus ultrices justo, ut feugiat ante vehicula quis.\n\
   Donec fringilla scelerisque mauris et viverra.\n\
   Maecenas adipiscing ornare scelerisque. Nullam at libero elit.\n\
   Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.\n\
   Nullam leo urna, tincidunt id semper eget, ultricies sed mi.\n\
   Morbi mauris massa, commodo id dignissim vel, lobortis et elit.\n\
   Fusce vel libero sed neque scelerisque venenatis.\n\
   Integer mattis tincidunt quam vitae iaculis.\n\
   Vivamus fringilla sem non velit venenatis fermentum.\n\
   Vivamus varius tincidunt nisi id vehicula.\n\
   Integer ullamcorper, enim vitae euismod rutrum, massa nisl semper ipsum,\n\
   vestibulum sodales sem ante in massa.\n\
   Vestibulum in augue non felis convallis viverra.\n\
   Mauris ultricies dolor sed massa convallis sed aliquet augue fringilla.\n\
   Duis erat eros, porta in accumsan in, blandit quis sem.\n\
   In hac habitasse platea dictumst. Etiam fringilla est id odio dapibus sit amet semper dui laoreet.\n" ;
    myText#set_character_size 22 ;
    myText#set_position 30. 20. ;
    myShader#load_from_file ~vertex:"resources/wave.vert" ~fragment:"resources/blur.frag" ()

  method private on_update time x y =
    myShader#set_parameter "wave_phase" time ;
    myShader#set_parameter "wave_amplitude" ~x:(x *. 40.) (y *. 40.) ;
    myShader#set_parameter "blur_radius" & (x +. y) *. 0.008

  method private on_draw target states =
    states.shader <- myShader ;
    target#draw ~render_states:states myText
end
  in

  let storm_blink =
object
  inherit effect "storm + blink"
  val myPoints = new vertex_array []
  val myShader = new shader ()
  method destroy = ()
    (*   myPoints#destroy ;
	 myShader#destroy *)
    
  method private on_load =
    myPoints#set_primitive_type Points ;
    let create_point () =
      let open Random in
      let pos = (float 800.,  float 600.) in
      let color = Color.rgb (int 255) (int 255) (int 255) in
      myPoints#append (mk_vertex ~position:pos ~color:color ())
    in
    for i = 0 to 40000
    do
      create_point ()
    done ;
    myShader#load_from_file ~vertex:"resources/storm.vert" ~fragment:"resources/blink.frag" ()

  method private on_update time x y =
    let radius = 200. +. (cos time) *. 150. in
    myShader#set_parameter "storm_position" ~x:(x *. 800.) (y *. 600.) ;
    myShader#set_parameter "storm_inner_radius" (radius /. 3.) ;
    myShader#set_parameter "storm_total_radius" radius ;
    myShader#set_parameter "blink_alpha" (0.5 +. (cos (time *. 3.) ) *. 0.25)

  method private on_draw target states =
    states.shader <- myShader ;
    target#draw ~render_states:states myPoints
end
  in
  let edge =
object
  inherit effect "edge post-effect"
  val myEntities = Array.init 6 (fun i -> new sprite ())
  val mySurface = new render_texture
  val myBackgroundTexture = new texture `None
  val myEntityTexture = new texture `None
  val myBackgroundSprite = new sprite ()
  val myShader = new shader ()
  val mySceneSprite = new sprite ()

  method destroy =
    (*    Array.iter (fun spr -> spr#destroy ) myEntities ;
	  mySurface#destroy ; *)
    myBackgroundTexture#destroy ;
    myEntityTexture#destroy (* ;
			       myBackgroundSprite#destroy ;
			       myShader#destroy ;
			       mySceneSprite#destroy *)

  method private on_load =
    if mySurface#create 800 600
      && myBackgroundTexture#load_from_file "resources/sfml.png"
      && myEntityTexture#load_from_file "resources/devices.png"
    then
      let init_entity i spr =
	(* spr#destroy ; *)
	let texture_rect = { left = 96 * i; top = 0 ; width = 96 ; height = 96 } in
	myEntities.(i) <- new sprite ~texture:myEntityTexture ~texture_rect ()
      in
      mySurface#set_smooth true ;
      myBackgroundTexture#set_smooth true ;
      myEntityTexture#set_smooth true ;
      myBackgroundSprite#set_texture myBackgroundTexture ;
      myBackgroundSprite#set_position 135. 100. ;
      Array.iteri init_entity myEntities ;
      (myShader#load_from_file ~fragment:"resources/edge.frag" ()) &&
	(myShader#set_current_texture "texture" ; true)
    else false


  method private on_update time x y =
    myShader#set_parameter "edge_threshold" & 1. -. (x +. y) /. 2. ;
    let entities_count = Array.length myEntities in
    let update_entity i entity =
      let i' = float_of_int i in
      let j' = float_of_int (entities_count - i) in
      let xpos = cos (0.25 *. (time *. i' +. j')) *. 300. +. 350. in
      let ypos = sin (0.25 *. (time *. j' +. i')) *. 200. +. 250. in
      entity#set_position xpos ypos ;
      mySurface#draw entity
    in
    mySurface#clear ~color:Color.white () ;
    mySurface#draw myBackgroundSprite ;
    Array.iteri update_entity myEntities ;
    mySurface#display

  method private on_draw target states =
    states.shader <- myShader ;
    let tex = mySurface#get_texture in
    mySceneSprite#set_texture tex;
    target#draw ~render_states:states mySceneSprite
end
  in
  let rec before = edge :: storm_blink :: wave_blur :: pixelate :: before in
  let rec after = pixelate :: wave_blur :: storm_blink :: edge :: after in
object (self)
  val before = before
  val after = after
  method current = List.hd after
  method next = match after with x::xs -> {< before = x::before ; after = xs >} | _ -> assert false
  method previous = match before with x::xs -> {< before = xs ; after = x::after >} | _ -> assert false
  method take n = if n = 0 then [] else self#current :: self#next#take (n-1)
end

let _ =
  Random.self_init () ;
  let app = new render_window (VideoMode.create ()) "Ocsfml Shader" in
  let effects = make_effects () in
  (* let f x = x#current#load ; x#next in *)
  (*f (f (f (f effects))) ;*)   
  List.iter (fun x -> x#load) (effects#take 4) ;
  
  
  
  
  let textBackgroundTexture =
    let tex = new texture `None in
    if tex#load_from_file "resources/text-background.png"
    then tex
    else failwith "Could not load text background texture"
  in

  let textBackground =
    new sprite
      ~texture:textBackgroundTexture
      ~position:(0., 520.)
      ~color:(Color.rgba 255 255 255 200) ()
  in
  
  
  let font =
    let font = new font `None in
    if font#load_from_file "resources/sansation.ttf"
    then font
    else failwith "Could not load font"
  in

  let description =
    new text ~string:("Current effect: " ^ effects#current#get_name )
      ~font ~character_size:20 ~position:(10., 530.) ~color:(Color.rgb 80 80 80) ()
  in
  
  let instructions =
    new text
      ~string:"Press left and right arrows to change the current shader"
      ~font:font
      ~character_size:20
      ~position:(280., 555.)
      ~color:(Color.rgb 80 80 80) ()
  in
  
  let timer = new clock in

  let rec event_loop effects =
    match app#poll_event with
      | Some e ->
          let open Event in
          let effects = match e with
	    | Closed | KeyPressed { code = KeyCode.Escape ; _ } ->
		app#close ; effects
	    | KeyPressed { code = KeyCode.Left ; _ } ->
		let effects = effects#previous in
		let current_name = effects#current#get_name in
		description#set_string ("Current effect: " ^ current_name);
		effects
	    | KeyPressed { code = KeyCode.Right ; _ } ->
		let effects = effects#next in
		let current_name = effects#current#get_name in
		description#set_string ("Current effect: " ^ current_name);
		effects 
	    | _ -> effects 
          in event_loop effects
      | None -> effects
  in
  
  let update effects =
    let x =
      (float_of_int & fst & Mouse.get_relative_position app) /.
	(float_of_int app#get_width) in
    let y =
      (float_of_int & snd & Mouse.get_relative_position app) /.
	(float_of_int & app#get_height) in
    effects#current#update (Time.as_seconds & timer#get_elapsed_time ) x y
  in
  
  let draw_scene effects =
    app#draw effects#current ;
    app#draw textBackground ;
    app#draw instructions ;
    app#draw description  ;
  in
  
  let rec main_loop effects =
    let effects = event_loop effects in
    update effects ;
    app#clear ~color:(Color.rgb 255 128 0 ) () ;
    draw_scene effects ;
    app#display ;
    if app#is_open then main_loop effects
  in
  main_loop effects ;
  
  textBackgroundTexture#destroy ;
  (*    textBackground#destroy ; *)
  font#destroy ;
  (*      description#destroy ;
	  instructions#destroy ;
	  timer#destroy ; *)
  List.iter (fun eff -> eff#destroy ) (effects#take 4);
  (* app#destroy *)
  print_newline () ;
  Gc.full_major () ;
  print_newline () ;
  print_string "Ok!" ;
  Gc.full_major ()
    
    
    
