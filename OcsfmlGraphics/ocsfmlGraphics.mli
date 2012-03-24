val do_if : ('a -> unit) -> 'a option -> unit
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
module MyInt :
  sig type t = int val add : t -> t -> t val sub : t -> t -> t end
module IntRect :
  sig
    val contains : MyInt.t rect -> MyInt.t -> MyInt.t -> bool
    val contains_v : MyInt.t rect -> MyInt.t * MyInt.t -> bool
    val intersects : MyInt.t rect -> MyInt.t rect -> MyInt.t rect option
  end
module MyFloat :
  sig type t = float val add : t -> t -> t val sub : t -> t -> t end
module FloatRect :
  sig
    val contains : MyFloat.t rect -> MyFloat.t -> MyFloat.t -> bool
    val contains_v : MyFloat.t rect -> MyFloat.t * MyFloat.t -> bool
    val intersects :
      MyFloat.t rect -> MyFloat.t rect -> MyFloat.t rect option
  end
module Color :
  sig
    type t = { r : int; g : int; b : int; a : int; }
    val rgb : int -> int -> int -> t
    val rgba : int -> int -> int -> int -> t
    external add : t -> t -> t = "color_add__impl"
    external modulate : t -> t -> t = "color_multiply__impl"
    val white : t
    val black : t
    val red : t
    val green : t
    val blue : t
    val yellow : t
    val magenta : t
    val cyan : t
    module Infix : sig val ( +% ) : t -> t -> t val ( *% ) : t -> t -> t end
  end
type blend_mode = BlendAlpha | BlendAdd | BlendMultiply | BlendNone
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
    external destroy : t -> unit = "sf_Transform_destroy__impl"
    external get_inverse : t -> 'a = "sf_Transform_getInverse__impl"
    external transform_point : t -> float -> float -> float * float
      = "sf_Transform_transformPoint__impl"
    external transform_point_v : t -> float * float -> float * float
      = "sf_Transform_transformPointV__impl"
    external transform_rect : t -> float rect -> float rect
      = "sf_Transform_transformRect__impl"
    external combine : t -> 'a -> 'a = "sf_Transform_combine__impl"
    external translate : t -> float -> float -> unit
      = "sf_Transform_translate__impl"
    external translate_v : t -> float * float -> unit
      = "sf_Transform_translateV__impl"
    external rotate :
      t -> ?center_x:float -> ?center_y:float -> float -> unit
      = "sf_Transform_rotate__impl"
    external rotate_v : t -> ?center:float * float -> float -> unit
      = "sf_Transform_rotateV__impl"
    external scale :
      t -> ?center_x:float -> ?center_y:float -> float -> float -> unit
      = "sf_Transform_scale__impl"
    external scale_v : t -> ?center:float * float -> float * float -> unit
      = "sf_Transform_scaleV__impl"
  end
class transform :
  Transform.t ->
  object ('a)
    val t_transform : Transform.t
    method combine : 'a -> 'a
    method destroy : unit
    method get_inverse : 'a
    method rep__sf_Transform : Transform.t
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
module Drawable :
  sig type t external destroy : t -> unit = "sf_Drawable_destroy__impl" end
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
    external destroy : t -> unit = "sf_Transformable_destroy__impl"
    external set_position : t -> float -> float -> unit
      = "sf_Transformable_setPosition__impl"
    external set_position_v : t -> float * float -> unit
      = "sf_Transformable_setPositionV__impl"
    external set_scale : t -> float -> float -> unit
      = "sf_Transformable_setScale__impl"
    external set_scale_v : t -> float * float -> unit
      = "sf_Transformable_setScaleV__impl"
    external set_origin : t -> float -> float -> unit
      = "sf_Transformable_setOrigin__impl"
    external set_origin_v : t -> float * float -> unit
      = "sf_Transformable_setOriginV__impl"
    external set_rotation : t -> float -> unit
      = "sf_Transformable_setRotation__impl"
    external get_position : t -> float * float
      = "sf_Transformable_getPosition__impl"
    external get_scale : t -> float * float
      = "sf_Transformable_getScale__impl"
    external get_origin : t -> float * float
      = "sf_Transformable_getOrigin__impl"
    external get_rotation : t -> float = "sf_Transformable_getRotation__impl"
    external move : t -> float -> float -> unit
      = "sf_Transformable_move__impl"
    external move_v : t -> float * float -> unit
      = "sf_Transformable_moveV__impl"
    external scale : t -> float -> float -> unit
      = "sf_Transformable_scale__impl"
    external scale_v : t -> float * float -> unit
      = "sf_Transformable_scaleV__impl"
    external rotate : t -> float -> unit = "sf_Transformable_rotate__impl"
    external get_transform : t -> transform
      = "sf_Transformable_getTransform__impl"
    external get_inverse_transform : t -> transform
      = "sf_Transformable_getInverseTransform__impl"
  end
class transformable :
  Transformable.t ->
  object
    val t_transformable : Transformable.t
    method destroy : unit
    method get_inverse_transform : transform
    method get_origin : float * float
    method get_position : float * float
    method get_rotation : float
    method get_scale : float * float
    method get_transform : transform
    method move : float -> float -> unit
    method move_v : float * float -> unit
    method rep__sf_Transformable : Transformable.t
    method rotate : float -> unit
    method scale : float -> float -> unit
    method scale_v : float * float -> unit
    method set_origin : float -> float -> unit
    method set_origin_v : float * float -> unit
    method set_position : float -> float -> unit
    method set_position_v : float * float -> unit
    method set_rotation : float -> unit
    method set_scale : float -> float -> unit
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
    external destroy : t -> unit = "sf_Image_destroy__impl"
    external default : unit -> t = "sf_Image_default_constructor__impl"
    external create_from_color : t -> ?color:Color.t -> int -> int -> unit
      = "sf_Image_createFromColor__impl"
    external load_from_file : t -> string -> bool
      = "sf_Image_loadFromFile__impl"
    external load_from_stream : t -> OcsfmlSystem.input_stream -> bool
      = "sf_Image_loadFromStream__impl"
    external save_to_file : t -> string -> bool = "sf_Image_saveToFile__impl"
    external get_width : t -> int = "sf_Image_getWidth__impl"
    external get_height : t -> int = "sf_Image_getWidth__impl"
    external get_pixels_ptr : t -> pixel_array_type
      = "sf_Image_getPixelsPtr__impl"
    external create_mask_from_color : t -> ?alpha:int -> Color.t -> unit
      = "sf_Image_createMaskFromColor__impl"
    external copy :
      t -> ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit
      = "sf_Image_copy__byte" "sf_Image_copy__impl"
    external set_pixel : t -> int -> int -> Color.t -> unit
      = "sf_Image_setPixel__impl"
    external get_pixel : t -> int -> int -> Color.t
      = "sf_Image_getPixel__impl"
    external flip_horizontally : t -> unit
      = "sf_Image_flipHorizontally__impl"
    external flip_vertically : t -> unit = "sf_Image_flipVertically__impl"
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
external get_maximum_size : unit -> int = "Texture_getMaximumSize__impl"
module Texture :
  sig
    type t
    external destroy : t -> unit = "sf_Texture_destroy__impl"
    external default : unit -> t = "sf_Texture_default_constructor__impl"
    external create : t -> int -> int -> unit = "sf_Texture_create__impl"
    external load_from_file : t -> ?rect:int rect -> string -> bool
      = "sf_Texture_loadFromFile__impl"
    external load_from_stream :
      t -> ?rect:int rect -> OcsfmlSystem.input_stream -> bool
      = "sf_Texture_loadFromStream__impl"
    external load_from_image : t -> ?rect:int rect -> image -> bool
      = "sf_Texture_loadFromImage__impl"
    external get_width : t -> int = "sf_Texture_getWidth__impl"
    external get_height : t -> int = "sf_Texture_getHeight__impl"
    external copy_to_image : t -> image = "sf_Texture_copyToImage__impl"
    external update_from_image : t -> ?coords:int * int -> image -> unit
      = "sf_Texture_updateFromImage__impl"
    external update_from_window :
      t -> ?coords:int * int -> #OcsfmlWindow.window -> unit
      = "sf_Texture_updateFromWindow__impl"
    external bind : t -> unit = "sf_Texture_bind__impl"
    external set_smooth : t -> bool -> unit = "sf_Texture_setSmooth__impl"
    external is_smooth : t -> bool -> unit = "sf_Texture_isSmooth__impl"
    external set_repeated : t -> bool -> unit
      = "sf_Texture_setRepeated__impl"
    external is_repeated : t -> bool = "sf_Texture_isRepeated__impl"
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
    external destroy : t -> unit = "sf_Font_destroy__impl"
    external default : unit -> t = "sf_Font_default_constructor__impl"
    external load_from_file : t -> string -> bool
      = "sf_Font_loadFromFile__impl"
    external load_from_stream : t -> #OcsfmlSystem.input_stream -> bool
      = "sf_Font_loadFromStream__impl"
    external get_glyph : t -> int -> int -> bool -> glyph
      = "sf_Font_getGlyph__impl"
    external get_kerning : t -> int -> int -> int -> int
      = "sf_Font_getKerning__impl"
    external get_line_spacing : t -> int -> int
      = "sf_Font_getLineSpacing__impl"
    external get_texture : t -> int -> texture = "sf_Font_getTexture__impl"
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
    external destroy : t -> unit = "sf_Shader_destroy__impl"
    external default : unit -> t = "sf_Shader_default_constructor__impl"
    external load_from_file :
      t -> ?vertex:string -> ?fragment:string -> unit -> bool
      = "sf_Shader_loadFromFile__impl"
    external load_from_stream :
      t ->
      ?vertex:(#OcsfmlSystem.input_stream as 'a) ->
      ?fragment:'a -> unit -> bool = "sf_Shader_loadFromStream__impl"
    external set_parameter1 : t -> string -> float -> unit
      = "sf_Shader_setFloatParameter__impl"
    external set_parameter2 : t -> string -> float -> float -> unit
      = "sf_Shader_setVec2Parameter__impl"
    external set_parameter3 : t -> string -> float -> float -> float -> unit
      = "sf_Shader_setVec3Parameter__impl"
    external set_parameter4 :
      t -> string -> float -> float -> float -> float -> unit
      = "sf_Shader_setVec4Parameter__byte" "sf_Shader_setVec4Parameter__impl"
    external set_parameter2v : t -> string -> float * float -> unit
      = "sf_Shader_setVec2ParameterV__impl"
    external set_parameter3v : t -> string -> float * float * float -> unit
      = "sf_Shader_setVec3ParameterV__impl"
    external set_color : t -> string -> Color.t -> unit
      = "sf_Shader_setColorParameter__impl"
    external set_transform : t -> string -> transform -> unit
      = "sf_Shader_setTransformParameter__impl"
    external set_texture : t -> string -> texture -> unit
      = "sf_Shader_setTextureParameter__impl"
    external set_current_texture : t -> string -> unit
      = "sf_Shader_setCurrentTexture__impl"
    external bind : t -> unit = "sf_Shader_bind__impl"
    external unbind : t -> unit = "sf_Shader_unbind__impl"
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
    method set_parameter :
      string -> ?x:float -> ?y:float -> ?z:float -> float -> unit
    method set_parameter1 : string -> float -> unit
    method set_parameter2 : string -> float -> float -> unit
    method set_parameter2v : string -> float * float -> unit
    method set_parameter3 : string -> float -> float -> float -> unit
    method set_parameter3v : string -> float * float * float -> unit
    method set_parameter4 :
      string -> float -> float -> float -> float -> unit
    method set_texture : string -> texture -> unit
    method set_transform : string -> transform -> unit
    method unbind : unit
  end
external shader_is_available : unit -> unit = "Shader_isAvailable__impl"
class shader_bis : unit -> shaderCpp
class shader : shader_bis
module View :
  sig
    type t
    external destroy : t -> unit = "sf_View_destroy__impl"
    external default : unit -> t = "sf_View_default_constructor__impl"
    external create_from_rect : float rect -> t
      = "sf_View_rectangle_constructor__impl"
    external create_from_vectors : float * float -> float * float -> t
      = "sf_View_center_and_size_constructor__impl"
    external set_center : t -> float -> float -> unit
      = "sf_View_setCenter__impl"
    external set_center_v : t -> float * float -> unit
      = "sf_View_setCenterV__impl"
    external set_size : t -> float -> float -> unit = "sf_View_setSize__impl"
    external set_size_v : t -> float * float -> unit
      = "sf_View_setSizeV__impl"
    external set_rotation : t -> float -> unit = "sf_View_setRotation__impl"
    external set_viewport : t -> float rect -> unit
      = "sf_View_setViewport__impl"
    external reset : t -> float rect -> unit = "sf_View_reset__impl"
    external get_center : t -> float * float = "sf_View_getCenter__impl"
    external get_size : t -> float * float = "sf_View_getSize__impl"
    external get_rotation : t -> float = "sf_View_getRotation__impl"
    external get_viewport : t -> float rect = "sf_View_getViewport__impl"
    external move : t -> float -> float -> unit = "sf_View_move__impl"
    external move_v : t -> float * float -> unit = "sf_View_moveV__impl"
    external rotate : t -> float -> unit = "sf_View_rotate__impl"
    external zoom : t -> float -> unit = "sf_View_zoom__impl"
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
external mk_render_states :
  ?blend_mode:blend_mode ->
  ?transform:transform -> ?texture:texture -> ?shader:shader -> unit -> unit
  = "mk_sf_RenderStates__impl"
module RenderTarget :
  sig
    type t
    external destroy : t -> unit = "sf_RenderTarget_destroy__impl"
    external clear : t -> ?color:Color.t -> unit -> unit
      = "sf_RenderTarget_clear__impl"
    external draw : t -> ?render_states:render_states -> #drawable -> unit
      = "sf_RenderTarget_draw__impl"
    external get_size : t -> int * int = "sf_RenderTarget_getSize__impl"
    external set_view : t -> view -> unit = "sf_RenderTarget_setView__impl"
    external get_view : t -> view = "sf_RenderTarget_getView__impl"
    external get_default_view : t -> view
      = "sf_RenderTarget_getDefaultView__impl"
    external get_viewport : t -> int rect
      = "sf_RenderTarget_getViewport__impl"
    external convert_coords : t -> ?view:view -> int -> int -> float * float
      = "sf_RenderTarget_convertCoords__impl"
    external push_gl_states : t -> unit
      = "sf_RenderTarget_pushGLStates__impl"
    external pop_gl_states : t -> unit = "sf_RenderTarget_popGLStates__impl"
    external reset_gl_states : t -> unit
      = "sf_RenderTarget_resetGLStates__impl"
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
    external destroy : t -> unit = "sf_RenderTexture_destroy__impl"
    external to_render_target : t -> RenderTarget.t
      = "upcast__sf_RenderTarget_of_sf_RenderTexture__impl"
    external default : unit -> t
      = "sf_RenderTexture_default_constructor__impl"
    external create : t -> ?dephtBfr:bool -> int -> int -> bool
      = "sf_RenderTexture_create__impl"
    external set_smooth : t -> bool -> unit
      = "sf_RenderTexture_setSmooth__impl"
    external is_smooth : t -> bool = "sf_RenderTexture_isSmooth__impl"
    external set_active : t -> ?active:bool -> unit -> bool
      = "sf_RenderTexture_setActive__impl"
    external display : t -> unit = "sf_RenderTexture_display__impl"
    external get_texture : t -> texture = "sf_RenderTexture_getTexture__impl"
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
    external destroy : t -> unit = "sf_RenderWindow_destroy__impl"
    external to_windowCpp : t -> OcsfmlWindow.Window.t
      = "upcast__sf_Window_of_sf_RenderWindow__impl"
    external to_render_target : t -> RenderTarget.t
      = "upcast__sf_RenderTarget_of_sf_RenderWindow__impl"
    external default : unit -> t
      = "sf_RenderWindow_default_constructor__impl"
    external create :
      ?style:OcsfmlWindow.Window.style list ->
      ?context:OcsfmlWindow.context_settings ->
      OcsfmlWindow.VideoMode.t -> string -> t
      = "sf_RenderWindow_create_constructor__impl"
    external capture : t -> image = "sf_RenderWindow_capture__impl"
    external set_icon : t -> pixel_array_type -> unit
      = "sf_RenderWindow_setIcon__impl"
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
    external destroy : t -> unit = "sf_Shape_destroy__impl"
    external to_transformable : t -> Transformable.t
      = "upcast__sf_Transformable_of_sf_Shape__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_sf_Shape__impl"
    external set_texture :
      t -> ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
      = "sf_Shape_setTexture__impl"
    external set_texture_rect : t -> int rect -> unit
      = "sf_Shape_setTextureRect__impl"
    external set_fill_color : t -> Color.t -> unit
      = "sf_Shape_setFillColor__impl"
    external set_outline_color : t -> Color.t -> unit
      = "sf_Shape_setOutlineColor__impl"
    external set_outline_thickness : t -> float -> unit
      = "sf_Shape_setOutlineThickness__impl"
    external get_texture : t -> texture option = "sf_Shape_getTexture__impl"
    external get_texture_rect : t -> int rect
      = "sf_Shape_getTextureRect__impl"
    external get_fill_color : t -> Color.t = "sf_Shape_getFillColor__impl"
    external get_outline_color : t -> Color.t
      = "sf_Shape_getOutlineColor__impl"
    external get_outline_thickness : t -> float
      = "sf_Shape_getOutlineThickness__impl"
    external get_point_count : t -> int = "sf_Shape_getPointCount__impl"
    external get_point : t -> int -> float * float
      = "sf_Shape_getPoint__impl"
    external get_local_bounds : t -> float rect
      = "sf_Shape_getLocalBounds__impl"
    external get_global_bounds : t -> float rect
      = "sf_Shape_getGlobalBounds__impl"
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
    method set_texture :
      ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
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
    external destroy : t -> unit = "sf_RectangleShape_destroy__impl"
    external to_shape : t -> Shape.t
      = "upcast__sf_Shape_of_sf_RectangleShape__impl"
    external default : unit -> t
      = "sf_RectangleShape_default_constructor__impl"
    external from_size : float * float -> t
      = "sf_RectangleShape_size_constructor__impl"
    external set_size : t -> float * float
      = "sf_RectangleShape_setSize__impl"
    external get_size : t -> float * float
      = "sf_RectangleShape_getSize__impl"
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
    method set_texture :
      ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
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
    external destroy : t -> unit = "sf_CircleShape_destroy__impl"
    external to_shape : t -> Shape.t
      = "upcast__sf_Shape_of_sf_CircleShape__impl"
    external default : unit -> t = "sf_CircleShape_default_constructor__impl"
    external from_radius : float -> t
      = "sf_CircleShape_radius_constructor__impl"
    external set_radius : t -> float -> unit
      = "sf_CircleShape_setRadius__impl"
    external get_radius : t -> float = "sf_CircleShape_getRadius__impl"
    external set_point_count : t -> int -> unit
      = "sf_CircleShape_setPointCount__impl"
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
    method set_texture :
      ?new_texture:texture -> ?reset_rect:bool -> unit -> unit
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
    external destroy : t -> unit = "sf_ConvexShape_destroy__impl"
    external to_shape : t -> Shape.t
      = "upcast__sf_Shape_of_sf_ConvexShape__impl"
    external default : unit -> t = "sf_ConvexShape_default_constructor__impl"
    external from_point_count : int -> t
      = "sf_ConvexShape_point_constructor__impl"
    external set_point_count : t -> int -> unit
      = "sf_ConvexShape_setPointCount__impl"
    external set_point : t -> int -> float * float -> unit
      = "sf_ConvexShape_setPoint__impl"
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
    external destroy : t -> unit = "sf_Text_destroy__impl"
    external to_transformable : t -> Transformable.t
      = "upcast__sf_Transformable_of_sf_Text__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_sf_Text__impl"
    external default : unit -> t = "sf_Text_default_constructor__impl"
    external create : string -> font -> int -> t
      = "sf_Text_init_constructor__impl"
    external set_string : t -> string -> unit = "sf_Text_setString__impl"
    external set_font : t -> font -> unit = "sf_Text_setFont__impl"
    external set_character_size : t -> int -> unit
      = "sf_Text_setCharacterSize__impl"
    external set_style : t -> text_style list -> unit
      = "sf_Text_setStyle__impl"
    external set_color : t -> Color.t -> unit = "sf_Text_setColor__impl"
    external get_string : t -> string = "sf_Text_getString__impl"
    external get_font : t -> font = "sf_Text_getFont__impl"
    external get_character_size : t -> int = "sf_Text_getCharacterSize__impl"
    external get_style : t -> text_style list = "sf_Text_getStyle__impl"
    external get_character_pos : t -> int -> float * float
      = "sf_Text_findCharacterPos__impl"
    external get_local_bounds : t -> float rect
      = "sf_Text_getLocalBounds__impl"
    external get_global_bounds : t -> float rect
      = "sf_Text_getGlobalBounds__impl"
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
    external destroy : t -> unit = "sf_Sprite_destroy__impl"
    external to_transformable : t -> Transformable.t
      = "upcast__sf_Transformable_of_sf_Sprite__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_sf_Sprite__impl"
    external default : unit -> t = "sf_Sprite_default_constructor__impl"
    external create_from_texture : texture -> t
      = "sf_Sprite_texture_constructor__impl"
    external set_texture : t -> ?resize:bool -> texture -> unit
      = "sf_Sprite_setTexture__impl"
    external set_texture_rect : t -> int rect -> unit
      = "sf_Sprite_setTextureRect__impl"
    external set_color : t -> Color.t -> unit = "sf_Sprite_setColor__impl"
    external get_texture : t -> texture = "sf_Sprite_getTexture__impl"
    external get_texture_rect : t -> int rect
      = "sf_Sprite_getTextureRect__impl"
    external get_color : t -> Color.t = "sf_Sprite_getColor__impl"
    external get_local_bounds : t -> float rect
      = "sf_Sprite_getLocalBounds__impl"
    external get_global_bounds : t -> float rect
      = "sf_Sprite_getGlobalBounds__impl"
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
    external destroy : t -> unit = "sf_VertexArray_destroy__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_sf_VertexArray__impl"
    external default : unit -> t = "sf_VertexArray_default_constructor__impl"
    external get_vertex_count : t -> int
      = "sf_VertexArray_getVertexCount__impl"
    external set_at_index : t -> int -> vertex -> unit
      = "sf_VertexArray_setAtIndex__impl"
    external get_at_index : t -> int -> vertex
      = "sf_VertexArray_getAtIndex__impl"
    external clear : t -> unit = "sf_VertexArray_clear__impl"
    external resize : t -> int -> unit = "sf_VertexArray_resize__impl"
    external append : t -> vertex -> unit = "sf_VertexArray_append__impl"
    external set_primitive_type : t -> primitive_type -> unit
      = "sf_VertexArray_setPrimitiveType__impl"
    external get_primitive_type : t -> primitive_type
      = "sf_VertexArray_getPrimitiveType__impl"
    external get_bounds : t -> float rect = "sf_VertexArray_getBounds__impl"
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
    external destroy : t -> unit = "CamlDrawable_destroy__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_CamlDrawable__impl"
    external default : unit -> t = "CamlDrawable_default_constructor__impl"
    external callback : draw_func_type -> t
      = "CamlDrawable_callback_constructor__impl"
    external set_callback : t -> draw_func_type -> unit
      = "CamlDrawable_setCallback__impl"
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
