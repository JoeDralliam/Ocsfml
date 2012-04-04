(** *)

(** *)
type 'a rect = { left : 'a; top : 'a; width : 'a; height : 'a; }
module type RECT_VAL =
sig type t val add : t -> t -> t val sub : t -> t -> t end
module Rect :
  functor (M : RECT_VAL) ->
sig
  val contains : M.t rect -> M.t -> M.t -> bool
  val contains_v : M.t rect -> M.t * M.t -> bool
  val intersects : M.t rect -> M.t rect -> M.t rect option
end



module IntRect :
sig
  val contains : int rect -> int -> int -> bool
  val contains_v : int rect -> int * int -> bool
  val intersects : int rect -> int rect -> int rect option
end


module FloatRect :
sig
  val contains : float rect -> float -> float -> bool
  val contains_v : float rect -> float * float -> bool
  val intersects :float rect -> float rect -> float rect option
end

module Color :
sig
    (** Utility class for manpulating RGBA colors.
	
	sf::Color is a simple color class composed of 4 components:
	
	- Red
	- Green
	- Blue
	- Alpha (opacity)
	
	Each component is an integer in the range [0, 255].
	
	The fourth component of colors, named "alpha", represents the opacity of the color. A color with an alpha value of 255 will be fully opaque, while an alpha value of 0 will make a color fully transparent, whatever the value of the other components is.
	
	Colors can also be added and modulated (multiplied) using the overloaded operators Infix.+% and Infix.*%. *)
  type t = { 
    r : int; (** Red component. *)
    g : int; (** Green component. *)
    b : int; (** Blue component. *)
    a : int; (** Alpha (opacity) component. *)
  }
      
      
    (** Construct the color from its 3 RGB components (alpha is set to 255).
	@return Color constructed from the 3 RGB components. *)
  val rgb : int -> int -> int -> t
    
    
    (** Construct the color from its 4 RGBA components. 
	@return Color constructed from the 4 RGBA components. *)
  val rgba : int -> int -> int -> int -> t
    
    
    (** Compute the the component-wise sum of two colors. Components that exceed 255 are clamped to 255. 
	@return Result of the sum. *) 
  val add : t -> t -> t

    
    (** Compute the the component-wise multiplication (also called "modulation") of two colors. Components are then divided by 255 so that the result is still in the range [0, 255].
	@return Result of the multiplication. *)
  val modulate : t -> t -> t
    
    (** White predefined color. *)
  val white : t

    (** White predefined color. *)
  val black : t

    (** White predefined color. *)
  val red : t

    (** White predefined color. *)
  val green : t

    (** White predefined color. *)
  val blue : t

    (** White predefined color. *)
  val yellow : t

    (** White predefined color. *)
  val magenta : t

    (** White predefined color. *)
  val cyan : t


  module Infix : 
  sig 
    val ( +% ) : t -> t -> t 
    val ( *% ) : t -> t -> t 
  end
end

(** Available blending modes for drawing. *)
type blend_mode = 
    BlendAlpha (** Pixel = Source * Source.a + Dest * (1 - Source.a) *)
  | BlendAdd  (** Pixel = Source + Dest. *)
  | BlendMultiply (** Pixel = Source * Dest. *)
  | BlendNone (** Pixel = Source. *)

module Transform :
sig
  type t
  class type transform_class_type =
  object ('a)
    val t_transform : t
    method combine : 'a -> 'a
    method destroy : unit
    method get_inverse : 'a
    method rep__sf_Transform : t
    method rotate : ?center_x:float -> ?center_y:float -> float -> unit
    method rotate_v : ?center:float * float -> float -> unit
    method scale :
      ?center_x:float -> ?center_y:float -> float -> float -> unit
    method scale_v : ?center:float * float -> float * float -> unit
    method transform_point : float -> float -> float * float
    method transform_point_v : float * float -> float * float
    method transform_rect : float rect -> float rect
    method translate : float -> float -> unit
    method translate_v : float * float -> unit
  end

  val destroy : t -> unit
  val get_inverse : t -> 'a
  val transform_point : t -> float -> float -> float * float
  val transform_point_v : t -> float * float -> float * float
  val transform_rect : t -> float rect -> float rect
  val combine : t -> 'a -> 'a
  val translate : t -> float -> float -> unit
  val translate_v : t -> float * float -> unit
  val rotate : t -> ?center_x:float -> ?center_y:float -> float -> unit
  val rotate_v : t -> ?center:float * float -> float -> unit
  val scale : t -> ?center_x:float -> ?center_y:float -> float -> float -> unit
  val scale_v : t -> ?center:float * float -> float * float -> unit
end

(** Define a 3x3 transform matrix.

    A sf::Transform specifies how to translate, rotate, scale, shear, project, whatever things.

    In mathematical terms, it defines how to transform a coordinate system into another.
    
    For example, if you apply a rotation transform to a sprite, the result will be a rotated sprite. And anything that is transformed by this rotation transform will be rotated the same way, according to its initial position.
    
    Transforms are typically used for drawing. But they can also be used for any computation that requires to transform points between the local and global coordinate systems of an entity (like collision detection). *)
class transform :
  Transform.t ->
object ('a)
  val t_transform : Transform.t


    (** Combine the current transform with another one.

	The result is a transform that is equivalent to applying this followed by transform. Mathematically, it is equivalent to a matrix multiplication.
	@return Reference to self. *)
  method combine : 'a -> 'a


    (**)
  method destroy : unit


    (** Return the inverse of the transform.

	If the inverse cannot be computed, an identity transform is returned.
	@return A new transform which is the inverse of self. *)
  method get_inverse : 'a


    (**/**)
  method rep__sf_Transform : Transform.t
    (**/**)

    
    (** Combine the current transform with a rotation.

	The center of rotation is provided for convenience as a second argument, so that you can build rotations around arbitrary points more easily (and efficiently) than the usual translate(-center).rotate(angle).translate(center).
	@param center_x X coordinate of the center of rotation. 
	@param center_y Y coordinate of the center of rotation. *)
  method rotate : ?center_x:float -> ?center_y:float -> float -> unit


    (** Combine the current transform with a rotation.
	
	The center of rotation is provided for convenience as a second argument, so that you can build rotations around arbitrary points more easily (and efficiently) than the usual translate(-center).rotate(angle).translate(center).
	@param center Center of rotation.*)
  method rotate_v : ?center:float * float -> float -> unit

    
    (** Combine the current transform with a scaling.
	
	The center of scaling is provided for convenience as a second argument, so that you can build scaling around arbitrary points more easily (and efficiently) than the usual translate(-center).scale(factors).translate(center).
	@param center_x X coordinate of the center of scaling 
	@param center_y Y coordinate of the center of scaling *)
  method scale : ?center_x:float -> ?center_y:float -> float -> float -> unit
    

    (** Combine the current transform with a scaling.
	
	The center of scaling is provided for convenience as a second argument, so that you can build scaling around arbitrary points more easily (and efficiently) than the usual translate(-center).scale(factors).translate(center).
	@param center Center of scaling. *)
  method scale_v : ?center:float * float -> float * float -> unit
    

    (** Transform a 2D point. 
	@return Transformed point. *)
  method transform_point : float -> float -> float * float
    

    (** Transform a 2D point. 
	@return Transformed point. *)
  method transform_point_v : float * float -> float * float
    

    (** Transform a rectangle.
	
	Since SFML doesn't provide support for oriented rectangles, the result of this function is always an axis-aligned rectangle. Which means that if the transform contains a rotation, the bounding rectangle of the transformed rectangle is returned.
	@return Transformed rectangle *)
  method transform_rect : float rect -> float rect
    

    (** Combine the current transform with a translation. *)
  method translate : float -> float -> unit
    

    (** Combine the current transform with a translation. *)
  method translate_v : float * float -> unit
end

module Drawable :
sig 
  type t 
  val destroy : t -> unit
end

(** Abstract base class for objects that can be drawn to a render target.
    
    Drawable is a very simple base class that allows objects of derived classes to be drawn to a RenderTarget.
    
    All you have to do in your derived class is to override the draw virtual function.
    
    Note that inheriting from Drawable is not mandatory, but it allows this nice syntax "window#draw(object)" rather than "object#draw(window)", which is more consistent with other SFML classes. *)
class drawable :
  Drawable.t ->
object
  val t_drawable : Drawable.t
  method destroy : unit
  method rep__sf_Drawable : Drawable.t
end


module Transformable :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val set_position : t -> float -> float -> unit
  val set_position_v : t -> float * float -> unit
  val set_scale : t -> float -> float -> unit
  val set_scale_v : t -> float * float -> unit
  val set_origin : t -> float -> float -> unit
  val set_origin_v : t -> float * float -> unit
  val set_rotation : t -> float -> unit
  val get_position : t -> float * float
  val get_scale : t -> float * float
  val get_origin : t -> float * float
  val get_rotation : t -> float
  val move : t -> float -> float -> unit
  val move_v : t -> float * float -> unit
  val scale : t -> float -> float -> unit
  val scale_v : t -> float * float -> unit
  val rotate : t -> float -> unit
  val get_transform : t -> transform
  val get_inverse_transform : t -> transform
end


(** Decomposed transform defined by a position, a rotation and a scale.
    
    This class is provided for convenience, on top of Transform.
    
    Transform, as a low-level class, offers a great level of flexibility but it is not always convenient to manage. Indeed, one can easily combine any kind of operation, such as a translation followed by a rotation followed by a scaling, but once the result transform is built, there's no way to go backward and, let's say, change only the rotation without modifying the translation and scaling. The entire transform must be recomputed, which means that you need to retrieve the initial translation and scale factors as well, and combine them the same way you did before updating the rotation. This is a tedious operation, and it requires to store all the individual components of the final transform.
    
    That's exactly what Transformable was written for: it hides these variables and the composed transform behind an easy to use interface. You can set or get any of the individual components without worrying about the others. It also provides the composed transform (as a Transform), and keeps it up-to-date.
    
    In addition to the position, rotation and scale, Transformable provides an "origin" component, which represents the local origin of the three other components. Let's take an example with a 10x10 pixels sprite. By default, the sprite is positionned/rotated/scaled relatively to its top-left corner, because it is the local point (0, 0). But if we change the origin to be (5, 5), the sprite will be positionned/rotated/scaled around its center instead. And if we set the origin to (10, 10), it will be transformed around its bottom-right corner.
    
    To keep the Transformable class simple, there's only one origin for all the components. You cannot position the sprite relatively to its top-left corner while rotating it around its center, for example. To do such things, use Transform directly.
    
    Transformable can be used as a base class. It is often combined with Drawable -- that's what SFML's sprites, texts and shapes do. *)
class transformable :
  Transformable.t ->
object
    (**/**)
  val t_transformable : Transformable.t
    (**/**)

  method destroy : unit

    (** Get the inverse of the combined transform of the object
	@return Inverse of the combined transformations applied to the object. *)
  method get_inverse_transform : transform

    (** Get the local origin of the object.
	@return Current origin. *)
  method get_origin : float * float
    
    (** Getthe position of the object.
	@return Current position *)
  method get_position : float * float

    (** Get the the orientation of the object.
	
	The rotation is always in the range [0, 360].
	@return Current rotation, in degrees. *)
  method get_rotation : float

    (** Get the scale of the object.
	@return Current scale factors. *)
  method get_scale : float * float

    (** Get the combined transform of the object.
	@return Transform combining the position/rotation/scale/origin of the object *)
  method get_transform : transform

    (** Move the object by a given offset.
	
	This function adds to the current position of the object, unlike setPosition which overwrites it. *)
  method move : float -> float -> unit
    
    (** Move the object by a given offset.
	
	This function adds to the current position of the object, unlike setPosition which overwrites it. *)
  method move_v : float * float -> unit
    
    (**/**)
  method rep__sf_Transformable : Transformable.t
    (**/**)

    (** Rotate the object.

	This function adds to the current rotation of the object, unlike setRotation which overwrites it. *)
  method rotate : float -> unit
    
    (** Scale the object.
	
	This function multiplies the current scale of the object, unlike setScale which overwrites it. *)
  method scale : float -> float -> unit
    
    (** Scale the object.
	
	This function multiplies the current scale of the object, unlike setScale which overwrites it. *)
  method scale_v : float * float -> unit
    
    (** Set the local origin of the object
	
	The origin of an object defines the center point for all transformations (position, scale, rotation). The coordinates of this point must be relative to the top-left corner of the object, and ignore all transformations (position, scale, rotation). The default origin of a transformable object is (0, 0). *)
  method set_origin : float -> float -> unit
    
    (** Set the local origin of the object
	
	The origin of an object defines the center point for all transformations (position, scale, rotation). The coordinates of this point must be relative to the top-left corner of the object, and ignore all transformations (position, scale, rotation). The default origin of a transformable object is (0, 0). *)
  method set_origin_v : float * float -> unit
    
    (** Set the position of the object
	
	This function completely overwrites the previous position. See Move to apply an offset based on the previous position instead. The default position of a transformable object is (0, 0). *)
  method set_position : float -> float -> unit
    
    (** Set the position of the object
	
	This function completely overwrites the previous position. See Move to apply an offset based on the previous position instead. The default position of a transformable object is (0, 0). *)
  method set_position_v : float * float -> unit
    
    (** Set the orientation of the object
	
	This function completely overwrites the previous rotation. See Rotate to add an angle based on the previous rotation instead. The default rotation of a transformable object is 0.*)
  method set_rotation : float -> unit
    
    (** Set the scale factors of the object

	This function completely overwrites the previous scale. See Scale to add a factor based on the previous scale instead. The default scale of a transformable object is (1, 1).*)
  method set_scale : float -> float -> unit
    
    (** Set the scale factors of the object

	This function completely overwrites the previous scale. See Scale to add a factor based on the previous scale instead. The default scale of a transformable object is (1, 1).*)
  method set_scale_v : float * float -> unit
end

val mk_transformable :
  ?position:float * float ->
  ?scale:float * float ->
  ?origin:float * float -> ?rotation:float -> #transformable -> unit


type pixel_array_type =
    (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array2.t

val pixel_array_kind : (int, Bigarray.int8_unsigned_elt) Bigarray.kind

val pixel_array_layout : Bigarray.c_layout Bigarray.layout

module Image :
sig
  type t
  class type imageCpp_class_type =
  object ('a)
    val t_imageCpp : t
    method copy :
      ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit
    method create_from_color : ?color:Color.t -> int -> int -> unit
    method create_mask_from_color : ?alpha:int -> Color.t -> unit
    method destroy : unit
    method flip_horizontally : unit
    method flip_vertically : unit
    method get_height : int
    method get_pixel : int -> int -> Color.t
    method get_pixels_ptr : pixel_array_type
    method get_width : int
    method load_from_file : string -> bool
    method load_from_stream : OcsfmlSystem.input_stream -> bool
    method rep__sf_Image : t
    method save_to_file : string -> bool
    method set_pixel : int -> int -> Color.t -> unit
  end
  val destroy : t -> unit
  val default : unit -> t
  val create_from_color : t -> ?color:Color.t -> int -> int -> unit
  val load_from_file : t -> string -> bool
  val load_from_stream : t -> OcsfmlSystem.input_stream -> bool
  val save_to_file : t -> string -> bool
  val get_width : t -> int
  val get_height : t -> int
  val get_pixels_ptr : t -> pixel_array_type
  val create_mask_from_color : t -> ?alpha:int -> Color.t -> unit
  val copy :
    t -> ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit
  val set_pixel : t -> int -> int -> Color.t -> unit
  val get_pixel : t -> int -> int -> Color.t
  val flip_horizontally : t -> unit
  val flip_vertically : t -> unit
end

class imageCpp :
  Image.t ->
object ('a)
  val t_imageCpp : Image.t
  method copy :
    ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit
  method create_from_color : ?color:Color.t -> int -> int -> unit
  method create_mask_from_color : ?alpha:int -> Color.t -> unit
  method destroy : unit
  method flip_horizontally : unit
  method flip_vertically : unit
  method get_height : int
  method get_pixel : int -> int -> Color.t
  method get_pixels_ptr : pixel_array_type
  method get_width : int
  method load_from_file : string -> bool
  method load_from_stream : OcsfmlSystem.input_stream -> bool
  method rep__sf_Image : Image.t
  method save_to_file : string -> bool
  method set_pixel : int -> int -> Color.t -> unit
end


class image_bis : unit -> imageCpp


class image : image_bis


val mk_image :
  [< `Color of Color.t * int * int
  | `Create of int * int
  | `File of string
  | `Stream of OcsfmlSystem.input_stream ] ->
  image

val get_maximum_size : unit -> int


module Texture :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val create : t -> int -> int -> unit
  val load_from_file : t -> ?rect:int rect -> string -> bool
  val load_from_stream :
    t -> ?rect:int rect -> OcsfmlSystem.input_stream -> bool
  val load_from_image : t -> ?rect:int rect -> image -> bool
  val get_width : t -> int
  val get_height : t -> int
  val copy_to_image : t -> image
  val update_from_image : t -> ?coords:int * int -> image -> unit
  val update_from_window :
    t -> ?coords:int * int -> #OcsfmlWindow.window -> unit
  val bind : t -> unit
  val set_smooth : t -> bool -> unit
  val is_smooth : t -> bool -> unit
  val set_repeated : t -> bool -> unit
  val is_repeated : t -> bool
end
class textureCpp :
  Texture.t ->
object
  val t_textureCpp : Texture.t
  method bind : unit
  method copy_to_image : image
  method create : int -> int -> unit
  method destroy : unit
  method get_height : int
  method get_width : int
  method is_repeated : bool
  method is_smooth : bool -> unit
  method load_from_file : ?rect:int rect -> string -> bool
  method load_from_image : ?rect:int rect -> image -> bool
  method load_from_stream :
    ?rect:int rect -> OcsfmlSystem.input_stream -> bool
  method rep__sf_Texture : Texture.t
  method set_repeated : bool -> unit
  method set_smooth : bool -> unit
  method update_from_image : ?coords:int * int -> image -> unit
  method update_from_window :
    ?coords:int * int -> #OcsfmlWindow.window -> unit
end


class texture_bis : unit -> textureCpp


class texture : texture_bis


val mk_texture :
  [< `File of string
  | `Image of int rect * image
  | `Stream of OcsfmlSystem.input_stream ] ->
  texture


type glyph = { advance : int; bounds : int rect; sub_rect : int rect; }


module Font :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val load_from_file : t -> string -> bool
  val load_from_stream : t -> #OcsfmlSystem.input_stream -> bool
  val get_glyph : t -> int -> int -> bool -> glyph
  val get_kerning : t -> int -> int -> int -> int
  val get_line_spacing : t -> int -> int
  val get_texture : t -> int -> texture
end


class fontCpp :
  Font.t ->
object
  val t_fontCpp : Font.t
  method destroy : unit
  method get_glyph : int -> int -> bool -> glyph
  method get_kerning : int -> int -> int -> int
  method get_line_spacing : int -> int
  method get_texture : int -> texture
  method load_from_file : string -> bool
  method load_from_stream : #OcsfmlSystem.input_stream -> bool
  method rep__sf_Font : Font.t
end


class font_bis : unit -> fontCpp


class font : font_bis


val mk_font :
  [< `File of string | `Stream of #OcsfmlSystem.input_stream ] -> font


module Shader :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val load_from_file :
    t -> ?vertex:string -> ?fragment:string -> unit -> bool
  val load_from_stream :
    t ->
    ?vertex:(#OcsfmlSystem.input_stream as 'a) ->
    ?fragment:'a -> unit -> bool
  val set_parameter1 : t -> string -> float -> unit
  val set_parameter2 : t -> string -> float -> float -> unit
  val set_parameter3 : t -> string -> float -> float -> float -> unit
  val set_parameter4 :
    t -> string -> float -> float -> float -> float -> unit
  val set_parameter2v : t -> string -> float * float -> unit
  val set_parameter3v : t -> string -> float * float * float -> unit
  val set_color : t -> string -> Color.t -> unit
  val set_transform : t -> string -> transform -> unit
  val set_texture : t -> string -> texture -> unit
  val set_current_texture : t -> string -> unit
  val bind : t -> unit
  val unbind : t -> unit
end
class shaderCpp :
  Shader.t ->
object
  val t_shaderCpp : Shader.t
  method bind : unit
  method destroy : unit
  method load_from_file :
    ?vertex:string -> ?fragment:string -> unit -> bool
  method load_from_stream :
    ?vertex:(#OcsfmlSystem.input_stream as 'a) ->
      ?fragment:'a -> unit -> bool
  method rep__sf_Shader : Shader.t
  method set_color : string -> Color.t -> unit
  method set_current_texture : string -> unit
  method set_parameter : string -> ?x:float -> ?y:float -> ?z:float -> float -> unit
  method set_parameter1 : string -> float -> unit
  method set_parameter2 : string -> float -> float -> unit
  method set_parameter2v : string -> float * float -> unit
  method set_parameter3 : string -> float -> float -> float -> unit
  method set_parameter3v : string -> float * float * float -> unit
  method set_parameter4 : string -> float -> float -> float -> float -> unit
  method set_texture : string -> texture -> unit
  method set_transform : string -> transform -> unit
  method unbind : unit
end

val shader_is_available : unit -> unit


class shader_bis : unit -> shaderCpp


class shader : shader_bis


module View :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val create_from_rect : float rect -> t
  val create_from_vectors : float * float -> float * float -> t
  val set_center : t -> float -> float -> unit
  val set_center_v : t -> float * float -> unit
  val set_size : t -> float -> float -> unit
  val set_size_v : t -> float * float -> unit
  val set_rotation : t -> float -> unit
  val set_viewport : t -> float rect -> unit
  val reset : t -> float rect -> unit
  val get_center : t -> float * float
  val get_size : t -> float * float
  val get_rotation : t -> float
  val get_viewport : t -> float rect
  val move : t -> float -> float -> unit
  val move_v : t -> float * float -> unit
  val rotate : t -> float -> unit
  val zoom : t -> float -> unit
end


class viewCpp :
  View.t ->
object
  val t_viewCpp : View.t
  method destroy : unit
  method get_center : float * float
  method get_rotation : float
  method get_size : float * float
  method get_viewport : float rect
  method move : float -> float -> unit
  method move_v : float * float -> unit
  method rep__sf_View : View.t
  method reset : float rect -> unit
  method rotate : float -> unit
  method set_center : float -> float -> unit
  method set_center_v : float * float -> unit
  method set_rotation : float -> unit
  method set_size : float -> float -> unit
  method set_size_v : float * float -> unit
  method set_viewport : float rect -> unit
  method zoom : float -> unit
end


class view : ?rect:float rect -> ?center:'a -> ?size:'b -> unit -> viewCpp


type render_states = {
  mutable blend_mode : blend_mode;
  mutable transform : transform;
  mutable texture : texture;
  mutable shader : shader;
}

val mk_render_states :
  ?blend_mode:blend_mode ->
  ?transform:transform -> ?texture:texture -> ?shader:shader -> unit -> unit


module RenderTarget :
sig
  type t
  val destroy : t -> unit
  val clear : t -> ?color:Color.t -> unit -> unit
  val draw : t -> ?render_states:render_states -> #drawable -> unit
  val get_size : t -> int * int
  val set_view : t -> view -> unit
  val get_view : t -> view
  val get_default_view : t -> view
  val get_viewport : t -> int rect
  val convert_coords : t -> ?view:view -> int -> int -> float * float
  val push_gl_states : t -> unit
  val pop_gl_states : t -> unit
  val reset_gl_states : t -> unit
end


class render_target :
  RenderTarget.t ->
object
  val t_render_target : RenderTarget.t
  method clear : ?color:Color.t -> unit -> unit
  method convert_coords : ?view:view -> int -> int -> float * float
  method destroy : unit
  method draw : ?render_states:render_states -> #drawable -> unit
  method get_default_view : view
  method get_size : int * int
  method get_view : view
  method get_viewport : int rect
  method pop_gl_states : unit
  method push_gl_states : unit
  method rep__sf_RenderTarget : RenderTarget.t
  method reset_gl_states : unit
  method set_view : view -> unit
end


module RenderTexture :
sig
  type t
  val destroy : t -> unit
  val to_render_target : t -> RenderTarget.t
  val default : unit -> t
  val create : t -> ?dephtBfr:bool -> int -> int -> bool
  val set_smooth : t -> bool -> unit
  val is_smooth : t -> bool
  val set_active : t -> ?active:bool -> unit -> bool
  val display : t -> unit
  val get_texture : t -> texture
end
class render_textureCpp :
  RenderTexture.t ->
object
  val t_render_target : RenderTarget.t
  val t_render_textureCpp : RenderTexture.t
  method clear : ?color:Color.t -> unit -> unit
  method convert_coords : ?view:view -> int -> int -> float * float
  method create : ?dephtBfr:bool -> int -> int -> bool
  method destroy : unit
  method display : unit
  method draw : ?render_states:render_states -> #drawable -> unit
  method get_default_view : view
  method get_size : int * int
  method get_texture : texture
  method get_view : view
  method get_viewport : int rect
  method is_smooth : bool
  method pop_gl_states : unit
  method push_gl_states : unit
  method rep__sf_RenderTarget : RenderTarget.t
  method rep__sf_RenderTexture : RenderTexture.t
  method reset_gl_states : unit
  method set_active : ?active:bool -> unit -> bool
  method set_smooth : bool -> unit
  method set_view : view -> unit
end


class render_texture_bis : unit -> render_textureCpp


class render_texture : render_texture_bis


module RenderWindow :
sig
  type t
  val destroy : t -> unit
  val to_windowCpp : t -> OcsfmlWindow.Window.t
  val to_render_target : t -> RenderTarget.t
  val default : unit -> t
  val create :
    ?style:OcsfmlWindow.Window.style list ->
    ?context:OcsfmlWindow.context_settings ->
    OcsfmlWindow.VideoMode.t -> string -> t
  val capture : t -> image
  val set_icon : t -> pixel_array_type -> unit
end


class render_windowCpp :
  RenderWindow.t ->
object
  val t_render_target : RenderTarget.t
  val t_render_windowCpp : RenderWindow.t
  val t_windowCpp : OcsfmlWindow.WindowCpp.t
  method capture : image
  method clear : ?color:Color.t -> unit -> unit
  method close : unit
  method convert_coords : ?view:view -> int -> int -> float * float
  method create :
    ?style:OcsfmlWindow.window_style list ->
      ?context:OcsfmlWindow.context_settings ->
	OcsfmlWindow.VideoMode.t -> string -> unit
  method destroy : unit
  method display : unit
  method draw : ?render_states:render_states -> #drawable -> unit
  method get_default_view : view
  method get_height : int
  method get_settings : OcsfmlWindow.context_settings
  method get_size : int * int
  method get_view : view
  method get_viewport : int rect
  method get_width : int
  method is_open : bool
  method poll_event : OcsfmlWindow.Event.t option
  method pop_gl_states : unit
  method push_gl_states : unit
  method rep__sf_RenderTarget : RenderTarget.t
  method rep__sf_RenderWindow : RenderWindow.t
  method rep__sf_Window : OcsfmlWindow.WindowCpp.t
  method reset_gl_states : unit
  method set_active : bool -> bool
  method set_framerate_limit : int -> unit
  method set_icon : pixel_array_type -> unit
  method set_joystick_threshold : float -> unit
  method set_key_repeat_enabled : bool -> unit
  method set_mouse_cursor_visible : bool -> unit
  method set_position : int -> int -> unit
  method set_size : int -> int -> unit
  method set_title : string -> unit
  method set_vertical_sync_enabled : bool -> unit
  method set_view : view -> unit
  method set_visible : bool -> unit
  method wait_event : OcsfmlWindow.Event.t option
end


class render_window :
  ?style:OcsfmlWindow.Window.style list ->
    ?context:OcsfmlWindow.context_settings ->
      OcsfmlWindow.VideoMode.t -> string -> render_windowCpp


module Shape :
sig
  type t
  val destroy : t -> unit
  val to_transformable : t -> Transformable.t
  val to_drawable : t -> Drawable.t
  val set_texture : t -> ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
  val set_texture_rect : t -> int rect -> unit
  val set_fill_color : t -> Color.t -> unit
  val set_outline_color : t -> Color.t -> unit
  val set_outline_thickness : t -> float -> unit
  val get_texture : t -> texture option
  val get_texture_rect : t -> int rect
  val get_fill_color : t -> Color.t
  val get_outline_color : t -> Color.t
  val get_outline_thickness : t -> float
  val get_point_count : t -> int
  val get_point : t -> int -> float * float
  val get_local_bounds : t -> float rect
  val get_global_bounds : t -> float rect
end
class shape :
  Shape.t ->
object
  val t_drawable : Drawable.t
  val t_shape : Shape.t
  val t_transformable : Transformable.t
  method destroy : unit
  method get_fill_color : Color.t
  method get_global_bounds : float rect
  method get_inverse_transform : transform
  method get_local_bounds : float rect
  method get_origin : float * float
  method get_outline_color : Color.t
  method get_outline_thickness : float
  method get_point : int -> float * float
  method get_point_count : int
  method get_position : float * float
  method get_rotation : float
  method get_scale : float * float
  method get_texture : texture option
  method get_texture_rect : int rect
  method get_transform : transform
  method move : float -> float -> unit
  method move_v : float * float -> unit
  method rep__sf_Drawable : Drawable.t
  method rep__sf_Shape : Shape.t
  method rep__sf_Transformable : Transformable.t
  method rotate : float -> unit
  method scale : float -> float -> unit
  method scale_v : float * float -> unit
  method set_fill_color : Color.t -> unit
  method set_origin : float -> float -> unit
  method set_origin_v : float * float -> unit
  method set_outline_color : Color.t -> unit
  method set_outline_thickness : float -> unit
  method set_position : float -> float -> unit
  method set_position_v : float * float -> unit
  method set_rotation : float -> unit
  method set_scale : float -> float -> unit
  method set_scale_v : float * float -> unit
  method set_texture : ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
  method set_texture_rect : int rect -> unit
end


val mk_shape :
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?new_texture:texture ->
  ?texture_rect:int rect ->
  ?fill_color:Color.t ->
  ?outline_color:Color.t -> ?outline_thickness:float -> #shape -> unit


module RectangleShape :
sig
  type t
  val destroy : t -> unit
  val to_shape : t -> Shape.t
  val default : unit -> t
  val from_size : float * float -> t
  val set_size : t -> float * float
  val get_size : t -> float * float
end
class rectangle_shapeCpp :
  RectangleShape.t ->
object
  val t_drawable : Drawable.t
  val t_rectangle_shapeCpp : RectangleShape.t
  val t_shape : Shape.t
  val t_transformable : Transformable.t
  method destroy : unit
  method get_fill_color : Color.t
  method get_global_bounds : float rect
  method get_inverse_transform : transform
  method get_local_bounds : float rect
  method get_origin : float * float
  method get_outline_color : Color.t
  method get_outline_thickness : float
  method get_point : int -> float * float
  method get_point_count : int
  method get_position : float * float
  method get_rotation : float
  method get_scale : float * float
  method get_size : float * float
  method get_texture : texture option
  method get_texture_rect : int rect
  method get_transform : transform
  method move : float -> float -> unit
  method move_v : float * float -> unit
  method rep__sf_Drawable : Drawable.t
  method rep__sf_RectangleShape : RectangleShape.t
  method rep__sf_Shape : Shape.t
  method rep__sf_Transformable : Transformable.t
  method rotate : float -> unit
  method scale : float -> float -> unit
  method scale_v : float * float -> unit
  method set_fill_color : Color.t -> unit
  method set_origin : float -> float -> unit
  method set_origin_v : float * float -> unit
  method set_outline_color : Color.t -> unit
  method set_outline_thickness : float -> unit
  method set_position : float -> float -> unit
  method set_position_v : float * float -> unit
  method set_rotation : float -> unit
  method set_scale : float -> float -> unit
  method set_scale_v : float * float -> unit
  method set_size : float * float
  method set_texture : ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
  method set_texture_rect : int rect -> unit
end


class rectangle_shape : ?size:float * float -> unit -> rectangle_shapeCpp


val mk_rectangle_shape :
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?new_texture:texture ->
  ?texture_rect:int rect ->
  ?fill_color:Color.t ->
  ?outline_color:Color.t ->
  ?outline_thickness:float -> ?size:float * float -> unit -> rectangle_shape


module CircleShape :
sig
  type t
  val destroy : t -> unit
  val to_shape : t -> Shape.t
  val default : unit -> t
  val from_radius : float -> t
  val set_radius : t -> float -> unit
  val get_radius : t -> float
  val set_point_count : t -> int -> unit
end
class circle_shapeCpp :
  CircleShape.t ->
object
  val t_circle_shapeCpp : CircleShape.t
  val t_drawable : Drawable.t
  val t_shape : Shape.t
  val t_transformable : Transformable.t
  method destroy : unit
  method get_fill_color : Color.t
  method get_global_bounds : float rect
  method get_inverse_transform : transform
  method get_local_bounds : float rect
  method get_origin : float * float
  method get_outline_color : Color.t
  method get_outline_thickness : float
  method get_point : int -> float * float
  method get_point_count : int
  method get_position : float * float
  method get_radius : float
  method get_rotation : float
  method get_scale : float * float
  method get_texture : texture option
  method get_texture_rect : int rect
  method get_transform : transform
  method move : float -> float -> unit
  method move_v : float * float -> unit
  method rep__sf_CircleShape : CircleShape.t
  method rep__sf_Drawable : Drawable.t
  method rep__sf_Shape : Shape.t
  method rep__sf_Transformable : Transformable.t
  method rotate : float -> unit
  method scale : float -> float -> unit
  method scale_v : float * float -> unit
  method set_fill_color : Color.t -> unit
  method set_origin : float -> float -> unit
  method set_origin_v : float * float -> unit
  method set_outline_color : Color.t -> unit
  method set_outline_thickness : float -> unit
  method set_point_count : int -> unit
  method set_position : float -> float -> unit
  method set_position_v : float * float -> unit
  method set_radius : float -> unit
  method set_rotation : float -> unit
  method set_scale : float -> float -> unit
  method set_scale_v : float * float -> unit
  method set_texture : ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
  method set_texture_rect : int rect -> unit
end


class circle_shape : ?radius:float -> unit -> circle_shapeCpp


val mk_circle_shape :
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?new_texture:texture ->
  ?texture_rect:int rect ->
  ?fill_color:Color.t ->
  ?outline_color:Color.t ->
  ?outline_thickness:float ->
  ?radius:float -> ?point_count:int -> unit -> circle_shape


module ConvexShape :
sig
  type t
  val destroy : t -> unit
  val to_shape : t -> Shape.t
  val default : unit -> t
  val from_point_count : int -> t
  val set_point_count : t -> int -> unit
  val set_point : t -> int -> float * float -> unit
end
  

class convex_shapeCpp :
  ConvexShape.t ->
object
  val t_convex_shapeCpp : ConvexShape.t
  val t_drawable : Drawable.t
  val t_shape : Shape.t
  val t_transformable : Transformable.t
  method destroy : unit
  method get_fill_color : Color.t
  method get_global_bounds : float rect
  method get_inverse_transform : transform
  method get_local_bounds : float rect
  method get_origin : float * float
  method get_outline_color : Color.t
  method get_outline_thickness : float
  method get_point : int -> float * float
  method get_point_count : int
  method get_position : float * float
  method get_rotation : float
  method get_scale : float * float
  method get_texture : texture option
  method get_texture_rect : int rect
  method get_transform : transform
  method move : float -> float -> unit
  method move_v : float * float -> unit
  method rep__sf_ConvexShape : ConvexShape.t
  method rep__sf_Drawable : Drawable.t
  method rep__sf_Shape : Shape.t
  method rep__sf_Transformable : Transformable.t
  method rotate : float -> unit
  method scale : float -> float -> unit
  method scale_v : float * float -> unit
  method set_fill_color : Color.t -> unit
  method set_origin : float -> float -> unit
  method set_origin_v : float * float -> unit
  method set_outline_color : Color.t -> unit
  method set_outline_thickness : float -> unit
  method set_point : int -> float * float -> unit
  method set_point_count : int -> unit
  method set_position : float -> float -> unit
  method set_position_v : float * float -> unit
  method set_rotation : float -> unit
  method set_scale : float -> float -> unit
  method set_scale_v : float * float -> unit
  method set_texture :
    ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
  method set_texture_rect : int rect -> unit
end


class convex_shape : ?point_count:int -> unit -> convex_shapeCpp


val mk_convex_shape :
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?new_texture:texture ->
  ?texture_rect:int rect ->
  ?fill_color:Color.t ->
  ?outline_color:Color.t ->
  ?outline_thickness:float ->
  ?points:(float * float) list -> unit -> convex_shape


type text_style = Bold | Italic | Underline


module Text :
sig
  type t
  val destroy : t -> unit
  val to_transformable : t -> Transformable.t
  val to_drawable : t -> Drawable.t
  val default : unit -> t
  val create : string -> font -> int -> t
  val set_string : t -> string -> unit
  val set_font : t -> font -> unit
  val set_character_size : t -> int -> unit
  val set_style : t -> text_style list -> unit
  val set_color : t -> Color.t -> unit
  val get_string : t -> string
  val get_font : t -> font
  val get_character_size : t -> int
  val get_style : t -> text_style list
  val get_character_pos : t -> int -> float * float
  val get_local_bounds : t -> float rect
  val get_global_bounds : t -> float rect
end
class textCpp :
  Text.t ->
object
  val t_drawable : Drawable.t
  val t_textCpp : Text.t
  val t_transformable : Transformable.t
  method destroy : unit
  method get_character_pos : int -> float * float
  method get_character_size : int
  method get_font : font
  method get_global_bounds : float rect
  method get_inverse_transform : transform
  method get_local_bounds : float rect
  method get_origin : float * float
  method get_position : float * float
  method get_rotation : float
  method get_scale : float * float
  method get_string : string
  method get_style : text_style list
  method get_transform : transform
  method move : float -> float -> unit
  method move_v : float * float -> unit
  method rep__sf_Drawable : Drawable.t
  method rep__sf_Text : Text.t
  method rep__sf_Transformable : Transformable.t
  method rotate : float -> unit
  method scale : float -> float -> unit
  method scale_v : float * float -> unit
  method set_character_size : int -> unit
  method set_color : Color.t -> unit
  method set_font : font -> unit
  method set_origin : float -> float -> unit
  method set_origin_v : float * float -> unit
  method set_position : float -> float -> unit
  method set_position_v : float * float -> unit
  method set_rotation : float -> unit
  method set_scale : float -> float -> unit
  method set_scale_v : float * float -> unit
  method set_string : string -> unit
  method set_style : text_style list -> unit
end


class text_bis : unit -> textCpp


class text : text_bis


val mk_text :
  ?string:string ->
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?color:Color.t ->
  ?font:font -> ?character_size:int -> ?style:text_style list -> unit -> text


module Sprite :
sig
  type t
  val destroy : t -> unit
  val to_transformable : t -> Transformable.t
  val to_drawable : t -> Drawable.t
  val default : unit -> t
  val create_from_texture : texture -> t
  val set_texture : t -> ?resize:bool -> texture -> unit
  val set_texture_rect : t -> int rect -> unit
  val set_color : t -> Color.t -> unit
  val get_texture : t -> texture
  val get_texture_rect : t -> int rect
  val get_color : t -> Color.t
  val get_local_bounds : t -> float rect
  val get_global_bounds : t -> float rect
end
class spriteCpp :
  Sprite.t ->
object
  val t_drawable : Drawable.t
  val t_spriteCpp : Sprite.t
  val t_transformable : Transformable.t
  method destroy : unit
  method get_color : Color.t
  method get_global_bounds : float rect
  method get_inverse_transform : transform
  method get_local_bounds : float rect
  method get_origin : float * float
  method get_position : float * float
  method get_rotation : float
  method get_scale : float * float
  method get_texture : texture
  method get_texture_rect : int rect
  method get_transform : transform
  method move : float -> float -> unit
  method move_v : float * float -> unit
  method rep__sf_Drawable : Drawable.t
  method rep__sf_Sprite : Sprite.t
  method rep__sf_Transformable : Transformable.t
  method rotate : float -> unit
  method scale : float -> float -> unit
  method scale_v : float * float -> unit
  method set_color : Color.t -> unit
  method set_origin : float -> float -> unit
  method set_origin_v : float * float -> unit
  method set_position : float -> float -> unit
  method set_position_v : float * float -> unit
  method set_rotation : float -> unit
  method set_scale : float -> float -> unit
  method set_scale_v : float * float -> unit
  method set_texture : ?resize:bool -> texture -> unit
  method set_texture_rect : int rect -> unit
end

class sprite_bis : unit -> spriteCpp


class sprite : sprite_bis


val mk_sprite :
  ?texture:texture ->
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?color:Color.t -> ?texture_rect:int rect -> unit -> sprite


type vertex = {
  position : float * float;
  color : Color.t;
  tex_coords : float * float;
}


val mk_vertex :
  ?position:float * float ->
  ?color:Color.t -> ?tex_coords:float * float -> unit -> vertex

type primitive_type =
    Points
  | Lines
  | LinesStrip
  | Triangles
  | TrianglesStrip
  | TrianglesFan
  | Quads


module VertexArray :
sig
  type t
  val destroy : t -> unit
  val to_drawable : t -> Drawable.t
  val default : unit -> t
  val get_vertex_count : t -> int
  val set_at_index : t -> int -> vertex -> unit
  val get_at_index : t -> int -> vertex
  val clear : t -> unit
  val resize : t -> int -> unit
  val append : t -> vertex -> unit
  val set_primitive_type : t -> primitive_type -> unit
  val get_primitive_type : t -> primitive_type
  val get_bounds : t -> float rect
end
class vertex_arrayCpp :
  VertexArray.t ->
object
  val t_drawable : Drawable.t
  val t_vertex_arrayCpp : VertexArray.t
  method append : vertex -> unit
  method clear : unit
  method destroy : unit
  method get_at_index : int -> vertex
  method get_bounds : float rect
  method get_primitive_type : primitive_type
  method get_vertex_count : int
  method rep__sf_Drawable : Drawable.t
  method rep__sf_VertexArray : VertexArray.t
  method resize : int -> unit
  method set_at_index : int -> vertex -> unit
  method set_primitive_type : primitive_type -> unit
end
class vertex_array_bis : unit -> vertex_arrayCpp
class vertex_array : vertex_array_bis
type draw_func_type = RenderTarget.t -> render_states -> unit
module CamlDrawable :
sig
  type t
  val destroy : t -> unit
  val to_drawable : t -> Drawable.t
  val default : unit -> t
  val callback : draw_func_type -> t
  val set_callback : t -> draw_func_type -> unit
end
class caml_drawableCpp :
  CamlDrawable.t ->
object
  val t_caml_drawableCpp : CamlDrawable.t
  val t_drawable : Drawable.t
  method destroy : unit
  method rep__CamlDrawable : CamlDrawable.t
  method rep__sf_Drawable : Drawable.t
  method set_callback : draw_func_type -> unit
end
class virtual caml_drawable :
object
  val t_caml_drawableCpp : CamlDrawable.t
  val t_drawable : Drawable.t
  method destroy : unit
  method virtual draw : render_target -> render_states -> unit
  method rep__CamlDrawable : CamlDrawable.t
  method rep__sf_Drawable : Drawable.t
  method set_callback : draw_func_type -> unit
end
