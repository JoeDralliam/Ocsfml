type pixel_array_type =
    (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array3.t

let pixel_array_kind = Bigarray.int8_unsigned
  
let pixel_array_layout = Bigarray.c_layout
  
module KeyCode =
struct
  type t =
    | A
    | B
    | C
    | D
    | E
    | F
    | G
    | H
    | I
    | J
    | K
    | L
    | M
    | N
    | O
    | P
    | Q
    | R
    | S
    | T
    | U
    | V
    | W
    | X
    | Y
    | Z
    | Num0
    | Num1
    | Num2
    | Num3
    | Num4
    | Num5
    | Num6
    | Num7
    | Num8
    | Num9
    | Escape
    | LControl
    | LShift
    | LAlt
    | LSystem
    | RControl
    | RShift
    | RAlt
    | RSystem
    | Menu
    | LBracket
    | RBracket
    | SemiColon
    | Comma
    | Period
    | Quote
    | Slash
    | BackSlash
    | Tilde
    | Equal
    | Dash
    | Space
    | Return
    | Back
    | Tab
    | PageUp
    | PageDown
    | End
    | Home
    | Insert
    | Delete
    | Add
    | Subtract
    | Multiply
    | Divide
    | Left
    | Right
    | Up
    | Down
    | Numpad0
    | Numpad1
    | Numpad2
    | Numpad3
    | Numpad4
    | Numpad5
    | Numpad6
    | Numpad7
    | Numpad8
    | Numpad9
    | F1
    | F2
    | F3
    | F4
    | F5
    | F6
    | F7
    | F8
    | F9
    | F10
    | F11
    | F12
    | F13
    | F14
    | F15
    | Pause
    | Count
	
end

module Keyboard =
struct
  external is_key_pressed : KeyCode.t -> bool = "Keyboard_isKeyPressed__impl"
end

module Joystick =
struct
  type id = int
      
  let count = 8
    
  let buttonCount = 32
    
  let axisCount = 8
    
  type axis =
    | X (* The X axis *)
    | Y (* The Y axis *)
    | Z (* The Z axis *)
    | R (* The R axis *)
    | U (* The U axis *)
    | V (* The V axis *)
    |PovX (* The X axis of the point-of-view hat *)
    |PovY (* The Y axis of the point-of-view hat *)
	
  let id_from_int n =
    if (n >= 0) && (n < count)
    then n
    else raise (Invalid_argument "Not a valid Joystick.id.")
      
  external is_connected : id -> bool =
    "Joystick_isConnected__impl"
      
  external get_button_count : id -> int =
    "Joystick_getButtonCount__impl"
      
  external has_axis : id -> axis -> bool =
    "Joystick_hasAxis__impl"
      
  external is_button_pressed : id -> int -> bool =
    "Joystick_isButtonPressed__impl"
      
  external get_axis_position : id -> axis -> float =
    "Joystick_getAxisPosition__impl"
      
  external update : unit -> unit = "Joystick_update__impl"
    
end
  
module Context =
struct
  type t
    
  external destroy : t -> unit = "sf_Context_destroy__impl"
      
  external default : unit -> t = "sf_Context_default_constructor__impl"
      
  external set_active : t -> bool -> bool = "sf_Context_setActive__impl"      
end
  
class context_base t_context_base' =
object ((self : 'self))
  val t_context_base = (t_context_base' : Context.t)
  method rep__sf_Context = t_context_base
  method destroy = Context.destroy t_context_base
  method set_active : bool -> bool =
    fun p1 -> Context.set_active t_context_base p1
end
  
    
class context = 
  let d = Context.default () 
  in context_base d
						
module Event =
struct
  type mouseButton =
    | MouseLeft
    | MouseRight
    | MouseMiddle
    | MouseXButton1
    | MouseXButton2
    | MouseButtonCount
	
  type sizeEvent = { width : int; height : int }
      
  type keyEvent =
      { code : KeyCode.t; alt : bool; control : bool; shift : bool;
        system : bool
      }
	
  type textEvent = { unicode : int }
      
  type mouseCoord = { x : int; y : int }
      
  type mouseMoveEvent = mouseCoord
      
  type mouseButtonEvent = (mouseButton * mouseCoord)
      
  type mouseWheelEvent = (int * mouseCoord)
      
  type joystickConnectEvent = Joystick.id
      
  type joystickMoveEvent = (Joystick.id * Joystick.axis * float)
      
  type joystickButtonEvent = (Joystick.id * int)
      
  type t =
    | Closed
    | LostFocus
    | GainedFocus
    | Resized of sizeEvent
    | TextEntered of textEvent
    | KeyPressed of keyEvent
    | KeyReleased of keyEvent
    | MouseWheelMoved of mouseWheelEvent
    | MouseButtonPressed of mouseButtonEvent
    | MouseButtonReleased of mouseButtonEvent
    | MouseMoved of mouseMoveEvent
    | MouseEntered
    | MouseLeft
    | JoystickButtonPressed of joystickButtonEvent
    | JoystickButtonReleased of joystickButtonEvent
    | JoystickMoved of joystickMoveEvent
    | JoystickConnected of joystickConnectEvent
    | JoystickDisconnected of joystickConnectEvent
	
end
  
module VideoMode =
struct
  type t = { width : int; height : int; bits_per_pixel : int }
      
  let create ?(w = 800) ?(h = 600) ?(bpp = 32) () =
    { width = w; height = h; bits_per_pixel = bpp; }
      
  external is_valid : t -> bool = "VideoMode_isValid__impl"
    
  external get_full_screen_modes : unit -> t array =
    "VideoMode_getFullscreenModes__impl"
      
  external get_desktop_mode : unit -> t = "VideoMode_getDesktopMode__impl"
    
end
  
type context_settings =
    { 
      depth_bits        : int; 
      stencil_bits      : int; 
      antialising_level : int;
      major_version     : int;
      minor_version     : int
    }

(* FIXME : add default values and check input values *)
let mk_context_settings ?(depth_bits=0) ?(stencil_bits=0) ?(antialising_level=0)
    ?(major_version=2) ?(minor_version=0) () =
  {
    depth_bits = depth_bits;
    stencil_bits = stencil_bits;
    antialising_level = antialising_level;
    major_version = major_version;
    minor_version = minor_version;
  }
    

module WindowBase =
struct
  type style = | Titlebar | Resize | Close | Fullscreen

  type t
    
  external destroy : t -> unit = "sf_Window_destroy__impl"
      
  external default : unit -> t = "sf_Window_default_constructor__impl"
      
  external create_init :
    ?style: (style list) ->
    ?context: context_settings -> VideoMode.t -> string -> t =
      "sf_Window_constructor_create__impl"
	
  external create :
    t ->
    ?style: (style list) ->
    ?context: context_settings -> VideoMode.t -> string -> unit =
      "sf_Window_create__impl"
	
  external close : t -> unit = "sf_Window_close__impl"
      
  external is_open : t -> bool = "sf_Window_isOpen__impl"
      
  external get_size : t -> (int * int) = "sf_Window_getSize__impl"
      
  external get_position : t -> (int * int) = "sf_Window_getPosition__impl"
      
  external get_settings : t -> context_settings =
      "sf_Window_getSettings__impl"
	
  external poll_event : t -> Event.t option = "sf_Window_pollEvent__impl"
      
  external wait_event : t -> Event.t option = "sf_Window_waitEvent__impl"
      
  external set_vertical_sync_enabled : t -> bool -> unit =
      "sf_Window_setVerticalSyncEnabled__impl"
	
  external set_mouse_cursor_visible : t -> bool -> unit =
      "sf_Window_setMouseCursorVisible__impl"
	
  external set_position_v : t -> (int * int) -> unit =
      "sf_Window_setPosition__impl"
	
  external set_size_v : t -> (int * int) -> unit =
      "sf_Window_setSize__impl"
	
  external set_title : t -> string -> unit = "sf_Window_setTitle__impl"
      
  external set_visible : t -> bool -> unit = "sf_Window_setVisible__impl"
      
  external set_key_repeat_enabled : t -> bool -> unit =
      "sf_Window_setKeyRepeatEnabled__impl"
	
  external set_icon : t -> pixel_array_type -> unit =
      "sf_Window_setIcon__impl"
	
  external set_active : t -> ?active:bool -> unit -> bool = "sf_Window_setActive__impl"
      
  external display : t -> unit = "sf_Window_display__impl"
      
  external set_framerate_limit : t -> int -> unit =
      "sf_Window_setFramerateLimit__impl"
	
  external set_joystick_threshold : t -> float -> unit =
      "sf_Window_setJoystickThreshold__impl"
	
end
  
class window_base t =
object ((self : 'self))
  val t_window_base = (t : WindowBase.t)
  method rep__sf_Window = t_window_base
  method destroy = WindowBase.destroy t_window_base
  method create :
    ?style: (WindowBase.style list) ->
    ?context: context_settings -> VideoMode.t -> string -> unit =
    fun ?style ?context p1 p2 ->
      WindowBase.create t_window_base ?style ?context p1 p2
  method close : unit = WindowBase.close t_window_base
  method is_open : bool = WindowBase.is_open t_window_base
  method get_size : (int * int) = WindowBase.get_size t_window_base
  method get_width = fst self#get_size
  method get_height = snd self#get_size
  method get_position : (int * int) = WindowBase.get_position t_window_base
  method get_settings : context_settings =
    WindowBase.get_settings t_window_base
  method poll_event : Event.t option = WindowBase.poll_event t_window_base
  method wait_event : Event.t option = WindowBase.wait_event t_window_base
  method set_vertical_sync_enabled : bool -> unit =
    fun p1 -> WindowBase.set_vertical_sync_enabled t_window_base p1
  method set_mouse_cursor_visible : bool -> unit =
    fun p1 -> WindowBase.set_mouse_cursor_visible t_window_base p1
  method set_position_v : (int * int) -> unit =
    fun p1 -> WindowBase.set_position_v t_window_base p1
  method set_position = fun x y -> self#set_position_v (x, y)
  method set_size_v : (int * int) -> unit =
    fun p1 -> WindowBase.set_size_v t_window_base p1
  method set_size = fun x y -> self#set_size_v (x, y)
  method set_title : string -> unit =
    fun p1 -> WindowBase.set_title t_window_base p1
  method set_visible : bool -> unit =
    fun p1 -> WindowBase.set_visible t_window_base p1
  method set_key_repeat_enabled : bool -> unit =
    fun p1 -> WindowBase.set_key_repeat_enabled t_window_base p1
  method set_icon : pixel_array_type -> unit =
    fun p1 -> WindowBase.set_icon t_window_base p1
  method set_active : ?active:bool -> unit -> bool =
    fun ?active p1  -> WindowBase.set_active t_window_base ?active p1
  method display : unit = WindowBase.display t_window_base
  method set_framerate_limit : int -> unit =
    fun p1 -> WindowBase.set_framerate_limit t_window_base p1
  method set_joystick_threshold : float -> unit =
    fun p1 -> WindowBase.set_joystick_threshold t_window_base p1
end


module Window =
struct
  include WindowBase
end
  
class window ?style ?context vm name =
  let t = Window.create_init ?style ?context vm name
  in window_base t
       
module Mouse =
struct
  type button = Event.mouseButton
      
  external is_button_pressed : button -> bool = "Mouse_isButtonPressed__impl"
      
  external get_position : unit -> (int * int) = "Mouse_getPosition__impl"
      
  external get_relative_position : (#window as 'a) -> (int * int) = "Mouse_getRelativePosition__impl"
      
  external set_position : (int * int) -> unit = "Mouse_setPosition__impl"
      
  external set_relative_position : (int * int) -> (#window as 'a) -> unit = "Mouse_setRelativePosition__impl"
end
  

