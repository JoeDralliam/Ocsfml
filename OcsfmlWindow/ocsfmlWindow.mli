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
external is_key_pressed : KeyCode.t -> bool = "Keyboard_isKeyPressed__impl"
module Joystick :
  sig
    val count : int
    val buttonCount : int
    val axisCount : int
    type axis = X | Y | Z | R | U | V | PovX | PovY
    external is_connected : int -> bool = "Joystick_isConnected__impl"
    external get_button_count : int -> int = "Joystick_getButtonCount__impl"
    external has_axis : int -> axis -> bool = "Joystick_hasAxis__impl"
    external is_button_pressed : int -> int -> bool
      = "Joystick_isButtonPressed__impl"
    external get_axis_position : int -> axis -> float
      = "Joystick_getAxisPosition__impl"
    external update : unit -> unit = "Joystick_update__impl"
  end
module Context :
  sig
    type t
    external destroy : t -> unit = "sf_Context_destroy__impl"
    external default : unit -> t = "sf_Context_default_constructor__impl"
    external set_active : t -> bool -> unit = "sf_Context_setActive__impl"
  end
class contextCpp :
  Context.t ->
  object
    val t_contextCpp : Context.t
    method destroy : unit
    method rep__sf_Context : Context.t
    method set_active : bool -> unit
  end
class context : contextCpp
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
module VideoMode :
  sig
    type t = { width : int; height : int; bits_per_pixel : int; }
    val create : ?w:int -> ?h:int -> ?bpp:int -> unit -> t
    external get_full_screen_modes : unit -> t array
      = "VideoMode_getFullscreenModes__impl"
    external get_desktop_mode : unit -> t = "VideoMode_getDesktopMode__impl"
  end
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
  major_version:int -> minor_version:int -> context_settings
type window_style = Titlebar | Resize | Close | Fullscreen
module WindowCpp :
  sig
    type t
    external destroy : t -> unit = "sf_Window_destroy__impl"
    external default : unit -> t = "sf_Window_default_constructor__impl"
    external create_init :
      ?style:window_style list ->
      ?context:context_settings -> VideoMode.t -> string -> t
      = "sf_Window_constructor_create__impl"
    external create :
      t ->
      ?style:window_style list ->
      ?context:context_settings -> VideoMode.t -> string -> unit
      = "sf_Window_create__impl"
    external close : t -> unit = "sf_Window_close__impl"
    external is_open : t -> bool = "sf_Window_isOpen__impl"
    external get_size : t -> int * int = "sf_Window_getSize__impl"
    external get_settings : t -> context_settings
      = "sf_Window_getSettings__impl"
    external poll_event : t -> Event.t option = "sf_Window_pollEvent__impl"
    external wait_event : t -> Event.t option = "sf_Window_waitEvent__impl"
    external set_vertical_sync_enabled : t -> bool -> unit
      = "sf_Window_setVerticalSyncEnabled__impl"
    external set_mouse_cursor_visible : t -> bool -> unit
      = "sf_Window_setMouseCursorVisible__impl"
    external set_position : t -> int -> int -> unit
      = "sf_Window_setPosition__impl"
    external set_size : t -> int -> int -> unit = "sf_Window_setSize__impl"
    external set_title : t -> string -> unit = "sf_Window_setTitle__impl"
    external set_visible : t -> bool -> unit = "sf_Window_setVisible__impl"
    external set_key_repeat_enabled : t -> bool -> unit
      = "sf_Window_setKeyRepeatEnabled__impl"
    external set_active : t -> bool -> bool = "sf_Window_setActive__impl"
    external display : t -> unit = "sf_Window_display__impl"
    external set_framerate_limit : t -> int -> unit
      = "sf_Window_setFramerateLimit__impl"
    external set_joystick_threshold : t -> float -> unit
      = "sf_Window_setJoystickThreshold__impl"
  end
class windowCpp :
  WindowCpp.t ->
  object
    val t_windowCpp : WindowCpp.t
    method close : unit
    method create :
      ?style:window_style list ->
      ?context:context_settings -> VideoMode.t -> string -> unit
    method destroy : unit
    method display : unit
    method get_height : int
    method get_settings : context_settings
    method get_size : int * int
    method get_width : int
    method is_open : bool
    method poll_event : Event.t option
    method rep__sf_Window : WindowCpp.t
    method set_active : bool -> bool
    method set_framerate_limit : int -> unit
    method set_joystick_threshold : float -> unit
    method set_key_repeat_enabled : bool -> unit
    method set_mouse_cursor_visible : bool -> unit
    method set_position : int -> int -> unit
    method set_size : int -> int -> unit
    method set_title : string -> unit
    method set_vertical_sync_enabled : bool -> unit
    method set_visible : bool -> unit
    method wait_event : Event.t option
  end
module Window :
  sig
    type style = window_style = Titlebar | Resize | Close | Fullscreen
    type t = WindowCpp.t
    external destroy : t -> unit = "sf_Window_destroy__impl"
    external default : unit -> t = "sf_Window_default_constructor__impl"
    external create_init :
      ?style:window_style list ->
      ?context:context_settings -> VideoMode.t -> string -> t
      = "sf_Window_constructor_create__impl"
    external create :
      t ->
      ?style:window_style list ->
      ?context:context_settings -> VideoMode.t -> string -> unit
      = "sf_Window_create__impl"
    external close : t -> unit = "sf_Window_close__impl"
    external is_open : t -> bool = "sf_Window_isOpen__impl"
    external get_size : t -> int * int = "sf_Window_getSize__impl"
    external get_settings : t -> context_settings
      = "sf_Window_getSettings__impl"
    external poll_event : t -> Event.t option = "sf_Window_pollEvent__impl"
    external wait_event : t -> Event.t option = "sf_Window_waitEvent__impl"
    external set_vertical_sync_enabled : t -> bool -> unit
      = "sf_Window_setVerticalSyncEnabled__impl"
    external set_mouse_cursor_visible : t -> bool -> unit
      = "sf_Window_setMouseCursorVisible__impl"
    external set_position : t -> int -> int -> unit
      = "sf_Window_setPosition__impl"
    external set_size : t -> int -> int -> unit = "sf_Window_setSize__impl"
    external set_title : t -> string -> unit = "sf_Window_setTitle__impl"
    external set_visible : t -> bool -> unit = "sf_Window_setVisible__impl"
    external set_key_repeat_enabled : t -> bool -> unit
      = "sf_Window_setKeyRepeatEnabled__impl"
    external set_active : t -> bool -> bool = "sf_Window_setActive__impl"
    external display : t -> unit = "sf_Window_display__impl"
    external set_framerate_limit : t -> int -> unit
      = "sf_Window_setFramerateLimit__impl"
    external set_joystick_threshold : t -> float -> unit
      = "sf_Window_setJoystickThreshold__impl"
  end
class window :
  ?style:window_style list ->
  ?context:context_settings -> VideoMode.t -> string -> windowCpp
module Mouse :
  sig
    type button = Event.mouseButton
    external is_button_pressed : button -> bool
      = "Mouse_isButtonPressed__impl"
    external get_position : unit -> int * int = "Mouse_getPosition__impl"
    external get_relative_position : #window -> int * int
      = "Mouse_getRelativePosition__impl"
    external set_position : int * int -> unit = "Mouse_setPosition__impl"
    external set_relative_position : int * int -> #window -> unit
      = "Mouse_setRelativePosition__impl"
  end
