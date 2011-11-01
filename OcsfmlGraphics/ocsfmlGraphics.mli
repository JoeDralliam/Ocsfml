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
module MyInt : RECT_VAL
module IntRect :
  sig
    val contains : MyInt.t rect -> MyInt.t -> MyInt.t -> bool
    val contains_v : MyInt.t rect -> MyInt.t * MyInt.t -> bool
    val intersects : MyInt.t rect -> MyInt.t rect -> MyInt.t rect option
  end
module MyFloat : RECT_VAL
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
  end
type blend_mode = BlendAlpha | BlendAdd | BlendMultiply | BlendNone
module Drawable :
  sig
    type t
    external destroy : t -> unit = "sf_Drawable_destroy__impl"
    external set_position : t -> float -> float -> unit
      = "sf_Drawable_SetPosition__impl"
    external set_position_v : t -> float * float -> unit
      = "sf_Drawable_SetPositionV__impl"
    external set_x : t -> float -> unit = "sf_Drawable_SetX__impl"
    external set_y : t -> float -> unit = "sf_Drawable_SetY__impl"
    external set_scale : t -> float -> float -> unit
      = "sf_Drawable_SetScale__impl"
    external set_scale_v : t -> float * float -> unit
      = "sf_Drawable_SetScaleV__impl"
    external set_scale_x : t -> float -> unit = "sf_Drawable_SetScaleX__impl"
    external set_scale_y : t -> float -> unit = "sf_Drawable_SetScaleY__impl"
    external set_origin : t -> float -> float -> unit
      = "sf_Drawable_SetOrigin__impl"
    external set_origin_v : t -> float * float -> unit
      = "sf_Drawable_SetOriginV__impl"
    external set_rotation : t -> float -> unit
      = "sf_Drawable_SetRotation__impl"
    external set_color : t -> Color.t -> unit = "sf_Drawable_SetColor__impl"
    external set_blend_mode : t -> blend_mode -> unit
      = "sf_Drawable_SetBlendMode__impl"
    external get_position : t -> float * float
      = "sf_Drawable_GetPosition__impl"
    external get_scale : t -> float * float = "sf_Drawable_GetScale__impl"
    external get_origin : t -> float * float = "sf_Drawable_GetOrigin__impl"
    external get_rotation : t -> float = "sf_Drawable_GetRotation__impl"
    external get_color : t -> Color.t = "sf_Drawable_GetColor__impl"
    external get_blend_mode : t -> blend_mode
      = "sf_Drawable_GetBlendMode__impl"
    external move : t -> float -> float -> unit = "sf_Drawable_Move__impl"
    external move_v : t -> float * float -> unit = "sf_Drawable_MoveV__impl"
    external scale : t -> float -> float -> unit = "sf_Drawable_Scale__impl"
    external scale_v : t -> float * float -> unit
      = "sf_Drawable_ScaleV__impl"
    external rotate : t -> float -> unit = "sf_Drawable_Rotate__impl"
    external transform_to_local : t -> float * float -> float * float
      = "sf_Drawable_TransformToLocal__impl"
    external transform_to_global : t -> float * float -> float * float
      = "sf_Drawable_TransformToGlobal__impl"
  end
class virtual drawable :
  Drawable.t ->
  object
    val t_drawable : Drawable.t
    method destroy : unit -> unit
    method get_blend_mode : unit -> blend_mode
    method get_color : unit -> Color.t
    method get_origin : unit -> float * float
    method get_position : unit -> float * float
    method get_rotation : unit -> float
    method get_scale : unit -> float * float
    method move : float -> float -> unit
    method move_v : float * float -> unit
    method rep__sf_Drawable : Drawable.t
    method rotate : float -> unit
    method scale : float -> float -> unit
    method scale_v : float * float -> unit
    method set_blend_mode : blend_mode -> unit
    method set_color : Color.t -> unit
    method set_origin : float -> float -> unit
    method set_origin_v : float * float -> unit
    method set_position : float -> float -> unit
    method set_position_v : float * float -> unit
    method set_rotation : float -> unit
    method set_scale : float -> float -> unit
    method set_scale_v : float * float -> unit
    method set_scale_x : float -> unit
    method set_scale_y : float -> unit
    method set_x : float -> unit
    method set_y : float -> unit
    method transform_to_global : float * float -> float * float
    method transform_to_local : float * float -> float * float
  end
val mk_drawable :
  ?position:float * float ->
  ?scale:float * float ->
  ?origin:float * float ->
  ?rotation:float -> ?color:'a -> ?blendMode:blend_mode -> #drawable -> unit
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
        method destroy : unit -> unit
        method flip_horizontally : unit -> unit
        method flip_vertically : unit -> unit
        method get_height : unit -> int
        method get_pixel : int -> int -> Color.t
        method get_width : unit -> int
        method load_from_file : string -> bool
        method load_from_stream : OcsfmlSystem.input_stream -> bool
        method rep__sf_Image : t
        method save_to_file : string -> bool
        method set_pixel : int -> int -> Color.t -> unit
      end
    external destroy : t -> unit = "sf_Image_destroy__impl"
    external default : unit -> t = "sf_Image_default_constructor__impl"
    external create_from_color : t -> ?color:Color.t -> int -> int -> unit
      = "sf_Image_CreateFromColor__impl"
    external load_from_file : t -> string -> bool
      = "sf_Image_LoadFromFile__impl"
    external load_from_stream : t -> OcsfmlSystem.input_stream -> bool
      = "sf_Image_LoadFromStream__impl"
    external save_to_file : t -> string -> bool = "sf_Image_SaveToFile__impl"
    external get_height : t -> int = "sf_Image_GetWidth__impl"
    external get_width : t -> int = "sf_Image_GetHeight__impl"
    external create_mask_from_color : t -> ?alpha:int -> Color.t -> unit
      = "sf_Image_CreateMaskFromColor__impl"
    external copy :
      t -> ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit
      = "sf_Image_Copy__byte" "sf_Image_Copy__impl"
    external set_pixel : t -> int -> int -> Color.t -> unit
      = "sf_Image_SetPixel__impl"
    external get_pixel : t -> int -> int -> Color.t
      = "sf_Image_GetPixel__impl"
    external flip_horizontally : t -> unit
      = "sf_Image_FlipHorizontally__impl"
    external flip_vertically : t -> unit = "sf_Image_FlipVertically__impl"
  end
class imageCpp :
  Image.t ->
  object ('a)
    val t_imageCpp : Image.t
    method copy :
      ?srcRect:int rect -> ?alpha:bool -> 'a -> int -> int -> unit
    method create_from_color : ?color:Color.t -> int -> int -> unit
    method create_mask_from_color : ?alpha:int -> Color.t -> unit
    method destroy : unit -> unit
    method flip_horizontally : unit -> unit
    method flip_vertically : unit -> unit
    method get_height : unit -> int
    method get_pixel : int -> int -> Color.t
    method get_width : unit -> int
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
external get_maximum_size : unit -> int = "Texture_GetMaximumSize__impl"
module Texture :
  sig
    type t
    external destroy : t -> unit = "sf_Texture_destroy__impl"
    external default : unit -> t = "sf_Texture_default_constructor__impl"
    external create : t -> int -> int -> unit = "sf_Texture_Create__impl"
    external load_from_file : t -> ?rect:int rect -> string -> bool
      = "sf_Texture_LoadFromFile__impl"
    external load_from_stream :
      t -> ?rect:int rect -> OcsfmlSystem.input_stream -> bool
      = "sf_Texture_LoadFromStream__impl"
    external load_from_image : t -> ?rect:int rect -> image -> bool
      = "sf_Texture_LoadFromImage__impl"
    external get_width : t -> int = "sf_Texture_GetWidth__impl"
    external get_height : t -> int = "sf_Texture_GetHeight__impl"
    external copy_to_image : t -> image = "sf_Texture_CopyToImage__impl"
    external update_from_image : t -> ?coords:int * int -> image -> unit
      = "sf_Texture_UpdateFromImage__impl"
    external update_from_window :
      t -> ?coords:int * int -> #OcsfmlWindow.window -> unit
      = "sf_Texture_UpdateFromWindow__impl"
    external bind : t -> unit = "sf_Texture_Bind__impl"
    external set_smooth : t -> bool -> unit = "sf_Texture_SetSmooth__impl"
    external is_smooth : t -> bool -> unit = "sf_Texture_IsSmooth__impl"
    external get_tex_coords : t -> int rect -> float rect
      = "sf_Texture_GetTexCoords__impl"
  end
class textureCpp :
  Texture.t ->
  object
    val t_textureCpp : Texture.t
    method bind : unit -> unit
    method copy_to_image : unit -> image
    method create : int -> int -> unit
    method destroy : unit -> unit
    method get_height : unit -> int
    method get_tex_coords : int rect -> float rect
    method get_width : unit -> int
    method is_smooth : bool -> unit
    method load_from_file : ?rect:int rect -> string -> bool
    method load_from_image : ?rect:int rect -> image -> bool
    method load_from_stream :
      ?rect:int rect -> OcsfmlSystem.input_stream -> bool
    method rep__sf_Texture : Texture.t
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
      = "sf_Font_LoadFromFile__impl"
    external load_from_stream : t -> #OcsfmlSystem.input_stream -> bool
      = "sf_Font_LoadFromStream__impl"
    external get_glyph : t -> int -> int -> bool -> glyph
      = "sf_Font_GetGlyph__impl"
    external get_kerning : t -> int -> int -> int -> int
      = "sf_Font_GetKerning__impl"
    external get_line_spacing : t -> int -> int
      = "sf_Font_GetLineSpacing__impl"
    external get_texture : t -> int -> texture = "sf_Font_GetTexture__impl"
  end
class fontCpp :
  Font.t ->
  object
    val t_fontCpp : Font.t
    method destroy : unit -> unit
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
    external load_from_file : t -> string -> bool
      = "sf_Shader_LoadFromFile__impl"
    external load_from_stream : t -> #OcsfmlSystem.input_stream -> bool
      = "sf_Shader_LoadFromStream__impl"
    external set_parameter1 : t -> string -> float -> unit
      = "sf_Shader_SetFloatParameter__impl"
    external set_parameter2 : t -> string -> float -> float -> unit
      = "sf_Shader_SetVec2Parameter__impl"
    external set_parameter3 : t -> string -> float -> float -> float -> unit
      = "sf_Shader_SetVec3Parameter__impl"
    external set_parameter4 :
      t -> string -> float -> float -> float -> float -> unit
      = "sf_Shader_SetVec4Parameter__byte" "sf_Shader_SetVec4Parameter__impl"
    external set_parameter2v : t -> string -> float * float -> unit
      = "sf_Shader_SetVec2ParameterV__impl"
    external set_parameter3v : t -> string -> float * float * float -> unit
      = "sf_Shader_SetVec3ParameterV__impl"
    external set_texture : t -> string -> texture -> unit
      = "sf_Shader_SetTexture__impl"
    external set_current_texture : t -> string -> unit
      = "sf_Shader_SetCurrentTexture__impl"
    external bind : t -> unit = "sf_Shader_Bind__impl"
    external unbind : t -> unit = "sf_Shader_Unbind__impl"
  end
class shaderCpp :
  Shader.t ->
  object
    val t_shaderCpp : Shader.t
    method bind : unit -> unit
    method destroy : unit -> unit
    method load_from_file : string -> bool
    method load_from_stream : #OcsfmlSystem.input_stream -> bool
    method rep__sf_Shader : Shader.t
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
    method unbind : unit -> unit
  end
external shader_is_available : unit -> unit = "Shader_IsAvailable__impl"
class shader_bis : unit -> shaderCpp
class shader : shader_bis
val mk_shader :
  [< `File of string | `Stream of #OcsfmlSystem.input_stream ] -> shader
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
      = "sf_View_SetCenter__impl"
    external set_center_v : t -> float * float -> unit
      = "sf_View_SetCenterV__impl"
    external set_size : t -> float -> float -> unit = "sf_View_SetSize__impl"
    external set_size_v : t -> float * float -> unit
      = "sf_View_SetSizeV__impl"
    external set_rotation : t -> float -> unit = "sf_View_SetRotation__impl"
    external set_viewport : t -> float rect -> unit
      = "sf_View_SetViewport__impl"
    external reset : t -> float rect -> unit = "sf_View_Reset__impl"
    external get_center : t -> float * float = "sf_View_GetCenter__impl"
    external get_size : t -> float * float = "sf_View_GetSize__impl"
    external get_rotation : t -> float = "sf_View_GetRotation__impl"
    external get_viewport : t -> float rect = "sf_View_GetViewport__impl"
    external move : t -> float -> float -> unit = "sf_View_Move__impl"
    external move_v : t -> float * float -> unit = "sf_View_MoveV__impl"
    external rotate : t -> float -> unit = "sf_View_Rotate__impl"
    external zoom : t -> float -> unit = "sf_View_Zoom__impl"
  end
class viewCpp :
  View.t ->
  object
    val t_viewCpp : View.t
    method destroy : unit -> unit
    method get_center : unit -> float * float
    method get_rotation : unit -> float
    method get_size : unit -> float * float
    method get_viewport : unit -> float rect
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
module RenderTarget :
  sig
    type t
    external destroy : t -> unit = "sf_RenderTarget_destroy__impl"
    external clear : t -> ?color:Color.t -> unit -> unit
      = "sf_RenderTarget_Clear__impl"
    external draw : t -> #drawable -> unit = "sf_RenderTarget_Draw__impl"
    external draw_with_shader : t -> shader -> #drawable -> unit
      = "sf_RenderTarget_DrawWithShader__impl"
    external get_width : t -> int = "sf_RenderTarget_GetWidth__impl"
    external get_height : t -> int = "sf_RenderTarget_GetHeight__impl"
    external set_view : t -> view -> unit = "sf_RenderTarget_SetView__impl"
    external get_view : t -> view = "sf_RenderTarget_GetView__impl"
    external get_default_view : t -> view
      = "sf_RenderTarget_GetDefaultView__impl"
    external get_viewport : t -> int rect
      = "sf_RenderTarget_GetViewport__impl"
    external convert_coords : t -> ?view:view -> int -> int -> float * float
      = "sf_RenderTarget_ConvertCoords__impl"
    external save_gl_states : t -> unit
      = "sf_RenderTarget_SaveGLStates__impl"
    external restore_gl_states : t -> unit
      = "sf_RenderTarget_RestoreGLStates__impl"
  end
class virtual render_target :
  RenderTarget.t ->
  object
    val t_render_target : RenderTarget.t
    method clear : ?color:Color.t -> unit -> unit
    method convert_coords : ?view:view -> int -> int -> float * float
    method destroy : unit -> unit
    method draw : #drawable -> unit
    method draw_with_shader : shader -> #drawable -> unit
    method get_default_view : unit -> view
    method get_height : unit -> int
    method get_view : unit -> view
    method get_viewport : unit -> int rect
    method get_width : unit -> int
    method rep__sf_RenderTarget : RenderTarget.t
    method restore_gl_states : unit -> unit
    method save_gl_states : unit -> unit
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
    external create : t -> ?dephtBfr:bool -> int -> int -> unit
      = "sf_RenderTexture_Create__impl"
    external set_smooth : t -> bool -> unit
      = "sf_RenderTexture_SetSmooth__impl"
    external is_smooth : t -> bool = "sf_RenderTexture_IsSmooth__impl"
    external set_active : t -> bool -> unit
      = "sf_RenderTexture_SetActive__impl"
    external display : t -> unit = "sf_RenderTexture_Display__impl"
    external get_texture : t -> texture = "sf_RenderTexture_GetTexture__impl"
  end
class render_textureCpp :
  RenderTexture.t ->
  object
    val t_render_target : RenderTarget.t
    val t_render_textureCpp : RenderTexture.t
    method clear : ?color:Color.t -> unit -> unit
    method convert_coords : ?view:view -> int -> int -> float * float
    method create : ?dephtBfr:bool -> int -> int -> unit
    method destroy : unit -> unit
    method display : unit -> unit
    method draw : #drawable -> unit
    method draw_with_shader : shader -> #drawable -> unit
    method get_default_view : unit -> view
    method get_height : unit -> int
    method get_texture : unit -> texture
    method get_view : unit -> view
    method get_viewport : unit -> int rect
    method get_width : unit -> int
    method is_smooth : unit -> bool
    method rep__sf_RenderTarget : RenderTarget.t
    method rep__sf_RenderTexture : RenderTexture.t
    method restore_gl_states : unit -> unit
    method save_gl_states : unit -> unit
    method set_active : bool -> unit
    method set_smooth : bool -> unit
    method set_view : view -> unit
  end
class render_texture : render_textureCpp
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
      ?style:OcsfmlWindow.window_style list ->
      ?context:OcsfmlWindow.context_settings ->
      OcsfmlWindow.VideoMode.t -> string -> t
      = "sf_RenderWindow_create_constructor__impl"
    external capture : t -> image = "sf_RenderWindow_Capture__impl"
  end
class render_windowCpp :
  RenderWindow.t ->
  object
    val t_render_target : RenderTarget.t
    val t_render_windowCpp : RenderWindow.t
    val t_windowCpp : OcsfmlWindow.Window.t
    method capture : unit -> image
    method clear : ?color:Color.t -> unit -> unit
    method close : unit -> unit
    method convert_coords : ?view:view -> int -> int -> float * float
    method create :
      ?style:OcsfmlWindow.window_style list ->
      ?context:OcsfmlWindow.context_settings ->
      OcsfmlWindow.VideoMode.t -> string -> unit
    method destroy : unit -> unit
    method display : unit -> unit
    method draw : #drawable -> unit
    method draw_with_shader : shader -> #drawable -> unit
    method enable_key_repeat : bool -> unit
    method enable_vertical_sync : bool -> unit
    method get_default_view : unit -> view
    method get_frame_time : unit -> int
    method get_height : unit -> int
    method get_settings : unit -> OcsfmlWindow.context_settings
    method get_size : unit -> int * int
    method get_view : unit -> view
    method get_viewport : unit -> int rect
    method get_width : unit -> int
    method is_opened : unit -> bool
    method poll_event : unit -> OcsfmlWindow.Event.t option
    method rep__sf_RenderTarget : RenderTarget.t
    method rep__sf_RenderWindow : RenderWindow.t
    method rep__sf_Window : OcsfmlWindow.Window.t
    method restore_gl_states : unit -> unit
    method save_gl_states : unit -> unit
    method set_active : bool -> bool
    method set_framerate_limit : int -> unit
    method set_joystick_threshold : float -> unit
    method set_position : int -> int -> unit
    method set_size : int -> int -> unit
    method set_title : string -> unit
    method set_view : view -> unit
    method show : bool -> unit
    method show_mouse_cursor : bool -> unit
    method wait_event : unit -> OcsfmlWindow.Event.t option
  end
class render_window :
  ?style:OcsfmlWindow.window_style list ->
  ?context:OcsfmlWindow.context_settings ->
  OcsfmlWindow.VideoMode.t -> string -> render_windowCpp
module Shape :
  sig
    type t
    external destroy : t -> unit = "sf_Shape_destroy__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_sf_Shape__impl"
    external default : unit -> t = "sf_Shape_default_constructor__impl"
    external add_point :
      t -> ?color:Color.t -> ?outline:Color.t -> float -> float -> unit
      = "sf_Shape_AddPoint__impl"
    external add_point_v :
      t -> ?color:Color.t -> ?outline:Color.t -> float * float -> unit
      = "sf_Shape_AddPointV__impl"
    external get_points_count : t -> int = "sf_Shape_GetPointsCount__impl"
    external enable_fill : t -> bool -> unit = "sf_Shape_EnableFill__impl"
    external enable_outline : t -> bool -> unit
      = "sf_Shape_EnableOutline__impl"
    external set_point_position : t -> int -> float -> float -> unit
      = "sf_Shape_SetPointPosition__impl"
    external set_point_position_v : t -> int -> float * float -> unit
      = "sf_Shape_SetPointPositionV__impl"
    external set_point_color : t -> int -> Color.t -> unit
      = "sf_Shape_SetPointColor__impl"
    external set_point_outline_color : t -> int -> Color.t -> unit
      = "sf_Shape_SetPointOutlineColor__impl"
    external set_outline_thickness : t -> float -> unit
      = "sf_Shape_SetOutlineThickness__impl"
    external get_point_position : t -> int -> float * float
      = "sf_Shape_GetPointPosition__impl"
    external get_point_color : t -> int -> Color.t
      = "sf_Shape_GetPointColor__impl"
    external get_point_outline_color : t -> int -> Color.t
      = "sf_Shape_GetPointOutlineColor__impl"
    external get_outline_thickness : t -> float
      = "sf_Shape_GetOutlineThickness__impl"
  end
class shapeCpp :
  Shape.t ->
  object
    val t_drawable : Drawable.t
    val t_shapeCpp : Shape.t
    method add_point :
      ?color:Color.t -> ?outline:Color.t -> float -> float -> unit
    method add_point_v :
      ?color:Color.t -> ?outline:Color.t -> float * float -> unit
    method destroy : unit -> unit
    method enable_fill : bool -> unit
    method enable_outline : bool -> unit
    method get_blend_mode : unit -> blend_mode
    method get_color : unit -> Color.t
    method get_origin : unit -> float * float
    method get_outline_thickness : unit -> float
    method get_point_color : int -> Color.t
    method get_point_outline_color : int -> Color.t
    method get_point_position : int -> float * float
    method get_points_count : unit -> int
    method get_position : unit -> float * float
    method get_rotation : unit -> float
    method get_scale : unit -> float * float
    method move : float -> float -> unit
    method move_v : float * float -> unit
    method rep__sf_Drawable : Drawable.t
    method rep__sf_Shape : Shape.t
    method rotate : float -> unit
    method scale : float -> float -> unit
    method scale_v : float * float -> unit
    method set_blend_mode : blend_mode -> unit
    method set_color : Color.t -> unit
    method set_origin : float -> float -> unit
    method set_origin_v : float * float -> unit
    method set_outline_thickness : float -> unit
    method set_point_color : int -> Color.t -> unit
    method set_point_outline_color : int -> Color.t -> unit
    method set_point_position : int -> float -> float -> unit
    method set_point_position_v : int -> float * float -> unit
    method set_position : float -> float -> unit
    method set_position_v : float * float -> unit
    method set_rotation : float -> unit
    method set_scale : float -> float -> unit
    method set_scale_v : float * float -> unit
    method set_scale_x : float -> unit
    method set_scale_y : float -> unit
    method set_x : float -> unit
    method set_y : float -> unit
    method transform_to_global : float * float -> float * float
    method transform_to_local : float * float -> float * float
  end
class shape_bis : unit -> shapeCpp
class shape : shape_bis
val mk_shape :
  ?points:(float * float * Color.t * Color.t) list ->
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?color:'a ->
  ?blendMode:blend_mode ->
  ?fill:bool -> ?outline:bool -> ?outline_thickness:float -> unit -> shape
module ShapeObjects :
  sig
    external line :
      ?outline:float ->
      ?outlineColor:Color.t ->
      float -> float -> float -> float -> float -> Color.t -> shape
      = "sf_Shape_Line__byte" "sf_Shape_Line__impl"
    external line_v :
      ?outline:float ->
      ?outlineColor:Color.t -> float * float -> float -> Color.t -> shape
      = "sf_Shape_LineV__impl"
    external rectangle :
      ?outline:float ->
      ?outlineColor:Color.t ->
      float -> float -> float -> float -> Color.t -> shape
      = "sf_Shape_Rectangle__byte" "sf_Shape_Rectangle__impl"
    external rectangle_r :
      ?outline:float ->
      ?outlineColor:Color.t -> float rect -> Color.t -> shape
      = "sf_Shape_RectangleR__impl"
    external circle :
      ?outline:float ->
      ?outlineColor:Color.t -> float -> float -> float -> Color.t -> shape
      = "sf_Shape_Circle__byte" "sf_Shape_Circle__impl"
    external circle_v :
      ?outline:float ->
      ?outlineColor:Color.t -> float * float -> float -> Color.t -> shape
      = "sf_Shape_CircleV__impl"
  end
type text_style = Bold | Italic | Underline
module Text :
  sig
    type t
    external destroy : t -> unit = "sf_Text_destroy__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_sf_Text__impl"
    external default : unit -> t = "sf_Text_default_constructor__impl"
    external create : string -> font -> int -> t
      = "sf_Text_init_constructor__impl"
    external set_string : t -> string -> unit = "sf_Text_SetString__impl"
    external set_font : t -> font -> unit = "sf_Text_SetFont__impl"
    external set_character_size : t -> int -> unit
      = "sf_Text_SetCharacterSize__impl"
    external set_style : t -> text_style list -> unit
      = "sf_Text_SetStyle__impl"
    external get_string : t -> string = "sf_Text_GetString__impl"
    external get_font : t -> font = "sf_Text_GetFont__impl"
    external get_character_size : t -> int = "sf_Text_GetCharacterSize__impl"
    external get_style : t -> text_style list = "sf_Text_GetStyle__impl"
    external get_character_pos : t -> int -> float * float
      = "sf_Text_GetCharacterPos__impl"
    external get_rect : t -> float rect = "sf_Text_GetRect__impl"
  end
class textCpp :
  Text.t ->
  object
    val t_drawable : Drawable.t
    val t_textCpp : Text.t
    method destroy : unit -> unit
    method get_blend_mode : unit -> blend_mode
    method get_character_pos : int -> float * float
    method get_character_size : unit -> int
    method get_color : unit -> Color.t
    method get_font : unit -> font
    method get_origin : unit -> float * float
    method get_position : unit -> float * float
    method get_rect : unit -> float rect
    method get_rotation : unit -> float
    method get_scale : unit -> float * float
    method get_string : unit -> string
    method get_style : unit -> text_style list
    method move : float -> float -> unit
    method move_v : float * float -> unit
    method rep__sf_Drawable : Drawable.t
    method rep__sf_Text : Text.t
    method rotate : float -> unit
    method scale : float -> float -> unit
    method scale_v : float * float -> unit
    method set_blend_mode : blend_mode -> unit
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
    method set_scale_x : float -> unit
    method set_scale_y : float -> unit
    method set_string : string -> unit
    method set_style : text_style list -> unit
    method set_x : float -> unit
    method set_y : float -> unit
    method transform_to_global : float * float -> float * float
    method transform_to_local : float * float -> float * float
  end
class text_bis : unit -> textCpp
class text : text_bis
val mk_text :
  ?string:'a ->
  ?string:string ->
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?color:'b ->
  ?blendMode:blend_mode ->
  ?font:font -> ?character_size:int -> ?style:text_style list -> unit -> text
module Sprite :
  sig
    type t
    external destroy : t -> unit = "sf_Sprite_destroy__impl"
    external to_drawable : t -> Drawable.t
      = "upcast__sf_Drawable_of_sf_Sprite__impl"
    external default : unit -> t = "sf_Sprite_default_constructor__impl"
    external create_from_texture : texture -> t
      = "sf_Sprite_texture_constructor__impl"
    external set_texture : t -> ?resize:bool -> texture -> unit
      = "sf_Sprite_SetTexture__impl"
    external set_sub_rect : t -> int rect -> unit
      = "sf_Sprite_SetSubRect__impl"
    external resize : t -> float -> float -> unit = "sf_Sprite_Resize__impl"
    external resize_v : t -> float * float -> unit
      = "sf_Sprite_ResizeV__impl"
    external flip_x : t -> bool -> unit = "sf_Sprite_FlipX__impl"
    external flip_y : t -> bool -> unit = "sf_Sprite_FlipY__impl"
    external get_texture : t -> texture = "sf_Sprite_GetTexture__impl"
    external get_sub_rect : t -> int rect = "sf_Sprite_GetSubRect__impl"
    external get_size : t -> float * float = "sf_Sprite_GetSize__impl"
  end
class spriteCpp :
  Sprite.t ->
  object
    val t_drawable : Drawable.t
    val t_spriteCpp : Sprite.t
    method destroy : unit -> unit
    method flip_x : bool -> unit
    method flip_y : bool -> unit
    method get_blend_mode : unit -> blend_mode
    method get_color : unit -> Color.t
    method get_origin : unit -> float * float
    method get_position : unit -> float * float
    method get_rotation : unit -> float
    method get_scale : unit -> float * float
    method get_size : unit -> float * float
    method get_sub_rect : unit -> int rect
    method get_texture : unit -> texture
    method move : float -> float -> unit
    method move_v : float * float -> unit
    method rep__sf_Drawable : Drawable.t
    method rep__sf_Sprite : Sprite.t
    method resize : float -> float -> unit
    method resize_v : float * float -> unit
    method rotate : float -> unit
    method scale : float -> float -> unit
    method scale_v : float * float -> unit
    method set_blend_mode : blend_mode -> unit
    method set_color : Color.t -> unit
    method set_origin : float -> float -> unit
    method set_origin_v : float * float -> unit
    method set_position : float -> float -> unit
    method set_position_v : float * float -> unit
    method set_rotation : float -> unit
    method set_scale : float -> float -> unit
    method set_scale_v : float * float -> unit
    method set_scale_x : float -> unit
    method set_scale_y : float -> unit
    method set_sub_rect : int rect -> unit
    method set_texture : ?resize:bool -> texture -> unit
    method set_x : float -> unit
    method set_y : float -> unit
    method transform_to_global : float * float -> float * float
    method transform_to_local : float * float -> float * float
  end
class sprite_bis : unit -> spriteCpp
class sprite : sprite_bis
val mk_sprite :
  ?texture:texture ->
  ?position:float * float ->
  ?scale:float * float ->
  ?rotation:float ->
  ?origin:float * float ->
  ?color:'a -> ?blendMode:blend_mode -> ?sub_rect:int rect -> unit -> sprite
