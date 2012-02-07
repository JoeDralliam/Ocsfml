(** module KeyCode : *)

module KeyCode : 
  sig
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

(** is_key_pressed k *)

external is_key_pressed : KeyCode.t -> bool = "Keyboard_IsKeyPressed__impl" 


(** module Joystick *)

module Joystick : 
  sig

    val count : int

    val buttonCount : int

    val axisCount : int

    type axis = X | Y | Z | R | U | V | PovX | PovY

    external is_connected : int -> bool = "Joystick_IsConnected__impl"

    external get_button_count : int -> int = "Joystick_GetButtonCount__impl"

    external has_axis : int -> axis -> bool = "Joystick_HasAxis__impl"

    external is_button_pressed : int -> int -> bool
      = "Joystick_IsButtonPressed__impl"

    external get_axis_position : int -> axis -> float
      = "Joystick_GetAxisPosition__impl"

    external update : unit -> unit = "Joystick_Update__impl"

  end




(** module Context & class context *)

module Context : 
  sig

    type t

    external destroy : t -> unit = "sf_Context_destroy__impl"

    external default : unit -> t = "sf_Context_default_constructor__impl"

    external set_active : t -> bool -> unit = "sf_Context_SetActive__impl"

  end

class context :
  object
    val t_contextCpp : Context.t
    method destroy : unit -> unit
    method rep__sf_Context : Context.t
    method set_active : bool -> unit
  end



(** module Event *)

module Event :
  sig

    type mouseButton =
        MouseLeft
      | MouseRight
      | MouseMiddle
      | MouseXButton1
      | MouseXButton2
      | MouseButtonCount

    type sizeEvent = { width : int; height : int; }

    type keyEvent = {
      code : KeyCode.t;
      alt : bool;
      control : bool;
      shift : bool;
      system : bool;
    }

    type textEvent = { unicode : int; }

    type mouseMoveEvent = { x : int; y : int; }

    type mouseButtonEvent = { button : mouseButton; x : int; y : int; }

    type mouseWheelEvent = { delta : int; x : int; y : int; }

    type joystickConnectEvent = { joystickId : int; }

    type joystickMoveEvent = {
      joystickId : int;
      axis : Joystick.axis;
      position : float;
    }

    type joystickButtonEvent = { joystickId : int; button : int; }

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




(** module VideoMode *)

module VideoMode : 
  sig

    type t = { width : int; height : int; bits_per_pixel : int; }

    val create : ?w:int -> ?h:int -> ?bpp:int -> unit -> t

    external get_full_screen_modes : unit -> t array
      = "VideoMode_GetFullscreenModes__impl"

    external get_desktop_mode : unit -> t = "VideoMode_GetDesktopMode__impl"

  end


(** context_settings *)

type context_settings = { 
  depth_bits : int;
  stencil_bits : int;
  antialising_level : int;
  major_version : int;
  minor_version : int;
}

val mk_context_settings : 
  depth_bits:int -> 
  stencil_bits:int ->
  antialising_level:int ->
  major_version:int ->
  minor_version:int ->
  context_settings


(** module Window & class window *)


module Window :
  sig
    type style = Titlebar | Resize | Close | Fullscreen 
    type t 
    external destroy : t -> unit = "sf_Window_destroy__impl"
    external default : unit -> t = "sf_Window_default_constructor__impl"
    external create_init :
      ?style:style list ->
      ?context:context_settings -> VideoMode.t -> string -> t
      = "sf_Window_constructor_create__impl"
    external create :
      t ->
      ?style:style list ->
      ?context:context_settings -> VideoMode.t -> string -> unit
      = "sf_Window_Create__impl"
    external close : t -> unit = "sf_Window_Close__impl"
    external is_open : t -> bool = "sf_Window_IsOpen__impl"
    external get_width : t -> int = "sf_Window_GetWidth__impl"
    external get_height : t -> int = "sf_Window_GetHeight__impl"
    external get_settings : t -> context_settings
      = "sf_Window_GetSettings__impl"
    external poll_event : t -> Event.t option = "sf_Window_PollEvent__impl"
    external wait_event : t -> Event.t option = "sf_Window_WaitEvent__impl"
    external enable_vertical_sync : t -> bool -> unit
      = "sf_Window_EnableVerticalSync__impl"
    external show_mouse_cursor : t -> bool -> unit
      = "sf_Window_ShowMouseCursor__impl"
    external set_position : t -> int -> int -> unit
      = "sf_Window_SetPosition__impl"
    external set_size : t -> int -> int -> unit = "sf_Window_SetSize__impl"
    external set_title : t -> string -> unit = "sf_Window_SetTitle__impl"
    external show : t -> bool -> unit = "sf_Window_Show__impl"
    external enable_key_repeat : t -> bool -> unit
      = "sf_Window_EnableKeyRepeat__impl"
    external set_active : t -> bool -> bool = "sf_Window_SetActive__impl"
    external display : t -> unit = "sf_Window_Display__impl"
    external set_framerate_limit : t -> int -> unit
      = "sf_Window_SetFramerateLimit__impl"
    external set_joystick_threshold : t -> float -> unit
      = "sf_Window_SetJoystickThreshold__impl"
  end


class window :
  ?style:Window.style list ->
  ?context:context_settings -> VideoMode.t -> string ->
  object
    val t_windowCpp : Window.t
    method close : unit
    method create :
      ?style:Window.style list ->
      ?context:context_settings -> VideoMode.t -> string -> unit
    method destroy : unit -> unit
    method display : unit
    method enable_key_repeat : bool -> unit
    method enable_vertical_sync : bool -> unit
    method get_height : int
    method get_settings : context_settings
    method get_size : int * int
    method get_width : int
    method is_open : bool
    method poll_event : Event.t option
    method rep__sf_Window : Window.t
    method set_active : bool -> bool
    method set_framerate_limit : int -> unit
    method set_joystick_threshold : float -> unit
    method set_position : int -> int -> unit
    method set_size : int -> int -> unit
    method set_title : string -> unit
    method show : bool -> unit
    method show_mouse_cursor : bool -> unit
    method wait_event : Event.t option
  end




(** module Mouse *)

module Mouse : 
  sig
    type button = Event.mouseButton
    external is_button_pressed : button -> bool
      = "Mouse_IsButtonPressed__impl"
    external get_position : unit -> int * int = "Mouse_GetPosition__impl"
    external get_relative_position : #window -> int * int
      = "Mouse_GetRelativePosition__impl"
    external set_position : int * int -> unit = "Mouse_SetPosition__impl"
    external set_relative_position : int * int -> #window -> unit
      = "Mouse_SetRelativePosition__impl"
  end
