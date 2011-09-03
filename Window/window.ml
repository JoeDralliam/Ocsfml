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

external is_key_pressed : KeyCode.t -> bool = "Keyboard_IsKeyPressed"

module Joystick =
struct
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
	
  external is_connected : int -> bool = "Joystick_IsConnected"
  external get_button_count : int -> int = "Joystick_GetButtonCount"
  external has_axis : int -> axis -> bool = "Joystick_HasAxis"
  external is_button_pressed : int -> int -> bool = "Joystick_IsButtonPressed"
  external get_axis_position : int -> axis -> float = "Joystick_GetAxisPosition"
  external update : unit -> unit = "Joystick_Update"
end 

external class contextCpp (Context) : "sf_Context" = 
object
  constructor default : unit = "default_constructor"
  external method set_active : bool -> unit = "SetActive"
end

class context = contextCpp (Context.default ())

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
      
  type mouseMoveEvent = {
    x : int ;
    y : int
  }
      
  type mouseButtonEvent =  {
    button : mouseButton ;
    x : int ;
    y : int
  }
      
  type mouseWheelEvent = {
    delta : int;
    x : int ;
    y : int
  }
      
  type joystickConnectEvent = {
    joystickId : int
  }
      
  type joystickMoveEvent = {
    joystickId : int ;
    axis : Joystick.axis ;
    position : float
  }
      
  type joystickButtonEvent = {
    joystickId : int ;
    button : int
  }

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

  external get_full_screen_modes : unit -> t array = "VideoMode_GetFullscreenModes"
  external get_desktop_mode : unit -> t = "VideoMode_GetDesktopMode"
end

type context_settings =
{
  depth_bits : int ;
  stencil_bits : int ;
  antialising_level : int ;
  major_version : int ;
  minor_version : int 
}

type window_style = Titlebar | Resize | Close | Fullscreen

external class window : "sf_Window" =
object (self)
  constructor create_init : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string = "constructor_create"
   external method create : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string -> unit = "Create"
   external method close : unit -> unit = "Close"
  external method is_opened : unit -> bool = "IsOpened"
  external method get_width : unit -> int = "GetWidth"
    external method get_height : unit -> int = "GetHeight"
    method get_size () = self#get_width (), self#get_height ()
    external method get_settings : unit -> context_settings = "GetSettings" 
    external method poll_event : unit -> Event.t option = "PollEvent"
    external method wait_event : unit -> Event.t option = "WaitEvent"
    external method enable_vertical_sync : bool -> unit = "EnableVerticalSync" 
    external method show_mouse_cursor : bool -> unit = "ShowMouseCursor"
    external method set_position : int -> int -> unit = "SetPosition" 
    external method set_size : int -> int -> unit = "SetSize"
    external method set_title : string -> unit = "SetTitle"
    external method show : bool -> unit = "Show" 
    external method enable_key_repeat : bool -> unit = "EnableKeyRepeat"
    (* external method set_icon : int -> int -> char array -> unit = "window__set_icon" *)
    external method set_active : bool -> bool = "SetActive" 
    external method display : unit -> unit = "Display"
    external method set_framerate_limit : int -> unit = "SetFramerateLimit"
    external method get_frame_time : unit -> int = "GetFrameTime" 
    external method set_joystick_threshold : float -> unit = "SetJoystickThreshold"

end

module Mouse =
struct
  type button = Event.mouseButton

  external is_button_pressed : button -> bool = "Mouse_IsButtonPressed"
  external get_position : unit -> int*int = "Mouse_GetPosition"
  external get_relative_position : window -> int*int = "Mouse_GetRelativePosition"
  external set_position : int * int -> unit = "Mouse_SetPosition"
  external set_relative_position : int*int -> window -> unit = "Mouse_SetRelativePosition"
end
