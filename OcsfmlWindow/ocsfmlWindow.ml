module KeyCode =
struct
  type t =
      A     
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

external cpp is_key_pressed : KeyCode.t -> bool = "Keyboard_isKeyPressed"

module Joystick =
struct
  type joystick_id = int
  let count = 8
  let buttonCount = 32
  let axisCount = 8
    
  type axis =
    | X     (* The X axis *)
    | Y     (* The Y axis *)
    | Z     (* The Z axis *)
    | R     (* The R axis *)
    | U     (* The U axis *)
    | V     (* The V axis *)
    | PovX  (* The X axis of the point-of-view hat *)
    | PovY  (* The Y axis of the point-of-view hat *)
	
  let joystick_id_from_int n = 
    if n >= 0 && n < count then n else raise (Invalid_argument "Not a valid joystick_id.")

  external cpp is_connected : joystick_id -> bool = "Joystick_isConnected"
  external cpp get_button_count : joystick_id -> int = "Joystick_getButtonCount"
  external cpp has_axis : joystick_id -> axis -> bool = "Joystick_hasAxis"
  external cpp is_button_pressed : joystick_id -> int -> bool = "Joystick_isButtonPressed"
  external cpp get_axis_position : joystick_id -> axis -> float = "Joystick_getAxisPosition"
  external cpp update : unit -> unit = "Joystick_update"
end 

external class contextCpp (Context) : "sf_Context" = 
object
  constructor default : unit = "default_constructor"
  external method set_active : bool -> unit = "setActive"
end

class context = let d = Context.default () in contextCpp d

module Event = 
struct

  type mouseButton = 
      MouseLeft 
    | MouseRight
    | MouseMiddle
    | MouseXButton1
    | MouseXButton2
    | MouseButtonCount

  type sizeEvent = {
    width : int ;
    height : int
  }
      
  type keyEvent = {
    code : KeyCode.t ;
    alt : bool ;
    control : bool ;
    shift : bool ;
    system : bool
  }
      
  type textEvent = {
    unicode : int
  }
  
  type mouseCoord = {
    x : int ;
    y : int
  }
    
  type mouseMoveEvent = mouseCoord
      
  type mouseButtonEvent = mouseButton * mouseCoord 
      
  type mouseWheelEvent = int * mouseCoord
      
  type joystickConnectEvent = Joystick.joystick_id
      
  type joystickMoveEvent = Joystick.joystick_id * Joystick.axis * float
      
  type joystickButtonEvent = Joystick.joystick_id * int


  type t = 
      Closed 
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
  type t =
      {
	width : int ;
	height : int ;
	bits_per_pixel : int
      }
  let create ?(w=800) ?(h=600) ?(bpp=32) () =
    { width = w ; height = h ; bits_per_pixel = bpp }
  external cpp get_full_screen_modes : unit -> t array = "VideoMode_getFullscreenModes"
  external cpp get_desktop_mode : unit -> t = "VideoMode_getDesktopMode"
end

type context_settings =
{
  depth_bits : int ;
  stencil_bits : int ;
  antialising_level : int ;
  major_version : int ;
  minor_version : int 
}

(* FIXME : add default values and check input values *)
let mk_context_settings ~depth_bits ~stencil_bits ~antialising_level ~major_version ~minor_version =
  {
    depth_bits = depth_bits ;
    stencil_bits = stencil_bits ;
    antialising_level = antialising_level ;
    major_version = major_version ;
    minor_version = minor_version ;
  }

type window_style = Titlebar | Resize | Close | Fullscreen

external class windowCpp (WindowCpp) : "sf_Window" =
object (self)
  constructor default : unit = "default_constructor" 
  constructor create_init : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string = "constructor_create"
  external method create : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string -> unit = "create"
  external method close : unit = "close"
  external method is_open : bool = "isOpen"
  external method get_size : int*int = "getSize"
  method get_width = fst self#get_size
  method get_height = snd self#get_size 
  external method get_settings : context_settings = "getSettings" 
  external method poll_event : Event.t option = "pollEvent"
  external method wait_event : Event.t option = "waitEvent"
  external method set_vertical_sync_enabled : bool -> unit = "setVerticalSyncEnabled" 
  external method set_mouse_cursor_visible : bool -> unit = "setMouseCursorVisible"
  external method set_position : int -> int -> unit = "setPosition" 
  external method set_size : int -> int -> unit = "setSize"
  external method set_title : string -> unit = "setTitle"
  external method set_visible : bool -> unit = "setVisible" 
  external method set_key_repeat_enabled : bool -> unit = "setKeyRepeatEnabled"
  (* external method set_icon : int -> int -> char array -> unit = "window__set_icon" *)
  external method set_active : bool -> bool = "setActive" 
  external method display : unit = "display"
  external method set_framerate_limit : int -> unit = "setFramerateLimit"
(*  external method get_frame_time : int = "getFrameTime"  *)
  external method set_joystick_threshold : float -> unit = "setJoystickThreshold"
end

module Window =
struct
  type style = window_style = Titlebar | Resize | Close | Fullscreen 
  include WindowCpp
end

class window ?style ?context vm name = 
  let t = Window.create_init ?style ?context vm name in 
    windowCpp t

module Mouse =
struct
  type button = Event.mouseButton

  external cpp is_button_pressed : button -> bool = "Mouse_isButtonPressed"
  external cpp get_position : unit -> int*int = "Mouse_getPosition"
  external cpp get_relative_position :  (#window as 'a) -> int*int = "Mouse_getRelativePosition"
  external cpp set_position : int * int -> unit = "Mouse_setPosition"
  external cpp set_relative_position : int*int -> (#window as 'a) -> unit = "Mouse_setRelativePosition"
end
