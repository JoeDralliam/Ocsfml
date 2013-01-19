#include "Texture.hpp"

#include "InputStream.hpp"
#include "RawDataType.hpp"
#include "Vector.hpp"

#include "Window.hpp"

#include "Image.hpp"
#include "Rect.hpp"

#include <camlpp/stub_generator.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/big_array.hpp>
#include <camlpp/unit.hpp>
#include <camlpp/std/string.hpp>

namespace
{
  bool texture_load_from_file_helper( sf::Texture* text, camlpp::optional<sf::IntRect> area, std::string filename )
  {
    return text->loadFromFile( filename, area.get_value_no_fail( sf::IntRect() ) );
  }
  
  bool texture_load_from_stream_helper( sf::Texture* text, camlpp::optional<sf::IntRect> area, sf::InputStream& stream )
  {
    return text->loadFromStream( stream, area.get_value_no_fail( sf::IntRect() ) );
  }
  
  bool texture_load_from_image_helper( sf::Texture* text, camlpp::optional<sf::IntRect> area, sf::Image const& image)
  {
    return text->loadFromImage( image , area.get_value_no_fail( sf::IntRect() ) );
  }
  
  
  bool texture_load_from_memory_helper( sf::Texture* text, camlpp::optional<sf::IntRect> area, RawDataType d)
  {
    return text->loadFromMemory( d.data, d.size[0], area.get_value_no_fail( sf::IntRect() ) );
  }
  
  
  void texture_update_from_pixels_helper( sf::Texture* tex, camlpp::optional<sf::Vector2<unsigned int> > p, camlpp::big_array<sf::Uint8, 3> const& pixels)
  {
    if(p.is_some())
      {
	tex->update( pixels.data, pixels.size[0], pixels.size[1], p.get_value().x, p.get_value().y );
      }
    else
      {
	tex->update( pixels.data );
      }
  }
  
  void texture_update_from_image_helper( sf::Texture* tex, camlpp::optional<sf::Vector2<unsigned int> > p, sf::Image const& img)
  {
    if(p.is_some())
      {
	tex->update( img, p.get_value().x, p.get_value().y );
      }
    else
      {
	tex->update( img );
      }
  }
  
  void texture_update_from_window_helper( sf::Texture* tex, camlpp::optional<sf::Vector2<unsigned int> > p, sf::Window const& wdw)
  {
    if(p.is_some())
      {
	tex->update( wdw, p.get_value().x, p.get_value().y );
      }
    else
      {
	tex->update( wdw );
      }
  }

  void Texture_bind( camlpp::optional<sf::Texture*> tex, camlpp::optional<sf::Texture::CoordinateType> coordinateType, camlpp::unit)
  {
      sf::Texture::bind( tex.get_value_no_fail(0), coordinateType.get_value_no_fail( sf::Texture::Normalized ) );
  }
}
  
#define CAMLPP__CLASS_NAME() sf_Texture
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_constructor1( copy_constructor, sf::Texture const&, 0);
  camlpp__register_external_method1( affect, &sf::Texture::operator=, 0);
  camlpp__register_method2( create, 0);
  camlpp__register_external_method2( loadFromFile, &texture_load_from_file_helper, camlpp::release_caml_runtime);
  camlpp__register_external_method2( loadFromStream, &texture_load_from_stream_helper, 0);
  camlpp__register_external_method2( loadFromImage, &texture_load_from_image_helper, 0);
  camlpp__register_external_method2( loadFromMemory, &texture_load_from_memory_helper, 0);
  camlpp__register_method0( getSize, 0);
  camlpp__register_method0( copyToImage, 0);
  camlpp__register_external_method2( updateFromPixels, &texture_update_from_pixels_helper, 0);
  camlpp__register_external_method2( updateFromImage , &texture_update_from_image_helper, 0);
  camlpp__register_external_method2( updateFromWindow, &texture_update_from_window_helper, 0);
  camlpp__register_method1( setSmooth, 0);
  camlpp__register_method0( isSmooth, 0);
  camlpp__register_method1( setRepeated, 0);
  camlpp__register_method0( isRepeated, 0);
} 
#undef CAMLPP__CLASS_NAME


extern "C"
{
  camlpp__register_free_function3( Texture_bind, 0);
  camlpp__register_overloaded_free_function0( Texture_getMaximumSize, &sf::Texture::getMaximumSize, 0)
}
