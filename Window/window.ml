open Window__joystick

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

external is_key_pressed : KeyCode.t -> bool = "keyboard__is_key_pressed"

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
	
  external is_connected : int -> bool = "joystick__is_connected"
  external get_button_count : int -> int = "joystick__get_button_count"
  external has_axis : int -> axis -> bool = "joystick__has_axis"
  external is_button_pressed : int -> int -> bool = "joystick__is_button_pressed"
  external get_axis_position : int -> axis -> float = "joystick__get_axis_position"
  external update : unit -> unit = "joystick__update"
end 

type mouseButton = 
    MouseLeft 
  | MouseRight
  | MouseMiddle
  | MouseXButton1
  | MouseXButton2
  | MouseButtonCount

external is_button_pressed : mouseButton -> bool = "mouse__is_button_pressed"

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
  axis : axis (*;
  position : float*)
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
  | MouseEntered of mouseMoveEvent
  | MouseLeft of mouseMoveEvent
  | JoystickButtonPressed of joystickButtonEvent
  | JoystickButtonReleased of joystickButtonEvent
  | JoystickMoved of joystickMoveEvent
  | JoystickConnected of joystickConnectEvent
  | JoystickDisconnected of joystickConnectEvent

	    
