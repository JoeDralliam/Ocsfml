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

(* glyph *)

(* texture *)

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

let create_font = function
  | `Font t -> new font (Font.create_from_copy t)
  | `File f -> (new font (Font.create ()))#load_from_file s
