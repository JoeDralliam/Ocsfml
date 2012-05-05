#include "Image.hpp"

#include "InputStream.hpp"
#include "RawDataType.hpp"
#include "Vector.hpp"

#include "Color.hpp"
#include "Rect.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/big_array.hpp>
#include <camlpp/std/string.hpp>

namespace
{
  void image_create_with_opt_color_helper( sf::Image* image, camlpp::optional<sf::Color> color, unsigned w, unsigned h)
  {
    image->create(w, h, color.get_value_no_fail( sf::Color(0, 0, 0) ) );
  }
  
  void image_create_from_pixels( sf::Image* image, camlpp::big_array<sf::Uint8, 3> const& pixels)
  {
    assert(pixels.size[2] == 4);
    image->create( pixels.size[0], pixels.size[1], pixels.data );
  }

  void image_create_mask_from_color_helper( sf::Image* image, camlpp::optional<sf::Uint8> alpha, sf::Color color)
  {
    image->createMaskFromColor( color, alpha.get_value_no_fail( 0 ) );
  }

  void image_load_from_memory_helper( sf::Image* image, RawDataType d)
  {
    image->loadFromMemory( d.data, d.size[0] );
  }

  void image_copy_helper( sf::Image* img, camlpp::optional<sf::IntRect> srcRect, camlpp::optional<bool> applyAlpha, sf::Image const& src, unsigned destX, unsigned destY)
  {
    img->copy( 	src, destX, destY, 
		srcRect.get_value_no_fail( sf::IntRect(0,0,0,0) ),
		applyAlpha.get_value_no_fail( false ) );
  }

  camlpp::big_array<sf::Uint8, 3> image_get_pixels_ptr_helper( sf::Image* img )
  {
    long size[] = { img->getSize().x, img->getSize().y, 4};
    return camlpp::big_array<sf::Uint8, 3>(const_cast<sf::Uint8*>(img->getPixelsPtr()),  size);
  }
}


#define CAMLPP__CLASS_NAME() sf_Image
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_external_method3( createFromColor, &image_create_with_opt_color_helper );
  camlpp__register_external_method1( createFromPixels, &image_create_from_pixels );
  camlpp__register_method1( loadFromFile );
  camlpp__register_external_method1( loadFromMemory, &image_load_from_memory_helper );
  camlpp__register_method1( loadFromStream );
  camlpp__register_method1( saveToFile );
  camlpp__register_method0( getSize );
  camlpp__register_external_method2( createMaskFromColor, &image_create_mask_from_color_helper );
  camlpp__register_external_method5( copy, &image_copy_helper );
  camlpp__register_method3( setPixel );
  camlpp__register_method2( getPixel );
  camlpp__register_external_method0( getPixelsPtr, &image_get_pixels_ptr_helper );
  camlpp__register_method0( flipHorizontally );
  camlpp__register_method0( flipVertically );
}
#undef CAMLPP__CLASS_NAME
