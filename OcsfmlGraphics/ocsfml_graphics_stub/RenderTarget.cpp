#include "RenderTarget.hpp"

#include "Vector.hpp"

#include "BlendMode.hpp"
#include "Color.hpp"
#include "Drawable.hpp"
#include "Rect.hpp"
#include "Shader.hpp"
#include "Texture.hpp"
#include "Transform.hpp"
#include "View.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>

#include <SFML/Graphics/RenderStates.hpp>

namespace
{
  void render_target_clear_helper( sf::RenderTarget* target, camlpp::optional<sf::Color> color, camlpp::unit )
  {
    return target->clear( color.get_value_no_fail( sf::Color(0, 0, 0, 255) ) );
  }

  sf::Vector2f render_target_convert_coords_helper( sf::RenderTarget* target, camlpp::optional<sf::View const*> opt, sf::Vector2i const& point)
  {
    if( opt.is_some() )
      {
	return target->convertCoords(point, *opt.get_value() );
      }
    return target->convertCoords(point);
  }

  void render_target_draw_helper( sf::RenderTarget* target,
				  /*camlpp::optional< sf::RenderStates > rs , */
				  camlpp::optional< sf::BlendMode > blend,
				  camlpp::optional< sf::Transform const* > transform,
				  camlpp::optional< sf::Texture const* > text,
				  camlpp::optional< sf::Shader const* > shader,
				  sf::Drawable const& drawable)
  {
    sf::RenderStates const& def = sf::RenderStates::Default;
    target->draw
      (
       drawable,
       // rs.get_value_no_fail( def )
       sf::RenderStates
       (
	blend.get_value_no_fail( def.blendMode ),
	*transform.get_value_no_fail( &def.transform ),
	text.get_value_no_fail( def.texture ),
	shader.get_value_no_fail( def.shader )
	)
       );
  }

  /*  
      void render_target_draw_prim_helper( sf::RenderTarget* target, 
      const 
      unsigned verticesCount,
      PrimitiveType type, 
      camlpp::optional< sf::RenderStates const* > states )
      {
      }  
  */


  sf::View const* render_target_get_view_helper( sf::RenderTarget* target )
  {
    return &target->getView();
  }

  sf::View const* render_target_get_default_view_helper( sf::RenderTarget* target )
  {
    return &target->getDefaultView();
  }
}

#define CAMLPP__CLASS_NAME() sf_RenderTarget
camlpp__register_preregistered_custom_class()
{
  camlpp__register_external_method2( clear, &render_target_clear_helper, camlpp::release_caml_runtime );
  camlpp__register_external_method5( draw, &render_target_draw_helper, camlpp::release_caml_runtime );
  //	camlpp__register_method2( DrawPrimitives, &render_target_draw_prim_helper );
  camlpp__register_method0( getSize, 0);
  camlpp__register_method1( setView, 0);
  camlpp__register_external_method0( getView, &render_target_get_view_helper, 0);
  camlpp__register_external_method0( getDefaultView, &render_target_get_default_view_helper, 0);
  camlpp__register_method1( getViewport, 0);
  camlpp__register_external_method2( convertCoords, &render_target_convert_coords_helper, 0);
  camlpp__register_method0( pushGLStates, camlpp::release_caml_runtime);
  camlpp__register_method0( popGLStates, camlpp::release_caml_runtime);
  camlpp__register_method0( resetGLStates, camlpp::release_caml_runtime);
}
#undef CAMLPP__CLASS_NAME
