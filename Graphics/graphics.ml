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

external class texture : "" =
object
  external method create : int -> int -> unit = ""
  external method load_from_file : 
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
  external method
end

type glyph =
    {
      advance : int ;
      bounds : int rect ;
      sub_rect : int rect
    }

external class fontCpp (Font): "" =
object 
  external method load_from_file : string -> bool = ""
  external method load_from_memory : string -> bool = ""
  external method load_from_stream : 'a. (#System.input_stream as 'a) -> bool = ""
  external method get_glyph : int -> int -> bool -> glyph = ""
  external method get_kerning : int -> int -> int -> int = ""
  external method get_line_spacing : int -> int = ""
  external method get_texture : int -> texture = ""
end

class font = fontCpp (Font.create ())

exception Font_error of font * string;

let create_font init = 
  let try_or_fail f b e = if b then f else raise e in
  match init with
  | `Font t -> new font (Font.create_from_copy t)
  | `File s -> let f = new font (Font.create ()) in
      try_or_fail f (f#load_from_file s) (Font_error (f, "file : "^s))
  | `Memory m -> let f = new font (Font.create ()) in
      try_or_fail f (f#load_from_memory m) (Font_error (f, "memory"))
  | `Stream s -> let f = new font (Font.create ()) in
      try_or_fail f (f#load_from_stream s) (Font_error (f, "stream"))

