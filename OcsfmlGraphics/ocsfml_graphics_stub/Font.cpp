#include "Font.hpp"

#include "RawDataType.hpp"
#include "InputStream.hpp"

#include "Glyph.hpp"
#include "Texture.hpp"

#include <camlpp/stub_generator.hpp>
#include <camlpp/std/string.hpp>


namespace
{
  bool font_load_from_memory_helper( sf::Font* font, RawDataType const& mem )
  {
    return font->loadFromMemory( mem.data, mem.size[0] );
  }
} 
  
typedef sf::Font sf_Font;
#define CAMLPP__CLASS_NAME() sf_Font
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( copy_constructor, sf::Font const& );
  camlpp__register_method1( loadFromFile );
  camlpp__register_external_method1( loadFromMemory, &font_load_from_memory_helper );
  camlpp__register_method1( loadFromStream );
  camlpp__register_method3( getGlyph );
  camlpp__register_method3( getKerning );
  camlpp__register_method1( getLineSpacing );
  camlpp__register_method1( getTexture );
  camlpp__register_external_method1( affect, &sf::Font::operator= );
}
#undef CAMLPP__CLASS_NAME

extern "C"
{
  camlpp__register_overloaded_free_function0( getDefaultFont, &sf::Font::getDefaultFont)
}
