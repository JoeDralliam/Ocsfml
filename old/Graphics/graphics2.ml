type 'a rect = { left : 'a; top : 'a; width : 'a; height : 'a }

module type RECT_VAL =
  sig type t
       val add : t -> t -> t
          val sub : t -> t -> t
             end
  
module Rect (M : RECT_VAL) =
  struct
    let contains { left = left; top = top; width = width; height = height } x
                 y =
      (x >= left) &&
        ((y >= top) && ((x < (M.add left width)) && (y < (M.add top height))))
      
    let contains_v r (x, y) = contains r x y
      
    let intersects { left = l1; top = t1; width = w1; height = h1 }
                   { left = l2; top = t2; width = w2; height = h2 } =
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
  
module MyInt : RECT_VAL =
  struct type t = int
          let add = ( + )
             let sub = ( - )
                end
  
module IntRect = Rect(MyInt)
  
module MyFloat : RECT_VAL =
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
      
    external add : t -> t -> t = "color_add__impl"
      
    external modulate : t -> t -> t = "color_multiply__impl"
      
  end
  
(*let ( +# ) c1 c2 = add c1 c2
  let ( *# ) c1 c2 = modulate c1 c2*)
type blend_mode = | BlendAlpha | BlendAdd | BlendMultiply | BlendNone

module Drawable =
  struct
    type t
    
    external destroy : t -> unit = "sf_Drawable_destroy__impl"
      
    external set_position : t -> float -> float -> unit =
      "sf_Drawable_SetPosition__impl"
      
    external set_position_v : t -> (float * float) -> unit =
      "sf_Drawable_SetPositionV__impl"
      
    external set_x : t -> float -> unit = "sf_Drawable_SetX__impl"
      
    external set_scale : t -> float -> float -> unit =
      "sf_Drawable_SetScale__impl"
      
    external set_scale_v : t -> (float * float) -> unit =
      "sf_Drawable_SetScaleV__impl"
      
    external set_scale_x : t -> float -> unit = "sf_Drawable_SetScaleX__impl"
      
    external set_scale_y : t -> float -> unit = "sf_Drawable_SetScaleY__impl"
      
    external set_origin : t -> float -> float -> unit =
      "sf_Drawable_SetOrigin__impl"
      
    external set_origin_v : t -> (float * float) -> unit =
      "sf_Drawable_SetOriginV__impl"
      
    external set_rotation : t -> float -> unit =
      "sf_Drawable_SetRotation__impl"
      
    external set_color : t -> Color.t -> unit = "sf_Drawable_SetColor__impl"
      
    external set_blend_mode : t -> blend_mode -> unit =
      "sf_Drawable_SetBlendMode__impl"
      
    external get_position : t -> (float * float) =
      "sf_Drawable_GetPosition__impl"
      
    external get_scale : t -> (float * float) = "sf_Drawable_GetScale__impl"
      
    external get_origin : t -> (float * float) =
      "sf_Drawable_GetOrigin__impl"
      
    external get_rotation : t -> float = "sf_Drawable_GetRotation__impl"
      
    external get_color : t -> Color.t = "sf_Drawable_GetColor__impl"
      
    external get_blend_mode : t -> blend_mode =
      "sf_Drawable_GetBlendMode__impl"
      
    external move : t -> float -> float -> unit = "sf_Drawable_Move__impl"
      
    external move_v : t -> (float * float) -> unit =
      "sf_Drawable_MoveV__impl"
      
    external scale : t -> float -> float -> unit = "sf_Drawable_Scale__impl"
      
    external scale_v : t -> (float * float) -> unit =
      "sf_Drawable_ScaleV__impl"
      
    external rotate : t -> float -> unit = "sf_Drawable_Rotate__impl"
      
    external transform_to_local : t -> (float * float) -> (float * float) =
      "sf_Drawable_TransformToLocal__impl"
      
    external transform_to_global : t -> (float * float) -> (float * float) =
      "sf_Drawable_TransformToGlobal__impl"
      
  end
  
class virtual drawable t_drawable' =
  object val t_drawable = t_drawable'
           
    method rep__sf_Drawable = t_drawable
      
    method destroy = fun () -> Drawable.destroy t_drawable
      
    method set_position : float -> float -> unit =
      fun p1 p2 -> Drawable.set_position t_drawable p1 p2
      
    method set_position_v : (float * float) -> unit =
      fun p1 -> Drawable.set_position_v t_drawable p1
      
    method set_x : float -> unit = fun p1 -> Drawable.set_x t_drawable p1
      
    method set_scale : float -> float -> unit =
      fun p1 p2 -> Drawable.set_scale t_drawable p1 p2
      
    method set_scale_v : (float * float) -> unit =
      fun p1 -> Drawable.set_scale_v t_drawable p1
      
    method set_scale_x : float -> unit =
      fun p1 -> Drawable.set_scale_x t_drawable p1
      
    method set_scale_y : float -> unit =
      fun p1 -> Drawable.set_scale_y t_drawable p1
      
    method set_origin : float -> float -> unit =
      fun p1 p2 -> Drawable.set_origin t_drawable p1 p2
      
    method set_origin_v : (float * float) -> unit =
      fun p1 -> Drawable.set_origin_v t_drawable p1
      
    method set_rotation : float -> unit =
      fun p1 -> Drawable.set_rotation t_drawable p1
      
    method set_color : Color.t -> unit =
      fun p1 -> Drawable.set_color t_drawable p1
      
    method set_blend_mode : blend_mode -> unit =
      fun p1 -> Drawable.set_blend_mode t_drawable p1
      
    method get_position = fun () -> Drawable.get_position t_drawable
      
    method get_scale = fun () -> Drawable.get_scale t_drawable
      
    method get_origin = fun () -> Drawable.get_origin t_drawable
      
    method get_rotation = fun () -> Drawable.get_rotation t_drawable
      
    method get_color = fun () -> Drawable.get_color t_drawable
      
    method get_blend_mode = fun () -> Drawable.get_blend_mode t_drawable
      
    method move : float -> float -> unit =
      fun p1 p2 -> Drawable.move t_drawable p1 p2
      
    method move_v : (float * float) -> unit =
      fun p1 -> Drawable.move_v t_drawable p1
      
    method scale : float -> float -> unit =
      fun p1 p2 -> Drawable.scale t_drawable p1 p2
      
    method scale_v : (float * float) -> unit =
      fun p1 -> Drawable.scale_v t_drawable p1
      
    method rotate : float -> unit = fun p1 -> Drawable.rotate t_drawable p1
      
    method transform_to_local : (float * float) -> (float * float) =
      fun p1 -> Drawable.transform_to_local t_drawable p1
      
    method transform_to_global : (float * float) -> (float * float) =
      fun p1 -> Drawable.transform_to_global t_drawable p1
      
  end
  
module Image =
  struct
    type t
    
    external destroy : t -> unit = "sf_Image_destroy__impl"
      
    external default : unit -> t = "sf_Image_default_constructor__impl"
      
    external create_from_color : t -> ?color: Color.t -> int -> int -> unit =
      "sf_Image_CreateFromColor__impl"
      
    external load_from_file : t -> string -> bool =
      "sf_Image_LoadFromFile__impl"
      
    external load_from_stream : t -> System.input_stream -> bool =
      "sf_Image_LoadFromStream__impl"
      
    external save_to_file : t -> string -> bool = "sf_Image_SaveToFile__impl"
      
    external get_height : t -> int = "sf_Image_GetWidth__impl"
      
    external get_width : t -> int = "sf_Image_GetHeight__impl"
      
    external create_mask_from_color : t -> ?alpha: int -> Color.t =
      "sf_Image_CreateMaskFromColor__impl"
      
    external copy__impl :
      t -> ?srcRect: (int rect) -> ?alpha: bool -> t -> int -> int -> unit =
      "sf_Image_Copy__byte" "sf_Image_Copy__impl"
      
    external set_pixel : t -> int -> int -> Color.t -> unit =
      "sf_Image_SetPixel__impl"
      
    external get_pixel : t -> int -> int -> Color.t =
      "sf_Image_GetPixel__impl"
      
    external flip_horizontally : t -> unit =
      "sf_Image_FlipHorizontally__impl"
      
    external flip_vertically : t -> unit = "sf_Image_FlipVertically__impl"
      
  end
  
class imageCpp t_imageCpp' =
  object (moiMemeMaitreDuMonde)
    val t_imageCpp = t_imageCpp'
      
    method rep__sf_Image = t_imageCpp
      
    method destroy = fun () -> Image.destroy t_imageCpp
      
    method create_from_color : ?color: Color.t -> int -> int -> unit =
      fun ?(color) p2 p3 -> Image.create_from_color t_imageCpp ?color p2 p3
      
    method load_from_file : string -> bool =
      fun p1 -> Image.load_from_file t_imageCpp p1
      
    method load_from_stream : System.input_stream -> bool =
      fun p1 -> Image.load_from_stream t_imageCpp p1
      
    method save_to_file : string -> bool =
      fun p1 -> Image.save_to_file t_imageCpp p1
      
    method get_height = fun () -> Image.get_height t_imageCpp
      
    method get_width = fun () -> Image.get_width t_imageCpp
      
    method create_mask_from_color : ?alpha: int -> Color.t =
      fun ?(alpha) -> Image.create_mask_from_color t_imageCpp ?alpha
      
    method copy__impl :
      ?srcRect: (int rect) -> ?alpha: bool -> t -> int -> int -> unit =
      fun ?(srcRect) ?(alpha) p3 p4 p5 ->
        Image.copy__impl t_imageCpp ?srcRect ?alpha p3 p4 p5
      
    method set_pixel : int -> int -> Color.t -> unit =
      fun p1 p2 p3 -> Image.set_pixel t_imageCpp p1 p2 p3
      
    method get_pixel : int -> int -> Color.t =
      fun p1 p2 -> Image.get_pixel t_imageCpp p1 p2
      
    method flip_horizontally = fun () -> Image.flip_horizontally t_imageCpp
      
    method flip_vertically = fun () -> Image.flip_vertically t_imageCpp
      
    (* external method create_from_pixels : int -> int -> string (* should it be a bigarray ? *) -> unit = "CreateFromPixels" *)
    (*  external method load_from_memory : string -> bool = "LoadFromMemory" *)
    (* external method get_pixels : unit -> string (* bigarray !!! *) = "GetPixelPtr" *)
    method copy =
      fun ?srcRect ?alpha src x y ->
        moiMemeMaitreDuMonde#copy__impl ?srcRect ?alpha
          (src#rep__sf_Image ()) x y
      
  end
  
let _ =
  let external_cpp_create_sf_Image t = new imageCpp t
  in
    Callback.register "external_cpp_create_sf_Image"
      external_cpp_create_sf_Image
  
class image = let t = Image.default () in imageCpp t
  
external get_maximum_size : unit -> int = "Texture_GetMaximumSize__impl"
  
module Texture =
  struct
    type t
    
    external destroy : t -> unit = "sf_texture_destroy__impl"
      
    external default : unit -> t = "sf_texture_default_constructor__impl"
      
    external create : t -> int -> int -> unit = "sf_texture_Create__impl"
      
    external load_from_file : t -> ?rect: (int rect) -> string -> unit =
      "sf_texture_LoadFromFile__impl"
      
    external load_from_stream :
      t -> ?rect: (int rect) -> System.input_stream -> unit =
      "sf_texture_LoadFromStream__impl"
      
    external load_from_image : t -> ?rect: (int rect) -> image -> unit =
      "sf_texture_LoadFromImage__impl"
      
    external get_width : t -> int = "sf_texture_GetWidth__impl"
      
    external get_height : t -> int = "sf_texture_GetHeight__impl"
      
    external copy_to_image : t -> image = "sf_texture_CopyToImage__impl"
      
    external update_from_image : t -> ?coords: (int * int) -> image -> unit =
      "sf_texture_UpdateFromImage__impl"
      
    external update_from_window :
      t ->
        (*external method load_from_memory : ?rect: int rect -> string -> unit = "LoadFromMemory" *)
        (*external method update_from_pixels : ?coords:int*int*int*int -> string  ou devrait-ce être un bigarray  -> unit = "UpdateFromPixels"*)
        ?coords: (int * int) -> (#window as 'a) -> unit =
      "sf_texture_UpdateFromWindow__impl"
      
    external bind : t -> unit = "sf_texture_Bind__impl"
      
    external unbind : t -> unit = "sf_texture_Unbind__impl"
      
    external set_smooth : t -> bool -> unit = "sf_texture_SetSmooth__impl"
      
    external is_smooth : t -> bool -> unit = "sf_texture_IsSmooth__impl"
      
    external get_tex_coords : t -> int rect -> float rect =
      "sf_texture_GetTexCoords__impl"
      
  end
  
class textureCpp t_textureCpp' =
  object val t_textureCpp = t_textureCpp'
           
    method rep__sf_texture = t_textureCpp
      
    method destroy = fun () -> Texture.destroy t_textureCpp
      
    method create : int -> int -> unit =
      fun p1 p2 -> Texture.create t_textureCpp p1 p2
      
    method load_from_file : ?rect: (int rect) -> string -> unit =
      fun ?(rect) p2 -> Texture.load_from_file t_textureCpp ?rect p2
      
    method load_from_stream :
      ?rect: (int rect) -> System.input_stream -> unit =
      fun ?(rect) p2 -> Texture.load_from_stream t_textureCpp ?rect p2
      
    method load_from_image : ?rect: (int rect) -> image -> unit =
      fun ?(rect) p2 -> Texture.load_from_image t_textureCpp ?rect p2
      
    method get_width = fun () -> Texture.get_width t_textureCpp
      
    method get_height = fun () -> Texture.get_height t_textureCpp
      
    method copy_to_image = fun () -> Texture.copy_to_image t_textureCpp
      
    method update_from_image : ?coords: (int * int) -> image -> unit =
      fun ?(coords) p2 -> Texture.update_from_image t_textureCpp ?coords p2
      
    method update_from_window :
      'a. ?coords: (int * int) -> (#window as 'a) -> unit =
      fun ?(coords) p2 -> Texture.update_from_window t_textureCpp ?coords p2
      
    method bind = fun () -> Texture.bind t_textureCpp
      
    method unbind = fun () -> Texture.unbind t_textureCpp
      
    method set_smooth : bool -> unit =
      fun p1 -> Texture.set_smooth t_textureCpp p1
      
    method is_smooth : bool -> unit =
      fun p1 -> Texture.is_smooth t_textureCpp p1
      
    method get_tex_coords : int rect -> float rect =
      fun p1 -> Texture.get_tex_coords t_textureCpp p1
      
  end
  
let _ =
  let external_cpp_create_sf_texture t = new textureCpp t
  in
    Callback.register "external_cpp_create_sf_texture"
      external_cpp_create_sf_texture
  
class texture = let t = Texture.default () in textureCpp t
  
let create_texture init =
  let t = new texture
  in
    if
      match init with
      | `File f -> t#load_from_file f
      | `Stream s -> t#load_from_stream s
      | `Memory m -> t#load_from_memory m
      | `Image img -> t#load_from_image img
    then t
    else failwith "unable to create the texture from this source"
  
type glyph = { advance : int; bounds : int rect; sub_rect : int rect }

module Font =
  struct
    type t
    
    external destroy : t -> unit = "sf_Font_destroy__impl"
      
    external default : unit -> t = "sf_Font_default_constructor__impl"
      
    external load_from_file : t -> string -> bool =
      "sf_Font_LoadFromFile__impl"
      
    external load_from_memory : t -> string -> bool =
      "sf_Font_LoadFromMemory__impl"
      
    external load_from_stream :
      t ->
        (*  constructor copy : 'b ---> pas possible ya un prob sur le type *)
        (#System.input_stream as 'a) -> bool =
      "sf_Font_LoadFromStream__impl"
      
    external get_glyph : t -> int -> int -> bool -> glyph =
      "sf_Font_GetGlyph__impl"
      
    external get_kerning : t -> int -> int -> int -> int =
      "sf_Font_GetKerning__impl"
      
    external get_line_spacing : t -> int -> int =
      "sf_Font_GetLineSpacing__impl"
      
    external get_texture : t -> int -> texture = "sf_Font_GetTexture__impl"
      
  end
  
class fontCpp t_fontCpp' =
  object ((_ : 'b))
    val t_fontCpp = t_fontCpp'
      
    method rep__sf_Font = t_fontCpp
      
    method destroy = fun () -> Font.destroy t_fontCpp
      
    method load_from_file : string -> bool =
      fun p1 -> Font.load_from_file t_fontCpp p1
      
    method load_from_memory : string -> bool =
      fun p1 -> Font.load_from_memory t_fontCpp p1
      
    method load_from_stream : 'a. (#System.input_stream as 'a) -> bool =
      fun p1 -> Font.load_from_stream t_fontCpp p1
      
    method get_glyph : int -> int -> bool -> glyph =
      fun p1 p2 p3 -> Font.get_glyph t_fontCpp p1 p2 p3
      
    method get_kerning : int -> int -> int -> int =
      fun p1 p2 p3 -> Font.get_kerning t_fontCpp p1 p2 p3
      
    method get_line_spacing : int -> int =
      fun p1 -> Font.get_line_spacing t_fontCpp p1
      
    method get_texture : int -> texture =
      fun p1 -> Font.get_texture t_fontCpp p1
      
  end
  
let _ =
  let external_cpp_create_sf_Font t = new fontCpp t
  in
    Callback.register "external_cpp_create_sf_Font"
      external_cpp_create_sf_Font
  
class font = fontCpp Font.default ()
  
let create_font init =
  let f = new font
  in
    if
      match init with
      | `File s -> f#load_from_file s
      | `Memory m -> f#load_from_memory m
      | `Stream s -> f#load_from_stream s
    then f
    else failwith "unable to initialise font from this source"
  
module Shader =
  struct
    type t
    
    external destroy : t -> unit = "sf_Shader_destroy__impl"
      
    external default : (* shader *) unit -> t =
      "sf_Shader_default_constructor__impl"
      
    external load_from_file : t -> string -> bool =
      "sf_Shader_LoadFromFile__impl"
      
    external load_from_stream :
      t ->
        (* external method load_from_memory : string -> bool = "LoadFromMemory" *)
        (#System.input_stream as 'a) -> bool =
      "sf_Shader_LoadFromStream__impl"
      
    external set_parameter1 : t -> string -> float -> unit =
      "sf_Shader_SetFloatParameter__impl"
      
    external set_parameter2 : t -> string -> float -> float -> unit =
      "sf_Shader_SetVec2Parameter__impl"
      
    external set_parameter3 :
      t -> string -> float -> float -> float -> unit =
      "sf_Shader_SetVec3Parameter__impl"
      
    external set_parameter4 :
      t -> string -> float -> float -> float -> float -> unit =
      "sf_Shader_SetVec4Parameter__byte" "sf_Shader_SetVec4Parameter__impl"
      
    external set_parameter2v : t -> string -> (float * float) -> unit =
      "sf_Shader_SetVec2ParameterV__impl"
      
    external set_parameter3v :
      t -> string -> (float * float * float) -> unit =
      "sf_Shader_SetVec3ParameterV__impl"
      
    external set_texture : t -> string -> texture -> unit =
      "sf_Shader_SetTexture__impl"
      
    external set_current_texture : t -> string -> unit =
      "sf_Shader_SetCurrentTexture__impl"
      
    external bind : t -> unit = "sf_Shader_Bind__impl"
      
    external unbind : t -> unit = "sf_Shader_Unbind__impl"
      
  end
  
class shaderCpp t_shaderCpp' =
  object (self)
    val t_shaderCpp = t_shaderCpp'
      
    method rep__sf_Shader = t_shaderCpp
      
    method destroy = fun () -> Shader.destroy t_shaderCpp
      
    method load_from_file : string -> bool =
      fun p1 -> Shader.load_from_file t_shaderCpp p1
      
    method load_from_stream : 'a. (#System.input_stream as 'a) -> bool =
      fun p1 -> Shader.load_from_stream t_shaderCpp p1
      
    method set_parameter =
      fun t name ?x ?y ?z w ->
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
      fun p1 p2 -> Shader.set_parameter1 t_shaderCpp p1 p2
      
    method set_parameter2 : string -> float -> float -> unit =
      fun p1 p2 p3 -> Shader.set_parameter2 t_shaderCpp p1 p2 p3
      
    method set_parameter3 : string -> float -> float -> float -> unit =
      fun p1 p2 p3 p4 -> Shader.set_parameter3 t_shaderCpp p1 p2 p3 p4
      
    method set_parameter4 :
      string -> float -> float -> float -> float -> unit =
      fun p1 p2 p3 p4 p5 -> Shader.set_parameter4 t_shaderCpp p1 p2 p3 p4 p5
      
    method set_parameter2v : string -> (float * float) -> unit =
      fun p1 p2 -> Shader.set_parameter2v t_shaderCpp p1 p2
      
    method set_parameter3v : string -> (float * float * float) -> unit =
      fun p1 p2 -> Shader.set_parameter3v t_shaderCpp p1 p2
      
    method set_texture : string -> texture -> unit =
      fun p1 p2 -> Shader.set_texture t_shaderCpp p1 p2
      
    method set_current_texture : string -> unit =
      fun p1 -> Shader.set_current_texture t_shaderCpp p1
      
    method bind = fun () -> Shader.bind t_shaderCpp
      
    method unbind = fun () -> Shader.unbind t_shaderCpp
      
  end
  
let _ =
  let external_cpp_create_sf_Shader t = new shaderCpp t
  in
    Callback.register "external_cpp_create_sf_Shader"
      external_cpp_create_sf_Shader
  
external is_available : unit -> unit = "Shader_IsAvailable__impl"
  
class shader = let t = Shader.default () in shaderCpp t
  
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
      
    external set_center : t -> float -> float -> unit =
      "sf_View_SetCenter__impl"
      
    external set_center_v : t -> (float * float) -> unit =
      "sf_View_SetCenterV__impl"
      
    external set_size : t -> float -> float -> unit = "sf_View_SetSize__impl"
      
    external set_size_v : t -> (float * float) -> unit =
      "sf_View_SetSizeV__impl"
      
    external set_rotation : t -> float -> unit = "sf_View_SetRotation__impl"
      
    external set_viewport : t -> float rect -> unit =
      "sf_View_SetViewport__impl"
      
    external reset : t -> float rect -> unit = "sf_View_Reset__impl"
      
    external get_center : t -> (float * float) = "sf_View_GetCenter__impl"
      
    external get_size : t -> (float * float) = "sf_View_GetSize__impl"
      
    external get_rotation : t -> float = "sf_View_GetRotation__impl"
      
    external get_viewport : t -> float rect = "sf_View_GetViewport__impl"
      
    external move : t -> float -> float -> unit = "sf_View_Move__impl"
      
    external move_v : t -> (float * float) -> unit = "sf_View_MoveV__impl"
      
    external rotate : t -> float -> unit = "sf_View_Rotate__impl"
      
    external zoom : t -> float -> unit = "sf_View_Zoom__impl"
      
  end
  
class viewCpp t_viewCpp' =
  object val t_viewCpp = t_viewCpp'
           
    method rep__sf_View = t_viewCpp
      
    method destroy = fun () -> View.destroy t_viewCpp
      
    method set_center : float -> float -> unit =
      fun p1 p2 -> View.set_center t_viewCpp p1 p2
      
    method set_center_v : (float * float) -> unit =
      fun p1 -> View.set_center_v t_viewCpp p1
      
    method set_size : float -> float -> unit =
      fun p1 p2 -> View.set_size t_viewCpp p1 p2
      
    method set_size_v : (float * float) -> unit =
      fun p1 -> View.set_size_v t_viewCpp p1
      
    method set_rotation : float -> unit =
      fun p1 -> View.set_rotation t_viewCpp p1
      
    method set_viewport : float rect -> unit =
      fun p1 -> View.set_viewport t_viewCpp p1
      
    method reset : float rect -> unit = fun p1 -> View.reset t_viewCpp p1
      
    method get_center = fun () -> View.get_center t_viewCpp
      
    method get_size = fun () -> View.get_size t_viewCpp
      
    method get_rotation = fun () -> View.get_rotation t_viewCpp
      
    method get_viewport = fun () -> View.get_viewport t_viewCpp
      
    method move : float -> float -> unit =
      fun p1 p2 -> View.move t_viewCpp p1 p2
      
    method move_v : (float * float) -> unit =
      fun p1 -> View.move_v t_viewCpp p1
      
    method rotate : float -> unit = fun p1 -> View.rotate t_viewCpp p1
      
    method zoom : float -> unit = fun p1 -> View.zoom t_viewCpp p1
      
  end
  
let _ =
  let external_cpp_create_sf_View t = new viewCpp t
  in
    Callback.register "external_cpp_create_sf_View"
      external_cpp_create_sf_View
  
(*external method get_matrix : unit -> matrix3 = "" --> matrix3
  external method get_inverse_matrix : unit -> matrix3 = ""*)
(** must be called either with param rect, either with both center and size*)
class view ?rect ?center ?size () =
  let t =
    match rect with
    | Some r -> View.create_from_rect r
    | None -> View.default ()
  in
    (*match center with
	     | Some c ->
		 (match size with
		    | Some s -> View.create_from_vectors c s
		    | None -> View.default ())
	     | None -> View.default ()*)
    viewCpp t
  
module RenderTarget =
  struct
    type t
    
    external destroy : t -> unit = "sf_RenderTarget_destroy__impl"
      
    external clear : t -> ?color: Color.t -> unit -> unit =
      "sf_RenderTarget_Clear__impl"
      
    external draw : t -> (#drawable as 'a) -> unit =
      "sf_RenderTarget_Draw__impl"
      
    external draw_with_shader : t -> shader -> (#drawable as 'a) -> unit =
      "sf_RenderTarget_DrawWithShader__impl"
      
    external get_width : t -> int = "sf_RenderTarget_GetWidth__impl"
      
    external get_height : t -> int = "sf_RenderTarget_GetHeight__impl"
      
    external set_view : t -> view -> unit = "sf_RenderTarget_SetView__impl"
      
    external get_view : t -> view = "sf_RenderTarget_GetView__impl"
      
    external get_default_view : t -> view =
      "sf_RenderTarget_GetDefaultView__impl"
      
    external get_viewport : t -> int rect =
      "sf_RenderTarget_GetViewport__impl"
      
    external convert_coords :
      t -> ?view: view -> int -> int -> (float * float) =
      "sf_RenderTarget_ConvertCoords__impl"
      
    external save_gl_states : t -> unit =
      "sf_RenderTarget_SaveGLStates__impl"
      
    external restore_gl_states : t -> unit =
      "sf_RenderTarget_RestoreGLStates__impl"
      
  end
  
class virtual render_target t_render_target' =
  object val t_render_target = t_render_target'
           
    method rep__sf_RenderTarget = t_render_target
      
    method destroy = fun () -> RenderTarget.destroy t_render_target
      
    method clear : ?color: Color.t -> unit -> unit =
      fun ?(color) p2 -> RenderTarget.clear t_render_target ?color p2
      
    method draw : 'a. (#drawable as 'a) -> unit =
      fun p1 -> RenderTarget.draw t_render_target p1
      
    method draw_with_shader : 'a. shader -> (#drawable as 'a) -> unit =
      fun p1 p2 -> RenderTarget.draw_with_shader t_render_target p1 p2
      
    method get_width = fun () -> RenderTarget.get_width t_render_target
      
    method get_height = fun () -> RenderTarget.get_height t_render_target
      
    method set_view : view -> unit =
      fun p1 -> RenderTarget.set_view t_render_target p1
      
    method get_view = fun () -> RenderTarget.get_view t_render_target
      
    method get_default_view =
      fun () -> RenderTarget.get_default_view t_render_target
      
    method get_viewport = fun () -> RenderTarget.get_viewport t_render_target
      
    method convert_coords : ?view: view -> int -> int -> (float * float) =
      fun ?(view) p2 p3 ->
        RenderTarget.convert_coords t_render_target ?view p2 p3
      
    method save_gl_states =
      fun () -> RenderTarget.save_gl_states t_render_target
      
    method restore_gl_states =
      fun () -> RenderTarget.restore_gl_states t_render_target
      
  end
  
module RenderImage =
  struct
    type t
    
    external destroy : t -> unit = "sf_RenderImage_destroy__impl"
      
    external to_render_target : t -> Render_target.t =
      "upcast__sf_RenderTarget_of_sf_RenderImage__impl"
      
    external default : unit -> t = "sf_RenderImage_default_constructor__impl"
      
    external create : t -> ?dephtBfr: bool -> int -> int -> unit =
      "sf_RenderImage_Create__impl"
      
    external set_smooth : t -> bool -> unit =
      "sf_RenderImage_SetSmooth__impl"
      
    external is_smooth : t -> bool = "sf_RenderImage_IsSmooth__impl"
      
    external set_active : t -> bool -> unit =
      "sf_RenderImage_SetActive__impl"
      
    external display : t -> unit = "sf_RenderImage_Display__impl"
      
    external get_image : t -> image = "sf_RenderImage_GetImage__impl"
      
  end
  
class render_imageCpp t_render_imageCpp' =
  object val t_render_imageCpp = t_render_imageCpp'
           
    method rep__sf_RenderImage = t_render_imageCpp
      
    method destroy = fun () -> RenderImage.destroy t_render_imageCpp
      
    inherit render_target (RenderImage.to_render_target t_render_imageCpp')
      
    method create : ?dephtBfr: bool -> int -> int -> unit =
      fun ?(dephtBfr) p2 p3 ->
        RenderImage.create t_render_imageCpp ?dephtBfr p2 p3
      
    method set_smooth : bool -> unit =
      fun p1 -> RenderImage.set_smooth t_render_imageCpp p1
      
    method is_smooth = fun () -> RenderImage.is_smooth t_render_imageCpp
      
    method set_active : bool -> unit =
      fun p1 -> RenderImage.set_active t_render_imageCpp p1
      
    method display = fun () -> RenderImage.display t_render_imageCpp
      
    method get_image = fun () -> RenderImage.get_image t_render_imageCpp
      
  end
  
let _ =
  let external_cpp_create_sf_RenderImage t = new render_imageCpp t
  in
    Callback.register "external_cpp_create_sf_RenderImage"
      external_cpp_create_sf_RenderImage
  
class render_image = render_imageCpp RenderImage.default ()
  
module RenderTexture =
  struct
    type t
    
    external destroy : t -> unit = "sf_RenderTexture_destroy__impl"
      
    external to_render_target : t -> Render_target.t =
      "upcast__sf_RenderTarget_of_sf_RenderTexture__impl"
      
    external default : unit -> t =
      "sf_RenderTexture_default_constructor__impl"
      
    external create : t -> ?dephtBfr: bool -> int -> int -> unit =
      "sf_RenderTexture_Create__impl"
      
    external set_smooth : t -> bool -> unit =
      "sf_RenderTexture_SetSmooth__impl"
      
    external is_smooth : t -> bool = "sf_RenderTexture_IsSmooth__impl"
      
    external set_active : t -> bool -> unit =
      "sf_RenderTexture_SetActive__impl"
      
    external display : t -> unit = "sf_RenderTexture_Display__impl"
      
    external get_texture : t -> texture = "sf_RenderTexture_GetTexture__impl"
      
  end
  
class render_textureCpp t_render_textureCpp' =
  object val t_render_textureCpp = t_render_textureCpp'
           
    method rep__sf_RenderTexture = t_render_textureCpp
      
    method destroy = fun () -> RenderTexture.destroy t_render_textureCpp
      
    inherit
      render_target (RenderTexture.to_render_target t_render_textureCpp')
      
    method create : ?dephtBfr: bool -> int -> int -> unit =
      fun ?(dephtBfr) p2 p3 ->
        RenderTexture.create t_render_textureCpp ?dephtBfr p2 p3
      
    method set_smooth : bool -> unit =
      fun p1 -> RenderTexture.set_smooth t_render_textureCpp p1
      
    method is_smooth = fun () -> RenderTexture.is_smooth t_render_textureCpp
      
    method set_active : bool -> unit =
      fun p1 -> RenderTexture.set_active t_render_textureCpp p1
      
    method display = fun () -> RenderTexture.display t_render_textureCpp
      
    method get_texture =
      fun () -> RenderTexture.get_texture t_render_textureCpp
      
  end
  
let _ =
  let external_cpp_create_sf_RenderTexture t = new render_textureCpp t
  in
    Callback.register "external_cpp_create_sf_RenderTexture"
      external_cpp_create_sf_RenderTexture
  
class render_texture = render_textureCpp RenderTexture.default ()
  
open Window
  
module RenderWindow =
  struct
    type t
    
    external destroy : t -> unit = "sf_RenderWindow_destroy__impl"
      
    external to_render_target : t -> Render_target.t =
      "upcast__sf_RenderTarget_of_sf_RenderWindow__impl"
      
    external to_windowCpp : t -> WindowCpp.t =
      "upcast__sf_Window_of_sf_RenderWindow__impl"
      
    external default : unit -> t =
      "sf_RenderWindow_default_constructor__impl"
      
    external create :
      ?style: (window_style list) ->
        ?context: context_settings -> VideoMode.t -> string -> t =
      "sf_RenderWindow_create_constructor__impl"
      
    external capture : t -> image = "sf_RenderWindow_Capture__impl"
      
  end
  
class render_windowCpp t_render_windowCpp' =
  object val t_render_windowCpp = t_render_windowCpp'
           
    method rep__sf_RenderWindow = t_render_windowCpp
      
    method destroy = fun () -> RenderWindow.destroy t_render_windowCpp
      
    inherit render_target (RenderWindow.to_render_target t_render_windowCpp')
      
    inherit windowCpp (RenderWindow.to_windowCpp t_render_windowCpp')
      
    method capture = fun () -> RenderWindow.capture t_render_windowCpp
      
  end
  
let _ =
  let external_cpp_create_sf_RenderWindow t = new render_windowCpp t
  in
    Callback.register "external_cpp_create_sf_RenderWindow"
      external_cpp_create_sf_RenderWindow
  
class render_window ?style ?context vm name =
  render_windowCpp RenderWindow.create ?style ?context vm name
  
module Shape =
  struct
    type t
    
    external destroy : t -> unit = "sf_Shape_destroy__impl"
      
    external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_sf_Shape__impl"
      
    external default : unit -> t = "sf_Shape_default_constructor__impl"
      
    external add_point :
      t -> ?color: Color.t -> ?outline: Color.t -> float -> float -> unit =
      "sf_Shape_AddPoint__impl"
      
    external add_point_v :
      t -> ?color: Color.t -> ?outline: Color.t -> (float * float) -> unit =
      "sf_Shape_AddPointV__impl"
      
    external get_points_count : t -> int = "sf_Shape_GetPointsCount__impl"
      
    external enable_fill : t -> bool -> unit = "sf_Shape_EnableFill__impl"
      
    external enable_outline : t -> bool -> unit =
      "sf_Shape_EnableOutline__impl"
      
    external set_point_position : t -> int -> float -> float -> unit =
      "sf_Shape_SetPointPosition__impl"
      
    external set_point_position_v : t -> int -> (float * float) -> unit =
      "sf_Shape_SetPointPositionV__impl"
      
    external set_point_color : t -> int -> Color.t -> unit =
      "sf_Shape_SetPointColor__impl"
      
    external set_point_outline_color : t -> int -> Color.t -> unit =
      "sf_Shape_SetPointOutlineColor__impl"
      
    external set_outline_thickness : t -> float -> unit =
      "sf_Shape_SetOutlineThickness__impl"
      
    external get_point_position : t -> int -> (float * float) =
      "sf_Shape_GetPointPosition__impl"
      
    external get_point_color : t -> int -> Color.t =
      "sf_Shape_GetPointColor__impl"
      
    external get_point_outline_color : t -> int -> Color.t =
      "sf_Shape_GetPointOutlineColor__impl"
      
    external get_outline_thickness : t -> float =
      "sf_Shape_GetOutlineThickness__impl"
      
  end
  
class shapeCpp t_shapeCpp' =
  object val t_shapeCpp = t_shapeCpp'
           
    method rep__sf_Shape = t_shapeCpp
      
    method destroy = fun () -> Shape.destroy t_shapeCpp
      
    inherit drawable (Shape.to_drawable t_shapeCpp')
      
    method add_point :
      ?color: Color.t -> ?outline: Color.t -> float -> float -> unit =
      fun ?(color) ?(outline) p3 p4 ->
        Shape.add_point t_shapeCpp ?color ?outline p3 p4
      
    method add_point_v :
      ?color: Color.t -> ?outline: Color.t -> (float * float) -> unit =
      fun ?(color) ?(outline) p3 ->
        Shape.add_point_v t_shapeCpp ?color ?outline p3
      
    method get_points_count = fun () -> Shape.get_points_count t_shapeCpp
      
    method enable_fill : bool -> unit =
      fun p1 -> Shape.enable_fill t_shapeCpp p1
      
    method enable_outline : bool -> unit =
      fun p1 -> Shape.enable_outline t_shapeCpp p1
      
    method set_point_position : int -> float -> float -> unit =
      fun p1 p2 p3 -> Shape.set_point_position t_shapeCpp p1 p2 p3
      
    method set_point_position_v : int -> (float * float) -> unit =
      fun p1 p2 -> Shape.set_point_position_v t_shapeCpp p1 p2
      
    method set_point_color : int -> Color.t -> unit =
      fun p1 p2 -> Shape.set_point_color t_shapeCpp p1 p2
      
    method set_point_outline_color : int -> Color.t -> unit =
      fun p1 p2 -> Shape.set_point_outline_color t_shapeCpp p1 p2
      
    method set_outline_thickness : float -> unit =
      fun p1 -> Shape.set_outline_thickness t_shapeCpp p1
      
    method get_point_position : int -> (float * float) =
      fun p1 -> Shape.get_point_position t_shapeCpp p1
      
    method get_point_color : int -> Color.t =
      fun p1 -> Shape.get_point_color t_shapeCpp p1
      
    method get_point_outline_color : int -> Color.t =
      fun p1 -> Shape.get_point_outline_color t_shapeCpp p1
      
    method get_outline_thickness =
      fun () -> Shape.get_outline_thickness t_shapeCpp
      
  end
  
let _ =
  let external_cpp_create_sf_Shape t = new shapeCpp t
  in
    Callback.register "external_cpp_create_sf_Shape"
      external_cpp_create_sf_Shape
  
class shape = let t = Shape.default () in shapeCpp t
  
module Text =
  struct
    type t
    
    external destroy : t -> unit = "sf_Text_destroy__impl"
      
    external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_sf_Text__impl"
      
    external default :
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
        unit -> t =
      "sf_Text_default_constructor__impl"
      
    external create : string -> font -> int -> t =
      "sf_Text_init_constructor__impl"
      
    external set_string : t -> string -> unit = "sf_Text_SetString__impl"
      
    external set_font : t -> font -> unit = "sf_Text_SetFont__impl"
      
    external set_character_size : t -> int -> unit =
      "sf_Text_SetCharacterSize__impl"
      
    external set_style : t -> style list -> unit = "sf_Text_SetStyle__impl"
      
    external get_string : t -> string = "sf_Text_GetString__impl"
      
    external get_font : t -> font = "sf_Text_GetFont__impl"
      
    external get_character_size : t -> int = "sf_Text_GetCharacterSize__impl"
      
    external get_style : t -> style list = "sf_Text_GetStyle__impl"
      
    external get_character_pos : t -> int -> (float * float) =
      "sf_Text_GetCharacterPos__impl"
      
    external get_rect : t -> float rect = "sf_Text_GetRect__impl"
      
  end
  
class textCpp t_textCpp' =
  object val t_textCpp = t_textCpp'
           
    method rep__sf_Text = t_textCpp
      
    method destroy = fun () -> Text.destroy t_textCpp
      
    inherit drawable (Text.to_drawable t_textCpp')
      
    method set_string : string -> unit =
      fun p1 -> Text.set_string t_textCpp p1
      
    method set_font : font -> unit = fun p1 -> Text.set_font t_textCpp p1
      
    method set_character_size : int -> unit =
      fun p1 -> Text.set_character_size t_textCpp p1
      
    method set_style : style list -> unit =
      fun p1 -> Text.set_style t_textCpp p1
      
    method get_string = fun () -> Text.get_string t_textCpp
      
    method get_font = fun () -> Text.get_font t_textCpp
      
    method get_character_size = fun () -> Text.get_character_size t_textCpp
      
    method get_style = fun () -> Text.get_style t_textCpp
      
    method get_character_pos : int -> (float * float) =
      fun p1 -> Text.get_character_pos t_textCpp p1
      
    method get_rect = fun () -> Text.get_rect t_textCpp
      
  end
  
let _ =
  let external_cpp_create_sf_Text t = new textCpp t
  in
    Callback.register "external_cpp_create_sf_Text"
      external_cpp_create_sf_Text
  
class text = let t = Text.default () in textCpp t
  
module Sprite =
  struct
    type t
    
    external destroy : t -> unit = "sf_Sprite_destroy__impl"
      
    external to_drawable : t -> Drawable.t =
      "upcast__sf_Drawable_of_sf_Sprite__impl"
      
    external default : unit -> t = "sf_Sprite_default_constructor__impl"
      
    external create_from_texture : texture -> t =
      "sf_Sprite_texture_constructor__impl"
      
    external set_texture : t -> texture -> unit =
      "sf_Sprite_SetTexture__impl"
      
    external set_sub_rect : t -> int rect -> unit =
      "sf_Sprite_SetSubRect__impl"
      
    external resize : t -> float -> float -> unit = "sf_Sprite_Resize__impl"
      
    external resize_v : t -> (float * float) -> unit =
      "sf_Sprite_ResizeV__impl"
      
    external flip_x : t -> bool -> unit = "sf_Sprite_FlipX__impl"
      
    external flip_y : t -> bool -> unit = "sf_Sprite_FlipY__impl"
      
    external get_texture : t -> texture = "sf_Sprite_GetTexture__impl"
      
    external get_sub_rect : t -> int rect = "sf_Sprite_GetSubRect__impl"
      
    external get_size : t -> (float * float) = "sf_Sprite_GetSize__impl"
      
  end
  
class spriteCpp t_spriteCpp' =
  object val t_spriteCpp = t_spriteCpp'
           
    method rep__sf_Sprite = t_spriteCpp
      
    method destroy = fun () -> Sprite.destroy t_spriteCpp
      
    inherit drawable (Sprite.to_drawable t_spriteCpp')
      
    method set_texture : texture -> unit =
      fun p1 -> Sprite.set_texture t_spriteCpp p1
      
    method set_sub_rect : int rect -> unit =
      fun p1 -> Sprite.set_sub_rect t_spriteCpp p1
      
    method resize : float -> float -> unit =
      fun p1 p2 -> Sprite.resize t_spriteCpp p1 p2
      
    method resize_v : (float * float) -> unit =
      fun p1 -> Sprite.resize_v t_spriteCpp p1
      
    method flip_x : bool -> unit = fun p1 -> Sprite.flip_x t_spriteCpp p1
      
    method flip_y : bool -> unit = fun p1 -> Sprite.flip_y t_spriteCpp p1
      
    method get_texture = fun () -> Sprite.get_texture t_spriteCpp
      
    method get_sub_rect = fun () -> Sprite.get_sub_rect t_spriteCpp
      
    method get_size = fun () -> Sprite.get_size t_spriteCpp
      
  end
  
let _ =
  let external_cpp_create_sf_Sprite t = new spriteCpp t
  in
    Callback.register "external_cpp_create_sf_Sprite"
      external_cpp_create_sf_Sprite
  
class sprite = let t = Sprite.default () in spriteCpp t
  

