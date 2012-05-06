open OcsfmlSystem
open OcsfmlWindow
open OcsfmlGraphics

let ( & ) f x = f x

class virtual effect (myName :string)  =
object (this : 'this)
  inherit drawable ~overloaded:`draw (Drawable.inherits ())
  method get_name = myName
  method virtual update : float -> float -> float -> unit
  method virtual destroy : unit
 end 

let load_failure =
object (self)
  inherit effect "load failure"
  val error = new text ~string:"Shader not\nsupported" 
      ~position:(320.,200.)
      ~character_size:36 ()
  method private draw target _ _ _ _ = target#draw error
  method destroy = ()
  method update _ _ _ = () 
end
  

class ['a] circular_buffer ?(index = 0) content = 
object (self)
  val index = index
  method current : 'a = content.(index)
  method next = {< index = (index + 1) mod 4 >}
  method previous = {< index = (index + 3) mod 4 >} 
  method take n = if n = 0 then [] else self#current :: self#next#take (n-1)
end


let make_effects () =
  let pixelate =
    try 
      let texture = new texture (`File "resources/background.jpg") in
object
  inherit effect "pixelate"
  val myTexture = texture
  val mySprite = new sprite ~texture ()
  val myShader = new shader ~fragment:(ShaderSource.file "resources/pixelate.frag") ()

  method destroy = myTexture#destroy

  method update time x y =
    myShader#set_parameter "pixel_threshold" & (x +. y) /. 30.

  method private draw target blend_mode transform texture sh =
    target#draw ~blend_mode ~transform ~texture ~shader:myShader mySprite
end
    with LoadFailure -> load_failure
  in

  let wave_blur =
    try 
      let string = 
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
   In hac habitasse platea dictumst. Etiam fringilla est id odio dapibus sit amet semper dui laoreet.\n"
      in
object
  inherit effect "wave + blur"
  val myText = new text ~string ~character_size:22 ~position:(30.,20.) ()
  val myShader = 
    let open ShaderSource in 
    new shader 
      ~vertex:(file "resources/wave.vert") 
      ~fragment:(file "resources/blur.frag") ()
      
  method destroy = ()

  method update time x y =
    myShader#set_parameter "wave_phase" time ;
    myShader#set_parameter "wave_amplitude" ~x:(x *. 40.) (y *. 40.) ;
    myShader#set_parameter "blur_radius" & (x +. y) *. 0.008

  method private draw target blend_mode transform texture sh =
    target#draw ~blend_mode ~transform ~texture ~shader:myShader myText
end
    with LoadFailure -> load_failure
  in

  let storm_blink =
    let rec range ?(acc=[]) a b = if a > b then acc else range ~acc:(b::acc) a (b-1) in
    Random.self_init () ;
    let create_point x =
      let open Random in
      let position = (float 800.,  float 600.) in
      let color = Color.rgb (int 255) (int 255) (int 255) in
      mk_vertex ~position ~color ()
    in
    try 
object
  inherit effect "storm + blink"
  val myPoints = new vertex_array ~primitive_type:Points (List.map create_point (range 0 40000))
  val myShader = let open ShaderSource in 
    new shader  
      ~vertex:(file "resources/storm.vert") 
      ~fragment:(file "resources/blink.frag") ()

  method destroy = ()

  method update time x y =
    let radius = 200. +. (cos time) *. 150. in
    myShader#set_parameter "storm_position" ~x:(x *. 800.) (y *. 600.) ;
    myShader#set_parameter "storm_inner_radius" (radius /. 3.) ;
    myShader#set_parameter "storm_total_radius" radius ;
    myShader#set_parameter "blink_alpha" (0.5 +. (cos (time *. 3.) ) *. 0.25)

  method private draw target blend_mode transform texture sh =
    target#draw ~blend_mode ~transform ~texture ~shader:myShader myPoints
end 
    with LoadFailure -> load_failure
  in
  let edge =
    try 
object (self)
  inherit effect "edge post-effect"
  val myEntities = Array.init 6 (fun i -> new sprite ())
  val mySurface = new render_texture 800 600
  val myBackgroundTexture = new texture `None
  val myEntityTexture = new texture `None
  val myBackgroundSprite = new sprite ()
  val myShader = new shader ()
  val mySceneSprite = new sprite ()

  method destroy =
    myBackgroundTexture#destroy ;
    myEntityTexture#destroy 

  method private on_load =
    if myBackgroundTexture#load_from_file "resources/sfml.png"
      && myEntityTexture#load_from_file "resources/devices.png"
    then
      let init_entity i spr =
	let texture_rect = { left = 96 * i; top = 0 ; width = 96 ; height = 96 } in
	myEntities.(i) <- new sprite ~texture:myEntityTexture ~texture_rect ()
      in
      mySurface#set_smooth true ;
      myBackgroundTexture#set_smooth true ;
      myEntityTexture#set_smooth true ;
      myBackgroundSprite#set_texture myBackgroundTexture ;
      myBackgroundSprite#set_position 135. 100. ;
      Array.iteri init_entity myEntities ;
      if myShader#load_from_file ~fragment:"resources/edge.frag" ()
      then myShader#set_current_texture "texture"


  initializer self#on_load

  method update time x y =
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

  method private draw target blend_mode transform texture sh =
    let tex = mySurface#get_texture in
    mySceneSprite#set_texture tex;
    target#draw ~blend_mode ~transform ~texture ~shader:myShader mySceneSprite

end
    with LoadFailure -> load_failure
  in
  let content = [| pixelate ; wave_blur ; storm_blink ; edge |] in 
  new circular_buffer content


let _ =
  Random.self_init () ;
  let app = new render_window (VideoMode.create ()) "Ocsfml Shader" in
  let effects = make_effects () in
  
  
  let textBackgroundTexture = new texture (`File "resources/text-background.png") in

  let textBackground =
    new sprite
      ~texture:textBackgroundTexture
      ~position:(0., 520.)
      ~color:(Color.rgba 255 255 255 200) ()
  in
  
  
  let font = new font (`File "resources/sansation.ttf") in

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
    effects#current#update (Time.as_seconds & timer#get_elapsed_time) x y
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
    app#clear ~color:(Color.rgb 255 128 0) () ;
    draw_scene effects ;
    app#display ;
    if app#is_open then main_loop effects
  in
  main_loop effects ;
  
  textBackgroundTexture#destroy ;
  font#destroy ;
  List.iter (fun eff -> eff#destroy ) (effects#take 4);
  (* app#destroy *)
  print_newline () ;
  Gc.full_major () ;
  print_newline () ;
  print_string "Ok!" ;
  Gc.full_major ()
    
    
    
