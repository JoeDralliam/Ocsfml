(** Windowing & event management *)


type pixel_array_type = (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array3.t

val pixel_array_kind : (int, Bigarray.int8_unsigned_elt) Bigarray.kind

val pixel_array_layout : Bigarray.c_layout Bigarray.layout


(** Module KeyCode : Key codes. *)
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

(** Give access to the real-time state of the keyboard.
    
    Keyboard provides an interface to the state of the keyboard.
    
    This class allows users to query the keyboard state at any time and directly, without having to deal with a window and its events. Compared to the KeyPressed and KeyReleased events, Keyboard can retrieve the state of a key at any time (you don't need to store and update a boolean on your side in order to know if a key is pressed or released), and you always get the real state of the keyboard, even if keys are pressed or released when your window is out of focus and no event is triggered.

    Usage example:
    {[
    if OcsfmlWindow.Keyboard.is_key_pressed OcsfmlWindow.KeyCode.Left
    then begin
    (* move left... *)
    end
    else if OcsfmlWindow.Keyboard.is_key_pressed OcsfmlWindow.KeyCode.Right
    then begin
    (* move right... *)
    end
    else if OcsfmlWindow.Keyboard.is_key_pressed OcsfmlWindow.KeyCode.Escape
    then begin
    (* quit... *)
    end
    ]} *)
module Keyboard :
sig
  (** Check if a key is pressed. 
      @return True if the key is pressed, false otherwise *)
  val is_key_pressed : KeyCode.t -> bool
end


(** Give access to the real-time state of the joysticks.

    Joystick provides an interface to the state of the joysticks.


    It only contains static functions, so it's not meant to be instanciated. Instead, each joystick is identified by an index that is passed to the functions of this class.


    This class allows users to query the state of joysticks at any time and directly, without having to deal with a window and its events. Compared to the JoystickMoved, JoystickButtonPressed and JoystickButtonReleased events, Joystick can retrieve the state of axes and buttons of joysticks at any time (you don't need to store and update a boolean on your side in order to know if a button is pressed or released), and you always get the real state of joysticks, even if they are moved, pressed or released when your window is out of focus and no event is triggered.


    SFML supports:

    - 8 joysticks (Joystick.count)
    - 32 buttons per joystick (Joystick.buttonCount)
    - 8 axes per joystick (Joystick.axisCount)


    Unlike the keyboard or mouse, the state of joysticks is sometimes not directly available (depending on the OS), therefore an update() function must be called in order to update the current state of joysticks. When you have a window with event handling, this is done automatically, you don't need to call anything. But if you have no window, or if you want to check joysticks state before creating one, you must call Joystick.update explicitely. 

    Usage example:
    {[
    (* The id of joystick #0 *)
    let id = OcsfmlWindow.id_from_int 0

    (* Is joystick #0 connected? *)
    let connected = OcsfmlWindow.Joystick.is_connected id in    

    (* How many buttons does joystick #0 support? *)
    let buttons = OcsfmlWindow.Joystick.get_button_count id in
    
    (* Does joystick #0 define a X axis? *)
    let hasX = OcsfmlWindow.Joystick.has_axis id OcsfmlWindow.Joystick.X in
    
    (* Is button #2 pressed on joystick #0? *)
    let pressed = OcsfmlWindow.Joystick.is_button_pressed id 2 in
    
    (* What's the current position of the Y axis on joystick #0? *)
    let position = OcsfmlWindow.Joystick.get_axis_position id OcsfmlWindow.Joystick.Y in
    ...
    ]} *)
module Joystick :
sig
  
  (** type of a joystick identifier *)
  type id = private int 
  
  (** Maximum number of supported joysticks. *)
  val count : int
    
  (** Maximum number of supported buttons. *)
  val buttonCount : int
    
  (** Maximum number of supported axes. *)
  val axisCount : int
    
  (** Axes supported by SFML joysticks. *)
  type axis = X | Y | Z | R | U | V | PovX | PovY
      
  (** Create a joystick_id from an int n 
      @return a joystick_id if n is between 0 and count-1, raise Invalid_argument otherwise *)
  val id_from_int : int -> id

  (** Check if a joystick is connected. 
      @return True if the joystick is connected, false otherwise *)
  val is_connected : id -> bool
    
  (** Return the number of buttons supported by a joystick.
      
      If the joystick is not connected, this function returns 0.
      @return Number of buttons supported by the joystick *)
  val get_button_count : id -> int
    
  (** Check if a joystick supports a given axis.
      
      If the joystick is not connected, this function returns false.
      @return True if the joystick supports the axis, false otherwise *)
  val has_axis : id -> axis -> bool
    
  (** Check if a joystick button is pressed.
      
      If the joystick is not connected, this function returns false.
      @return True if the button is pressed, false otherwise *)
  val is_button_pressed : id -> int -> bool
    
  (** Get the current position of a joystick axis.
      
      If the joystick is not connected, this function returns 0.
      @return Current position of the axis, in range [-100 .. 100] *)
  val get_axis_position : id -> axis -> float
    
  (** Update the states of all joysticks.
      
      This function is used internally by SFML, so you normally don't have to call it explicitely. However, you may need to call it if you have no window yet (or no window at all): in this case the joysticks states are not updated automatically. *)
  val update : unit -> unit
end


(**/**)
module Context :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val set_active : t -> bool -> bool
end
(**/**)

(** Class holding a valid drawing context.

    If you need to make OpenGL calls without having an active window (like in a thread), you can use an instance of this class to get a valid context.

    Having a valid context is necessary for *every* OpenGL call.

    Note that a context is only active in its current thread, if you create a new thread it will have no valid context by default.

    To use a context instance, just construct it and let it live as long as you need a valid context. No explicit activation is needed, all it has to do is to exist. Its destructor will take care of deactivating and freeing all the attached resources. 

    Usage example:
    {[
    let thread_func () =
        let context = new context in
        (* from now on, you have a valid context *)
      
        (* you can make OpenGL calls *)
         GlClear.clear [`depth];

        (* Destruction is not automated *)
         context#destroy 
    ]}
*)
class context :
object
  (**/**)
  val t_context_base : Context.t
    (**/**)

  (**)
  method destroy : unit

  (**/**)
  method rep__sf_Context : Context.t
    (**/**)

  (** Activate or deactivate explicitely the context. 
      @return True on success, false on failure*)
  method set_active : bool -> bool
end

(** Defines a system event and its parameters.

    Event.t holds all the informations about a system event that just happened.

    Events are retrieved using the Window.poll_event and Window.wait_event functions.

    A Event.t instance contains the type of the event (mouse moved, key pressed, window closed, ...) as well as the details about this particular event. 

    Usage example:
    {[    
    let rec poll_events window =
        let open OcsfmlWindow.Event in
        match window#poll_event with
            | Some e -> begin
                match e with
                    | Closed -> window#close
                    | KeyPressed { code = KeyCode.Escape ; _ } -> window#close
                    | Resized { width ; height } -> do_something_with_the_new_size width height ;
                poll_events window end
            | None -> ()
    in poll_events my_window
    ]} *)
module Event :
sig
  
  type mouseButton =
      MouseLeft
    | MouseRight
    | MouseMiddle
    | MouseXButton1
    | MouseXButton2
    | MouseButtonCount

  (** Size events parameters (Resized) *)
  type sizeEvent = { 
    width : int; (** New width, in pixels. *)
    height : int; (** New height, in pixels. *)
  }
  (** Keyboard event parameters (KeyPressed, KeyReleased) *)
  type keyEvent = {
    code : KeyCode.t; (** Code of the key that has been pressed. *)
    alt : bool; (** Is the Alt key pressed? *)
    control : bool; (** Is the Control key pressed? *)
    shift : bool; (** Is the Shift key pressed? *)
    system : bool; (** Is the System key pressed? *)
  }

  (** Text event parameters (TextEntered) *)
  type textEvent = { 
    unicode : int; (** UTF-32 unicode value of the character. *)
  }
      
  type mouseCoord = {
    x : int ; (** X position of the mouse pointer, relative to the left of the owner window. *)
    y : int ; (** Y position of the mouse pointer, relative to the top of the owner window. *)
  }

  (** Mouse move event parameters (MouseMoved) *)
  type mouseMoveEvent = mouseCoord (** coordinates of the mouse pointer *)
      
  (** Mouse buttons events parameters (MouseButtonPressed, MouseButtonReleased) *)
  type mouseButtonEvent =  
      mouseButton (** Code of the button that has been pressed. *)
      * mouseCoord  (** coordinates of the mouse pointer *)
      
  (** Mouse wheel events parameters (MouseWheelMoved) *)
  type mouseWheelEvent = 
      int (** Number of ticks the wheel has moved (positive is up, negative is down) *)
      * mouseCoord  (** coordinates of the mouse pointer *)
 
  (** Joystick connection events parameters (JoystickConnected, JoystickDisconnected) *)
  type joystickConnectEvent = Joystick.id (** Index of the joystick (in range [0 .. Joystick.count - 1]) *)
      
  (** Joystick axis move event parameters (JoystickMoved) *)
  type joystickMoveEvent = 
      Joystick.id (** Index of the joystick (in range [0 .. Joystick.count - 1]) *)
      * Joystick.axis (** Axis on which the joystick moved. *)
      * float (** New position on the axis (in range [-100 .. 100]) *)

  (** Joystick buttons events parameters (JoystickButtonPressed, JoystickButtonReleased) *)
  type joystickButtonEvent = 
      Joystick.id (** Index of the joystick (in range [0 .. Joystick.count - 1]) *)
      * int (** Index of the joystick (in range [0 .. Joystick.count - 1]) *)
      
  (** Enumeration of the different types of events. *)
  type t =
      Closed	(** The window requested to be closed. *)
    | LostFocus (** The window lost the focus. *)
    | GainedFocus (** The window gained the focus. *)
    | Resized of sizeEvent (** The window was resized. *)
    | TextEntered of textEvent (** A character was entered. *)
    | KeyPressed of keyEvent (** A key was pressed. *)
    | KeyReleased of keyEvent (** A key was released. *)
    | MouseWheelMoved of mouseWheelEvent (** The mouse wheel was scrolled. *)
    | MouseButtonPressed of mouseButtonEvent (** A mouse button was pressed. *)
    | MouseButtonReleased of mouseButtonEvent (** A mouse button was released. *)
    | MouseMoved of mouseMoveEvent (** The mouse cursor moved. *)
    | MouseEntered (** The mouse cursor entered the area of the window. *)
    | MouseLeft (** The mouse cursor left the area of the window. *)
    | JoystickButtonPressed of joystickButtonEvent (** A joystick button was pressed. *)
    | JoystickButtonReleased of joystickButtonEvent (** A joystick button was released. *)
    | JoystickMoved of joystickMoveEvent (** The joystick moved along an axis. *)
    | JoystickConnected of joystickConnectEvent (** A joystick was connected. *)
    | JoystickDisconnected of joystickConnectEvent (** A joystick was disconnected. *)
end
  
(** VideoMode.t defines a video mode (width, height, bpp)
    
    A video mode is defined by a width and a height (in pixels) and a depth (in bits per pixel).
    
    Video modes are used to setup windows (window) at creation time.
    
    The main usage of video modes is for fullscreen mode: indeed you must use one of the valid video modes allowed by the OS (which are defined by what the monitor and the graphics card support), otherwise your window creation will just fail.
    
    VideoMode.t provides a static function for retrieving the list of all the video modes supported by the system: get_fullscreen_modes().

    A custom video mode can also be checked directly for fullscreen compatibility with its is_valid() function.

    Additionnally, the module VideoMode provides a function to get the mode currently used by the desktop: get_desktop_mode(). This allows to build windows with the same size or pixel depth as the current resolution. *)
module VideoMode :
sig
  type t = { 
    width : int; (** Video mode width, in pixels. *)
    height : int; (** Video mode height, in pixels. *)
    bits_per_pixel : int; (** Video mode pixel depth, in bits per pixels. *)
  }

  val create : ?w:int -> ?h:int -> ?bpp:int -> unit -> t
    

  (** Tell whether or not the video mode is valid.

      The validity of video modes is only relevant when using fullscreen windows; otherwise any video mode can be used with no restriction.
      @return True if the video mode is valid for fullscreen mode *)
  val is_valid : t -> bool

  (** Retrieve all the video modes supported in fullscreen mode.
      
      When creating a fullscreen window, the video mode is restricted to be compatible with what the graphics driver and monitor support. This function returns the complete list of all video modes that can be used in fullscreen mode. The returned array is sorted from best to worst, so that the first element will always give the best mode (higher width, height and bits-per-pixel). 
      @return Array containing all the supported fullscreen modes *)
  val get_full_screen_modes : unit -> t array
    
  (** Get the current desktop video mode. 
      @return Current desktop video mode *)
  val get_desktop_mode : unit -> t
end

(** Structure defining the settings of the OpenGL context attached to a window.

    context_settings allows to define several advanced settings of the OpenGL context attached to a window.
    
    All these settings have no impact on the regular SFML rendering (graphics module) -- except the anti-aliasing level, so you may need to use this structure only if you're using SFML as a windowing system for custom OpenGL rendering.
    
    - The depth_bits and stencil_bits members define the number of bits per pixel requested for the (respectively) depth and stencil buffers.

    - antialiasing_level represents the requested number of multisampling levels for anti-aliasing.
    
    - major_version and minor_version define the version of the OpenGL context that you want. Only versions greater or equal to 3.0 are relevant; versions lesser than 3.0 are all handled the same way (i.e. you can use any version < 3.0 if you don't want an OpenGL 3 context).
    
    Please note that these values are only a hint. No failure will be reported if one or more of these values are not supported by the system; instead, SFML will try to find the closest valid match. You can then retrieve the settings that the window actually used to create its context, with window.get_settings.  *)
type context_settings = {
  depth_bits : int; (** Bits of the depth buffer. *)
  stencil_bits : int; (** Bits of the stencil buffer. *)
  antialising_level : int; (** Level of antialiasing. *)
  major_version : int; (** Major number of the context version to create. *)
  minor_version : int; (** Minor number of the context version to create. *)
}


val mk_context_settings :
  ?depth_bits:int ->
  ?stencil_bits:int ->
  ?antialising_level:int ->
  ?major_version:int -> 
  ?minor_version:int -> unit -> context_settings


(**/**)
module WindowBase :
sig
  type style = 
    Titlebar 
  | Resize
  | Close
  | Fullscreen

  type t
  val destroy : t -> unit
  val default : unit -> t
  val create_init :
    ?style:style list ->
      ?context:context_settings -> VideoMode.t -> string -> t
  val create :
    t ->
      ?style:style list ->
	?context:context_settings -> VideoMode.t -> string -> unit
  val close : t -> unit
  val is_open : t -> bool
  val get_position : t -> int * int
  val get_size : t -> int * int
  val get_settings : t -> context_settings
  val poll_event : t -> Event.t option
  val wait_event : t -> Event.t option
  val set_vertical_sync_enabled : t -> bool -> unit
  val set_mouse_cursor_visible : t -> bool -> unit
  val set_position_v : t -> int * int -> unit
  val set_size_v : t -> int * int -> unit
  val set_title : t -> string -> unit
  val set_visible : t -> bool -> unit
  val set_key_repeat_enabled : t -> bool -> unit
  val set_active : t -> ?active:bool -> unit -> bool
  val display : t -> unit
  val set_framerate_limit : t -> int -> unit
  val set_joystick_threshold : t -> float -> unit
  val set_icon : t -> pixel_array_type -> unit
end

class window_base :
  WindowBase.t ->
object
  val t_window_base : WindowBase.t
  method close : unit
  method create :
    ?style:WindowBase.style list ->
      ?context:context_settings -> VideoMode.t -> string -> unit
  method destroy : unit
  method display : unit
  method get_height : int
  method get_position : int * int
  method get_settings : context_settings
  method get_size : int * int
  method get_width : int
  method is_open : bool
  method poll_event : Event.t option
  method rep__sf_Window : WindowBase.t
  method set_active : ?active:bool -> unit -> bool
  method set_framerate_limit : int -> unit
  method set_icon : pixel_array_type -> unit
  method set_joystick_threshold : float -> unit
  method set_key_repeat_enabled : bool -> unit
  method set_mouse_cursor_visible : bool -> unit
  method set_position : int -> int -> unit
  method set_position_v : int * int -> unit
  method set_size : int -> int -> unit
  method set_size_v : int * int -> unit
  method set_title : string -> unit
  method set_vertical_sync_enabled : bool -> unit
  method set_visible : bool -> unit
  method wait_event : Event.t option
end
(**/**)


module Window :
sig
  (** Enumeration of the window styles. *)
  type style = 
      WindowBase.style =
      Titlebar (** Title bar + fixed border. *)
    | Resize  (** Titlebar + resizable border + maximize button. *)
    | Close  (** Titlebar + close button. *)
    | Fullscreen  (** Fullscreen mode (this flag and all others are mutually exclusive) *)
	  

  (**/**)
  type t = WindowBase.t
  val destroy : t -> unit
  val default : unit -> t
  val create_init :
    ?style:style list ->
      ?context:context_settings -> VideoMode.t -> string -> t
  val create :
    t ->
      ?style:style list ->
	?context:context_settings -> VideoMode.t -> string -> unit
  val close : t -> unit
  val is_open : t -> bool
  val get_position : t -> int * int
  val get_size : t -> int * int
  val get_settings : t -> context_settings
  val poll_event : t -> Event.t option
  val wait_event : t -> Event.t option
  val set_vertical_sync_enabled : t -> bool -> unit
  val set_mouse_cursor_visible : t -> bool -> unit
  val set_position_v : t -> int * int -> unit
  val set_size_v : t -> int * int -> unit
  val set_title : t -> string -> unit
  val set_visible : t -> bool -> unit
  val set_key_repeat_enabled : t -> bool -> unit
  val set_active : t -> ?active:bool -> unit -> bool
  val display : t -> unit
  val set_framerate_limit : t -> int -> unit
  val set_joystick_threshold : t -> float -> unit
  val set_icon : t -> pixel_array_type -> unit
end


(** Window that serves as a target for OpenGL rendering.
    
    sf::Window is the main class of the Window module.
    
    It defines an OS window that is able to receive an OpenGL rendering.

    The OcsfmlWindow.Window class provides a simple interface for manipulating the window: move, resize, show/hide, control mouse cursor, etc. It also provides event handling through its poll_event and wait_event methods.
    
    Note that OpenGL experts can pass their own parameters (antialiasing level, bits for the depth and stencil buffers, etc.) to the OpenGL context attached to the window, with the sf::ContextSettings structure which is passed as an optional argument when creating the window.
    
    Usage example:
    {[
    (* Declare and create a new window *)
    let window = new window (VideoMode.create ~w:800 ~h:600) "SFML window" in
    
    (* Limit the framerate to 60 frames per second (this step is optional) *)
    window#set_framerate_limit 60.

    (* The main loop - ends as soon as the window is closed *)
    let rec main_loop () =
        (* Event processing *)
        let rec poll_events () =
            match window#poll_event with
                (* Request for closing the window *)
                | Some Closed -> ( window#close ; poll_events () )
                | Some ev -> poll_events ()
                | None -> ()
        in poll_events () ; 
        (* Activate the window for OpenGL rendering *)
        window#set_active ();

        (* OpenGL drawing commands go here... *)
   
        (* End the current frame and display its contents on screen *)
        window#display
        if window#is_open
        then main_loop ()
    in main_loop ()
    ]} *)
class window :
  ?style:Window.style list ->
    ?context:context_settings -> VideoMode.t -> string -> 
object
  (**/**)
  val t_window_base : WindowBase.t
    (**/**)
  
  (** Close the window and destroy all the attached resources.

      After calling this function, the sf::Window instance remains valid and you can call create to recreate the window. All other functions such as poll_event or display will still work (i.e. you don't have to test is_open every time), and will have no effect on closed windows. *)
  method close : unit
  
  (** Create (or recreate) the window from an existing control.

      Use this function if you want to create an OpenGL rendering area into an already existing control. If the window was already created, it closes it first.
      @param style Window style 
      @param contex Additional settings for the underlying OpenGL context *)
  method create :
    ?style:Window.style list ->
      ?context:context_settings -> VideoMode.t -> string -> unit
  
  (**)
  method destroy : unit
  

  (** Display on screen what has been rendered to the window so far.

      This function is typically called after all OpenGL rendering has been done for the current frame, in order to show it on screen. *)
  method display : unit
  

  method get_height : int
  
  (** Get the position of the window. 
      @return Position of the window, in pixels. *)
  method get_position : int * int
  

  (** Get the settings of the OpenGL context of the window.

      Note that these settings may be different from what was passed to the constructor or the create() function, if one or more settings were not supported. In this case, SFML chose the closest match. 
      @return Structure containing the OpenGL context settings *)
  method get_settings : context_settings
  
  (** Get the size of the rendering region of the window.

      The size doesn't include the titlebar and borders of the window.
      @return Size in pixels *)
  method get_size : int * int
  

  method get_width : int
  
  (** Tell whether or not the window is open.

      This function returns whether or not the window exists. Note that a hidden window (setVisible(false)) is open (therefore this function would return true).
      @return True if the window is open, false if it has been closed *)
  method is_open : bool
    
  (** Pop the event on top of events stack, if any, and return it.
      
      This function is not blocking: if there's no pending event then it will return None. Note that more than one event may be present in the events stack, thus you should always call this function in a loop or recursive function to make sure that you process every pending event.

      {[
      let rec poll_events window =
      match window#poll_event with
          | Some event -> begin
              (* process event... *) ;
              poll_events window
          | None ()
      in poll_events ... 
      ]} 
      @return The returned event if any, None otherwise *)
  method poll_event : Event.t option
  
  (**/**)
  method rep__sf_Window : WindowBase.t
    (**/**)  

  (** Activate or deactivate the window as the current target for OpenGL rendering.

      A window is active only on the current thread, if you want to make it active on another thread you have to deactivate it on the previous thread first if it was active. Only one window can be active on a thread at a time, thus the window previously active (if any) automatically gets deactivated.
      @param active True to activate, false to deactivate
      @return True if operation was successful, false otherwise*)
  method set_active : ?active:bool -> unit -> bool
  
  (** Limit the framerate to a maximum fixed frequency.
      
      If a limit is set, the window will use a small delay after each call to display to ensure that the current frame lasted long enough to match the framerate limit. SFML will try to match the given limit as much as it can, but since it internally uses sleep, whose precision depends on the underlying OS, the results may be a little unprecise as well (for example, you can get 65 FPS when requesting 60).*)
  method set_framerate_limit : int -> unit
  
  (** Change the window's icon.

      pixels must be an array of pixels in 32-bits RGBA format.

      The OS default icon is used by default.*)
  method set_icon : pixel_array_type -> unit
  
  (** Change the joystick threshold.
      
      The joystick threshold is the value below which no JoystickMoved event will be generated.
      
      The threshold value is 0.1 by default.*)
  method set_joystick_threshold : float -> unit
  
  (** Enable or disable automatic key-repeat.
      
      If key repeat is enabled, you will receive repeated KeyPressed events while keeping a key pressed. If it is disabled, you will only get a single event when the key is pressed.
      
      Key repeat is enabled by default.*)
  method set_key_repeat_enabled : bool -> unit
  
  (** Show or hide the mouse cursor.

      The mouse cursor is visible by default.*)
  method set_mouse_cursor_visible : bool -> unit
  
  (** Change the position of the window on screen.

      This function only works for top-level windows (i.e. it will be ignored for windows created from the handle of a child window/control).*)
  method set_position : int -> int -> unit
  
  (** Change the position of the window on screen.

      This function only works for top-level windows (i.e. it will be ignored for windows created from the handle of a child window/control).*)
  method set_position_v : int * int -> unit
  
  (** Change the size of the rendering region of the window. *)
  method set_size : int -> int -> unit
  
  (** Change the size of the rendering region of the window. *)
  method set_size_v : int * int -> unit
  
  (** Change the title of the window. *)
  method set_title : string -> unit
  
  (** Enable or disable vertical synchronization.

      Activating vertical synchronization will limit the number of frames displayed to the refresh rate of the monitor. This can avoid some visual artifacts, and limit the framerate to a good value (but not constant across different computers).

      Vertical synchronization is disabled by default.*)
  method set_vertical_sync_enabled : bool -> unit
  
  (** Show or hide the window.

      The window is shown by default.*)
  method set_visible : bool -> unit
  
  (** Wait for an event and return it.
      
      This function is blocking: if there's no pending event then it will wait until an event is received. After this function returns (and no error occured), the event object is always valid and filled properly. This function is typically used when you have a thread that is dedicated to events handling: you want to make this thread sleep as long as no new event is received.
      {[
      match window#wait_event with
          | Some event -> (* process event... *)
          | None -> (* error... *)      
      ]}
      @return None if any error occured, the event otherwise. *)
  method wait_event : Event.t option
end


(** Give access to the real-time state of the mouse.

    Mouse provides an interface to the state of the mouse.
    
    A single mouse is assumed.
    
    This class allows users to query the mouse state at any time and directly, without having to deal with a window and its events. Compared to the MouseMoved, MouseButtonPressed and MouseButtonReleased events, Mouse can retrieve the state of the cursor and the buttons at any time (you don't need to store and update a boolean on your side in order to know if a button is pressed or released), and you always get the real state of the mouse, even if it is moved, pressed or released when your window is out of focus and no event is triggered.
    
    The set_position and get_position functions can be used to change or retrieve the current position of the mouse pointer. There are two versions: one that operates in global coordinates (relative to the desktop) and one that operates in window coordinates (relative to a specific window). *)
module Mouse :
sig
  (** Mouse buttons *)
  type button = Event.mouseButton
      

  (** Check if a mouse button is pressed. 
      @return True if the button is pressed, false otherwise *)
  val is_button_pressed : button -> bool
    
    
  (** Get the current position of the mouse in desktop coordinates.

      This function returns the global position of the mouse cursor on the desktop. 
      @return Current position of the mouse *)
  val get_position : unit -> int * int


  (** Get the current position of the mouse in window coordinates.

      This function returns the current position of the mouse cursor, relative to the given window.
      @return Current position of the mouse *)
  val get_relative_position : #window -> int * int

      
  (** Set the current position of the mouse in desktop coordinates.
      
      This function sets the global position of the mouse cursor on the desktop. *)
  val set_position : int * int -> unit

      
  (** Set the current position of the mouse in window coordinates.
      
      This function sets the current position of the mouse cursor, relative to the given window.*)
  val set_relative_position : int * int -> #window -> unit
end
  
