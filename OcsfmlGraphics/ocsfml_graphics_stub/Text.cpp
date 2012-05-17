#include "Text.hpp"

#include "Vector.hpp"

#include "Window.hpp"

#include "Color.hpp"
#include "Drawable.hpp"
#include "Font.hpp"
#include "Rect.hpp"
#include "Transformable.hpp"

#include <SFML/System/Utf.hpp>

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/cstring.hpp>
#include <camlpp/std/list.hpp>
#include <camlpp/std/string.hpp>

namespace
{
  sf::Text* text_constructor_helper( camlpp::optional<sf::Font const*> font, camlpp::optional<unsigned> characterSize, char* str)
  {
    return new sf::Text( 	sf::String(str),
				font.is_some() ? *font.get_value() : sf::Font::getDefaultFont(), 
				characterSize.get_value_no_fail( 30 ) );
  }

  void text_set_string_helper( sf::Text* txt, camlpp::c_string latin1Str)
  {
    sf::String s(std::string(latin1Str.size, ' '));
    sf::Utf<8>::toUtf32( latin1Str.string, latin1Str.string+latin1Str.size, s.begin() );
    txt->setString( s );
  }

  std::string text_get_string_helper( sf::Text const* txt )
  {
    return txt->getString().toAnsiString();
  }

  void text_set_style_helper( sf::Text* txt, std::list<unsigned long> style)
  {
    txt->setStyle( style_of_list_unsigned( style ) );
  }

  std::list<unsigned long> text_get_style_helper( sf::Text* txt )
  {
    unsigned long style = txt->getStyle();
    std::list<unsigned long> res;
    for(int i = 0; i < 2; ++i)
      {
	if(style & (1 << i))
	  {
	    res.push_back(i);
	  }
      }
    return std::move(res);
  }
}
#define CAMLPP__CLASS_NAME() sf_Text
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_inheritance_relationship( sf_Transformable );
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_external_constructor3( init_constructor, &text_constructor_helper, 0);
  camlpp__register_external_method1( setString, &text_set_string_helper, 0);
  camlpp__register_method1( setFont, 0);
  camlpp__register_method1( setCharacterSize, 0);
  camlpp__register_external_method1( setStyle, &text_set_style_helper, 0);
  camlpp__register_method1( setColor, 0);
  camlpp__register_external_method0( getString, &text_get_string_helper, 0);
  camlpp__register_method0( getFont, 0);
  camlpp__register_method0( getCharacterSize, 0);
  camlpp__register_external_method0( getStyle, &text_get_style_helper, 0);
  camlpp__register_method0( getColor, 0);
  camlpp__register_method1( findCharacterPos, 0);
  camlpp__register_method0( getLocalBounds, 0);
  camlpp__register_method0( getGlobalBounds, 0);
}
#undef CAMLPP__CLASS_NAME
