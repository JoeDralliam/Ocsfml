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

external cpp is_key_pressed : KeyCode.t -> bool = "Keyboard_IsKeyPressed"

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
	
  external cpp is_connected : int -> bool = "Joystick_IsConnected"
  external cpp get_button_count : int -> int = "Joystick_GetButtonCount"
  external cpp has_axis : int -> axis -> bool = "Joystick_HasAxis"
  external cpp is_button_pressed : int -> int -> bool = "Joystick_IsButtonPressed"
  external cpp get_axis_position : int -> axis -> float = "Joystick_GetAxisPosition"
  external cpp update : unit -> unit = "Joystick_Update"
end 

external class contextCpp (Context) : "sf_Context" = 
object
  constructor default : unit = "default_constructor"
  external method set_active : bool -> unit = "SetActive"
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
  let create ?(w=800) ?(h=600) ?(bpp=32) () =
    { width = w ; height = h ; bits_per_pixel = bpp }
  external cpp get_full_screen_modes : unit -> t array = "VideoMode_GetFullscreenModes"
  external cpp get_desktop_mode : unit -> t = "VideoMode_GetDesktopMode"
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

external class windowCpp (Window) : "sf_Window" =
object (self)
  constructor default : unit = "default_constructor" 
  constructor create_init : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string = "constructor_create"
  external method create : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string -> unit = "Create"
  external method close : unit = "Close"
  external method is_open : bool = "IsOpen"
  external method get_width : int = "GetWidth"
  external method get_height : int = "GetHeight"
  method get_size () = self#get_width (), self#get_height ()
  external method get_settings : context_settings = "GetSettings" 
  external method poll_event : Event.t option = "PollEvent"
  external method wait_event : Event.t option = "WaitEvent"
  external method enable_vertical_sync : bool -> unit = "EnableVerticalSync" 
  external method show_mouse_cursor : bool -> unit = "ShowMouseCursor"
  external method set_position : int -> int -> unit = "SetPosition" 
  external method set_size : int -> int -> unit = "SetSize"
  external method set_title : string -> unit = "SetTitle"
  external method show : bool -> unit = "Show" 
  external method enable_key_repeat : bool -> unit = "EnableKeyRepeat"
  (* external method set_icon : int -> int -> char array -> unit = "window__set_icon" *)
  external method set_active : bool -> bool = "SetActive" 
  external method display : unit = "Display"
  external method set_framerate_limit : int -> unit = "SetFramerateLimit"
(*  external method get_frame_time : int = "GetFrameTime"  *)
  external method set_joystick_threshold : float -> unit = "SetJoystickThreshold"
end

class window ?style ?context vm name = 
  let t = Window.create_init ?style ?context vm name in 
    windowCpp t

module Mouse =
struct
  type button = Event.mouseButton

  external cpp is_button_pressed : button -> bool = "Mouse_IsButtonPressed"
  external cpp get_position : int*int = "Mouse_GetPosition"
  external cpp get_relative_position :  (#window as 'a) -> int*int = "Mouse_GetRelativePosition"
  external cpp set_position : int * int -> unit = "Mouse_SetPosition"
  external cpp set_relative_position : int*int -> (#window as 'a) -> unit = "Mouse_SetRelativePosition"
end
