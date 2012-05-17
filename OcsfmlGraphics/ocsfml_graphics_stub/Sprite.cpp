#include "Sprite.hpp"

#include "Vector.hpp"

#include "Color.hpp"
#include "Drawable.hpp"
#include "Rect.hpp"
#include "Texture.hpp"
#include "Transformable.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>

void sprite_set_texture_helper( sf::Sprite* spr, camlpp::optional<bool> resize, sf::Texture const& texture )
{
  spr->setTexture( texture, resize.get_value_no_fail( false ) );
}

camlpp::optional<sf::Texture const*> sprite_get_texture_helper( sf::Sprite const* spr )
{
  sf::Texture const* res = spr->getTexture();
  return (res ? camlpp::some(res) : camlpp::none<sf::Texture const*>());
}

#define CAMLPP__CLASS_NAME() sf_Sprite
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_inheritance_relationship( sf_Transformable );
  camlpp__register_constructor0( default_constructor, 0 );
  camlpp__register_constructor1( texture_constructor, sf::Texture const&, 0);
  camlpp__register_external_method2( setTexture, &sprite_set_texture_helper, 0 );
  camlpp__register_method1( setTextureRect, 0);
  camlpp__register_method1( setColor, 0);
  camlpp__register_external_method0( getTexture, &sprite_get_texture_helper, 0);
  camlpp__register_method0( getTextureRect, 0);
  camlpp__register_method0( getColor, 0);
  camlpp__register_method0( getLocalBounds, 0);
  camlpp__register_method0( getGlobalBounds, 0);
}
#undef CAMLPP__CLASS_NAME
