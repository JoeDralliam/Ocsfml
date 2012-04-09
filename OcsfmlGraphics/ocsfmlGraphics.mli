(** *)

(** Utility class for manipulating 2D axis aligned rectangles.
    
    A rectangle is defined by its top-left corner and its size.
    
    It is a very simple class defined for convenience, so its member variables (left, top, width and height) are public and can be accessed directly.

    To keep things simple, rect doesn't define functions to emulate the properties that are not directly members (such as right, bottom, center, etc.), it rather only provides intersection functions.
    
    rect uses the usual rules for its boundaries:

    The left and top edges are included in the rectangle's area
    The right (left + width) and bottom (top + height) edges are excluded from the rectangle's area
    
    This means that \{ left = 0; top = 0 ; width = 1; height = 1 \} and \{ left = 0; top = 0 ; width = 1; height = 1 \} don't intersect. *)
type 'a rect = { left : 'a; top : 'a; width : 'a; height : 'a; }

(**/**)
module type RECT_VAL =
sig type t val add : t -> t -> t val sub : t -> t -> t end
(**/**)

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

  val destroy : t -> unit
  val default : unit -> t
  val create_from_color : t -> ?color:Color.t -> int -> int -> unit
  val load_from_file : t -> string -> bool
  val load_from_stream : t -> OcsfmlSystem.input_stream -> bool
  val save_to_file : t -> string -> bool
  val get_size : t -> int * int
  val get_pixels_ptr : t -> pixel_array_type
  val create_mask_from_color : t -> ?alpha:int -> Color.t -> unit
  val copy :
    t -> ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit
  val set_pixel : t -> int -> int -> Color.t -> unit
  val get_pixel : t -> int -> int -> Color.t
  val flip_horizontally : t -> unit
  val flip_vertically : t -> unit
end
  
(** Class for loading, manipulating and saving images.
    
    image is an abstraction to manipulate images as bidimensional arrays of pixels.
    
    The class provides functions to load, read, write and save pixels, as well as many other useful functions.
    
    image can handle a unique internal representation of pixels, which is RGBA 32 bits. This means that a pixel must be composed of 8 bits red, green, blue and alpha channels -- just like an color. All the functions that return an array of pixels follow this rule, and all parameters that you pass to image functions (such as loadFromPixels) must use this representation as well.
    
    A image can be copied, but it is a heavy resource and if possible you should always use [const] references to pass or return them to avoid useless copies. *)
class image : 
object ('a)
  (**/**)
  val t_imageCpp : Image.t
  (**/**)

  (** Copy pixels from another image onto this one.
      
      This function does a slow pixel copy and should not be used intensively. It can be used to prepare a complex static image from several others, but if you need this kind of feature in real-time you'd better use render_texture.
      @param srcRect Sub-rectangle of the source image to copy.
      @param alpha Should the copy take in account the source transparency ? *)
  method copy : ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit


  (** Create the image and fill it with a unique color. 
      @param color Fill color.*)
  method create_from_color : ?color:Color.t -> int -> int -> unit

  (** Create a transparency mask from a specified color-key.
      
      This function sets the alpha value of every pixel matching the given color to alpha (0 by default), so that they become transparent.
      @param alpha Alpha value to assign to transparent pixels. *)
  method create_mask_from_color : ?alpha:int -> Color.t -> unit

  (***)
  method destroy : unit

  (** Flip the image horizontally (left <-> right).*)
  method flip_horizontally : unit

  (** Flip the image vertically (top <-> bottom).*)
  method flip_vertically : unit

  (** Return the size of the image. 
      @return Size in pixels. *)
  method get_size : int * int

  (** Get the color of a pixel.
      
      This function doesn't check the validity of the pixel coordinates, using out-of-range values will result in an undefined behaviour. 
      @return Color of the pixel at coordinates (x, y). *)
  method get_pixel : int -> int -> Color.t
    
  (** Get a read-only bigarray of pixels.
      
      The returned value is an array of RGBA pixels made of 8 bits integers components. The size of the array is GetWidth() * GetHeight() * 4. Warning: the returned pointer may become invalid if you modify the image, so you should never store it for too long. If the image is empty, a null pointer is returned. 
      @return Read-only bigarray of pixels *)
  method get_pixels_ptr : pixel_array_type

  (**Load the image from a file on disk.
     
     The supported image formats are bmp, png, tga, jpg, gif, psd, hdr and pic. Some format options are not supported, like progressive jpeg. If this function fails, the image is left unchanged.
     @return True if loading was successful. *)
  method load_from_file : string -> bool

  (** Load the image from a custom stream.
      
      The supported image formats are bmp, png, tga, jpg, gif, psd, hdr and pic. Some format options are not supported, like progressive jpeg. If this function fails, the image is left unchanged.
      @return True if loading was successful. *)
  method load_from_stream : OcsfmlSystem.input_stream -> bool

  (**/**)
  method rep__sf_Image : Image.t
  (**/**)

  (** Save the image to a file on disk.

      The format of the image is automatically deduced from the extension. The supported image formats are bmp, png, tga and jpg. The destination file is overwritten if it already exists. This function fails if the image is empty.
      @return True if saving was successful. *)
  method save_to_file : string -> bool

  (** Change the color of a pixel.

      This function doesn't check the validity of the pixel coordinates, using out-of-range values will result in an undefined behaviour. *)
  method set_pixel : int -> int -> Color.t -> unit
end


val mk_image :
  [< `Color of Color.t * int * int
  | `Create of int * int
  | `File of string
  | `Stream of OcsfmlSystem.input_stream ] ->
  image


(** Get the maximum texture size allowed.

    This maximum size is defined by the graphics driver. You can expect a value of 512 pixels for low-end graphics card, and up to 8192 pixels or more for newer hardware. 
    @return Maximum size allowed for textures, in pixels. *)
val get_maximum_size : unit -> int


module Texture :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val create : t -> int -> int -> unit
  val load_from_file : t -> ?rect:int rect -> string -> bool
  val load_from_stream : t -> ?rect:int rect -> OcsfmlSystem.input_stream -> bool
  val load_from_image : t -> ?rect:int rect -> image -> bool
  val get_size : t -> int * int
  val copy_to_image : t -> image
  val update_from_image : t -> ?coords:int * int -> image -> unit
  val update_from_window : t -> ?coords:int * int -> #OcsfmlWindow.window -> unit
  val bind : t -> unit
  val set_smooth : t -> bool -> unit
  val is_smooth : t -> bool -> unit
  val set_repeated : t -> bool -> unit
  val is_repeated : t -> bool
end
  
(** Image living on the graphics card that can be used for drawing.
    
    texture stores pixels that can be drawn, with a sprite for example.
    
    A texture lives in the graphics card memory, therefore it is very fast to draw a texture to a render target, or copy a render target to a texture (the graphics card can access both directly).
    
    Being stored in the graphics card memory has some drawbacks. A texture cannot be manipulated as freely as a image, you need to prepare the pixels first and then upload them to the texture in a single operation (see texture#update ).
    
    texture makes it easy to convert from/to image, but keep in mind that these calls require transfers between the graphics card and the central memory, therefore they are slow operations.

    A texture can be loaded from an image, but also directly from a file/memory/stream. The necessary shortcuts are defined so that you don't need an image first for the most common cases. However, if you want to perform some modifications on the pixels before creating the final texture, you can load your file to a image, do whatever you need with the pixels, and then call texture#load_from_image.
    
    Since they live in the graphics card memory, the pixels of a texture cannot be accessed without a slow copy first. And they cannot be accessed individually. Therefore, if you need to read the texture's pixels (like for pixel-perfect collisions), it is recommended to store the collision information separately, for example in an array of booleans.
    
    Like image, texture can handle a unique internal representation of pixels, which is RGBA 32 bits. This means that a pixel must be composed of 8 bits red, green, blue and alpha channels -- just like a color.*)
class texture :
object
  (**/**)
  val t_textureCpp : Texture.t
  (**/**)
  
  (* TODO: add Coordinate type *)
  (** Activate the texture for rendering.
      
      This function is mainly used internally by the SFML rendering system. However it can be useful when using sf::Texture together with OpenGL code (this function is equivalent to glBindTexture).
      
      The coordinateType argument controls how texture coordinates will be interpreted. If Normalized (the default), they must be in range [0 .. 1], which is the default way of handling texture coordinates with OpenGL. If Pixels, they must be given in pixels (range [0 .. size]). This mode is used internally by the graphics classes of SFML, it makes the definition of texture coordinates more intuitive for the high-level API, users don't need to compute normalized values. *)
  method bind : unit
  
  (** Copy the texture pixels to an image.

      This function performs a slow operation that downloads the texture's pixels from the graphics card and copies them to a new image, potentially applying transformations to pixels if necessary (texture may be padded or flipped).*)
  method copy_to_image : image
  
  (** Create the texture.

      If this function fails, the texture is left unchanged.*)
  method create : int -> int -> unit
  

  method destroy : unit
  
  (** Return the size of the texture. 
      @return Size in pixels.*)
  method get_size : int * int
  
  (** Tell whether the texture is repeated or not. 
      @return True if repeat mode is enabled, false if it is disabled. *)
  method is_repeated : bool
  
  (** Tell whether the smooth filter is enabled or not. 
      @return True if smoothing is enabled, false if it is disabled. *)
  method is_smooth : bool -> unit

  (** Load the texture from a file on disk. 

      The rect argument can be used to load only a sub-rectangle of the whole image. If you want the entire image then leave the default value. If the area rectangle crosses the bounds of the image, it is adjusted to fit the image size.
      
      The maximum size for a texture depends on the graphics driver and can be retrieved with the getMaximumSize function.
      
      If this function fails, the texture is left unchanged.
      @param rect Area of the image to load.
      @return True if loading was successful. *)
  method load_from_file : ?rect:int rect -> string -> bool
    
  (** Load the texture from an image.
      
      The rect argument can be used to load only a sub-rectangle of the whole image. If you want the entire image then leave the default value. If the area rectangle crosses the bounds of the image, it is adjusted to fit the image size.
      
      The maximum size for a texture depends on the graphics driver and can be retrieved with the get_maximum_size function.
      
      If this function fails, the texture is left unchanged.
      @param rect Area of the image to load.
      @return True if loading was successful. *)
  method load_from_image : ?rect:int rect -> image -> bool

(** Load the texture from a custom stream.
    
    The rect argument can be used to load only a sub-rectangle of the whole image. If you want the entire image then leave the default value. If the area rectangle crosses the bounds of the image, it is adjusted to fit the image size.
    
    The maximum size for a texture depends on the graphics driver and can be retrieved with the get_maximum_size function.
    
    If this function fails, the texture is left unchanged. 
    @param rect Area of the image to load.
    @return True if loading was successful. *)
  method load_from_stream : ?rect:int rect -> OcsfmlSystem.input_stream -> bool

  (**/**)
  method rep__sf_Texture : Texture.t
  (**/**)

  (** Enable or disable repeating.

    Repeating is involved when using texture coordinates outside the texture rectangle [0, 0, width, height]. In this case, if repeat mode is enabled, the whole texture will be repeated as many times as needed to reach the coordinate (for example, if the X texture coordinate is 3 * width, the texture will be repeated 3 times). If repeat mode is disabled, the "extra space" will instead be filled with border pixels. Warning: on very old graphics cards, white pixels may appear when the texture is repeated. With such cards, repeat mode can be used reliably only if the texture has power-of-two dimensions (such as 256x128). Repeating is disabled by default. *)
  method set_repeated : bool -> unit


  (** Enable or disable the smooth filter.
      
      When the filter is activated, the texture appears smoother so that pixels are less noticeable. However if you want the texture to look exactly the same as its source file, you should leave it disabled. The smooth filter is disabled by default. *)
  method set_smooth : bool -> unit
    
  (** Update the texture from an image.
      
      Although the source image can be smaller than the texture, this function is usually used for updating the whole texture. The other overload, which has (x, y) additional arguments, is more convenient for updating a sub-area of the texture.
      
      No additional check is performed on the size of the image, passing an image bigger than the texture will lead to an undefined behaviour.
      
      This function does nothing if the texture was not previously created.
      @param coords Offset in the texture where to copy the source image. *)
  method update_from_image : ?coords:int * int -> image -> unit
    
  (**  Update the texture from the contents of a window.
       
       Although the source window can be smaller than the texture, this function is usually used for updating the whole texture. The other overload, which has (x, y) additional arguments, is more convenient for updating a sub-area of the texture.
       
       No additional check is performed on the size of the window, passing a window bigger than the texture will lead to an undefined behaviour.
       
       This function does nothing if either the texture or the window was not previously created. 
       @param coords Offset in the texture where to copy the source window. *)
  method update_from_window : ?coords:int * int -> #OcsfmlWindow.window -> unit
end
  
val mk_texture :
  [< `File of string
  | `Image of int rect * image
  | `Stream of OcsfmlSystem.input_stream ] ->
  texture
    
(** Structure describing a glyph.
    
    A glyph is the visual representation of a character.
    
    The sf::Glyph structure provides the information needed to handle the glyph:
    
    - its coordinates in the font's texture
    - its bounding rectangle
    - the offset to apply to get the starting position of the next glyph *)
type glyph = { 
  advance : int; (** Offset to move horizontically to the next character. *)
  bounds : int rect; (** Bounding rectangle of the glyph, in coordinates relative to the baseline. *)
  texture_rect : int rect; (** Texture coordinates of the glyph inside the font's texture. *)
}


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

(** Class for loading and manipulating character fonts.
    
    Fonts can be loaded from a file, from memory or from a custom stream, and supports the most common types of fonts.
    
    See the load_from_file function for the complete list of supported formats.

    Once it is loaded, a font instance provides three types of informations about the font:
    
    - Global metrics, such as the line spacing
    - Per-glyph metrics, such as bounding box or kerning
    - Pixel representation of glyphs
    
    Fonts alone are not very useful: they hold the font data but cannot make anything useful of it. To do so you need to use the text class, which is able to properly output text with several options such as character size, style, color, position, rotation, etc. This separation allows more flexibility and better performances: indeed a font is a heavy resource, and any operation on it is slow (often too slow for real-time applications). On the other side, a text is a lightweight object which can combine the glyphs data and metrics of a font to display any text on a render target. Note that it is also possible to bind several text instances to the same font.
    
    It is important to note that the text instance doesn't copy the font that it uses, it only keeps a reference to it. Thus, a font must not be destructed while it is used by a text (i.e. never write a function that uses a local font instance for creating a text).*)
class font :
object
  (**/**)
  val t_fontCpp : Font.t
  (**/**)

  (**)
  method destroy : unit

  (** Retrieve a glyph of the font. 
      @return The glyph corresponding to codePoint and characterSize.*)
  method get_glyph : int -> int -> bool -> glyph

  (** Get the kerning offset of two glyphs.

      The kerning is an extra offset (negative) to apply between two glyphs when rendering them, to make the pair look more "natural". For example, the pair "AV" have a special kerning to make them closer than other characters. Most of the glyphs pairs have a kerning offset of zero, though.
      @return Kerning value for first and second, in pixels. *)
  method get_kerning : int -> int -> int -> int
    
  (** Get the line spacing.

      Line spacing is the vertical offset to apply between two consecutive lines of text.
      @return Line spacing, in pixels *)
  method get_line_spacing : int -> int
 
  (** Retrieve the texture containing the loaded glyphs of a certain size.

      The contents of the returned texture changes as more glyphs are requested, thus it is not very relevant. It is mainly used internally by text.
      @return Texture containing the glyphs of the requested size. *)
  method get_texture : int -> texture

  (** Load the font from a file.

      The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42. Note that this function know nothing about the standard fonts installed on the user's system, thus you can't load them directly.
      @return True if loading succeeded, false if it failed. *)
  method load_from_file : string -> bool

  (** Load the font from a custom stream.

      The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42. Warning: SFML cannot preload all the font data in this function, so the contents of stream have to remain valid as long as the font is used.
      @return True if loading succeeded, false if it failed. *)
  method load_from_stream : #OcsfmlSystem.input_stream -> bool
    
  (**/**)
  method rep__sf_Font : Font.t
(**/**)
    
end
  
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

(**)
val shader_is_available : unit -> unit

(** Shader class (vertex and fragment)

    Shaders are programs written using a specific language, executed directly by the graphics card and allowing to apply real-time operations to the rendered entities.

    There are two kinds of shaders:

    Vertex shaders, that process vertices
    Fragment (pixel) shaders, that process pixels

    A OcsfmlGraphics.shader can be composed of either a vertex shader alone, a fragment shader alone, or both combined (see the variants of the Load functions).

    Shaders are written in GLSL, which is a C-like language dedicated to OpenGL shaders. You'll probably need to learn its basics before writing your own shaders for SFML.

    Like any Caml program, a shader has its own variables that you can set from your Caml application. OcsfmlGraphics.shader handles 4 different types of variables:

    - floats
    - vectors (2, 3 or 4 components)
    - textures
    - transforms (matrices)

    The value of the variables can be changed at any time with either the various overloads of the set_* function:
    {[
    shader#set_parameter1 "offset" 2.0 ;
    shader#set_parameter3 "color" 0.5 0.8 0.3 ;
    shader#set_transform "matrix" transform ; (* transform is a OcsfmlGraphics.transform *)
    shader#set_texture "overlay" texture ; (* texture is a OcsfmlGraphics.texture *)
    shader#set_current_texture "texture" 
    ]}
    The special Shader::CurrentTexture argument maps the given texture variable to the current texture of the object being drawn (which cannot be known in advance).

    To apply a shader to a drawable, you must pass it as an additional parameter to the Draw function:
    {[ 
    window#draw ~render_states:(mk_render_states ~shader:shader ()) sprite 
    ]}
    Shaders can be used on any drawable, but some combinations are not interesting. For example, using a vertex shader on a OcsfmlGraphics.sprite is limited because there are only 4 vertices, the sprite would have to be subdivided in order to apply wave effects. Another bad example is a fragment shader with OcsfmlGraphics.text: the texture of the text is not the actual text that you see on screen, it is a big texture containing all the characters of the font in an arbitrary order; thus, texture lookups on pixels other than the current one may not give you the expected result.
    
    Shaders can also be used to apply global post-effects to the current contents of the target. This can be done in two different ways:
    
    - draw everything to a OcsfmlGraphics.render_texture, then draw it to the main target using the shader
    - draw everything directly to the main target, then use OcsfmlGraphics.texture#update_from_window to copy its contents to a texture and draw it to the main target using the shader
    
    The first technique is more optimized because it doesn't involve retrieving the target's pixels to system memory, but the second one doesn't impact the rendering process and can be easily inserted anywhere without impacting all the code.

    Like OcsfmlGraphics.texture that can be used as a raw OpenGL texture, OcsfmlGraphics.shader can also be used directly as a raw shader for custom OpenGL geometry.
    {[  
    window#set_active () ;
    shader#bind ;
    (* ... render OpenGL geometry ... *)
    shader#unbind 
    ]} *)
class shader :
object
  (**/**)
  val t_shaderCpp : Shader.t
  (**/**)

  (** Bind the shader for rendering (activate it)

      This function is normally for internal use only, unless you want to use the shader with a custom OpenGL rendering instead of a SFML drawable.  
      {[
      window#set_active () ;
      shader#bind ;
  (* ... render OpenGL geometry ... *)
      shader#unbind 
      ]} *)
  method bind : unit
  method destroy : unit

  (** Load the vertex and/or the fragment shader from files. 
      Warning: At least one of the shaders must be loaded.
      @param vertex Path of the vertex shader file to load.
      @param fragment Path of the fragment shader file to load. 
      @return True if loading succeeded, false if it failed. *)
  method load_from_file :
    ?vertex:string -> ?fragment:string -> unit -> bool

  (** Load the vertex and/or the fragment shader from custom streams. 
      Warning: At least one of the shaders must be loaded.
      @param vertex Source stream to read the vertex shader from.
      @param fragment Source stream to read the fragment shader from.
      @return True if loading succeeded, false if it failed. *)
  method load_from_stream :
    ?vertex:(#OcsfmlSystem.input_stream as 'a) ->
      ?fragment:'a -> unit -> bool

  (**/**)
  method rep__sf_Shader : Shader.t
  (**/**)

  (** Change a color parameter of the shader.

      The string argument is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x1 vector (vec4 GLSL type).
      
      It is important to note that the components of the color are normalized before being passed to the shader. Therefore, they are converted from range [0 .. 255] to range [0 .. 1]. For example, a OcsfmlGraphics.Color.\{r = 255; g = 125; b = 0; a = 255\} will be transformed to a vec4(1.0, 0.5, 0.0, 1.0) in the shader.
      
      Example:
      {[uniform vec4 color; // this is the variable in the shader]}1
      {[shader#set_color "color" OcsfmlGraphics.Color.{ r = 255; g = 128; b = 0; a = 255}]} *)
  method set_color : string -> Color.t -> unit


  (** Change a texture parameter of the shader.

      This overload maps a shader texture variable to the texture of the object being drawn, which cannot be known in advance. The second argument must be sf::Shader::CurrentTexture. The corresponding parameter in the shader must be a 2D texture (sampler2D GLSL type).
      
      Example: 
      {[uniform sampler2D current; // this is the variable in the shader]}
      {[shader#set_current_texture "current"]} *)
  method set_current_texture : string -> unit
    
  method set_parameter : string -> ?x:float -> ?y:float -> ?z:float -> float -> unit
    
  (** Change a float parameter of the shader.
      
      name is the name of the variable to change in the shader. The corresponding parameter in the shader must be a float (float GLSL type).
      
      Example:
      {[uniform float myparam; // this is the variable in the shader]}
      {[shader#set_parameter1 "myparam" 5.2]} *)
  method set_parameter1 : string -> float -> unit
  
  (** Change a 2-components vector parameter of the shader.
      
      The string argument is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 2x1 vector (vec2 GLSL type).
      
      Example:
      {[uniform vec2 myparam; // this is the variable in the shader]}
      {[shader#set_parameter2 "myparam" 5.2 6.0]} *)
  method set_parameter2 : string -> float -> float -> unit
    
  (** Change a 2-components vector parameter of the shader.
      
      The string argument is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 2x1 vector (vec2 GLSL type).

      Example:
      {[uniform vec2 myparam; // this is the variable in the shader]}
      {[shader#set_parameter2v "myparam" (5.2, 6.0)]} *)
  method set_parameter2v : string -> float * float -> unit

  (** Change a 3-components vector parameter of the shader.
      
      The string argument is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 3x1 vector (vec3 GLSL type).
      
      Example: 
      {[uniform vec3 myparam; // this is the variable in the shader]}
      {[shader#set_parameter3 "myparam" 5.2 6.0 -8.1]} *)
  method set_parameter3 : string -> float -> float -> float -> unit

      
  (** Change a 3-components vector parameter of the shader.
      
      The string argument is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 3x1 vector (vec3 GLSL type).
      
      Example:      
      {[uniform vec3 myparam; // this is the variable in the shader]}      
      {[shader#set_parameter3v "myparam" (5.2, 6.0, -8.1)]} *)
  method set_parameter3v : string -> float * float * float -> unit

  (** Change a 4-components vector parameter of the shader.
      
      name is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x1 vector (vec4 GLSL type).
      
      Example:
      {[uniform vec4 myparam; // this is the variable in the shader]}
      {[shader#set_parameter3 "myparam" 5.2 6.0 -8.1 0.4]} *)
  method set_parameter4 : string -> float -> float -> float -> float -> unit

  (** Change a texture parameter of the shader.
      
      The string argument is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 2D texture (sampler2D GLSL type).

      Example: 
      {[uniform sampler2D the_texture; // this is the variable in the shader]}
      {[let texture = new texture in
      ...
      shader#set_texture "the_texture" texture ]} 

      It is important to note that texture must remain alive as long as the shader uses it, no copy is made internally.

      To use the texture of the object being draw, which cannot be known in advance, you can use set_current_texture:
      {[shader#set_current_texture "the_texture"]} *)
  method set_texture : string -> texture -> unit
    
  (** Change a matrix parameter of the shader.
    
      The string argument is the name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x4 matrix (mat4 GLSL type).
      
      Example:
      {[uniform mat4 matrix; // this is the variable in the shader]}
      {[let transform = new transform in
      transform#translate 5 10 ;
      shader#set_transform "matrix" transform]} *)
  method set_transform : string -> transform -> unit
    
  (** Unbind the shader (deactivate it)
      
      This function is normally for internal use only, unless you want to use the shader with a custom OpenGL rendering instead of a SFML drawable. *)
  method unbind : unit
end


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

(** 2D camera that defines what region is shown on screen.

    {!OcsfmlGraphics.view} defines a camera in the 2D scene.

    This is a very powerful concept: you can scroll, rotate or zoom the entire scene without altering the way that your drawable objects are drawn.
    
    A view is composed of a source rectangle, which defines what part of the 2D scene is shown, and a target viewport, which defines where the contents of the source rectangle will be displayed on the render target (window or texture).
    
    The viewport allows to map the scene to a custom part of the render target, and can be used for split-screen or for displaying a minimap, for example. If the source rectangle has not the same size as the viewport, its contents will be stretched to fit in.
    
    To apply a view, you have to assign it to the render target. Then, every objects drawn in this render target will be affected by the view until you use another view.

    Usage example:
    {[
    let window = new render_window (* ... *) in
    let view = new view () in
    
(* Initialize the view to a rectangle located at (100, 100) and with a size of 400x200 *)
    view#reset { left = 100.; top = 100.; width = 400.; height = 200. } ;
    
(* Rotate it by 45 degrees *)
    view#rotate 45. ;
    
(* Set its target viewport to be half of the window *)
    view#set_viewport { left = 0.; top = 0.; width = 0.5; height =  1. } ;
    
(* Apply it *)
    window#set_view view ;
    
(* Render stuff *)
    window#draw someSprite ;
    
(* Set the default view back *)
    window#set_view window#get_default_view ;
    
(* Render stuff not affected by the view *)
    window#draw someText 
    ]} *)
class view : 
  ?rect:float rect -> 
    ?center:'a -> ?size:'b -> 
      unit ->
object
  (**/**)
  val t_viewCpp : View.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the center of the view. 
      @return Center of the view. *)
  method get_center : float * float


  (* TODO: get_inverse_transform *)

  (** Get the current orientation of the view. 
      @return Rotation angle of the view, in degrees.*)
  method get_rotation : float

  (** Get the size of the view. 
      @return Size of the view. *)
  method get_size : float * float

  (* TODO : get_transform *)

  (** Get the target viewport rectangle of the view. 
      @return Viewport rectangle, expressed as a factor of the target size. *)
  method get_viewport : float rect

  (** Move the view relatively to its current position. *)
  method move : float -> float -> unit

  (** Move the view relatively to its current position. *)
  method move_v : float * float -> unit

  (**/**)
  method rep__sf_View : View.t
  (**/**)

  (** Reset the view to the given rectangle.

      Note that this function resets the rotation angle to 0.*)
  method reset : float rect -> unit

  (** Rotate the view relatively to its current orientation. *)
  method rotate : float -> unit

  (** Set the center of the view. *)
  method set_center : float -> float -> unit

  (** Set the center of the view. *)
  method set_center_v : float * float -> unit

  (** Set the orientation of the view.

      The default rotation of a view is 0 degree. *)
  method set_rotation : float -> unit

  (** Set the size of the view. *)
  method set_size : float -> float -> unit

  (** Set the size of the view. *)
  method set_size_v : float * float -> unit

  (** Set the target viewport.
      
      The viewport is the rectangle into which the contents of the view are displayed, expressed as a factor (between 0 and 1) of the size of the {!OcsfmlGraphics.render_target} to which the view is applied. For example, a view which takes the left side of the target would be defined with View.setViewport(sf::FloatRect(0, 0, 0.5, 1)). By default, a view has a viewport which covers the entire target. *)
  method set_viewport : float rect -> unit
    
  (** Resize the view rectangle relatively to its current size.
      
      Resizing the view simulates a zoom, as the zone displayed on screen grows or shrinks. factor is a multiplier:
      
      -   1 keeps the size unchanged
      - > 1 makes the view bigger (objects appear smaller)
      - < 1 makes the view smaller (objects appear bigger)
  *)
  method zoom : float -> unit
end

(** Define the states used for drawing to a RenderTarget.
    
    There are four global states that can be applied to the drawn objects:
    
    - the blend mode: how pixels of the object are blended with the background
    - the transform: how the object is positioned/rotated/scaled
    - the texture: what image is mapped to the object
    - the shader: what custom effect is applied to the object
    
    High-level objects such as sprites or text force some of these states when they are drawn. For example, a sprite will set its own texture, so that you don't have to care about it when drawing the sprite.
    
    The transform is a special case: sprites, texts and shapes (and it's a good idea to do it with your own drawable classes too) combine their transform with the one that is passed in the RenderStates structure. So that you can use a "global" transform on top of each object's transform. *)
type render_states = {
  mutable blend_mode : blend_mode; (** Blending mode. *)
  mutable transform : transform; (** Transform *)
  mutable texture : texture; (** Texture. *)
  mutable shader : shader; (** Shader. *)
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
  val get_viewport : t -> view -> int rect
  val convert_coords : t -> ?view:view -> int * int -> float * float
  val push_gl_states : t -> unit
  val pop_gl_states : t -> unit
  val reset_gl_states : t -> unit
end

(** Base class for all render targets (window, texture, ...)
    
    OcsfmlGraphics.render_target defines the common behaviour of all the 2D render targets usable in the graphics module.
    
    It makes it possible to draw 2D entities like sprites, shapes, text without using any OpenGL command directly.
    
    A OcsfmlGraphics.render_target is also able to use views (OcsfmlGraphics.view), which are a kind of 2D cameras. With views you can globally scroll, rotate or zoom everything that is drawn, without having to transform every single entity. See the documentation of OcsfmlGraphics.view for more details and sample pieces of code about this class.

    On top of that, render targets are still able to render direct OpenGL stuff. It is even possible to mix together OpenGL calls and regular SFML drawing commands. When doing so, make sure that OpenGL states are not messed up by calling the push_gl_states/pop_gl_states methods. *)
class render_target :
  RenderTarget.t ->
object
  (**/**)
  val t_render_target : RenderTarget.t
  (**/**)

  (** Clear the entire target with a single color.

      This function is usually called once every frame, to clear the previous contents of the target. *)
  method clear : ?color:Color.t -> unit -> unit

  (** Convert a point from target coordinates to view coordinates.
      
      Initially, a unit of the 2D world matches a pixel of the render target. But if you define a custom view, this assertion is not true anymore, ie. a point located at (10, 50) in your render target (for example a window) may map to the point (150, 75) in your 2D world -- for example if the view is translated by (140, 25).

      For render windows, this function is typically used to find which point (or object) is located below the mouse cursor.

      @param view The view to use for converting the point (default is the current view of the render_target) 
      @return The converted point, in "world" units *)
  method convert_coords : ?view:view -> int * int -> float * float

  (**)
  method destroy : unit

  (** Draw a drawable object to the render-target. 
      @param render_states Render states to use for drawing. *)
  method draw : ?render_states:render_states -> #drawable -> unit

  (** Get the default view of the render target.

      The default view has the initial size of the render target, and never changes after the target has been created.
      @return The default view of the render target. *)
  method get_default_view : view

  (** Return the size of the rendering region of the target. 
      @return Size in pixels. *)
  method get_size : int * int

  (** Get the view currently in use in the render target. 
      @return The view object that is currently used. *)
  method get_view : view

  (** Get the viewport of a view, applied to this render target.

      The viewport is defined in the view as a ratio, this function simply applies this ratio to the current dimensions of the render target to calculate the pixels rectangle that the viewport actually covers in the target.
      @return Viewport rectangle, expressed in pixels  *)
  method get_viewport : view -> int rect

  (** Restore the previously saved OpenGL render states and matrices.

      See the description of pushGLStates to get a detailed description of these functions. *)
  method pop_gl_states : unit

  (** Save the current OpenGL render states and matrices.
    
      This function can be used when you mix SFML drawing and direct OpenGL rendering. Combined with pop_gl_states, it ensures that:
    
      - SFML's internal states are not messed up by your OpenGL code
      - your OpenGL states are not modified by a call to a SFML function
      
      More specifically, it must be used around code that calls Draw functions. Example:
      {[
  (* OpenGL code here... *)
      window#push_gl_states;
      window#draw (* ... *);
      window#draw (* ... *);
      window#pop_gl_states
  (* OpenGL code here... *)
      ]}
      Note that this function is quite expensive: it saves all the possible OpenGL states and matrices, even the ones you don't care about. Therefore it should be used wisely. It is provided for convenience, but the best results will be achieved if you handle OpenGL states yourself (because you know which states have really changed, and need to be saved and restored). Take a look at the ResetGLStates function if you do so. *)
  method push_gl_states : unit
  
  (**/**)
  method rep__sf_RenderTarget : RenderTarget.t
  (**/**)
    
  (** Reset the internal OpenGL states so that the target is ready for drawing.
      
      This function can be used when you mix SFML drawing and direct OpenGL rendering, if you choose not to use pushGLStates/popGLStates. It makes sure that all OpenGL states needed by SFML are set, so that subsequent draw calls will work as expected.
      
      Example:
      {[
      (* OpenGL code here... *)
      glPushAttrib (* ... *) ;
      window#reset_gl_states ;
      window#draw (* ... *) ;
      window#draw (* ... *) ;
      glPopAttrib (* ... *) ;
      // OpenGL code here...
      ]} *) 
  method reset_gl_states : unit

  (** Change the current active view.
      
      The view is like a 2D camera, it controls which part of the 2D scene is visible, and how it is viewed in the render-target. The new view will affect everything that is drawn, until another view is set. The render target keeps its own copy of the view object, so it is not necessary to keep the original one alive after calling this function. To restore the original view of the target, you can pass the result of get_default_view to this function.*)
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

(** Target for off-screen 2D rendering into an texture.

    OcsfmlGraphics.render_texture is the little brother of OcsfmlGraphics.render_window.
    
    It implements the same 2D drawing and OpenGL-related functions (see their base class OcsfmlGraphics.render_target for more details), the difference is that the result is stored in an off-screen texture rather than being show in a window.
    
    Rendering to a texture can be useful in a variety of situations:
    
    - precomputing a complex static texture (like a level's background from multiple tiles)
    - applying post-effects to the whole scene with shaders
    - creating a sprite from a 3D object rendered with OpenGL
    - etc.

    Usage example:
    {[
(* Create a new render-window *)
    let window = new render_window (OcsfmlWindow.VideoMode.create ~w:800 ~h:600 ()) "SFML window" in
    
(* Create a new render-texture *)
    let texture = new OcsfmlGraphics.render_texture in
    if not (texture#create 500 500)
    then   failwith "Could not create the render texture"
    
    let main_loop () =
      (* Event processing *)
      (* ... *)

      (* Clear the whole texture with red color *)
        texture#clear ~color:OcsfmlGraphics.Color.red ();
    
      (* Draw stuff to the texture *)
        texture#draw sprite ;  (* sprite is an Ocsfml.sprite *)
        texture#draw shape ;   (* shape is an Ocsfml.shape *)
        texture#draw text ;    (* text is an Ocsfml.text *)
    
      (* We're done drawing to the texture *)
        texture#display ;

      (* Now we start rendering to the window, clear it first *)
        window#clear ()
    
      (* Draw the texture *)
        let sprite = mk_sprite ~texture:(texture#get_texture) () in
        window#draw sprite ;
    
      (* End the current frame and display its contents on screen *)
        window#display ;
    
        if window#is_open 
        then main_loop ()
    in

    main_loop ()
    ]}*)
class render_texture :
object
  inherit render_target
  (**/**)
  val t_render_textureCpp : RenderTexture.t
  (**/**)

  (** Create the render-texture.

      Before calling this function, the render-texture is in an invalid state, thus it is mandatory to call it before doing anything with the render-texture. The optional parameter, depthBfr, is useful if you want to use the render-texture for 3D OpenGL rendering that requires a depth-buffer. Otherwise it is unnecessary, and you should leave this parameter to false (which is its default value).
      @param dephtBfr Do you want this render-texture to have a depth buffer?
      @return True if creation has been successful. *)
  method create : ?dephtBfr:bool -> int -> int -> bool

  (**)
  method destroy : unit

  (** Update the contents of the target texture.

      This function updates the target texture with what has been drawn so far. Like for windows, calling this function is mandatory at the end of rendering. Not calling it may leave the texture in an undefined state. *)
  method display : unit

  (** Get a read-only reference to the target texture.

      After drawing to the render-texture and calling display, you can retrieve the updated texture using this function, and draw it using a sprite (for example). The internal texture of a render-texture is always the same instance, so that it is possible to call this function once and keep a reference to the texture even after it is modified. 
      @return Const reference to the texture. *)
  method get_texture : texture

  (** Tell whether the smooth filtering is enabled or not. 
      @return True if texture smoothing is enabled. *)
  method is_smooth : bool

  (**/**)
  method rep__sf_RenderTexture : RenderTexture.t
  (**/**)

  (** Activate of deactivate the render-texture for rendering.

      This function makes the render-texture's context current for future OpenGL rendering operations (so you shouldn't care about it if you're not doing direct OpenGL stuff). Only one context can be current in a thread, so if you want to draw OpenGL geometry to another render target (like a render_window) don't forget to activate it again. 
      @return True if operation was successful, false otherwise. *)
  method set_active : ?active:bool -> unit -> bool

  (** Enable or disable texture smoothing.

      This function is similar to Ocsfml.texture.set_smooth. This parameter is disabled by default.*)
  method set_smooth : bool -> unit
end

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

(** Window that can serve as a target for 2D drawing.
    
    OcsfmlGraphics.render_window is the main class of the Graphics module.
    
    It defines an OS window that can be painted using the other classes of the graphics module.
    
    OcsfmlGraphics.render_window is derived from OcsfmlWindow.window, thus it inherits all its features: events, window management, OpenGL rendering, etc. See the documentation of OcsfmlWindow.window for a more complete description of all these features, as well as code examples.

    On top of that, OcsfmlWindow.render_window adds more features related to 2D drawing with the graphics module (see its base class OcsfmlGraphics.render_target for more details). Here is a typical rendering and event loop with a OcsfmlWindow.render_window:
    {[
    (* Declare and create a new render-window *)
    let window = new window (OcsfmlGraphics.VideoMode.create ~w:800 ~h:600) "SFML window" in
    
    (* Limit the framerate to 60 frames per second (this step is optional) *)
    window#set_framerate_limit 60 

    (* Event processing *)
    let rec process_events () =
        match window#poll_event with
          | Some e -> 
            begin 
              match e with
                | OcsfmlWindow.Event.Closed -> window#close
                | _ -> () ;
              process_events ()
            end
          | _ -> ()
    in

    (* The main loop - ends as soon as the window is closed *)
    let rec main_loop () =
       process_events () ;
       
       (* Clear the whole window before rendering a new frame *)
       window#clear () ;

       (* Draw some graphical entities *)
       window#draw sprite ;
       window#draw circle ;
       window#draw text ;

       (* End the current frame and display its contents on screen *)
        window.display();

        if window#is_open
        then main_loop () 
    in
    main_loop ()
    ]} *)
class render_window :
  ?style:OcsfmlWindow.Window.style list ->
    ?context:OcsfmlWindow.context_settings ->
      OcsfmlWindow.VideoMode.t -> string -> 
object
  inherit OcsfmlWindow.window
  inherit render_target

  (**/**)
  val t_render_windowCpp : RenderWindow.t
  (**/**)

  (**)
  method destroy : unit
    
  (** Copy the current contents of the window to an image.
      
      This is a slow operation, whose main purpose is to make screenshots of the application. If you want to update an image with the contents of the window and then use it for drawing, you should rather use a OcsfmlGraphics.texture and its update_from_window function. You can also draw things directly to a texture with the OcsfmlGraphics.render_texture class.
      @return Image containing the captured contents. *)
  method capture : image

  (**/**)
  method rep__sf_RenderWindow : RenderWindow.t
  (**/**)

  (** Change the window's icon.

      pixels must be a bigarray of width x height pixels in 32-bits RGBA format.
      
      The OS default icon is used by default.*)
  method set_icon : pixel_array_type -> unit
end


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

(** Base class for textured shapes with outline.

Ocsfml.Shape is a drawable class that allows to define and display a custom convex shape on a render target.

It's only an abstract base, it needs to be specialized for concrete types of shapes (circle, rectangle, convex polygon, star, ...).

In addition to the attributes provided by the specialized shape classes, a shape always has the following attributes:

    - a texture
    - a texture rectangle
    - a fill color
    - an outline color
    - an outline thickness

Each feature is optional, and can be disabled easily:

    - the texture can be none
    - the fill/outline colors can be OcsfmlGraphics.Color.Transparent
    - the outline thickness can be zero

You can write your own derived shape class, there are only two virtual functions to override:

    - get_point_count must return the number of points of the shape
    - get_point must return the points of the shape *)
class shape :
  Shape.t ->
object
  inherit drawable
  inherit transformable
    
  (**/**)
  val t_shape : Shape.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the fill color of the shape. 
      @return Fill color of the shape. *)
  method get_fill_color : Color.t

  (** Get the global bounding rectangle of the entity.

      The returned rectangle is in global coordinates, which means that it takes in account the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the sprite in the global 2D world's coordinate system.
      @return Global bounding rectangle of the entity *)
  method get_global_bounds : float rect

  (** Get the local bounding rectangle of the entity.

      The returned rectangle is in local coordinates, which means that it ignores the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the entity in the entity's coordinate system.
      @return Local bounding rectangle of the entity *)
  method get_local_bounds : float rect

  (** Get the outline color of the shape. 
      @return Outline color of the shape. *)
  method get_outline_color : Color.t

  (** Get the outline thickness of the shape. 
      @return Outline thickness of the shape. *)
  method get_outline_thickness : float

  (** Get a point of the shape.

      The result is undefined if the index is out of the valid range.
      @return Index-th point of the shape. *)
  method get_point : int -> float * float

  (** Get the total number of points of the shape. 
      @return Number of points of the shape. *)
  method get_point_count : int

  (** Get the source texture of the shape.

      If the shape has no source texture, none is returned. The returned value is const, which means that you can't modify the texture when you retrieve it with this function.
      @return Shape's texture. *)
  method get_texture : texture option

  (** Get the sub-rectangle of the texture displayed by the shape. 
      @return Texture rectangle of the shape *)
  method get_texture_rect : int rect

  (**/**)
  method rep__sf_Shape : Shape.t
  (**/**)

  (** Set the fill color of the shape.

      This color is modulated (multiplied) with the shape's texture if any. It can be used to colorize the shape, or change its global opacity. You can use OcsfmlGraphics.Color.Transparent to make the inside of the shape transparent, and have the outline alone. By default, the shape's fill color is opaque white.*)
  method set_fill_color : Color.t -> unit

  (** Set the outline color of the shape.

      You can use OcsfmlGraphics.Color.Transparent to disable the outline. By default, the shape's outline color is opaque white.*)
  method set_outline_color : Color.t -> unit

  (** Set the thickness of the shape's outline.

      This number cannot be negative. Using zero disables the outline. By default, the outline thickness is 0.*)
  method set_outline_thickness : float -> unit

  (** Change the source texture of the shape.

      The new_texture argument refers to a texture that must exist as long as the shape uses it. Indeed, the shape doesn't store its own copy of the texture, but rather keeps a pointer to the one that you passed to this function. If the source texture is destroyed and the shape tries to use it, the behaviour is undefined. If reset_rect is true, the TextureRect property of the shape is automatically adjusted to the size of the new texture. If it is false (the default), the texture rect is left unchanged.
      @param new_texture The new texture. Default disables texturing
      @param reset_rect Should the texture rect be reset to the size of the new texture?
*)
  method set_texture : ?new_texture:texture -> ?reset_rect:bool -> unit -> unit

  (** Set the sub-rectangle of the texture that the shape will display.

      The texture rect is useful when you don't want to display the whole texture, but rather a part of it. By default, the texture rect covers the entire texture.*)
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

(** Specialized shape representing a rectangle.

    This class inherits all the functions of sf::Transformable (position, rotation, scale, bounds, ...) as well as the functions of sf::Shape (outline, color, texture, ...).
    
    Usage example: 
    {[
    let rectangle = OcsfmlGraphics.(mk_rectangle_shape 
                           ~size:(100.,50.)
                           ~outline_color:Color.red
                           ~outline_thickness:5.
                           ~position:(10., 20.) ()) in
    ...
    window#draw rectangle
    ]} *)
class rectangle_shape : ?size:float * float -> unit ->
object
  inherit shape

  (**/**)
  val t_rectangle_shapeCpp : RectangleShape.t
  (**/**)

  (**)
  method destroy : unit

  (** Set the size of the rectangle. *)
  method get_size : float * float

  (**/**)
  method rep__sf_RectangleShape : RectangleShape.t
  (**/**)

  (** Get the size of the rectangle. 
      @return Size of the rectangle. *)
  method set_size : float * float
end


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


(** Specialized shape representing a circle.

    This class inherits all the functions of OcsfmlGraphics.transformable (position, rotation, scale, bounds, ...) as well as the functions of OcsfmlGraphics.shape (outline, color, texture, ...).
    
    Usage example:
    {[
    let circle = OcsfmlGraphics.(mk_circle_shape
                                     ~radius:150.
                                     ~outline_color:Color.red
                                     ~outline_thickness:5.
                                     ~position:(10, 20) () in
    ...
    window#draw circle 
    ]}
    Since the graphics card can't draw perfect circles, we have to fake them with multiple triangles connected to each other. The "points count" property of sf::CircleShape defines how many of these triangles to use, and therefore defines the quality of the circle.

    The number of points can also be used for another purpose; with small numbers you can create any regular polygon shape: equilateral triangle, square, pentagon, hexagon, ... *)
class circle_shape : ?radius:float -> unit ->
object
  (**/**)
  val t_circle_shapeCpp : CircleShape.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the radius of the circle. 
      @return Radius of the circle. *)
  method get_radius : float

  (**/**)
  method rep__sf_CircleShape : CircleShape.t
  (**/**)

  (** Set the radius of the circle. *)
  method set_radius : float -> unit

  (** Set the number of points of the circle. *)
  method set_point_count : int
end


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


(** Specialized shape representing a convex polygon.
    
    This class inherits all the functions of sf::Transformable (position, rotation, scale, bounds, ...) as well as the functions of sf::Shape (outline, color, texture, ...).
    
    It is important to keep in mind that a convex shape must always be... convex, otherwise it may not be drawn correctly. Moreover, the points must be defined in order; using a random order would result in an incorrect shape.
    
    Usage example:
    {[
    let polygon = OcsfmlGraphics.(mk_convex_shape 
                                       ~points:[(0.,0.) ; (0.,10.) ; (25., 5.)]
                                       ~outline_color:Color.red
                                       ~outline_thickness:5.
                                       ~position:(10.,20.) ()) in
    ...
    window#draw polygon
    ]} *)
class convex_shape : ?point_count:int -> unit -> 
object
  inherit shape
  (**/**)
  val t_convex_shapeCpp : ConvexShape.t
  (**/**)

  (**)
  method destroy : unit

  (**/**)
  method rep__sf_ConvexShape : ConvexShape.t
  (**/**)

  (** Set the position of a point.

      Don't forget that the polygon must remain convex, and the points need to stay ordered! SetPointCount must be called first in order to set the total number of points. The result is undefined if index is out of the valid range. *)
  method set_point : int -> float * float -> unit

  (** Set the number of points of the polygon.

      count must be greater than 2 to define a valid shape. *)
  method set_point_count : int -> unit
end


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
  val find_character_pos : t -> int -> float * float
  val get_local_bounds : t -> float rect
  val get_global_bounds : t -> float rect
end

class text :
object
  inherit drawable
  inherit transformable
    
  (**/**)
  val t_textCpp : Text.t
  (**/**)

  (**)
  method destroy : unit

  (** Return the position of the index-th character.

      This function computes the visual position of a character from its index in the string. The returned position is in global coordinates (translation, rotation, scale and origin are applied). If index is out of range, the position of the end of the string is returned.
      @return Position of the character *)
  method find_character_pos : int -> float * float

  (** Get the character size. 
      @return Size of the characters, in pixels. *)
  method get_character_size : int

  (** Get the global color of the text. 
      @return Global color of the text. *)
  method get_color : Color.t

  (** Get the text's font.

      The returned reference is const, which means that you cannot modify the font when you get it from this function.
      @return Text's font. *)
  method get_font : font
    
  (** Get the global bounding rectangle of the entity.
      
      The returned rectangle is in global coordinates, which means that it takes in account the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the sprite in the global 2D world's coordinate system.
      @return Global bounding rectangle of the entity *)
  method get_global_bounds : float rect
    
  (** Get the local bounding rectangle of the entity.
      
      The returned rectangle is in local coordinates, which means that it ignores the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the entity in the entity's coordinate system.
      @return Local bounding rectangle of the entity *)
  method get_local_bounds : float rect
    
  (** Get the text's string. 
      @return Text's string*)
  method get_string : string

  (** Get the text's style. 
      @return Text's style. *)
  method get_style : text_style list

  (**/**)
  method rep__sf_Text : Text.t
  (**/**)

  (** Set the character size.

      The default size is 30. *)
  method set_character_size : int -> unit

  (** Set the global color of the text.

      By default, the text's color is opaque white. *)
  method set_color : Color.t -> unit

  (** Set the text's font.

      The font argument refers to a font that must exist as long as the text uses it. Indeed, the text doesn't store its own copy of the font, but rather keeps a pointer to the one that you passed to this function. If the font is destroyed and the text tries to use it, the behaviour is undefined. Texts have a valid font by default, which is the built-in get_default_font().*)
  method set_font : font -> unit

  (** Set the text's string. *)
  method set_string : string -> unit

  (** Set the text's style.

      You can pass a combination of one or more styles, for example [ Bold ; Italic ]. The default style is [].*)
  method set_style : text_style list -> unit
end


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
  val get_texture : t -> texture option
  val get_texture_rect : t -> int rect
  val get_color : t -> Color.t
  val get_local_bounds : t -> float rect
  val get_global_bounds : t -> float rect
end


class sprite : 
object
  (**/**)
  val t_spriteCpp : Sprite.t
  (**/**)

  (**)
  method destroy : unit

  (** Get the global color of the sprite. 
      @return Global color of the sprite. *)
  method get_color : Color.t

  (** Get the global bounding rectangle of the entity.

      The returned rectangle is in global coordinates, which means that it takes in account the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the sprite in the global 2D world's coordinate system.
      @return Global bounding rectangle of the entity. *)
  method get_global_bounds : float rect

  (** Get the local bounding rectangle of the entity.

      The returned rectangle is in local coordinates, which means that it ignores the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the entity in the entity's coordinate system.
      @return Local bounding rectangle of the entity. *)
  method get_local_bounds : float rect

  (** Get the source texture of the sprite.

      If the sprite has no source texture, none is returned. The returned value is const, which means that you can't modify the texture when you retrieve it with this function.
      @return The sprite's texture. *)
  method get_texture : texture option

  (** Get the sub-rectangle of the texture displayed by the sprite. 
      @return Texture rectangle of the sprite. *)
  method get_texture_rect : int rect

  (**/**)
  method rep__sf_Sprite : Sprite.t
  (**/**)

  (** Set the global color of the sprite.

      This color is modulated (multiplied) with the sprite's texture. It can be used to colorize the sprite, or change its global opacity. By default, the sprite's color is opaque white.*)
  method set_color : Color.t -> unit

  (** Change the source texture of the sprite.

      The texture argument refers to a texture that must exist as long as the sprite uses it. Indeed, the sprite doesn't store its own copy of the texture, but rather keeps a pointer to the one that you passed to this function. If the source texture is destroyed and the sprite tries to use it, the behaviour is undefined. If resetRect is true, the TextureRect property of the sprite is automatically adjusted to the size of the new texture. If it is false, the texture rect is left unchanged. *)
  method set_texture : ?resize:bool -> texture -> unit

  (** Set the sub-rectangle of the texture that the sprite will display.

      The texture rect is useful when you don't want to display the whole texture, but rather a part of it. By default, the texture rect covers the entire texture. *)
  method set_texture_rect : int rect -> unit
end



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

class vertex_array : 
object
  inherit drawable

  val t_vertex_arrayCpp : VertexArray.t

  (** Add a vertex to the array. *)
  method append : vertex -> unit

  (** Clear the vertex array.

      This function removes all the vertices from the array. It doesn't deallocate the corresponding memory, so that adding new vertices after clearing doesn't involve reallocating all the memory.*)
  method clear : unit

  (**)
  method destroy : unit

  (** Get a read-only access to a vertex by its index. 

      This function doesn't check index, it must be in range [0, GetVertexCount() - 1]. The behaviour is undefined otherwise.*)
  method get_at_index : int -> vertex

  (** Compute the bounding rectangle of the vertex array.

      This function returns the axis-aligned rectangle that contains all the vertices of the array.
      @return Bounding rectangle of the vertex array *)
  method get_bounds : float rect

  (** Get the type of primitives drawn by the vertex array. 
      @return Primitive type *)
  method get_primitive_type : primitive_type

  (** Return the vertex count. 
      @return Number of vertices in the array. *)
  method get_vertex_count : int

  (**/**)
  method rep__sf_VertexArray : VertexArray.t
  (**/**)

  (** Resize the vertex array.

      If vertexCount is greater than the current size, the previous vertices are kept and new (default-constructed) vertices are added. If vertexCount is less than the current size, existing vertices are removed from the array. *)
  method resize : int -> unit

  (** *)
  method set_at_index : int -> vertex -> unit

  (** Set the type of primitives to draw.

      This function defines how the vertices must be interpreted when it's time to draw them:

      - As points
      - As lines
      - As triangles
      - As quads 
      The default primitive type is sf::Points. *)
  method set_primitive_type : primitive_type -> unit
end



(**/**)

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
