type 'a rect =
    {
      left : 'a ;
      top : 'a ;
      width : 'a ;
      height : 'a
    }

module type RECT_VAL =
sig
  type t
  val add : t -> t -> t
end

module Rect (M : RECT_VAL) =
struct
  let contains { left; top; width; height} x y =
    x >= left && y >= top  && x < (M.add left width) && y < (M.add top height)
  let contains_v r (x,y) = contains r x y
  let intersects 
      { left = l1 ; top = t1 ; width = w1 ; height = h1 }
      { left = l2 ; top = t2 ; width = w2 ; height = h2 } =
    let left = max l1 l2 in
    let top = max t1 t2 in
    let right = min (M.add l1 w1) (M.add l2 w2) in
    let bottom = min (M.add t1 h1) (M.add t2 h2) in
      if left < right && top < bottom
      then Some { left ; top ; width = M.sub right left ; height = M.sub bottom top }
      else None
end

module MyInt : RECT_VAL =
struct
  type t = int
  let add = ( + )
  let sub = ( - )
end

module IntRect = Rect(MyInt)

module MyFloat : RECT_VAL =
struct
  type t = float
  let add = ( +. )
  let sub = ( -. )
end

module IntRect = Rect(MyInt)

module Color = 
struct
  type t = {
    r : int ;
    g : int ;
    b : int ;
    a : int
  }

  external rgb : int -> int -> int -> t = ""
  external rgba : int -> int -> int -> int -> t = ""
  external add : t -> t -> t = "color__add"
  external modulate : t -> t -> t = "color__modulate"
  let ( +# ) c1 c2 = add c1 c2
  let ( *# ) c1 c2 = modulate c1 c2
end

type blend_mode = 
    BlendAlpha
  | BlendAdd
  | BlendMultiply
  | BlendNone

external class virtual drawable : "sf_Drawable" =
object
  external method set_position : float -> float -> unit = "SetPosition"
  external method set_position_v : float*float -> unit = "SetPositionV"
  external method set_x : float -> unit = "SetX"
  external method set_scale : float -> float -> unit = "SetScale"
  external method set_scale_v : float*float -> unit = "SetScaleV"
  external method set_scale_x : float -> unit = "SetScaleX"
  external method set_scale_y : float -> unit = "SetScaleY"
  external method set_origin : float -> float -> unit = "SetOrigin"
  external method set_origin_v : float*float -> unit = "SetOriginV"
  external method set_rotation : float -> unit = "SetRotation"
  external method set_color : Color.t -> unit = "SetColor"
  external method set_blend_mode : blend_mode -> unit = "SetBlendMode"
  external method get_position : unit -> float * float = "GetPosition"
  external method get_scale : unit -> float * float = "GetScale"
  external method get_origin : unit -> float * float = "GetOrigin"
  external method get_rotation : unit -> float = "GetRotation"
  external method get_color : unit -> Color.t = "GetColor"
  external method get_blend_mode : unit -> blend_mode = "GetBlendMode"
  external method move : float -> float -> unit = "Move"
  external method move_v : float * float -> unit = "MoveV"
  external method scale : float -> float -> unit = "Scale"
  external method scale_v : float * float -> unit = "ScaleV"
  external method rotate : float -> unit = "Rotate"
  external method transform_to_local : float * float -> float * float = "TransformToLocal"
  external method transform_to_global : float * float -> float * float = "TransformToGlobal"
end

external class image : "sf_Image" =
object
  constructor default : unit = "default_constructor"
  external method create_from_color : ?color:Color.t -> int -> int -> unit = "CreateFromColor"
  (* external method create_from_pixels : int -> int -> string (* should it be a bigarray ? *) -> unit = "CreateFromPixels" *)
  external method load_from_file : string -> bool = "LoadFromFile"
(*  external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : System.input_stream -> bool = "LoadFromStream"
  external method save_to_file : string -> bool = "SaveToFile"
  external method get_height : unit -> int = "GetWidth"
  external method get_width : unit -> int = "GetHeight"
  external method create_mask_from_color : ?alpha:int -> Color.t = "CreateMaskFromColor"
  external method copy :  ?srcRect:int rect -> ?alpha:bool -> image -> int -> int -> unit = "Copy"
  external method set_pixel : int -> int -> Color.t -> unit = "SetPixel"
  external method get_pixel : int -> int -> Color.t = "GetPixel"
(* external method get_pixels : unit -> string (* bigarray !!! *) = "GetPixelPtr" *)
  external method flip_horizontally : unit -> unit = "FlipHorizontally"
  external method flip_vertically : unit -> unit = "FlipVertically"
end

external get_maximum_size : unit -> int = ""

external class texture : "" =
object
  external method create : int -> int -> unit = ""
  external method load_from_file : ?rect: int rect -> string -> unit = ""
  external method load_from_memory : ?rect: int rect -> string -> unit = ""
  external method load_from_stream : ?rect: int rect -> System.input_stream -> unit = ""
  external method load_from_image : ?rect: int rect -> image -> unit = ""
  external method get_width : unit -> int = ""
  external method get_height : unit -> int = ""
  external method copy_to_image : unit -> image = ""
  external method update_from_pixels : ?coords:int*int*int*int -> string (* ou devrait-ce être un bigarray *) -> unit = ""
  external method update_from_image : ?coords:int*int -> image -> unit = ""
  external method update_from_window : 'a . ?coords:int*int -> (#window as 'a) -> unit = ""
  external method bind : unit -> unit = ""
  external method set_smooth : bool -> unit = ""
  external method get_tex_coords : int rect -> float rect = ""
end

type glyph =
    {
      advance : int ;
      bounds : int rect ;
      sub_rect : int rect
    }

external class fontCpp (Font): "sf_Font" =
object (_:'b)
  constructor default : unit = "default_constructor"
  (*  constructor copy : 'b ---> pas possible ya un prob sur le type *)
  external method load_from_file : string -> bool = "LoadFromFile"
  external method load_from_memory : string -> bool = "LoadFromMemory"
  external method load_from_stream : 'a. (#System.input_stream as 'a) -> bool = "LoadFromStream"
  external method get_glyph : int -> int -> bool -> glyph = "GetGlyph"
  external method get_kerning : int -> int -> int -> int = "GetKerning"
  external method get_line_spacing : int -> int = "GetLineSpacing"
  external method get_texture : int -> texture = "GetTexture"
end

class font = fontCpp (Font.default ())

exception Font_error of font * string;

let create_font init = 
  let try_or_fail f b e = if b then f else raise e in
  match init with
  | `Font t -> new font (Font.create_from_copy t)
  | `File s -> let f = new font in
      try_or_fail f (f#load_from_file s) (Font_error (f, "file : "^s))
  | `Memory m -> let f = new font in
      try_or_fail f (f#load_from_memory m) (Font_error (f, "memory"))
  | `Stream s -> let f = new font in
      try_or_fail f (f#load_from_stream s) (Font_error (f, "stream"))

(* shader *)
external class shader : "" =
object (self)
  external method load_from_file : string -> bool = ""
  external method load_from_memory : string -> bool = ""
  external method load_from_stream : 'a. (#System.input_stream as 'a) -> bool = ""
  method set_parameter t name ?x ?y ?z w =
    let count = ref 0 in
    let vars = Array.make 4 0.0 in
    let process v = match v with
      | None -> () 
      | Some v' -> (vars.(!count) <- v' ; incr count)
    in process x ; process y ; process z ; process (Some w) ;
      match !count with
	| 1 -> self#set_parameter1 name vars.(0)
	| 2 -> self#set_parameter2 name vars.(0) vars.(1)
	| 3 -> self#set_parameter3 name vars.(0) vars.(1) vars.(2)
	| 4 -> self#set_parameter4 name vars.(0) vars.(1) vars.(2) vars.(3)
	| _ -> assert false
  external method set_parameter1 : string -> float -> unit = ""
  external method set_parameter2 : string -> float -> float -> unit = ""
  external method set_parameter3 : string -> float -> float -> float -> unit = ""
  external method set_parameter4 : string -> float -> float -> float -> float -> unit = ""
  external method set_parameter2v : string -> float * float -> unit = ""
  external method set_parameter3v : string -> float * float * float -> unit = ""
  external method set_texture : string -> texture -> unit = ""
  external method set_current_texture : string -> unit = ""
  external method bind : unit -> unit = ""
  external method unbind : unit -> unit = ""
end

external is_available : unit -> unit = ""

(* view *)
external class view : "" =
object
  external method set_center : float -> float -> unit = ""
  external method set_center_v : float * float -> unit = ""
  external method set_size : float -> float -> unit = ""
  external method set_size_v : float * float -> unit = ""
  external method set_rotation : float -> unit = ""
  external method set_viewport : float rect -> unit = ""
  external method reset : float rect -> unit = ""
  external method get_center : unit -> float * float = ""
  external method get_size : unit -> float * float = ""
  external method get_rotation : unit -> float = ""
  external method get_viewport : unit -> float rect = ""
  external method move : float -> float -> unit = ""
  external method move_v : float * float -> unit = ""
  external method rotate : float -> unit = ""
  external method zoom : float -> unit = ""
  (*external method get_matrix : unit -> matrix3 = "" --> matrix3
  external method get_inverse_matrix : unit -> matrix3 = ""*)
end

external class virtual render_target (RenderTarget): "sf_RenderTarget" =
object
  external method clear : ?color:Color.t -> unit -> unit = "Clear"
  external method draw : 'a . (#drawable as 'a) -> unit = "Draw"
  external method draw_with_shader : 'a . shader -> (#drawable as 'a) -> unit = "DrawWithShader"
  external method get_width : unit -> int = "GetWidth"
  external method get_height : unit -> int = "GetHeight"
  external method set_view : view -> unit = "SetView"
  external method get_view : unit -> view = "GetView"
  external method get_default_view : unit -> view = "GetDefaultView"
  external method get_viewport : unit -> int rect = "GetViewport"
  external method convert_coords : ?view:view -> int -> int -> float * float = "ConvertCoords"
  external method save_gl_states : unit -> unit = "SaveGLStates"
  external method restore_gl_states : unit -> unit = "RestoreGLStates" 
end 

external class render_imageCpp (RenderImage) : "sf_RenderImage" =
object
  external inherit render_target "sf_RenderTarget"
  constructor default : unit = "default_constructor"
  external method create : ?dephtBfr:bool -> int -> int -> unit = "Create"
  external method set_smooth : bool -> unit = "SetSmooth"
  external method is_smooth : unit -> bool = "IsSmooth"
  external method set_active : bool -> unit = "SetActive"
  external method display : unit -> unit = "Display"
  external method get_image : unit -> image = "GetImage"
end

class render_image = render_imageCpp (RenderImage.default ())

external class render_textureCpp (RenderTexture) : "sf_RenderTexture" =
object
  external inherit render_target "sf_RenderTarget"
  constructor default : unit = "default_constructor"
  external method create : ?dephtBfr:bool -> int -> int -> unit = "Create"
  external method set_smooth : bool -> unit = "SetSmooth"
  external method is_smooth : unit -> bool = "IsSmooth"
  external method set_active : bool -> unit = "SetActive"
  external method display : unit -> unit = "Display"
  external method get_texture : unit -> texture = "GetTexture"
end

class render_texture = render_textureCpp (RenderTexture.default ())

external class render_windowCpp (RenderWindow) : "sf_RenderWindow" =
object
  external inherit render_target "sf_RenderTarget"
  external inherit Window.window "sf_Window"
  constructor default : unit = "default_constructor"
  constructor create : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string = "create_constructor"
  external method capture : unit -> image = "Capture"
end

class render_window ?style ?context vm name = render_windowCpp (RenderWindow.create ?style ?context vm name)

external class shapeCpp (Shape) : "sf_Shape" =
object

end

external class text : "sf_Text" =
object
  external inherit drawable
    constructor default : unit = "default_constructor"
end
