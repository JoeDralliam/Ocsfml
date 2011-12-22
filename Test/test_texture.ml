open OcsfmlWindow
open OcsfmlGraphics


let _ =
  let context = new context in
  let render_texture = new render_texture in
  if not (render_texture#create 800 600)
  then failwith "Could not create render texture";
  render_texture#clear () ;
  render_texture#display () ;
  render_texture#display () ;
  ignore ( render_texture#get_texture () ) ;
 (* let image = (render_texture#get_texture ())#copy_to_image () in
  image#destroy () ; *)
  render_texture#destroy () ;
  context#destroy ()
