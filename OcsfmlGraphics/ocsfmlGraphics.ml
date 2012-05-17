open OcsfmlSystem
open OcsfmlWindow

let do_if f = function | Some x -> f x | None -> ()
  
type 'a rect = { left : 'a; top : 'a; width : 'a; height : 'a }

module type RECT_VAL =
sig type t
    val add : t -> t -> t
    val sub : t -> t -> t
end
  
module Rect (M : RECT_VAL) =
struct
  let contains { left = left; top = top; width = width; height = height } x y =
    (x >= left) && ((y >= top) && ((x < (M.add left width)) && (y < (M.add top height))))
      
  let contains_v r (x, y) = contains r x y
    
  let intersects  { left = l1; top = t1; width = w1; height = h1 } { left = l2; top = t2; width = w2; height = h2 } =
    let left = max l1 l2 in
    let top = max t1 t2 in
    let right = min (M.add l1 w1) (M.add l2 w2) in
    let bottom = min (M.add t1 h1) (M.add t2 h2)
    in
    if (left < right) && (top < bottom)
    then
      Some
        {
          left = left;
          top = top;
          width = M.sub right left;
          height = M.sub bottom top;
        }
    else None    
end
  
module MyInt : RECT_VAL with type t = int =
struct type t = int
       let add = ( + )
       let sub = ( - )
end
  
module IntRect = Rect(MyInt)
  
module MyFloat : RECT_VAL with type t = float =
struct type t = float
       let add = ( +. )
       let sub = ( -. )
end
  
module FloatRect = Rect(MyFloat)
  
module Color =
struct
  type t = { r : int; g : int; b : int; a : int }
      
  let rgb r g b = { r = r; g = g; b = b; a = 255; }
    
  let rgba r g b a = { r = r; g = g; b = b; a = a; }
    
  let add c1 c2 = 
    let add_comp x1 x2 = Pervasives.min (x1 + x2) 255 in
    rgba (add_comp c1.r c2.r) 
      (add_comp c1.g c2.g) 
      (add_comp c1.b c2.b) 
      (add_comp c1.a c2.a)
    
  let modulate c1 c2 = 
    let mul_comp x1 x2 = (x1 * x2) / 255 in
    rgba (mul_comp c1.r c2.r) 
      (mul_comp c1.g c2.g) 
      (mul_comp c1.b c2.b) 
      (mul_comp c1.a c2.a)
    
    
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
  
type blend_mode = | BlendAlpha | BlendAdd | BlendMultiply | BlendNone

module Transform =
struct
  type t
    
  class type transform_base_class_type =
  object ('a)
    val t_transform_base : t
    method rep__sf_Transform : t
    method destroy : unit
    method get_inverse : 'a
    method transform_point : float -> float -> (float * float)
    method transform_point_v : (float * float) -> (float * float)
    method transform_rect : float rect -> float rect
    method combine : 'a -> 'a
    method translate : float -> float -> unit
    method translate_v : (float * float) -> unit
    method rotate : ?center_x: float -> ?center_y: float -> float -> unit
    method rotate_v : ?center: (float * float) -> float -> unit
    method scale :
      ?center_x: float -> ?center_y: float -> float -> float -> unit
    method scale_v : ?center: (float * float) -> (float * float) -> unit
  end
    
  external destroy : t -> unit = "sf_Transform_destroy__impl"
	    
  external default : unit -> t = "sf_Transform_default_constructor__impl"
	    
  external matrix :
    float ->
    float ->
    float -> float -> float -> float -> float -> float -> float -> t =
	    "sf_Transform_matrix_constructor__byte"
	      "sf_Transform_matrix_constructor__impl"
	      
  external get_inverse : t -> 'a = "sf_Transform_getInverse__impl"
	    
  external transform_point : t -> float -> float -> (float * float) =
	    "sf_Transform_transformPoint__impl"
	      
  external transform_point_v : t -> (float * float) -> (float * float) =
	    "sf_Transform_transformPointV__impl"
	      
  external transform_rect : t -> float rect -> float rect =
	    "sf_Transform_transformRect__impl"
	      
  external combine : t -> 'a -> 'a = "sf_Transform_combine__impl"
	    
  external translate : t -> float -> float -> unit =
	    "sf_Transform_translate__impl"
	      
  external translate_v : t -> (float * float) -> unit =
	    "sf_Transform_translateV__impl"
	      
  external rotate :
    t -> ?center_x: float -> ?center_y: float -> float -> unit =
	    "sf_Transform_rotate__impl"
	      
  external rotate_v : t -> ?center: (float * float) -> float -> unit =
	    "sf_Transform_rotateV__impl"
	      
  external scale :
    t -> ?center_x: float -> ?center_y: float -> float -> float -> unit =
	    "sf_Transform_scale__impl"
	      
  external scale_v :
    t -> ?center: (float * float) -> (float * float) -> unit =
	    "sf_Transform_scaleV__impl"
	      
end
  
class transform_base t =
object ((self : 'a))
  val t_transform_base = (t : Transform.t)
  method rep__sf_Transform = t_transform_base
  method destroy = Transform.destroy t_transform_base
  method get_inverse : 'a = Transform.get_inverse t_transform_base
  method transform_point : float -> float -> (float * float) =
    fun p1 p2 -> Transform.transform_point t_transform_base p1 p2
  method transform_point_v : (float * float) -> (float * float) =
    fun p1 -> Transform.transform_point_v t_transform_base p1
  method transform_rect : float rect -> float rect =
    fun p1 -> Transform.transform_rect t_transform_base p1
  method combine : 'a -> 'a =
    fun p1 -> Transform.combine t_transform_base p1
  method translate : float -> float -> unit =
    fun p1 p2 -> Transform.translate t_transform_base p1 p2
  method translate_v : (float * float) -> unit =
    fun p1 -> Transform.translate_v t_transform_base p1
  method rotate : ?center_x: float -> ?center_y: float -> float -> unit =
    fun ?center_x ?center_y p1 ->
      Transform.rotate t_transform_base ?center_x ?center_y p1
  method rotate_v : ?center: (float * float) -> float -> unit =
    fun ?center p1 -> Transform.rotate_v t_transform_base ?center p1
  method scale :
    ?center_x: float -> ?center_y: float -> float -> float -> unit =
    fun ?center_x ?center_y p1 p2 ->
      Transform.scale t_transform_base ?center_x ?center_y p1 p2
  method scale_v : ?center: (float * float) -> (float * float) -> unit =
    fun ?center p1 -> Transform.scale_v t_transform_base ?center p1
end
  
    
class transform ?matrix () =
  let t =
    match matrix with
      | Some (a00, a01, a02, a10, a11, a12, a20, a21, a22) ->
          Transform.matrix a00 a01 a02 a10 a11 a12 a20 a21 a22
      | None -> Transform.default ()
  in transform_base t
         
module Transformable =
struct
  type t
    
  external destroy : t -> unit = "sf_Transformable_destroy__impl"
      
  external default : unit -> t =
      "sf_Transformable_default_constructor__impl"
	
  external set_position : t -> float -> float -> unit =
      "sf_Transformable_setPosition__impl"
	
  external set_position_v : t -> (float * float) -> unit =
      "sf_Transformable_setPositionV__impl"
	
  external set_scale : t -> float -> float -> unit =
      "sf_Transformable_setScale__impl"
	
  external set_scale_v : t -> (float * float) -> unit =
      "sf_Transformable_setScaleV__impl"
	
  external set_origin : t -> float -> float -> unit =
      "sf_Transformable_setOrigin__impl"
	
  external set_origin_v : t -> (float * float) -> unit =
      "sf_Transformable_setOriginV__impl"
	
  external set_rotation : t -> float -> unit =
      "sf_Transformable_setRotation__impl"
	
  external get_position : t -> (float * float) =
      "sf_Transformable_getPosition__impl"
	
  external get_scale : t -> (float * float) =
      "sf_Transformable_getScale__impl"
	
  external get_origin : t -> (float * float) =
      "sf_Transformable_getOrigin__impl"
	
  external get_rotation : t -> float = "sf_Transformable_getRotation__impl"
      
  external move : t -> float -> float -> unit =
      "sf_Transformable_move__impl"
	
  external move_v : t -> (float * float) -> unit =
      "sf_Transformable_moveV__impl"
	
  external scale : t -> float -> float -> unit =
      "sf_Transformable_scale__impl"
	
  external scale_v : t -> (float * float) -> unit =
      "sf_Transformable_scaleV__impl"
	
  external rotate : t -> float -> unit = "sf_Transformable_rotate__impl"
      
  external get_transform : t -> transform =
      "sf_Transformable_getTransform__impl"
	
  external get_inverse_transform : t -> transform =
      "sf_Transformable_getInverseTransform__impl"
	
end
  
class transformable_base t =
object ((self : 'self))
  val t_transformable_base = (t : Transformable.t)
  method rep__sf_Transformable = t_transformable_base
  method destroy = Transformable.destroy t_transformable_base
  method set_position : float -> float -> unit =
    fun p1 p2 -> Transformable.set_position t_transformable_base p1 p2
  method set_position_v : (float * float) -> unit =
    fun p1 -> Transformable.set_position_v t_transformable_base p1
  method set_scale : float -> float -> unit =
    fun p1 p2 -> Transformable.set_scale t_transformable_base p1 p2
  method set_scale_v : (float * float) -> unit =
    fun p1 -> Transformable.set_scale_v t_transformable_base p1
  method set_origin : float -> float -> unit =
    fun p1 p2 -> Transformable.set_origin t_transformable_base p1 p2
  method set_origin_v : (float * float) -> unit =
    fun p1 -> Transformable.set_origin_v t_transformable_base p1
  method set_rotation : float -> unit =
    fun p1 -> Transformable.set_rotation t_transformable_base p1
  method get_position : (float * float) =
    Transformable.get_position t_transformable_base
  method get_scale : (float * float) =
    Transformable.get_scale t_transformable_base
  method get_origin : (float * float) =
    Transformable.get_origin t_transformable_base
  method get_rotation : float =
    Transformable.get_rotation t_transformable_base
  method move : float -> float -> unit =
    fun p1 p2 -> Transformable.move t_transformable_base p1 p2
  method move_v : (float * float) -> unit =
    fun p1 -> Transformable.move_v t_transformable_base p1
  method scale : float -> float -> unit =
    fun p1 p2 -> Transformable.scale t_transformable_base p1 p2
  method scale_v : (float * float) -> unit =
    fun p1 -> Transformable.scale_v t_transformable_base p1
  method rotate : float -> unit =
    fun p1 -> Transformable.rotate t_transformable_base p1
  method get_transform : transform =
    Transformable.get_transform t_transformable_base
  method get_inverse_transform : transform =
    Transformable.get_inverse_transform t_transformable_base
end

   
class transformable_init ?position ?scale ?origin ?rotation t =
object (self)
  inherit transformable_base t

  initializer do_if self#set_position_v position
  initializer do_if self#set_scale_v scale
  initializer do_if self#set_origin_v origin
  initializer do_if self#set_rotation rotation
end
  
class transformable ?position ?scale ?origin ?rotation () =
  let t = Transformable.default ()
  in transformable_init ?position ?scale ?origin ?rotation t
       
module Image =
struct
  type t
    
  class type image_base_class_type =
  object ((*
	    let mk_transformable ?position ?scale ?origin ?rotation (t: #transformable) =
	    do_if t#set_position_v position ;
	    do_if t#set_scale_v scale ;
	    do_if t#set_origin_v origin ;
	    do_if t#set_rotation rotation
	  *)
    'a)
    val t_image_base : t
    method rep__sf_Image : t
    method destroy : unit
    method create_from_color : ?color: Color.t -> int -> int -> unit
    method create_from_pixels : OcsfmlWindow.pixel_array_type -> unit
    method load_from_file : string -> bool
    method load_from_memory : raw_data_type -> bool
    method load_from_stream : input_stream -> bool
    method save_to_file : string -> bool
    method get_size : (int * int)
    method get_pixels_ptr : OcsfmlWindow.pixel_array_type
    method create_mask_from_color : ?alpha: int -> Color.t -> unit
    method copy :
      ?srcRect: (int rect) -> ?alpha: bool -> 'a -> int -> int -> unit
    method set_pixel : (* à mettre private *)
      int -> int -> Color.t -> unit
    method get_pixel : int -> int -> Color.t
    method flip_horizontally : unit
    method flip_vertically : unit
  end
    
  external destroy : t -> unit = "sf_Image_destroy__impl"
	    
  external default : unit -> t = "sf_Image_default_constructor__impl"
	    
  external create_from_color : t -> ?color: Color.t -> int -> int -> unit =
	    "sf_Image_createFromColor__impl"
	      
  external create_from_pixels :
    t -> OcsfmlWindow.pixel_array_type -> unit =
	    "sf_Image_createFromPixels__impl"
	      
  external load_from_file : t -> string -> bool =
	    "sf_Image_loadFromFile__impl"
	      
  external load_from_memory : t -> raw_data_type -> bool =
	    "sf_Image_loadFromMemory__impl"
	      
  external load_from_stream : t -> input_stream -> bool =
	    "sf_Image_loadFromStream__impl"
	      
  external save_to_file : t -> string -> bool = "sf_Image_saveToFile__impl"
	    
  external get_size : t -> (int * int) = "sf_Image_getSize__impl"
	    
  external get_pixels_ptr : t -> OcsfmlWindow.pixel_array_type =
	    "sf_Image_getPixelsPtr__impl"
	      
  external create_mask_from_color : t -> ?alpha: int -> Color.t -> unit =
	    "sf_Image_createMaskFromColor__impl"
	      
  external copy :
    t -> ?srcRect: (int rect) -> ?alpha: bool -> 'a -> int -> int -> unit =
	    "sf_Image_copy__byte" "sf_Image_copy__impl"
	      
  external set_pixel : t -> int -> int -> Color.t -> unit =
	    "sf_Image_setPixel__impl"
	      
  external get_pixel : t -> int -> int -> Color.t =
	    "sf_Image_getPixel__impl"
	      
  external flip_horizontally : t -> unit =
	    "sf_Image_flipHorizontally__impl"
	      
  external flip_vertically : t -> unit = "sf_Image_flipVertically__impl"
	    
end
  
class image_base t =
object ((self : 'a))
  val t_image_base = (t : Image.t)
  method rep__sf_Image = t_image_base
  method destroy = Image.destroy t_image_base
  method create_from_color : ?color: Color.t -> int -> int -> unit =
    fun ?color p1 p2 -> Image.create_from_color t_image_base ?color p1 p2
  method create_from_pixels : OcsfmlWindow.pixel_array_type -> unit =
    fun p1 -> Image.create_from_pixels t_image_base p1
  method load_from_file : string -> bool =
    fun p1 -> Image.load_from_file t_image_base p1
  method load_from_memory : raw_data_type -> bool =
    fun p1 -> Image.load_from_memory t_image_base p1
  method load_from_stream : input_stream -> bool =
    fun p1 -> Image.load_from_stream t_image_base p1
  method save_to_file : string -> bool =
    fun p1 -> Image.save_to_file t_image_base p1
  method get_size : (int * int) = Image.get_size t_image_base
  method get_pixels_ptr : OcsfmlWindow.pixel_array_type =
    Image.get_pixels_ptr t_image_base
  method create_mask_from_color : ?alpha: int -> Color.t -> unit =
    fun ?alpha p1 -> Image.create_mask_from_color t_image_base ?alpha p1
  method copy :
    ?srcRect: (int rect) -> ?alpha: bool -> 'a -> int -> int -> unit =
    fun ?srcRect ?alpha p1 p2 p3 ->
      Image.copy t_image_base ?srcRect ?alpha p1 p2 p3
  method set_pixel : int -> int -> Color.t -> unit =
    fun p1 p2 p3 -> Image.set_pixel t_image_base p1 p2 p3
  method get_pixel : int -> int -> Color.t =
    fun p1 p2 -> Image.get_pixel t_image_base p1 p2
  method flip_horizontally : unit = Image.flip_horizontally t_image_base
  method flip_vertically : unit = Image.flip_vertically t_image_base
end
  
  
class image_init tag t =
object (self)
  inherit image_base t
  initializer
    if
      match tag with
        | `Create (w, h) -> (self#create_from_color w h; true)
        | `Color (color, w, h) -> (self#create_from_color ~color w h; true)
        | `File filename -> self#load_from_file filename
        | `Stream inputstream -> self#load_from_stream inputstream
        | `None -> true
    then ()
    else raise LoadFailure
end

class image tag =
  let t = Image.default ()
  in image_init tag t
  
external get_maximum_size : unit -> int = "Texture_getMaximumSize__impl"

module Texture =
struct
  type t
    
  external destroy : t -> unit = "sf_Texture_destroy__impl"
      
  external default : unit -> t = "sf_Texture_default_constructor__impl"
      
  external create : t -> int -> int -> unit = "sf_Texture_create__impl"
      
  external load_from_file : t -> ?rect: (int rect) -> string -> bool =
      "sf_Texture_loadFromFile__impl"
	
  external load_from_memory :
    t -> ?rect: (int rect) -> raw_data_type -> bool =
      "sf_Texture_loadFromMemory__impl"
	
  external load_from_stream :
    t -> ?rect: (int rect) -> input_stream -> bool =
      "sf_Texture_loadFromStream__impl"
	
  external load_from_image : t -> ?rect: (int rect) -> image -> bool =
      "sf_Texture_loadFromImage__impl"
	
  external get_size : t -> (int * int) = "sf_Texture_getSize__impl"
      
  external copy_to_image : t -> image = "sf_Texture_copyToImage__impl"
      
  external update_from_pixels :
    t -> ?coords: (int * int) -> OcsfmlWindow.pixel_array_type -> unit =
      "sf_Texture_updateFromPixels__impl"
	
  external update_from_image : t -> ?coords: (int * int) -> image -> unit =
      "sf_Texture_updateFromImage__impl"
	
  external update_from_window :
    t -> ?coords: (int * int) -> (#window as 'a) -> unit =
      "sf_Texture_updateFromWindow__impl"
	
  external bind : t -> unit = "sf_Texture_bind__impl"
      
  external set_smooth : t -> bool -> unit = "sf_Texture_setSmooth__impl"
      
  external is_smooth : t -> bool -> unit = "sf_Texture_isSmooth__impl"
      
  external set_repeated : t -> bool -> unit =
      "sf_Texture_setRepeated__impl"
	
  external is_repeated : t -> bool = "sf_Texture_isRepeated__impl"
      
end
  
class texture_base t =
object ((self : 'self))
  val t_texture_base = (t : Texture.t)
  method rep__sf_Texture = t_texture_base
  method destroy = Texture.destroy t_texture_base
  method create : int -> int -> unit =
    fun p1 p2 -> Texture.create t_texture_base p1 p2
  method load_from_file : ?rect: (int rect) -> string -> bool =
    fun ?rect p1 -> Texture.load_from_file t_texture_base ?rect p1
  method load_from_memory : ?rect: (int rect) -> raw_data_type -> bool =
    fun ?rect p1 -> Texture.load_from_memory t_texture_base ?rect p1
  method load_from_stream : ?rect: (int rect) -> input_stream -> bool =
    fun ?rect p1 -> Texture.load_from_stream t_texture_base ?rect p1
  method load_from_image : ?rect: (int rect) -> image -> bool =
    fun ?rect p1 -> Texture.load_from_image t_texture_base ?rect p1
  method get_size : (int * int) = Texture.get_size t_texture_base
  method copy_to_image : image = Texture.copy_to_image t_texture_base
  method update_from_pixels :
    ?coords: (int * int) -> OcsfmlWindow.pixel_array_type -> unit =
    fun ?coords p1 -> Texture.update_from_pixels t_texture_base ?coords p1
  method update_from_image : ?coords: (int * int) -> image -> unit =
    fun ?coords p1 -> Texture.update_from_image t_texture_base ?coords p1
  method update_from_window :
    'a. ?coords: (int * int) -> (#window as 'a) -> unit =
    fun ?coords p1 -> Texture.update_from_window t_texture_base ?coords p1
  method bind : unit = Texture.bind t_texture_base
  method set_smooth : bool -> unit =
    fun p1 -> Texture.set_smooth t_texture_base p1
  method is_smooth : bool -> unit =
    fun p1 -> Texture.is_smooth t_texture_base p1
  method set_repeated : bool -> unit =
    fun p1 -> Texture.set_repeated t_texture_base p1
  method is_repeated : bool = Texture.is_repeated t_texture_base
end
  
    
class texture_init ?rect tag t =
object (self)
  inherit texture_base t
  initializer
    if
      match tag with
        | `Image img -> self#load_from_image ?rect img
        | `File filename -> self#load_from_file ?rect filename
        | `Stream inputstream -> self#load_from_stream ?rect inputstream
        | `Memory memory -> self#load_from_memory ?rect memory
        | `None -> true
    then ()
    else raise LoadFailure
end
  
class texture ?rect tag =
  let t = Texture.default ()
  in texture_init ?rect tag t


type glyph = { advance : int; bounds : int rect; texture_rect : int rect }

module Font =
struct
  type t
    
  external destroy : t -> unit = "sf_Font_destroy__impl"
      
  external default : unit -> t = "sf_Font_default_constructor__impl"
      
  external load_from_file : t -> string -> bool =
      "sf_Font_loadFromFile__impl"
	
  external load_from_memory : t -> raw_data_type -> bool =
      "sf_Font_loadFromMemory__impl"
	
  external load_from_stream : t -> (#input_stream as 'a) -> bool =
      "sf_Font_loadFromStream__impl"
	
  external get_glyph : t -> int -> int -> bool -> glyph =
      "sf_Font_getGlyph__impl"
	
  external get_kerning : t -> int -> int -> int -> int =
      "sf_Font_getKerning__impl"
	
  external get_line_spacing : t -> int -> int =
      "sf_Font_getLineSpacing__impl"
	
  external get_texture : t -> int -> texture = "sf_Font_getTexture__impl"
      
end
  
class font_base t =
object ((_ : 'b))
  val t_font_base = (t : Font.t)
  method rep__sf_Font = t_font_base
  method destroy = Font.destroy t_font_base
  method load_from_file : string -> bool =
    fun p1 -> Font.load_from_file t_font_base p1
  method load_from_memory : raw_data_type -> bool =
    fun p1 -> Font.load_from_memory t_font_base p1
  method load_from_stream : 'a. (#input_stream as 'a) -> bool =
    fun p1 -> Font.load_from_stream t_font_base p1
  method get_glyph : int -> int -> bool -> glyph =
    fun p1 p2 p3 -> Font.get_glyph t_font_base p1 p2 p3
  method get_kerning : int -> int -> int -> int =
    fun p1 p2 p3 -> Font.get_kerning t_font_base p1 p2 p3
  method get_line_spacing : int -> int =
    fun p1 -> Font.get_line_spacing t_font_base p1
  method get_texture : int -> texture =
    fun p1 -> Font.get_texture t_font_base p1
end
  
    
class font_init tag t =
object (self)
  inherit font_base t
  initializer
    if
      match tag with
        | `File s -> self#load_from_file s
        | `Stream s -> self#load_from_stream s
        | `Memory m -> self#load_from_memory m
        | `None -> true
    then ()
    else raise LoadFailure
end

class font tag =
  let t = Font.default ()
  in font_init tag t
  
module Shader =
struct
  type t
    
  external destroy : t -> unit = "sf_Shader_destroy__impl"
      
  external default : (* shader *) unit -> t =
      "sf_Shader_default_constructor__impl"
	
  external load_from_file :
    t -> ?vertex: string -> ?fragment: string -> unit -> bool =
      "sf_Shader_loadFromFile__impl"
	
  external load_from_memory :
    t -> ?vertex: string -> ?fragment: string -> unit -> bool =
      "sf_Shader_loadFromMemory__impl"
	
  external load_from_stream :
    t ->
    ?vertex: (#OcsfmlSystem.input_stream as 'a) ->
    ?fragment: (#OcsfmlSystem.input_stream as 'a) -> unit -> bool =
      "sf_Shader_loadFromStream__impl"
	
  external set_parameter1 : t -> string -> float -> unit =
      "sf_Shader_setFloatParameter__impl"
	
  external set_parameter2 : t -> string -> float -> float -> unit =
      "sf_Shader_setVec2Parameter__impl"
	
  external set_parameter3 :
    t -> string -> float -> float -> float -> unit =
      "sf_Shader_setVec3Parameter__impl"
	
  external set_parameter4 :
    t -> string -> float -> float -> float -> float -> unit =
      "sf_Shader_setVec4Parameter__byte" "sf_Shader_setVec4Parameter__impl"
	
  external set_parameter2v : t -> string -> (float * float) -> unit =
      "sf_Shader_setVec2ParameterV__impl"
	
  external set_parameter3v :
    t -> string -> (float * float * float) -> unit =
      "sf_Shader_setVec3ParameterV__impl"
	
  external set_color : t -> string -> Color.t -> unit =
      "sf_Shader_setColorParameter__impl"
	
  external set_transform : t -> string -> transform -> unit =
      "sf_Shader_setTransformParameter__impl"
	
  external set_texture : t -> string -> texture -> unit =
      "sf_Shader_setTextureParameter__impl"
	
  external set_current_texture : t -> string -> unit =
      "sf_Shader_setCurrentTexture__impl"
	
  external bind : t -> unit = "sf_Shader_bind__impl"
      
  external unbind : t -> unit = "sf_Shader_unbind__impl"
      
end
  
class shader_base t_shader_base' =
object ((self : 'self))
  val t_shader_base = (t_shader_base' : Shader.t)
  method rep__sf_Shader = t_shader_base
  method destroy = Shader.destroy t_shader_base
  method load_from_file :
    ?vertex: string -> ?fragment: string -> unit -> bool =
    fun ?vertex ?fragment p1 ->
      Shader.load_from_file t_shader_base ?vertex ?fragment p1
  method load_from_memory :
    ?vertex: string -> ?fragment: string -> unit -> bool =
    fun ?vertex ?fragment p1 ->
      Shader.load_from_memory t_shader_base ?vertex ?fragment p1
  method load_from_stream :
    'a.
    ?vertex: (#OcsfmlSystem.input_stream as 'a) ->
    ?fragment: (#OcsfmlSystem.input_stream as 'a) -> unit -> bool =
    fun ?vertex ?fragment p1 ->
      Shader.load_from_stream t_shader_base ?vertex ?fragment p1
  method set_parameter =
    fun name ?x ?y ?z w ->
      let count = ref 0 in
      let vars = Array.make 4 0.0 in
      let process v =
        match v with
          | None -> ()
          | Some v' -> (vars.(!count) <- v'; incr count)
      in
      (process x;
       process y;
       process z;
       process (Some w);
       match !count with
         | 1 -> self#set_parameter1 name vars.(0)
         | 2 -> self#set_parameter2 name vars.(0) vars.(1)
         | 3 -> self#set_parameter3 name vars.(0) vars.(1) vars.(2)
         | 4 ->
             self#set_parameter4 name vars.(0) vars.(1) vars.(2) vars.(3)
         | _ -> assert false)
  method set_parameter1 : string -> float -> unit =
    fun p1 p2 -> Shader.set_parameter1 t_shader_base p1 p2
  method set_parameter2 : string -> float -> float -> unit =
    fun p1 p2 p3 -> Shader.set_parameter2 t_shader_base p1 p2 p3
  method set_parameter3 : string -> float -> float -> float -> unit =
    fun p1 p2 p3 p4 -> Shader.set_parameter3 t_shader_base p1 p2 p3 p4
  method set_parameter4 :
    string -> float -> float -> float -> float -> unit =
    fun p1 p2 p3 p4 p5 ->
      Shader.set_parameter4 t_shader_base p1 p2 p3 p4 p5
  method set_parameter2v : string -> (float * float) -> unit =
    fun p1 p2 -> Shader.set_parameter2v t_shader_base p1 p2
  method set_parameter3v : string -> (float * float * float) -> unit =
    fun p1 p2 -> Shader.set_parameter3v t_shader_base p1 p2
  method set_color : string -> Color.t -> unit =
    fun p1 p2 -> Shader.set_color t_shader_base p1 p2
  method set_transform : string -> transform -> unit =
    fun p1 p2 -> Shader.set_transform t_shader_base p1 p2
  method set_texture : string -> texture -> unit =
    fun p1 p2 -> Shader.set_texture t_shader_base p1 p2
  method set_current_texture : string -> unit =
    fun p1 -> Shader.set_current_texture t_shader_base p1
  method bind : unit = Shader.bind t_shader_base
  method unbind : unit = Shader.unbind t_shader_base
end
 
external shader_is_available : unit -> unit = "Shader_isAvailable__impl"


module ShaderSource =
struct
  type file = [`File of string]
  type stream = [ `Stream of OcsfmlSystem.input_stream ]
  type memory = [ `Memory of string ]
  type 'a source = [ `File of string | `Stream of OcsfmlSystem.input_stream | `Memory of string ]
  let file s = `File s
  let stream s = `Stream (s :> OcsfmlSystem.input_stream)
  let memory s = `Memory s
  let get x = x
end
  

class shader_init ?vertex ?fragment t =
object (self)
  inherit shader_base t
  initializer
    if
      match (vertex,fragment) with
	  (Some `File v, Some `File f) -> self#load_from_file ~vertex:v ~fragment:f ()
        | (None, Some `File f) -> self#load_from_file ~fragment:f ()
        | (Some `File v, None) -> self#load_from_file ~vertex:v ()
        | (Some `Stream v, Some `Stream f)  -> self#load_from_stream ~vertex:v ~fragment:f ()
        | (None, Some `Stream f) -> self#load_from_stream ~fragment:f ()
        | (Some `Stream v, None) -> self#load_from_stream ~vertex:v ()
        | (Some `Memory v, Some `Memory f) -> self#load_from_memory ~vertex:v ~fragment:f ()
        | (None, Some `Memory f) -> self#load_from_memory ~fragment:f ()
        | (Some `Memory v, None) -> self#load_from_memory ~vertex:v ()
	| (None, None) -> true
	| _ -> false
    then ()
    else raise LoadFailure
end

class shader ?vertex ?fragment () =
  let t = Shader.default ()
  in shader_init ?vertex ?fragment t
  
module View =
struct
  type t
    
  external destroy : t -> unit = "sf_View_destroy__impl"
      
  external default : (* view *) unit -> t =
      "sf_View_default_constructor__impl"
	
  external create_from_rect : float rect -> t =
      "sf_View_rectangle_constructor__impl"
	
  external create_from_vectors : (float * float) -> (float * float) -> t =
      "sf_View_center_and_size_constructor__impl"
	
  external copy : t -> t =
      "sf_View_copy_constructor__impl"
      
  external affect : t -> t -> unit =
      "sf_View_affect__impl"

  external set_center : t -> float -> float -> unit =
      "sf_View_setCenter__impl"
	
  external set_center_v : t -> (float * float) -> unit =
      "sf_View_setCenterV__impl"
	
  external set_size : t -> float -> float -> unit = "sf_View_setSize__impl"
      
  external set_size_v : t -> (float * float) -> unit =
      "sf_View_setSizeV__impl"
	
  external set_rotation : t -> float -> unit = "sf_View_setRotation__impl"
      
  external set_viewport : t -> float rect -> unit =
      "sf_View_setViewport__impl"
	
  external reset : t -> float rect -> unit = "sf_View_reset__impl"
      
  external get_center : t -> (float * float) = "sf_View_getCenter__impl"
      
  external get_size : t -> (float * float) = "sf_View_getSize__impl"
      
  external get_rotation : t -> float = "sf_View_getRotation__impl"
      
  external get_viewport : t -> float rect = "sf_View_getViewport__impl"
      
  external move : t -> float -> float -> unit = "sf_View_move__impl"
      
  external move_v : t -> (float * float) -> unit = "sf_View_moveV__impl"
      
  external rotate : t -> float -> unit = "sf_View_rotate__impl"
      
  external zoom : t -> float -> unit = "sf_View_zoom__impl"
      
end
  
type 'a reference = 'a

class const_view_base t_view_base' =
object ((self : 'self))
  val t_view_base = (t_view_base' : View.t)
  method rep__sf_View = t_view_base
  method destroy = View.destroy t_view_base
  
  method get_center : (float * float) = View.get_center t_view_base
  
  method get_size : (float * float) = View.get_size t_view_base
  
  method get_rotation : float = View.get_rotation t_view_base
  
  method get_viewport : float rect = View.get_viewport t_view_base
end

class const_view tag =
  let t =
    match tag with
      | `Rect r -> View.create_from_rect r
      | `Center (center, size) -> View.create_from_vectors center size
      | `Copy other -> View.copy other#rep__sf_View
      | `None -> View.default ()
  in const_view_base t

class view_base t_view_base' =
object ((self : 'self))
  inherit const_view_base t_view_base'
  val! t_view_base = (t_view_base' : View.t)

  method rep__sf_View = t_view_base

  method destroy = View.destroy t_view_base

  method affect : const_view -> unit =
    fun p1 -> View.affect t_view_base p1#rep__sf_View

  method set_center : float -> float -> unit =
    fun p1 p2 -> View.set_center t_view_base p1 p2
  
  method set_center_v : (float * float) -> unit =
    fun p1 -> View.set_center_v t_view_base p1
  
  method set_size : float -> float -> unit =
    fun p1 p2 -> View.set_size t_view_base p1 p2
  
  method set_size_v : (float * float) -> unit =
    fun p1 -> View.set_size_v t_view_base p1
  
  method set_rotation : float -> unit =
    fun p1 -> View.set_rotation t_view_base p1
  
  method set_viewport : float rect -> unit =
    fun p1 -> View.set_viewport t_view_base p1
  
  method reset : float rect -> unit = fun p1 -> View.reset t_view_base p1
  
  method get_center : (float * float) = View.get_center t_view_base
  
  method get_size : (float * float) = View.get_size t_view_base
  
  method get_rotation : float = View.get_rotation t_view_base
  
  method get_viewport : float rect = View.get_viewport t_view_base
  
  method move : float -> float -> unit =
  fun p1 p2 -> View.move t_view_base p1 p2
  
  method move_v : (float * float) -> unit =
    fun p1 -> View.move_v t_view_base p1
  
  method rotate : float -> unit = fun p1 -> View.rotate t_view_base p1
  
  method zoom : float -> unit = fun p1 -> View.zoom t_view_base p1
end
  
    
(*external method get_matrix : matrix3 = "" --> matrix3
  external method get_inverse_matrix : matrix3 = ""*)
(** must be called either with param rect, either with both center and size*)
(* 
   class view ?rect ?center ?size () =
   let t = 
   match rect with
   | Some r -> View.create_from_rect r
   | None -> View.default ()
(*match (center, size) with
   | ((Some c), (Some s)) -> View.create_from_vectors c s
   | _ -> View.default ()*)
   in viewCpp t
*)


class view tag =
  let t =
    match tag with
      | `Rect r -> View.create_from_rect r
      | `Center (center, size) -> View.create_from_vectors center size
      | `Copy other -> View.copy other#rep__sf_View
      | `None -> View.default ()
  in view_base t
       

      

module Drawable =
struct type t
       external destroy : t -> unit = "sf_Drawable_destroy__impl"

       external inherits : unit -> t = "sf_Drawable_inherits__impl"
end

module RenderTarget =
struct
  type t
    
  external destroy : t -> unit = "sf_RenderTarget_destroy__impl"
      
  external clear : t -> ?color: Color.t -> unit -> unit =
      "sf_RenderTarget_clear__impl"
	
  external draw :
    t ->
    (*?render_states: render_states -> *)
    ?blend_mode:blend_mode ->  ?transform:transform -> ?texture:texture ->  ?shader:shader ->
    Drawable.t -> unit =
      "sf_RenderTarget_draw__byte"
      "sf_RenderTarget_draw__impl"
	
  external get_size : t -> (int * int) = "sf_RenderTarget_getSize__impl"
      
  external set_view : t -> const_view -> unit = "sf_RenderTarget_setView__impl"
      
  external get_view : t -> View.t = "sf_RenderTarget_getView__impl"
      
  external get_default_view : t -> View.t =
      "sf_RenderTarget_getDefaultView__impl"
	
  external get_viewport : t -> const_view -> int rect =
      "sf_RenderTarget_getViewport__impl"
	
  external convert_coords :
    t -> ?view:const_view -> (int * int) -> (float * float) =
      "sf_RenderTarget_convertCoords__impl"
	
  external push_gl_states : t -> unit =
      "sf_RenderTarget_pushGLStates__impl"
	
  external pop_gl_states : t -> unit = "sf_RenderTarget_popGLStates__impl"
      
  external reset_gl_states : t -> unit =
      "sf_RenderTarget_resetGLStates__impl"
	
end
  
(* external set_drawable_draw_override : Drawable.t -> (RenderTarget.t -> RenderStatesBase.t -> unit) -> unit = "sf_Drawable_override_draw__impl" *)
external set_drawable_draw_override : Drawable.t -> (RenderTarget.t -> blend_mode ->  Transform.t -> Texture.t ->  Shader.t -> unit) -> unit = "sf_Drawable_override_draw__impl"

class drawable ?overloaded t_drawable' =
object ((self : 'self))
  val t_drawable = (t_drawable' : Drawable.t)

  initializer match overloaded with
      (*      Some `draw -> set_drawable_draw_override t_drawable (fun target states -> self#draw (new render_target target) (RenderStatesBase.caml_render_states states) ) *)
      Some `draw -> set_drawable_draw_override t_drawable (fun target b tr tx s -> self#draw (new render_target target) b (new transform_base tr) (new texture_base tx) (new shader_base s) )
    | None -> ()

  method rep__sf_Drawable = t_drawable
  method destroy = Drawable.destroy t_drawable

  method private draw : render_target -> blend_mode -> transform -> texture -> shader -> unit = fun p1 p2 p3 p4 p5 -> ()
end
and render_target t_render_target' =
object ((self : 'self))
  val t_render_target = (t_render_target' : RenderTarget.t)
  method rep__sf_RenderTarget = t_render_target
  method destroy = RenderTarget.destroy t_render_target
  method clear : ?color: Color.t -> unit -> unit =
    fun ?color p1 -> RenderTarget.clear t_render_target ?color p1
  method draw :
(*    'a. ?render_states: render_states -> (< rep__sf_Drawable : Drawable.t; .. > as 'a) -> unit = 
      fun ?render_states p1 ->
      RenderTarget.draw t_render_target ?render_states p1#rep__sf_Drawable*)
    'a. ?blend_mode:blend_mode -> ?transform:transform -> ?texture:texture -> ?shader:shader -> (< rep__sf_Drawable : Drawable.t; .. > as 'a) -> unit =
    fun ?blend_mode ?transform ?texture ?shader p1 ->
      RenderTarget.draw t_render_target ?blend_mode ?transform ?texture ?shader p1#rep__sf_Drawable
  method get_size : (int * int) = RenderTarget.get_size t_render_target
  method set_view : const_view -> unit =
    fun p1 -> RenderTarget.set_view t_render_target p1
  method get_view : const_view reference = 
    new const_view_base (RenderTarget.get_view t_render_target)
  method get_default_view : const_view reference =
    new const_view_base (RenderTarget.get_default_view t_render_target)
  method get_viewport : const_view -> int rect =
    fun p1 -> RenderTarget.get_viewport t_render_target p1
  method convert_coords : ?view:const_view -> (int * int) -> (float * float) =
    fun ?view p1 -> RenderTarget.convert_coords t_render_target ?view p1
  method push_gl_states : unit =
    RenderTarget.push_gl_states t_render_target
  method pop_gl_states : unit = RenderTarget.pop_gl_states t_render_target
  method reset_gl_states : unit =
    RenderTarget.reset_gl_states t_render_target
end
  
    
module RenderTexture =
struct
  type t
    
  external destroy : t -> unit = "sf_RenderTexture_destroy__impl"
      
  external to_render_target : t -> RenderTarget.t =
      "upcast__sf_RenderTarget_of_sf_RenderTexture__impl"
	
  external default : unit -> t =
      "sf_RenderTexture_default_constructor__impl"
	
  external create : t -> ?depht_buffer: bool -> int -> int -> bool =
      "sf_RenderTexture_create__impl"
	
  external set_smooth : t -> bool -> unit =
      "sf_RenderTexture_setSmooth__impl"
	
  external is_smooth : t -> bool = "sf_RenderTexture_isSmooth__impl"
      
  external set_active : t -> ?active: bool -> unit -> bool =
      "sf_RenderTexture_setActive__impl"
	
  external display : t -> unit = "sf_RenderTexture_display__impl"
      
  external get_texture : t -> texture = "sf_RenderTexture_getTexture__impl"
      
end
  
class render_texture_base t_render_texture_base' =
object ((self : 'self))
  val t_render_texture_base = (t_render_texture_base' : RenderTexture.t)
  method rep__sf_RenderTexture = t_render_texture_base
  method destroy = RenderTexture.destroy t_render_texture_base
  inherit
    render_target (RenderTexture.to_render_target t_render_texture_base')
  method create : ?depht_buffer: bool -> int -> int -> bool =
    fun ?depht_buffer p1 p2 ->
      RenderTexture.create t_render_texture_base ?depht_buffer p1 p2
  method set_smooth : bool -> unit =
    fun p1 -> RenderTexture.set_smooth t_render_texture_base p1
  method is_smooth : bool = RenderTexture.is_smooth t_render_texture_base
  method set_active : ?active: bool -> unit -> bool =
    fun ?active p1 ->
      RenderTexture.set_active t_render_texture_base ?active p1
  method display : unit = RenderTexture.display t_render_texture_base
  method get_texture : texture =
    RenderTexture.get_texture t_render_texture_base
end
  
    
exception CreateFailure
       
class render_texture ?depht_buffer width height = 
  let t = RenderTexture.default () in
object (self)
  inherit render_texture_base t
  initializer if not (self#create ?depht_buffer width height) then raise CreateFailure
end
  
module RenderWindow =
struct
  type t
    
  external destroy : t -> unit = "sf_RenderWindow_destroy__impl"
      
  external to_window_base : t -> Window.t =
      "upcast__sf_Window_of_sf_RenderWindow__impl"
	
  external to_render_target : t -> RenderTarget.t =
      "upcast__sf_RenderTarget_of_sf_RenderWindow__impl"
	
  external default : unit -> t =
      "sf_RenderWindow_default_constructor__impl"
	
  external create :
    ?style: (Window.style list) ->
    ?context: context_settings -> VideoMode.t -> string -> t =
      "sf_RenderWindow_create_constructor__impl"
	
  external capture : t -> image = "sf_RenderWindow_capture__impl"
      
end
  
class render_window_base t_render_window_base' =
object ((self : 'self))
  val t_render_window_base = (t_render_window_base' : RenderWindow.t)
  method rep__sf_RenderWindow = t_render_window_base
  method destroy = RenderWindow.destroy t_render_window_base
  inherit window_base (RenderWindow.to_window_base t_render_window_base')
  inherit
    render_target (RenderWindow.to_render_target t_render_window_base')
  method capture : image = RenderWindow.capture t_render_window_base
end
  
    
class render_window ?style ?context vm name =
  let t = RenderWindow.create ?style ?context vm name
  in render_window_base t
       
module Shape =
struct
  type t
    
  external destroy : t -> unit = "sf_Shape_destroy__impl"

  external to_transformable : t -> Transformable.t =
      "upcast__sf_Transformable_of_sf_Shape__impl"
      
  external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_sf_Shape__impl"
	
  external set_texture :
    t -> ?new_texture: texture -> ?reset_rect: bool -> unit -> unit =
      "sf_Shape_setTexture__impl"
	
  external set_texture_rect : t -> int rect -> unit =
      "sf_Shape_setTextureRect__impl"
	
  external set_fill_color : t -> Color.t -> unit =
      "sf_Shape_setFillColor__impl"
	
  external set_outline_color : t -> Color.t -> unit =
      "sf_Shape_setOutlineColor__impl"
	
  external set_outline_thickness : t -> float -> unit =
      "sf_Shape_setOutlineThickness__impl"
	
  external get_texture : t -> texture option = "sf_Shape_getTexture__impl"
      
  external get_texture_rect : t -> int rect =
      "sf_Shape_getTextureRect__impl"
	
  external get_fill_color : t -> Color.t = "sf_Shape_getFillColor__impl"
      
  external get_outline_color : t -> Color.t =
      "sf_Shape_getOutlineColor__impl"
	
  external get_outline_thickness : t -> float =
      "sf_Shape_getOutlineThickness__impl"
	
  external get_point_count : t -> int = "sf_Shape_getPointCount__impl"
      
  external get_point : t -> int -> (float * float) =
      "sf_Shape_getPoint__impl"
	
  external get_local_bounds : t -> float rect =
      "sf_Shape_getLocalBounds__impl"
	
  external get_global_bounds : t -> float rect =
      "sf_Shape_getGlobalBounds__impl"
	
end
  
class shape_base ?position ?scale ?rotation ?origin t =
object ((self : 'self))
  val t_shape_base = (t : Shape.t)
  method rep__sf_Shape = t_shape_base
  method destroy = Shape.destroy t_shape_base
  
  inherit transformable_init ?position ?scale ?rotation ?origin (Shape.to_transformable t)
  inherit drawable (Shape.to_drawable t)
 

  method set_texture :
    ?new_texture: texture -> ?reset_rect: bool -> unit -> unit =
    fun ?new_texture ?reset_rect p1 ->
      Shape.set_texture t_shape_base ?new_texture
        ?reset_rect p1
  method set_texture_rect : int rect -> unit =
    fun p1 -> Shape.set_texture_rect t_shape_base p1
  method set_fill_color : Color.t -> unit =
    fun p1 -> Shape.set_fill_color t_shape_base p1
  method set_outline_color : Color.t -> unit =
    fun p1 -> Shape.set_outline_color t_shape_base p1
  method set_outline_thickness : float -> unit =
    fun p1 -> Shape.set_outline_thickness t_shape_base p1
  method get_texture : texture option =
    Shape.get_texture t_shape_base
  method get_texture_rect : int rect =
    Shape.get_texture_rect t_shape_base
  method get_fill_color : Color.t =
    Shape.get_fill_color t_shape_base
  method get_outline_color : Color.t =
    Shape.get_outline_color t_shape_base
  method get_outline_thickness : float =
    Shape.get_outline_thickness t_shape_base
  method get_point_count : int =
    Shape.get_point_count t_shape_base
  method get_point : int -> (float * float) =
    fun p1 -> Shape.get_point t_shape_base p1
  method get_local_bounds : float rect =
    Shape.get_local_bounds t_shape_base
  method get_global_bounds : float rect =
    Shape.get_global_bounds t_shape_base
end

    
class shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t =
object (self)
  inherit shape_base ?position ?scale ?rotation ?origin t


  initializer self#set_texture ?new_texture ~reset_rect: true ()
  initializer do_if self#set_texture_rect texture_rect
  initializer do_if self#set_fill_color fill_color
  initializer do_if self#set_outline_color outline_color
  initializer do_if self#set_outline_thickness outline_thickness
end
  
class shape = shape_init
  
module RectangleShape =
struct
  type t
    
  external destroy : t -> unit = "sf_RectangleShape_destroy__impl"
      
  external to_shape : t -> Shape.t = "upcast__sf_Shape_of_sf_RectangleShape__impl"

  external default : unit -> t =
      "sf_RectangleShape_default_constructor__impl"
	
  external from_size : (float * float) -> t =
      "sf_RectangleShape_size_constructor__impl"
	
  external set_size : t -> (float * float) =
      "sf_RectangleShape_setSize__impl"
	
  external get_size : t -> (float * float) =
      "sf_RectangleShape_getSize__impl"
	
end
  
class rectangle_shape_base ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t =
object ((self : 'self))
  inherit shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness (RectangleShape.to_shape t)

  val t_rectangle_shape_base = (t : RectangleShape.t)
  method rep__sf_RectangleShape = t_rectangle_shape_base
  method destroy = RectangleShape.destroy t_rectangle_shape_base
  method set_size : (float * float) =
    RectangleShape.set_size t_rectangle_shape_base
  method get_size : (float * float) =
    RectangleShape.get_size t_rectangle_shape_base
end
    
  
class rectangle_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?size () =
  let t =
    match size with
      | Some s -> RectangleShape.from_size s
      | None -> RectangleShape.default ()
  in
  rectangle_shape_base ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t
    
module CircleShape =
struct
  type t
    
  external to_shape : t -> Shape.t = "upcast__sf_Shape_of_sf_CircleShape__impl"


  external destroy : t -> unit = "sf_CircleShape_destroy__impl"
      
  external default : unit -> t = "sf_CircleShape_default_constructor__impl"
      
  external from_radius : float -> t =
      "sf_CircleShape_radius_constructor__impl"
	
  external set_radius : t -> float -> unit =
      "sf_CircleShape_setRadius__impl"
	
  external get_radius : t -> float = "sf_CircleShape_getRadius__impl"
      
  external set_point_count : t -> int -> unit =
      "sf_CircleShape_setPointCount__impl"
	
end
  
class circle_shape_base ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t =
object ((self : 'self))
  inherit shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness (CircleShape.to_shape t)

  val t_circle_shape_base = (t : CircleShape.t)
  method rep__sf_CircleShape = t_circle_shape_base
  method destroy = CircleShape.destroy t_circle_shape_base
  method set_radius : float -> unit =
    fun p1 -> CircleShape.set_radius t_circle_shape_base p1
  method get_radius : float =
    CircleShape.get_radius t_circle_shape_base
  method set_point_count : int -> unit =
    fun p1 -> CircleShape.set_point_count t_circle_shape_base p1
end
     
  
class circle_shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?point_count t =
object (self)
  inherit circle_shape_base ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t
  initializer do_if self#set_point_count point_count
end
  
class circle_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?point_count ?radius () =
  let t =
    match radius with
      | Some r -> CircleShape.from_radius r
      | None -> CircleShape.default ()
  in
  circle_shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?point_count t
    
module ConvexShape =
struct
  type t

  external to_shape : t -> Shape.t = "upcast__sf_Shape_of_sf_ConvexShape__impl"
    
  external destroy : t -> unit = "sf_ConvexShape_destroy__impl"
      
  external default : unit -> t = "sf_ConvexShape_default_constructor__impl"
      
  external from_point_count : int -> t =
      "sf_ConvexShape_point_constructor__impl"
	
  external set_point_count : t -> int -> unit =
      "sf_ConvexShape_setPointCount__impl"
	
  external set_point : t -> int -> (float * float) -> unit =
      "sf_ConvexShape_setPoint__impl"
	
end
  
class convex_shape_base ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t =
object ((self : 'self))
  inherit shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness (ConvexShape.to_shape t)

  val t_convex_shape_base = (t : ConvexShape.t)
  method rep__sf_ConvexShape = t_convex_shape_base
  method destroy = ConvexShape.destroy t_convex_shape_base
  method set_point_count : int -> unit =
    fun p1 -> ConvexShape.set_point_count t_convex_shape_base p1
  method set_point : int -> (float * float) -> unit =
    fun p1 p2 -> ConvexShape.set_point t_convex_shape_base p1 p2
end   

  
class convex_shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?points t =
object (self)
  inherit convex_shape_base ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness t

  initializer do_if 
    (
      fun l ->
	(
	  self#set_point_count (List.length l);
	  ignore (List.fold_left (fun idx pos -> (self#set_point idx pos; idx + 1)) 0 l)
	)
    ) points
end
  
class convex_shape ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?points () =
  let t = ConvexShape.default ()
  in convex_shape_init ?position ?scale ?rotation ?origin ?new_texture ?texture_rect ?fill_color ?outline_color ?outline_thickness ?points t
    
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
type text_style = | Bold | Italic | Underline

module Text =
struct
  type t
    
  external destroy : t -> unit = "sf_Text_destroy__impl"

  external to_transformable : t -> Transformable.t =
      "upcast__sf_Transformable_of_sf_Text__impl"
      
  external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_sf_Text__impl"
	
  external default : unit -> t = "sf_Text_default_constructor__impl"
      
  external create : string -> font -> int -> t =
      "sf_Text_init_constructor__impl"
	
  external set_string : t -> string -> unit = "sf_Text_setString__impl"
      
  external set_font : t -> font -> unit = "sf_Text_setFont__impl"
      
  external set_character_size : t -> int -> unit =
      "sf_Text_setCharacterSize__impl"
	
  external set_style : t -> text_style list -> unit =
      "sf_Text_setStyle__impl"
	
  external set_color : t -> Color.t -> unit = "sf_Text_setColor__impl"
      
  external get_string : t -> string = "sf_Text_getString__impl"
      
  external get_font : t -> font = "sf_Text_getFont__impl"
      
  external get_character_size : t -> int = "sf_Text_getCharacterSize__impl"
      
  external get_style : t -> text_style list = "sf_Text_getStyle__impl"
      
  external find_character_pos : t -> int -> (float * float) =
      "sf_Text_findCharacterPos__impl"
	
  external get_local_bounds : t -> float rect =
      "sf_Text_getLocalBounds__impl"
	
  external get_global_bounds : t -> float rect =
      "sf_Text_getGlobalBounds__impl"
	
end
  
class text_base ?position ?scale ?rotation ?origin t =
object ((self : 'self))
  val t_text_base = (t : Text.t)
  method rep__sf_Text = t_text_base
  method destroy = Text.destroy t_text_base

  inherit transformable_init ?position ?scale ?rotation ?origin (Text.to_transformable t)
  inherit drawable (Text.to_drawable t)

  method set_string : string -> unit =
    fun p1 -> Text.set_string t_text_base p1
  method set_font : font -> unit =
    fun p1 -> Text.set_font t_text_base p1
  method set_character_size : int -> unit =
    fun p1 -> Text.set_character_size t_text_base p1
  method set_style : text_style list -> unit =
    fun p1 -> Text.set_style t_text_base p1
  method set_color : Color.t -> unit =
    fun p1 -> Text.set_color t_text_base p1
  method get_string : string = Text.get_string t_text_base
  method get_font : font = Text.get_font t_text_base
  method get_character_size : int =
    Text.get_character_size t_text_base
  method get_style : text_style list = Text.get_style t_text_base
  method find_character_pos : int -> (float * float) =
    fun p1 -> Text.find_character_pos t_text_base p1
  method get_local_bounds : float rect =
    Text.get_local_bounds t_text_base
  method get_global_bounds : float rect =
    Text.get_global_bounds t_text_base
end    
  
class text_init ?string ?position ?scale ?rotation ?origin ?color ?font ?character_size ?style t =
object (self)
 inherit text_base ?position ?scale ?rotation ?origin t
   
 initializer do_if self#set_string string
 initializer do_if self#set_font font
 initializer do_if self#set_character_size character_size
 initializer do_if self#set_style style
 initializer do_if self#set_color color
end
  
class text ?string ?position ?scale ?rotation ?origin ?color ?font ?character_size ?style () =
  let t = Text.default ()
  in text_init ?string ?position ?scale ?rotation ?origin ?color ?font ?character_size ?style t
    
module Sprite =
struct
  type t
    
  external destroy : t -> unit = "sf_Sprite_destroy__impl"
      
  external to_transformable : t -> Transformable.t =
      "upcast__sf_Transformable_of_sf_Sprite__impl"
	
  external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_sf_Sprite__impl"
	
  external default : unit -> t = "sf_Sprite_default_constructor__impl"
      
  external create_from_texture : texture -> t =
      "sf_Sprite_texture_constructor__impl"
	
  external set_texture : t -> ?resize: bool -> texture -> unit =
      "sf_Sprite_setTexture__impl"
	
  external set_texture_rect : t -> int rect -> unit =
      "sf_Sprite_setTextureRect__impl"
	
  external set_color : t -> Color.t -> unit = "sf_Sprite_setColor__impl"
      
  external get_texture : t -> texture option = "sf_Sprite_getTexture__impl"
      
  external get_texture_rect : t -> int rect =
      "sf_Sprite_getTextureRect__impl"
	
  external get_color : t -> Color.t = "sf_Sprite_getColor__impl"
      
  external get_local_bounds : t -> float rect =
      "sf_Sprite_getLocalBounds__impl"
	
  external get_global_bounds : t -> float rect =
      "sf_Sprite_getGlobalBounds__impl"
	
end
  
class sprite_base ?position ?scale ?rotation ?origin t =
object ((self : 'self))
  val t_sprite_base = (t : Sprite.t)
  method rep__sf_Sprite = t_sprite_base
  method destroy = Sprite.destroy t_sprite_base

  inherit transformable_init ?position ?scale ?rotation ?origin (Sprite.to_transformable t)
  inherit drawable (Sprite.to_drawable t)

  method set_texture : ?resize: bool -> texture -> unit =
    fun ?resize p1 -> Sprite.set_texture t_sprite_base ?resize p1
  method set_texture_rect : int rect -> unit =
    fun p1 -> Sprite.set_texture_rect t_sprite_base p1
  method set_color : Color.t -> unit =
    fun p1 -> Sprite.set_color t_sprite_base p1
  method get_texture : texture option =
    Sprite.get_texture t_sprite_base
  method get_texture_rect : int rect =
    Sprite.get_texture_rect t_sprite_base
  method get_color : Color.t = Sprite.get_color t_sprite_base
  method get_local_bounds : float rect =
    Sprite.get_local_bounds t_sprite_base
  method get_global_bounds : float rect =
    Sprite.get_global_bounds t_sprite_base
end
  
class sprite_init ?texture ?position ?scale ?rotation ?origin ?color ?texture_rect t =
object (self)
  inherit sprite_base ?position ?scale ?rotation ?origin t

  initializer do_if self#set_texture texture
  initializer do_if self#set_texture_rect texture_rect
  initializer do_if self#set_color color
end
 
class sprite ?texture ?position ?scale ?rotation ?origin ?color ?texture_rect () = 
  let t = Sprite.default ()
  in sprite_init ?texture ?position ?scale ?rotation ?origin ?color ?texture_rect t
  
    
type vertex =
    { position : (float * float); color : Color.t; tex_coords : (float * float)
    }


let mk_vertex ?(position = (0., 0.)) ?(color = Color.white)
    ?(tex_coords = (0., 0.)) () =
  { position = position; color = color; tex_coords = tex_coords; }

    
type primitive_type =
  | Points
  | Lines
  | LinesStrip
  | Triangles
  | TrianglesStrip
  | TrianglesFan
  | Quads


module VertexArray =
struct
  type t
    
  external destroy : t -> unit = "sf_VertexArray_destroy__impl"
      
  external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_sf_VertexArray__impl"
	
  external default : unit -> t = "sf_VertexArray_default_constructor__impl"
      
  external get_vertex_count : t -> int =
      "sf_VertexArray_getVertexCount__impl"
	
  external set_at_index : t -> int -> vertex -> unit =
      "sf_VertexArray_setAtIndex__impl"
	
  external get_at_index : t -> int -> vertex =
      "sf_VertexArray_getAtIndex__impl"
	
  external clear : t -> unit = "sf_VertexArray_clear__impl"
      
  external resize : t -> int -> unit = "sf_VertexArray_resize__impl"
      
  external append : t -> vertex -> unit = "sf_VertexArray_append__impl"
      
  external set_primitive_type : t -> primitive_type -> unit =
      "sf_VertexArray_setPrimitiveType__impl"
	
  external get_primitive_type : t -> primitive_type =
      "sf_VertexArray_getPrimitiveType__impl"
	
  external get_bounds : t -> float rect = "sf_VertexArray_getBounds__impl"
      
end
  
class vertex_array_base t =
object ((self : 'self))

  val t_vertex_array_base = (t : VertexArray.t)
  method rep__sf_VertexArray = t_vertex_array_base
  method destroy = VertexArray.destroy t_vertex_array_base

  inherit drawable (VertexArray.to_drawable t)

  method get_vertex_count : int =
    VertexArray.get_vertex_count t_vertex_array_base
  method set_at_index : int -> vertex -> unit =
    fun p1 p2 -> VertexArray.set_at_index t_vertex_array_base p1 p2
  method get_at_index : int -> vertex =
    fun p1 -> VertexArray.get_at_index t_vertex_array_base p1
  method clear : unit = VertexArray.clear t_vertex_array_base
  method resize : int -> unit =
    fun p1 -> VertexArray.resize t_vertex_array_base p1
  method append : vertex -> unit =
    fun p1 -> VertexArray.append t_vertex_array_base p1
  method set_primitive_type : primitive_type -> unit =
    fun p1 -> VertexArray.set_primitive_type t_vertex_array_base p1
  method get_primitive_type : primitive_type =
    VertexArray.get_primitive_type t_vertex_array_base
  method get_bounds : float rect = VertexArray.get_bounds t_vertex_array_base
end
       
class vertex_array ?primitive_type content = 
  let t = VertexArray.default () in 
object (self)
  inherit vertex_array_base t
  initializer List.iter self#append content
  initializer 
    match primitive_type with 
      | None -> () 
      | Some t -> self#set_primitive_type t
end
  
(* type draw_func_type = RenderTarget.t -> render_states -> unit *)


(*
module CamlDrawable =
struct
  type t
    
  external destroy : t -> unit = "CamlDrawable_destroy__impl"
      
  external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_CamlDrawable__impl"
	
  external default : unit -> t = "CamlDrawable_default_constructor__impl"
      
  external callback : draw_func_type -> t =
      "CamlDrawable_callback_constructor__impl"
	
  external set_callback : t -> draw_func_type -> unit =
      "CamlDrawable_setCallback__impl"
	
end
  
class caml_drawable_base t =
object ((self : 'self))
  val t_caml_drawable_base = (t : CamlDrawable.t)
  method rep__CamlDrawable = t_caml_drawable_base
  method destroy = CamlDrawable.destroy t_caml_drawable_base

  inherit drawable (CamlDrawable.to_drawable t)

  method set_callback : draw_func_type -> unit =
    fun p1 -> CamlDrawable.set_callback t_caml_drawable_base p1
end
  
    
class virtual caml_drawable =
object (self)
  inherit caml_drawable_base (CamlDrawable.default ()) as super
  method virtual draw : render_target -> render_states -> unit
  initializer
    super#set_callback (fun t s -> self#draw (new render_target t) s)
end
*)
