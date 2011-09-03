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

  let rgb r g b = { r = r ; g = g ; b = b ; a = 255 }
  let rgba r g b a = { r = r ; g = g ; b = b ; a = a }
  external add : t -> t -> t = "color_add"
  external modulate : t -> t -> t = "color_multiply"
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

external class imageCpp (Image) : "sf_Image" =
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

class image = let t = Image.default () in imageCpp t

external get_maximum_size : unit -> int = "Texture_GetMaximumSize"

external class textureCpp (Texture) : "sf_texture" =
object
  constructor default : unit = "default_constructor"
  external method create : int -> int -> unit = "Create"
  external method load_from_file : ?rect: int rect -> string -> unit = "LoadFromFile" 
(*external method load_from_memory : ?rect: int rect -> string -> unit = "LoadFromMemory" *)
  external method load_from_stream : ?rect: int rect -> System.input_stream -> unit = "LoadFromStream"
  external method load_from_image : ?rect: int rect -> image -> unit = "LoadFromImage"
  external method get_width : unit -> int = "GetWidth"
  external method get_height : unit -> int = "GetHeight"
  external method copy_to_image : unit -> image = "CopyToImage"
  (*external method update_from_pixels : ?coords:int*int*int*int -> string  ou devrait-ce être un bigarray  -> unit = "UpdateFromPixels"*)
  external method update_from_image : ?coords:int*int -> image -> unit = "UpdateFromImage"
  external method update_from_window : 'a . ?coords:int*int -> (#window as 'a) -> unit = "UpdateFromWindow"
  external method bind : unit -> unit = "Bind"
  external method unbind : unit -> unit = "Unbind"
  external method set_smooth : bool -> unit = "SetSmooth"
  external method is_smooth : bool -> unit = "IsSmooth"
  external method get_tex_coords : int rect -> float rect = "GetTexCoords"
end

class texture = let t = Texture.default () in textureCpp t	 

let create_texture init = 
  let t = new texture in
    if (match init with
      | `File f -> t#load_from_file f
      | `Stream s -> t#load_from_stream s
      | `Memory m -> t#load_from_memory m
      | `Image img -> t#load_from_image img)
    then t
    else failwith "unable to create the texture from this source" 

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

let create_font init = 
  let f = new font in
  if (match init with
	| `File s -> f#load_from_file s
	| `Memory m -> f#load_from_memory m
	| `Stream s -> f#load_from_stream s)
  then f
  else failwith "unable to initialise font from this source"

(* shader *)
external class shaderCpp (Shader) : "sf_Shader" =
object (self)
  constructor default : unit = "default_constructor"
  external method load_from_file : string -> bool = "LoadFromFile"
(* external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : 'a. (#System.input_stream as 'a) -> bool = "LoadFromStream"
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
  external method set_parameter1 : string -> float -> unit = "SetFloatParameter"
  external method set_parameter2 : string -> float -> float -> unit = "SetVec2Parameter"
  external method set_parameter3 : string -> float -> float -> float -> unit = "SetVec3Parameter"
  external method set_parameter4 : string -> float -> float -> float -> float -> unit = "SetVec4Parameter"
  external method set_parameter2v : string -> float * float -> unit = "SetVec2ParameterV"
  external method set_parameter3v : string -> float * float * float -> unit = "SetVec3ParameterV"
  external method set_texture : string -> texture -> unit = "SetTexture"
  external method set_current_texture : string -> unit = "SetCurrentTexture"
  external method bind : unit -> unit = "Bind"
  external method unbind : unit -> unit = "Unbind"
end

external is_available : unit -> unit = "Shader_IsAvailable"

class shader = 
  let t = Shader.default () in 
    shaderCpp t

(* view *)
external class viewCpp (View) : "sf_View" =
object
  constructor default : unit = "default_constructor"
  constructor create_from_rect : float rect = "rectangle_constructor"
  constructor create_from_vectors : float * float -> float * float = "center_and_size_constructor"
  external method set_center : float -> float -> unit = "SetCenter"
  external method set_center_v : float * float -> unit = "SetCenterV"
  external method set_size : float -> float -> unit = "SetSize"
  external method set_size_v : float * float -> unit = "SetSizeV"
  external method set_rotation : float -> unit = "SetRotation"
  external method set_viewport : float rect -> unit = "SetViewport"
  external method reset : float rect -> unit = "Reset"
  external method get_center : unit -> float * float = "GetCenter"
  external method get_size : unit -> float * float = "GetSize"
  external method get_rotation : unit -> float = "GetRotation"
  external method get_viewport : unit -> float rect = "GetViewport"
  external method move : float -> float -> unit = "Move"
  external method move_v : float * float -> unit = "MoveV"
  external method rotate : float -> unit = "Rotate"
  external method zoom : float -> unit = "Zoom"
  (*external method get_matrix : unit -> matrix3 = "" --> matrix3
  external method get_inverse_matrix : unit -> matrix3 = ""*)
end

(** must be called either with param rect, either with both center and size*)
class view ?rect ?center ?size () =
  let t = 
    match rect with
      | Some r -> View.create_from_rect r
      | None -> (match (center, size) with
	  | (Some c) , (Some s) -> View.create_from_vectors c s
	  | _ -> View.default ()) 
  in viewCpp t

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
  external inherit drawable "sf_Drawable"
  constructor default : unit = "default_constructor"
  external method add_point : ?color:Color.t -> ?outline:Color.t -> float -> float -> unit = "AddPoint"
  external method add_point_v : ?color:Color.t -> ?outline:Color.t -> float * float -> unit = "AddPointV"
  external method get_points_count : unit -> int = "GetPointsCount"
  external method enable_fill : bool -> unit = "EnableFill"
  external method enable_outline : bool -> unit = "EnableOutline"
  external method set_point_position : int -> float -> float -> unit = "SetPointPosition"
  external method set_point_position_v : int -> float * float -> unit = "SetPointPositionV"
  external method set_point_color : int -> Color.t -> unit = "SetPointColor"
  external method set_point_outline_color : int -> Color.t -> unit = "SetPointOutlineColor"
  external method set_outline_thickness : float -> unit = "SetOutlineThickness"
  external method get_point_position : int -> float * float = "GetPointPosition"
  external method get_point_color : int -> Color.t = "GetPointColor"
  external method get_point_outline_color : int -> Color.t = "GetPointOutlineColor"
  external method get_outline_thickness : unit -> float = "GetOutlineThickness"
end

class shape = let t = Shape.default () in shapeCpp t

(* TODO : faire se bouger jun pour qu'il implémente toutes ces fonctions
module ShapeObjects =
struct
  external line : float -> float -> float -> float -> float -> Color.t -> float -> Color.t -> shape = ""
  external line_v : float * float -> float -> Color.t -> float -> Color.t -> shape = ""
  external rectangle : float -> float -> float -> float -> Color.t -> float -> Color.t -> shape = ""
  external rectangle_r : float rect ->  Color.t -> float -> Color.t -> shape = ""
  external circle : float -> float -> float -> Color.t -> float -> Color.t -> shape = ""
  external circle_v : float * float -> float -> Color.t -> float -> Color.t -> shape = ""
end 
*)

external class textCpp (Text) : "sf_Text" =
object
  external inherit drawable "sf_Drawable"
  constructor default : unit = "default_constructor"
  constructor create : string -> font -> int = "init_constructor"
  external method set_string : string -> unit = "SetString"
  external method set_font : font -> unit = "SetFont"
  external method set_character_size : int -> unit = "SetCharacterSize"
  external method set_style : style list -> unit = "SetStyle"
  external method get_string : unit -> string = "GetString"
  external method get_font : unit -> font = "GetFont"
  external method get_character_size : unit -> int = "GetCharacterSize"
  external method get_style : unit -> style list = "GetStyle" 
  external method get_character_pos : int -> float * float = "GetCharacterPos"
  external method get_rect : unit -> float rect = "GetRect"
end

class text = let t = Text. in textCpp t

external class spriteCpp (Sprite) : "sf_Sprite" =
object
  external inherit drawable "sf_Drawable"
  constructor default : unit = "default_constructor"
  constructor create_from_texture : texture = "texture_constructor"
  external method set_texture : texture -> unit = "SetTexture"
  external method set_sub_rect : int rect -> unit = "SetSubRect"
  external method resize : float -> float -> unit = "Resize"
  external method resize_v : float * float -> unit = "ResizeV"
  external method flip_x : bool -> unit = "FlipX"
  external method flip_y : bool -> unit = "FlipY" 
  external method get_texture : unit -> texture = "GetTexture"
  external method get_sub_rect : unit -> int rect = "GetSubRect"
  external method get_size : = "GetSize"
end

class sprite = let t = Sprite. in spriteCpp t
