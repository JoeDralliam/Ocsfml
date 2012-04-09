open OcsfmlSystem
open OcsfmlWindow

let do_if f = function
    | Some x -> f x
    | None -> ()

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

module MyInt : RECT_VAL with type t = int =
struct
  type t = int
  let add = ( + )
  let sub = ( - )
end

module IntRect = Rect(MyInt)

module MyFloat : RECT_VAL with type t = float =
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

  module Infix =
  struct
    let ( +% ) c1 c2 = add c1 c2
    let ( *% ) c1 c2 = modulate c1 c2
  end
end

type blend_mode = 
    BlendAlpha
  | BlendAdd
  | BlendMultiply
  | BlendNone

external class transform : "sf_Transform" =
object auto (self:'a)
  external method get_inverse : 'a = "getInverse"
  external method transform_point : float -> float -> float*float = "transformPoint"
  external method transform_point_v : float*float -> float*float = "transformPointV"
  external method transform_rect : float rect -> float rect = "transformRect"
  external method combine : 'a -> 'a = "combine"
  external method translate : float -> float -> unit = "translate"
  external method translate_v : float*float -> unit = "translateV"
  external method rotate :  ?center_x:float -> ?center_y:float -> float -> unit = "rotate"
  external method rotate_v : ?center:float*float -> float -> unit = "rotateV"
  external method scale : ?center_x:float -> ?center_y:float -> float -> float -> unit = "scale"
  external method scale_v : ?center:float*float -> float*float -> unit = "scaleV"
end

external class virtual drawable : "sf_Drawable" =
object
end

external class virtual transformable : "sf_Transformable" =
object
  constructor default : unit = "default_constructor"
  external method set_position : float -> float -> unit = "setPosition"
  external method set_position_v : float*float -> unit = "setPositionV"
  external method set_scale : float -> float -> unit = "setScale"
  external method set_scale_v : float*float -> unit = "setScaleV" 
  external method set_origin : float -> float -> unit = "setOrigin"
  external method set_origin_v : float*float -> unit = "setOriginV"
  external method set_rotation : float -> unit = "setRotation"
  external method get_position : float * float = "getPosition"
  external method get_scale : float * float = "getScale"
  external method get_origin : float * float = "getOrigin"
  external method get_rotation : float = "getRotation"
  external method move : float -> float -> unit = "move"
  external method move_v : float * float -> unit = "moveV"
  external method scale : float -> float -> unit = "scale"
  external method scale_v : float * float -> unit = "scaleV"
  external method rotate : float -> unit = "rotate"
  external method get_transform : transform = "getTransform"
  external method get_inverse_transform : transform = "getInverseTransform"
end

let mk_transformable ?position ?scale ?origin ?rotation (t: #transformable) =
  do_if t#set_position_v position ;
  do_if t#set_scale_v scale ;
  do_if t#set_origin_v origin ;
  do_if t#set_rotation rotation

type pixel_array_type = (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array2.t
let pixel_array_kind = Bigarray.int8_unsigned
let pixel_array_layout = Bigarray.c_layout


external class imageCpp (Image) : "sf_Image" =
object auto (self:'a)
  constructor default : unit = "default_constructor"
  external method create_from_color : ?color:Color.t -> int -> int -> unit = "createFromColor"
  (* external method create_from_pixels : int -> int -> string (* should it be a bigarray ? *) -> unit = "CreateFromPixels" *)
  external method load_from_file : string -> bool = "loadFromFile"
(*  external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : input_stream -> bool = "loadFromStream"
  external method save_to_file : string -> bool = "saveToFile"
  external method get_size : int * int = "getSize"
  external method get_pixels_ptr : pixel_array_type = "getPixelsPtr"
  external method create_mask_from_color : ?alpha:int -> Color.t -> unit = "createMaskFromColor"
  external method copy : ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit = "copy" (* à mettre private *)
  external method set_pixel : int -> int -> Color.t -> unit = "setPixel"
  external method get_pixel : int -> int -> Color.t = "getPixel" 
(* external method get_pixels : string (* bigarray !!! *) = "getPixelPtr" *)
  external method flip_horizontally : unit = "flipHorizontally"
  external method flip_vertically : unit = "flipVertically"
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

external cpp get_maximum_size : unit -> int = "Texture_getMaximumSize"

external class textureCpp (Texture) : "sf_Texture" =
object
  constructor default : unit = "default_constructor"
  external method create : int -> int -> unit = "create"
  external method load_from_file : ?rect: int rect -> string -> bool = "loadFromFile" 
(*external method load_from_memory : ?rect: int rect -> string -> bool = "loadFromMemory" *)
  external method load_from_stream : ?rect: int rect -> input_stream -> bool = "loadFromStream"
  external method load_from_image : ?rect: int rect -> image -> bool = "loadFromImage"
  external method get_size : int * int = "getSize"
  external method copy_to_image : image = "copyToImage"
  (*external method update_from_pixels : ?coords:int*int*int*int -> string  ou devrait-ce être un bigarray  -> unit = "UpdateFromPixels"*)
  external method update_from_image : ?coords:int*int -> image -> unit = "updateFromImage"
  external method update_from_window : 'a . ?coords:int*int -> (#window as 'a) -> unit = "updateFromWindow"
  external method bind : unit = "bind"
 (* external method unbind : unit = "Unbind" Removed *)
  external method set_smooth : bool -> unit = "setSmooth"
  external method is_smooth : bool -> unit = "isSmooth" 
  external method set_repeated : bool -> unit = "setRepeated"
  external method is_repeated : bool = "isRepeated"
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
      texture_rect : int rect
    }

external class fontCpp (Font): "sf_Font" =
object (_:'b)
  constructor default : unit = "default_constructor"
  (*  constructor copy : 'b ---> pas possible ya un prob sur le type *)
  external method load_from_file : string -> bool = "loadFromFile"
  (*external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : 'a. (#input_stream as 'a) -> bool = "loadFromStream"
  external method get_glyph : int -> int -> bool -> glyph = "getGlyph"
  external method get_kerning : int -> int -> int -> int = "getKerning"
  external method get_line_spacing : int -> int = "getLineSpacing"
  external method get_texture : int -> texture = "getTexture"
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
  external method load_from_file : ?vertex:string -> ?fragment:string -> unit -> bool = "loadFromFile"
(* external method load_from_memory : string -> bool = "LoadFromMemory" *)
  external method load_from_stream : 'a. ?vertex:(#input_stream as 'a) -> ?fragment:(#input_stream as 'a) -> unit -> bool = "loadFromStream" 
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
  external method set_parameter1 : string -> float -> unit = "setFloatParameter"
  external method set_parameter2 : string -> float -> float -> unit = "setVec2Parameter"
  external method set_parameter3 : string -> float -> float -> float -> unit = "setVec3Parameter"
  external method set_parameter4 : string -> float -> float -> float -> float -> unit = "setVec4Parameter"
  external method set_parameter2v : string -> float * float -> unit = "setVec2ParameterV"
  external method set_parameter3v : string -> float * float * float -> unit = "setVec3ParameterV"
  external method set_color : string -> Color.t -> unit = "setColorParameter"
  external method set_transform : string -> transform -> unit = "setTransformParameter"
  external method set_texture : string -> texture -> unit = "setTextureParameter"
  external method set_current_texture : string -> unit = "setCurrentTexture"
  external method bind : unit = "bind"
  external method unbind : unit = "unbind"
end

external cpp shader_is_available : unit -> unit = "Shader_isAvailable"

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
  external method set_center : float -> float -> unit = "setCenter"
  external method set_center_v : float * float -> unit = "setCenterV"
  external method set_size : float -> float -> unit = "setSize"
  external method set_size_v : float * float -> unit = "setSizeV"
  external method set_rotation : float -> unit = "setRotation"
  external method set_viewport : float rect -> unit = "setViewport"
  external method reset : float rect -> unit = "reset"
  external method get_center : float * float = "getCenter"
  external method get_size : float * float = "getSize"
  external method get_rotation : float = "getRotation"
  external method get_viewport : float rect = "getViewport"
  external method move : float -> float -> unit = "move"
  external method move_v : float * float -> unit = "moveV"
  external method rotate : float -> unit = "rotate"
  external method zoom : float -> unit = "zoom"
  (*external method get_matrix : matrix3 = "" --> matrix3
  external method get_inverse_matrix : matrix3 = ""*)
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

type render_states =
    {
      mutable blend_mode : blend_mode ;
      mutable transform : transform ;
      mutable texture : texture ;
      mutable shader : shader
    }


external cpp  mk_render_states : ?blend_mode:blend_mode -> ?transform:transform -> ?texture:texture -> ?shader:shader -> unit -> unit = "mk_sf_RenderStates"

external class virtual render_target (RenderTarget): "sf_RenderTarget" =
object
  external method clear : ?color:Color.t -> unit -> unit = "clear"
  external method draw : 'a . ?render_states:render_states (*?blend_mode:blend_mode ->  ?transform:transform -> ?texture:texture ->  ?shader:shader*) ->  (#drawable as 'a) -> unit = "draw"
(*  external method draw_with_shader : 'a . shader -> (#drawable as 'a) -> unit = "DrawWithShader" *)
  external method get_size : int*int = "getSize"
  external method set_view : view -> unit = "setView"
  external method get_view : view = "getView"
  external method get_default_view : view = "getDefaultView"
  external method get_viewport : view -> int rect = "getViewport"
  external method convert_coords : ?view:view -> int * int -> float * float = "convertCoords"
  external method push_gl_states : unit = "pushGLStates"
  external method pop_gl_states : unit = "popGLStates" 
  external method reset_gl_states : unit = "resetGLStates"
end 


external class render_textureCpp (RenderTexture) : "sf_RenderTexture" =
object
  external inherit render_target (RenderTarget) : "sf_RenderTarget"
  constructor default : unit = "default_constructor"
  external method create : ?dephtBfr:bool -> int -> int -> bool = "create"
  external method set_smooth : bool -> unit = "setSmooth"
  external method is_smooth : bool = "isSmooth"
  external method set_active : ?active:bool -> unit -> bool = "setActive"
  external method display : unit = "display"
  external method get_texture : texture = "getTexture"
end

class render_texture_bis () = let t = RenderTexture.default () in render_textureCpp t
class render_texture = render_texture_bis () 

external class render_windowCpp (RenderWindow) : "sf_RenderWindow" =
object
  external inherit windowCpp (Window) : "sf_Window"
  external inherit render_target (RenderTarget) : "sf_RenderTarget"
  constructor default : unit = "default_constructor"
  constructor create : ?style:Window.style list -> ?context:context_settings -> VideoMode.t -> string = "create_constructor"
  external method capture : image = "capture"
  external method set_icon : pixel_array_type -> unit = "setIcon"
end



class render_window ?style ?context vm name = 
  let t = RenderWindow.create ?style ?context vm name in 
  render_windowCpp t

external class virtual shape : "sf_Shape" =
object
  external inherit transformable : "sf_Transformable"
  external inherit drawable : "sf_Drawable"
  external method set_texture : ?new_texture:texture -> ?reset_rect:bool -> unit -> unit = "setTexture"
  external method set_texture_rect : int rect -> unit = "setTextureRect"
  external method set_fill_color : Color.t -> unit = "setFillColor"
  external method set_outline_color : Color.t -> unit = "setOutlineColor"
  external method set_outline_thickness : float -> unit = "setOutlineThickness"
  external method get_texture : texture option = "getTexture"
  external method get_texture_rect : int rect = "getTextureRect"
  external method get_fill_color : Color.t = "getFillColor"
  external method get_outline_color : Color.t = "getOutlineColor"
  external method get_outline_thickness : float = "getOutlineThickness"
  external method get_point_count : int = "getPointCount"
  external method get_point : int -> float*float = "getPoint"
  external method get_local_bounds : float rect = "getLocalBounds"
  external method get_global_bounds : float rect = "getGlobalBounds" 
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
  external method set_size : float*float = "setSize"
  external method get_size : float*float = "getSize"
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
  external method set_radius : float -> unit = "setRadius"
  external method get_radius : float = "getRadius"
  external method set_point_count : int -> unit = "setPointCount"
end

class circle_shape ?radius () =
  let t = match radius with
    | Some r -> CircleShape.from_radius r
    | None -> CircleShape.default () in
    circle_shapeCpp t

let mk_circle_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?radius ?point_count () =
  let t = new circle_shape ?radius () in
  mk_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t ;
  do_if t#set_point_count point_count ;
  t

external class convex_shapeCpp (ConvexShape) : "sf_ConvexShape" =
object
  external inherit shape : "sf_Shape"
  constructor default : unit = "default_constructor"
  constructor from_point_count : int = "point_constructor"
  external method set_point_count : int -> unit = "setPointCount"
  external method set_point : int -> float*float -> unit = "setPoint"
end

class convex_shape ?point_count () = 
  let t = match point_count with
    | Some x -> ConvexShape.from_point_count x
    | None -> ConvexShape.default () in
    convex_shapeCpp t 

let mk_convex_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?points () =
  let t = match points with 
      | Some l -> new convex_shape ~point_count:(List.length l) ()
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
  external method set_string : string -> unit = "setString"
  external method set_font : font -> unit = "setFont"
  external method set_character_size : int -> unit = "setCharacterSize"
  external method set_style : text_style list -> unit = "setStyle"
  external method set_color : Color.t -> unit = "setColor" 
  external method get_string : string = "getString"
  external method get_font : font = "getFont"
  external method get_character_size : int = "getCharacterSize"
  external method get_style : text_style list = "getStyle" 
  external method find_character_pos : int -> float * float = "findCharacterPos"
  external method get_local_bounds : float rect = "getLocalBounds"
  external method get_global_bounds : float rect = "getGlobalBounds"
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
  external method set_texture : ?resize:bool -> texture -> unit = "setTexture"
  external method set_texture_rect : int rect -> unit = "setTextureRect"
  external method set_color : Color.t -> unit = "setColor"
(*  external method resize : float -> float -> unit = "Resize"
  external method resize_v : float * float -> unit = "ResizeV"
  external method flip_x : bool -> unit = "FlipX"
  external method flip_y : bool -> unit = "FlipY" *)
  external method get_texture : texture option = "getTexture"
  external method get_texture_rect : int rect = "getTextureRect"
  external method get_color : Color.t = "getColor"
  external method get_local_bounds : float rect = "getLocalBounds"
  external method get_global_bounds : float rect = "getGlobalBounds"
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
      tex_coords : float*float
    }

let mk_vertex ?(position = (0., 0.)) ?(color = Color.white) ?(tex_coords = (0.,0.)) () =
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
  external method get_vertex_count : int = "getVertexCount"
  external method set_at_index : int -> vertex -> unit = "setAtIndex"
  external method get_at_index : int -> vertex = "getAtIndex"
  external method clear : unit = "clear"
  external method resize : int -> unit = "resize"
  external method append : vertex -> unit = "append"
  external method set_primitive_type : primitive_type -> unit = "setPrimitiveType"
  external method get_primitive_type : primitive_type = "getPrimitiveType"
  external method get_bounds : float rect = "getBounds"
end

class vertex_array_bis () =
  let t = VertexArray.default () in
  vertex_arrayCpp t

class vertex_array =
  vertex_array_bis ()

type draw_func_type = RenderTarget.t -> render_states -> unit 

external class caml_drawableCpp (CamlDrawable) : "CamlDrawable" =
object
  external inherit drawable : "sf_Drawable"
  constructor default : unit = "default_constructor"
  constructor callback : draw_func_type = "callback_constructor"
  external method set_callback : draw_func_type -> unit = "setCallback" 
end

class virtual caml_drawable =
object (self)
  inherit caml_drawableCpp (CamlDrawable.default ()) as super
  method virtual draw : render_target -> render_states -> unit
  initializer super#set_callback (fun t s -> self#draw (new render_target t) s)
end
