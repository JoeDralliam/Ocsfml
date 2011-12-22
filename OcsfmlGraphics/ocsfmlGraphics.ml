open OcsfmlSystem
open OcsfmlWindow

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
  val sub : t -> t -> t
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

module FloatRect = Rect(MyFloat)

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
  external cpp add : t -> t -> t = "color_add"
  external cpp modulate : t -> t -> t = "color_multiply"
  let white = rgb 255 255 255
  let black = rgb 0 0 0
  let red = rgb 255 0 0
  let green = rgb 0 255 0
  let blue = rgb 0 0 255
  let yellow = rgb 255 255 0
  let magenta = rgb 255 0 255
  let cyan = rgb 0 255 255
  (*let ( +# ) c1 c2 = add c1 c2
  let ( *# ) c1 c2 = modulate c1 c2*)
end

type blend_mode = 
    BlendAlpha
  | BlendAdd
  | BlendMultiply
  | BlendNone

external class transform : "sf_Transform" =
object auto (self:'a)
  external method get_inverse : unit -> 'a = "GetInverse"
  external method transform_point : float -> float -> float*float = "TransformPoint"
  external method transform_point_v : float*float -> float*float = "TransformPointV"
  external method transform_rect : float rect -> float rect = "TransformRect"
  external method combine : 'a -> 'a = "Combine"
  external method translate : float -> float -> unit = "Translate"
  external method translate_v : float*float -> unit = "TranslateV"
  external method rotate :  ?center_x:float -> ?center_y:float -> float -> unit = "Rotate"
  external method rotate_v : ?center:float*float -> float -> unit = "RotateV"
  external method scale : ?center_x:float -> ?center_y:float -> float -> float -> unit = "Scale"
  external method scale_v : ?center:float*float -> float*float -> unit = "ScaleV"
end

external class virtual drawable : "sf_Drawable" =
object
end

external class virtual transformable : "sf_Transformable" =
object
  external method set_position : float -> float -> unit = "SetPosition"
  external method set_position_v : float*float -> unit = "SetPositionV"
  external method set_scale : float -> float -> unit = "SetScale"
  external method set_scale_v : float*float -> unit = "SetScaleV" 
  external method set_origin : float -> float -> unit = "SetOrigin"
  external method set_origin_v : float*float -> unit = "SetOriginV"
  external method set_rotation : float -> unit = "SetRotation"
  external method get_position : unit -> float * float = "GetPosition"
  external method get_scale : unit -> float * float = "GetScale"
  external method get_origin : unit -> float * float = "GetOrigin"
  external method get_rotation : unit -> float = "GetRotation"
  external method move : float -> float -> unit = "Move"
  external method move_v : float * float -> unit = "MoveV"
  external method scale : float -> float -> unit = "Scale"
  external method scale_v : float * float -> unit = "ScaleV"
  external method rotate : float -> unit = "Rotate"
  external method get_transform : unit -> transform = "GetTransform"
  external method get_inverse_transform : unit -> transform = "GetInverseTransform"
end

let mk_transformable ?position ?scale ?origin ?rotation (t: #transformable) =
  do_if t#set_position_v position ;
  do_if t#set_scale_v scale ;
  do_if t#set_origin_v origin ;
  do_if t#set_rotation rotation

external class imageCpp (Image) : "sf_Image" =
object auto (self:'a)
  constructor default : unit = "default_constructor"
  external method create_from_color : ?color:Color.t -> int -> int -> unit = "CreateFromColor"
  (* external method create_from_pixels : int -> int -> string (* should it be a bigarray ? *) -> unit = "CreateFromPixels" *)
  external method load_from_file : string -> bool = "LoadFromFile"
(*  external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : input_stream -> bool = "LoadFromStream"
  external method save_to_file : string -> bool = "SaveToFile"
  external method get_height : unit -> int = "GetWidth"
  external method get_width : unit -> int = "GetHeight"
  external method create_mask_from_color : ?alpha:int -> Color.t -> unit = "CreateMaskFromColor"
  external method copy : ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit = "Copy" (* à mettre private *)
  external method set_pixel : int -> int -> Color.t -> unit = "SetPixel"
  external method get_pixel : int -> int -> Color.t = "GetPixel" 
(* external method get_pixels : unit -> string (* bigarray !!! *) = "GetPixelPtr" *)
  external method flip_horizontally : unit -> unit = "FlipHorizontally"
  external method flip_vertically : unit -> unit = "FlipVertically"
end

class image_bis () = 
  let t = Image.default () 
  in imageCpp t

class image =
  image_bis ()
 

let mk_image tag = 
  let img = new image in
    if match tag with
      | `Create (w,h) -> (img#create_from_color w h ; true)
      | `Color (color,w,h) -> (img#create_from_color ~color w h ; true)
      | `File filename -> img#load_from_file filename
      | `Stream inputstream -> img#load_from_stream inputstream
    then img
    else raise LoadFailure

external cpp get_maximum_size : unit -> int = "Texture_GetMaximumSize"

external class textureCpp (Texture) : "sf_Texture" =
object
  constructor default : unit = "default_constructor"
  external method create : int -> int -> unit = "Create"
  external method load_from_file : ?rect: int rect -> string -> bool = "LoadFromFile" 
(*external method load_from_memory : ?rect: int rect -> string -> bool = "LoadFromMemory" *)
  external method load_from_stream : ?rect: int rect -> input_stream -> bool = "LoadFromStream"
  external method load_from_image : ?rect: int rect -> image -> bool = "LoadFromImage"
  external method get_width : unit -> int = "GetWidth"
  external method get_height : unit -> int = "GetHeight"
  external method copy_to_image : unit -> image = "CopyToImage"
  (*external method update_from_pixels : ?coords:int*int*int*int -> string  ou devrait-ce être un bigarray  -> unit = "UpdateFromPixels"*)
  external method update_from_image : ?coords:int*int -> image -> unit = "UpdateFromImage"
  external method update_from_window : 'a . ?coords:int*int -> (#window as 'a) -> unit = "UpdateFromWindow"
  external method bind : unit -> unit = "Bind"
 (* external method unbind : unit -> unit = "Unbind" Removed *)
  external method set_smooth : bool -> unit = "SetSmooth"
  external method is_smooth : bool -> unit = "IsSmooth" 
  external method set_repeated : bool -> unit = "SetRepeated"
  external method is_repeated : unit -> bool = "IsRepeated"
end

class texture_bis () = 
  let t = Texture.default () in 
    textureCpp t

class texture =
  texture_bis ()

let mk_texture tag =
  let tex = new texture in
    if match tag with
      | `Image (rect,img) -> tex#load_from_image ~rect img
      | `File filename -> tex#load_from_file filename
      | `Stream inputstream -> tex#load_from_stream inputstream
    then tex
    else raise LoadFailure

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
  (*external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : 'a. (#input_stream as 'a) -> bool = "LoadFromStream"
  external method get_glyph : int -> int -> bool -> glyph = "GetGlyph"
  external method get_kerning : int -> int -> int -> int = "GetKerning"
  external method get_line_spacing : int -> int = "GetLineSpacing"
  external method get_texture : int -> texture = "GetTexture"
end

class font_bis () = 
  let t = Font.default () in 
    fontCpp t

class font =
  font_bis ()

let mk_font tag = 
  let f = new font in
    if match tag with
      | `File s -> f#load_from_file s
      | `Stream s -> f#load_from_stream s
  then f
  else raise LoadFailure

(* shader *)
external class shaderCpp (Shader) : "sf_Shader" =
object (self)
  constructor default : unit = "default_constructor"
  external method load_from_file : ?vertex:string -> ?fragment:string -> unit -> bool = "LoadFromFile"
(* external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : 'a. ?vertex:(#input_stream as 'a) -> ?fragment:(#input_stream as 'a) -> unit -> bool = "LoadFromStream" 
  method set_parameter name ?x ?y ?z w =
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
  external method set_color : string -> Color.t -> unit = "SetColorParameter"
  external method set_transform : string -> transform -> unit = "SetTransformParameter"
  external method set_texture : string -> texture -> unit = "SetTextureParameter"
  external method set_current_texture : string -> unit = "SetCurrentTexture"
  external method bind : unit -> unit = "Bind"
  external method unbind : unit -> unit = "Unbind"
end

external cpp shader_is_available : unit -> unit = "Shader_IsAvailable"

class shader_bis () = 
  let t = Shader.default () in 
    shaderCpp t

class shader =
  shader_bis ()
(*
let mk_shader tag = 
  let sh = new shader in
    if match tag with
      | `File  -> sh#load_from_file s
      | `Stream s -> sh#load_from_stream s
  then sh
  else raise LoadFailure
*)
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
      | None -> View.default ()
	  (*match (center, size) with
	     | ((Some c), (Some s)) -> View.create_from_vectors c s
	     | _ -> View.default ()*)
  in viewCpp t

external class virtual render_target (RenderTarget): "sf_RenderTarget" =
object
  external method clear : ?color:Color.t -> unit -> unit = "Clear"
  external method draw : 'a . ?blend_mode:blend_mode ->  ?transform:transform -> ?texture:texture ->  ?shader:shader ->  (#drawable as 'a) -> unit = "Draw"
(*  external method draw_with_shader : 'a . shader -> (#drawable as 'a) -> unit = "DrawWithShader" *)
  external method get_width : unit -> int = "GetWidth"
  external method get_height : unit -> int = "GetHeight"
  external method set_view : view -> unit = "SetView"
  external method get_view : unit -> view = "GetView"
  external method get_default_view : unit -> view = "GetDefaultView"
  external method get_viewport : unit -> int rect = "GetViewport"
  external method convert_coords : ?view:view -> int -> int -> float * float = "ConvertCoords"
  external method push_gl_states : unit -> unit = "PushGLStates"
  external method pop_gl_states : unit -> unit = "PopGLStates" 
end 


external class render_textureCpp (RenderTexture) : "sf_RenderTexture" =
object
  external inherit render_target (RenderTarget) : "sf_RenderTarget"
  constructor default : unit = "default_constructor"
  external method create : ?dephtBfr:bool -> int -> int -> bool = "Create"
  external method set_smooth : bool -> unit = "SetSmooth"
  external method is_smooth : unit -> bool = "IsSmooth"
  external method set_active : ?active:bool -> unit -> bool = "SetActive"
  external method display : unit -> unit = "Display"
  external method get_texture : unit -> texture = "GetTexture"
end

class render_texture = let t = RenderTexture.default () in render_textureCpp t

external class render_windowCpp (RenderWindow) : "sf_RenderWindow" =
object
  external inherit windowCpp (Window) : "sf_Window"
  external inherit render_target (RenderTarget) : "sf_RenderTarget"
  constructor default : unit = "default_constructor"
  constructor create : ?style:window_style list -> ?context:context_settings -> VideoMode.t -> string = "create_constructor"
  external method capture : unit -> image = "Capture"
end

class render_window ?style ?context vm name = 
  let t = RenderWindow.create ?style ?context vm name in 
  render_windowCpp t

external class virtual shape : "sf_Shape" =
object
  external inherit transformable : "sf_Transformable"
  external inherit drawable : "sf_Drawable"
  external method set_texture : ?new_texture:texture -> ?reset_rect:bool -> unit -> unit = "SetTexture"
  external method set_texture_rect : int rect -> unit = "SetTextureRect"
  external method set_fill_color : Color.t -> unit = "SetFillColor"
  external method set_outline_color : Color.t -> unit = "SetOutlineColor"
  external method set_outline_thickness : float -> unit = "SetOutlineThickness"
  external method get_texture : unit -> texture option = "GetTexture"
  external method get_texture_rect : unit -> int rect = "GetTextureRect"
  external method get_fill_color : unit -> Color.t = "GetFillColor"
  external method get_outline_color : unit -> Color.t = "GetOutlineColor"
  external method get_outline_thickness : unit -> float = "GetOutlineThickness"
  external method get_points_count : unit -> int = "GetPointsCount"
  external method get_point : int -> float*float = "GetPoint"
  external method get_local_bounds : unit -> float rect = "GetLocalBounds"
  external method get_global_bounds : unit -> float rect = "GetGlobalBounds" 
end

let mk_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness (t :#shape) =
    mk_transformable ?position ?scale ?rotation ?origin t;
    t#set_texture ?new_texture ~reset_rect:true ();
    do_if t#set_texture_rect texture_rect ;
    do_if t#set_fill_color fill_color ;
    do_if t#set_outline_color outline_color ;
    do_if t#set_outline_thickness outline_thickness




external class rectangle_shapeCpp (RectangleShape) : "sf_RectangleShape" =
object
  external inherit shape : "sf_Shape"
  constructor default : unit = "default_constructor"
  constructor from_size : float*float = "size_constructor"
  external method set_size : unit -> float*float = "SetSize"
  external method get_size : unit -> float*float = "GetSize"
end

class rectangle_shape ?size () =
  let t = match size with
    | Some s -> RectangleShape.from_size s
    | None -> RectangleShape.default () in
    rectangle_shapeCpp t

let mk_rectangle_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?size () =
  let t = new rectangle_shape ?size () in
    mk_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t ;
    t


external class circle_shapeCpp (CircleShape) : "sf_CircleShape" =
object
  external inherit shape : "sf_Shape"
  constructor default : unit = "default_constructor"
  constructor from_radius : float = "radius_constructor"
  external method set_radius : float -> unit = "SetRadius"
  external method get_radius : unit -> float = "GetRadius"
  external method set_points_count : int -> unit = "SetPointsCount"
end

class circle_shape ?radius () =
  let t = match radius with
    | Some r -> CircleShape.from_radius r
    | None -> CircleShape.default () in
    circle_shapeCpp t

let mk_circle_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?radius () =
  let t = new circle_shape ?radius () in
    mk_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t ;
    t

external class convex_shapeCpp (ConvexShape) : "sf_ConvexShape" =
object
  external inherit shape : "sf_Shape"
  constructor default : unit = "default_constructor"
  constructor from_points_count : int = "points_constructor"
  external method set_points_count : int -> unit = "SetPointsCount"
  external method set_point : int -> float*float -> unit = "SetPoint"
end

class convex_shape ?points_count () = 
  let t = match points_count with
    | Some x -> ConvexShape.from_points_count x
    | None -> ConvexShape.default () in
    convex_shapeCpp t 

let mk_convex_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?points () =
  let t = match points with 
      | Some l -> new convex_shape ~points_count:(List.length l) ()
      | None -> new convex_shape () in
    do_if (fun l -> ignore( List.fold_left (fun idx pos ->( t#set_point idx pos; idx+1) ) 0 l)) points ;
    mk_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t ;
    t


(*
module ShapeObjects =
struct 
  external cpp line : ?outline:float -> ?outlineColor:Color.t -> float -> float -> float -> float -> float -> Color.t -> shape = "sf_Shape_Line"
  external cpp line_v : ?outline:float -> ?outlineColor:Color.t -> float * float -> float -> Color.t -> shape = "sf_Shape_LineV"
  external cpp rectangle : ?outline:float -> ?outlineColor:Color.t -> float -> float -> float -> float -> Color.t -> shape = "sf_Shape_Rectangle"
  external cpp rectangle_r : ?outline:float -> ?outlineColor:Color.t -> float rect ->  Color.t -> shape = "sf_Shape_RectangleR"
  external cpp circle : ?outline:float -> ?outlineColor:Color.t -> float -> float -> float -> Color.t -> shape = "sf_Shape_Circle"
  external cpp circle_v : ?outline:float -> ?outlineColor:Color.t -> float * float -> float -> Color.t -> shape = "sf_Shape_CircleV"
end 
*)

type text_style = Bold | Italic | Underline
 
external class textCpp (Text) : "sf_Text" =
object
  external inherit transformable : "sf_Transformable"
  external inherit drawable : "sf_Drawable"
  constructor default : unit = "default_constructor"
  constructor create : string -> font -> int = "init_constructor"
  external method set_string : string -> unit = "SetString"
  external method set_font : font -> unit = "SetFont"
  external method set_character_size : int -> unit = "SetCharacterSize"
  external method set_style : text_style list -> unit = "SetStyle"
  external method set_color : Color.t -> unit = "SetColor" 
  external method get_string : unit -> string = "GetString"
  external method get_font : unit -> font = "GetFont"
  external method get_character_size : unit -> int = "GetCharacterSize"
  external method get_style : unit -> text_style list = "GetStyle" 
  external method get_character_pos : int -> float * float = "FindCharacterPos"
  external method get_local_bounds : unit -> float rect = "GetLocalBounds"
  external method get_global_bounds : unit -> float rect = "GetGlobalBounds"
end

class text_bis () = 
  let t = Text.default () in 
    textCpp t

class text =
  text_bis ()

let mk_text ?string ?position ?scale ?rotation ?origin ?color ?font ?character_size ?style () =
  let t = new text in
    do_if t#set_string string ;
    mk_transformable ?position ?scale ?rotation ?origin t;
    do_if t#set_font font ;
    do_if t#set_character_size character_size ;
    do_if t#set_style style ;
    do_if t#set_color color ;
    t

external class spriteCpp (Sprite) : "sf_Sprite" =
object
  external inherit transformable : "sf_Transformable"
  external inherit drawable : "sf_Drawable"
  constructor default : unit = "default_constructor"
  constructor create_from_texture : texture = "texture_constructor"
  external method set_texture : ?resize:bool -> texture -> unit = "SetTexture"
  external method set_texture_rect : int rect -> unit = "SetTextureRect"
  external method set_color : Color.t -> unit = "SetColor"
(*  external method resize : float -> float -> unit = "Resize"
  external method resize_v : float * float -> unit = "ResizeV"
  external method flip_x : bool -> unit = "FlipX"
  external method flip_y : bool -> unit = "FlipY" *)
  external method get_texture : unit -> texture = "GetTexture"
  external method get_texture_rect : unit -> int rect = "GetTextureRect"
  external method get_color : unit -> Color.t = "GetColor"
  external method get_local_bounds : unit -> float rect = "GetLocalBounds"
  external method get_global_bounds : unit -> float rect = "GetGlobalBounds"
end

class sprite_bis () = 
  let t = Sprite.default () in 
    spriteCpp t

class sprite =
  sprite_bis ()

let mk_sprite ?texture ?position ?scale ?rotation ?origin ?color ?texture_rect () =
  let t = new sprite in
    do_if t#set_texture texture ;
    mk_transformable ?position ?scale ?rotation ?origin t;
    do_if t#set_texture_rect texture_rect ;
    do_if t#set_color color ;
    t

type vertex =
    {
      position : float*float ;
      color : Color.t ;
      tex_coords : int*int
    }

let mk_vertex ?(position = (0., 0.)) ?(color = Color.white) ?(tex_coords = (0,0)) () =
  { position=position ; color=color ; tex_coords=tex_coords }

type primitive_type =
    Points
  | Lines
  | LinesStrip
  | Triangles
  | TrianglesStrip
  | TrianglesFan
  | Quads

external class vertex_arrayCpp (VertexArray) : "sf_VertexArray" =
object
  external inherit drawable : "sf_Drawable"
  constructor default : unit = "default_constructor"
  external method get_vertices_count : unit -> int = "GetVerticesCount"
  external method set_at_index : int -> vertex -> unit = "SetAtIndex"
  external method get_at_index : int -> vertex = "GetAtIndex"
  external method clear : unit -> unit = "Clear"
  external method resize : int -> unit = "Resize"
  external method append : vertex -> unit = "Append"
  external method set_primitive_type : primitive_type -> unit = "SetPrimitiveType"
  external method get_primitive_type : unit -> primitive_type = "GetPrimitiveType"
  external method get_bounds : unit -> float rect = "GetBounds"
end

class vertex_array () =
  let t = VertexArray.default () in
  vertex_arrayCpp t

type draw_func_type = render_target -> unit 

external class caml_drawableCpp (CamlDrawable) : "CamlDrawable" =
object
  external inherit drawable : "sf_Drawable"
  constructor default : unit = "default_constructor"
  constructor callback : draw_func_type = "callback_constructor"
  external method set_callback : draw_func_type -> unit = "SetCallback" 
end

class virtual caml_drawable () =
object (self)
  inherit caml_drawableCpp (CamlDrawable.default ()) as super
  method virtual draw : render_target -> unit
  initializer super#set_callback self#draw
end
