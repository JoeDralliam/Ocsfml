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
  
external is_key_pressed : KeyCode.t -> bool = "Keyboard_IsKeyPressed__impl"
  
module Joystick =
  struct
    let count = 8
      
    let buttonCount = 32
      
    let axisCount = 8
      
    type axis = | X | Y | Z | R | U | V | PovX | PovY
    
    (* The X axis *)
    (* The Y axis *)
    (* The Z axis *)
    (* The R axis *)
    (* The U axis *)
    (* The V axis *)
    (* The X axis of the point-of-view hat *)
    (* The Y axis of the point-of-view hat *)
    external is_connected : int -> bool = "Joystick_IsConnected__impl"
      
    external get_button_count : int -> int = "Joystick_GetButtonCount__impl"
      
    external has_axis : int -> axis -> bool = "Joystick_HasAxis__impl"
      
    external is_button_pressed : int -> int -> bool =
      "Joystick_IsButtonPressed__impl"
      
    external get_axis_position : int -> axis -> float =
      "Joystick_GetAxisPosition__impl"
      
    external update : unit -> unit = "Joystick_Update__impl"
      
  end
  
module Context =
  struct
    type t
    
    external destroy : t -> unit = "sf_Context_destroy__impl"
      
    external default : unit -> t = "sf_Context_default_constructor__impl"
      
    external set_active : t -> bool -> unit = "sf_Context_SetActive__impl"
      
  end
  
class contextCpp t_contextCpp' =
  object val t_contextCpp = t_contextCpp'
           
    method rep__sf_Context = t_contextCpp
      
    method destroy = fun () -> Context.destroy t_contextCpp
      
    method set_active : bool -> unit =
      fun p1 -> Context.set_active t_contextCpp p1
      
  end
  
let _ =
  let external_cpp_create_sf_Context t = new contextCpp t
  in
    Callback.register "external_cpp_create_sf_Context"
      external_cpp_create_sf_Context
  
class context = let d = Context.default () in contextCpp d
  
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
    
    type mouseMoveEvent = { x : int; y : int }
    
    type mouseButtonEvent = { button : mouseButton; x : int; y : int }
    
    type mouseWheelEvent = { delta : int; x : int; y : int }
    
    type joystickConnectEvent = { joystickId : int }
    
    type joystickMoveEvent =
      { joystickId : int; axis : Joystick.axis; position : float
      }
    
    type joystickButtonEvent = { joystickId : int; button : int }
    
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
      
    external get_full_screen_modes : unit -> t array =
      "VideoMode_GetFullscreenModes__impl"
      
    external get_desktop_mode : unit -> t = "VideoMode_GetDesktopMode__impl"
      
  end
  
type context_settings =
  { depth_bits : int; stencil_bits : int; antialising_level : int;
    major_version : int; minor_version : int
  }

type window_style = | Titlebar | Resize | Close | Fullscreen

module Window =
  struct
    type t
    
    external destroy : t -> unit = "sf_Window_destroy__impl"
      
    external default : unit -> t = "sf_Window_default_constructor__impl"
      
    external create_init :
      ?style: (window_style list) ->
        ?context: context_settings -> VideoMode.t -> string -> t =
      "sf_Window_constructor_create__impl"
      
    external create :
      t ->
        ?style: (window_style list) ->
          ?context: context_settings -> VideoMode.t -> string -> unit =
      "sf_Window_Create__impl"
      
    external close : t -> unit = "sf_Window_Close__impl"
      
    external is_opened : t -> bool = "sf_Window_IsOpened__impl"
      
    external get_width : t -> int = "sf_Window_GetWidth__impl"
      
    external get_height : t -> int = "sf_Window_GetHeight__impl"
      
    external get_settings : t -> context_settings =
      "sf_Window_GetSettings__impl"
      
    external poll_event : t -> Event.t option = "sf_Window_PollEvent__impl"
      
    external wait_event : t -> Event.t option = "sf_Window_WaitEvent__impl"
      
    external enable_vertical_sync : t -> bool -> unit =
      "sf_Window_EnableVerticalSync__impl"
      
    external show_mouse_cursor : t -> bool -> unit =
      "sf_Window_ShowMouseCursor__impl"
      
    external set_position : t -> int -> int -> unit =
      "sf_Window_SetPosition__impl"
      
    external set_size : t -> int -> int -> unit = "sf_Window_SetSize__impl"
      
    external set_title : t -> string -> unit = "sf_Window_SetTitle__impl"
      
    external show : t -> bool -> unit = "sf_Window_Show__impl"
      
    external enable_key_repeat : t -> bool -> unit =
      "sf_Window_EnableKeyRepeat__impl"
      
    external set_active : t -> bool -> bool = "sf_Window_SetActive__impl"
      
    external display : t -> unit = "sf_Window_Display__impl"
      
    external set_framerate_limit : t -> int -> unit =
      "sf_Window_SetFramerateLimit__impl"
      
    external get_frame_time : t -> int = "sf_Window_GetFrameTime__impl"
      
    external set_joystick_threshold : t -> float -> unit =
      "sf_Window_SetJoystickThreshold__impl"
      
  end
  
class windowCpp t_windowCpp' =
  object (self)
    val t_windowCpp = t_windowCpp'
      
    method rep__sf_Window = t_windowCpp
      
    method destroy = fun () -> Window.destroy t_windowCpp
      
    method create :
      ?style: (window_style list) ->
        ?context: context_settings -> VideoMode.t -> string -> unit =
      fun ?(style) ?(context) p3 p4 ->
        Window.create t_windowCpp ?style ?context p3 p4
      
    method close = fun () -> Window.close t_windowCpp
      
    method is_opened = fun () -> Window.is_opened t_windowCpp
      
    method get_width = fun () -> Window.get_width t_windowCpp
      
    method get_height = fun () -> Window.get_height t_windowCpp
      
    method get_size = fun () -> ((self#get_width ()), (self#get_height ()))
      
    method get_settings = fun () -> Window.get_settings t_windowCpp
      
    method poll_event = fun () -> Window.poll_event t_windowCpp
      
    method wait_event = fun () -> Window.wait_event t_windowCpp
      
    method enable_vertical_sync : bool -> unit =
      fun p1 -> Window.enable_vertical_sync t_windowCpp p1
      
    method show_mouse_cursor : bool -> unit =
      fun p1 -> Window.show_mouse_cursor t_windowCpp p1
      
    method set_position : int -> int -> unit =
      fun p1 p2 -> Window.set_position t_windowCpp p1 p2
      
    method set_size : int -> int -> unit =
      fun p1 p2 -> Window.set_size t_windowCpp p1 p2
      
    method set_title : string -> unit =
      fun p1 -> Window.set_title t_windowCpp p1
      
    method show : bool -> unit = fun p1 -> Window.show t_windowCpp p1
      
    method enable_key_repeat : bool -> unit =
      fun p1 -> Window.enable_key_repeat t_windowCpp p1
      
    method set_active : bool -> bool =
      fun p1 -> Window.set_active t_windowCpp p1
      
    method display = fun () -> Window.display t_windowCpp
      
    method set_framerate_limit : int -> unit =
      fun p1 -> Window.set_framerate_limit t_windowCpp p1
      
    method get_frame_time = fun () -> Window.get_frame_time t_windowCpp
      
    method set_joystick_threshold : float -> unit =
      fun p1 -> Window.set_joystick_threshold t_windowCpp p1
      
  end
  
let _ =
  let external_cpp_create_sf_Window t = new windowCpp t
  in
    Callback.register "external_cpp_create_sf_Window"
      external_cpp_create_sf_Window
  
(* external method set_icon : int -> int -> char array -> unit = "window__set_icon" *)
class window ?style ?context vm name =
  let t = Window.create_init ?style ?context vm name
  in windowCpp t
  
module Mouse =
  struct
    type button = Event.mouseButton
    
    external is_button_pressed : button -> bool =
      "Mouse_IsButtonPressed__impl"
      
    external get_position : unit -> (int * int) = "Mouse_GetPosition__impl"
      
    external get_relative_position : window -> (int * int) =
      "Mouse_GetRelativePosition__impl"
      
    external set_position : (int * int) -> unit = "Mouse_SetPosition__impl"
      
    external set_relative_position : (int * int) -> window -> unit =
      "Mouse_SetRelativePosition__impl"
      
  end
  

