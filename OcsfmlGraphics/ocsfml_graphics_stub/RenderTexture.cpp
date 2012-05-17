#include "RenderTexture.hpp"

#include "RenderTarget.hpp"
#include "Texture.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>

bool render_texture_create_helper( sf::RenderTexture* rI, camlpp::optional<bool> depthBfr, unsigned w, unsigned h)
{
  return rI->create( w, h, depthBfr.get_value_no_fail( false ) );
}

bool render_texture_set_active_helper( sf::RenderTexture* rI, camlpp::optional<bool> active, camlpp::unit )
{
  return rI->setActive( active.get_value_no_fail( true ) );
}

sf::Texture const* render_texture_get_texture_helper(sf::RenderTexture* rT )
{
  return &rT->getTexture();
}

#define CAMLPP__CLASS_NAME() sf_RenderTexture
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_RenderTarget );
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_external_method3( create, &render_texture_create_helper, 0);
  camlpp__register_method1( setSmooth, 0);
  camlpp__register_method0( isSmooth, 0);
  camlpp__register_external_method2( setActive, &render_texture_set_active_helper, 0);
  camlpp__register_method0( display, camlpp::release_caml_runtime);
  camlpp__register_external_method0( getTexture, &render_texture_get_texture_helper, 0);
}
#undef CAMLPP__CLASS_NAME
