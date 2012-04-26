#include "ocsfml_graphics_stub.hpp"
#include <SFML/Graphics.hpp>

#include <camlpp/custom_conversion.hpp>
#include <camlpp/custom_class.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>
#include <camlpp/custom_ops.hpp>
#include <camlpp/big_array.hpp>

custom_struct_affectation(	 sf::FloatRect,
				&sf::FloatRect::left,
				&sf::FloatRect::top,
				&sf::FloatRect::width,
				&sf::FloatRect::height ); 

custom_struct_conversion(	 sf::FloatRect,
				&sf::FloatRect::left,
				&sf::FloatRect::top,
				&sf::FloatRect::width,
				&sf::FloatRect::height );

custom_struct_affectation(	 sf::IntRect,
				&sf::IntRect::left,
				&sf::IntRect::top,
				&sf::IntRect::width,
				&sf::IntRect::height );

custom_struct_conversion(	 sf::IntRect,
				&sf::IntRect::left,
				&sf::IntRect::top,
				&sf::IntRect::width,
				&sf::IntRect::height );

custom_struct_affectation(	 sf::Color,
				&sf::Color::r,
				&sf::Color::g,
				&sf::Color::b,
				&sf::Color::a );

custom_struct_conversion(	 sf::Color,
				&sf::Color::r,
				&sf::Color::g,
				&sf::Color::b,
				&sf::Color::a );

bool color_is_equal( sf::Color const& a, sf::Color const& b)
{
  return a == b;
}

bool color_is_not_equal( sf::Color const& a, sf::Color const& b)
{
  return a != b;
}

sf::Color color_add( sf::Color const& a, sf::Color const& b)
{
  return a + b;
}

sf::Color color_multiply( sf::Color const& a, sf::Color const& b)
{
  return a * b;
}

extern "C"
{
  camlpp__register_free_function2( color_is_equal )
  camlpp__register_free_function2( color_is_not_equal )
  camlpp__register_free_function2( color_add )
  camlpp__register_free_function2( color_multiply )
}

#include <SFML/Graphics/Transformable.hpp>

void image_create_with_opt_color_helper( sf::Image* image, Optional<sf::Color> color, unsigned w, unsigned h)
{
  image->create(w, h, color.get_value_no_fail( sf::Color(0, 0, 0) ) );
}

void image_create_from_pixels( sf::Image* image, BigarrayInterface<sf::Uint8, 3> const& pixels)
{
  assert(pixels.size[2] == 4);
  image->create( pixels.size[0], pixels.size[1], pixels.data );
}

void image_create_mask_from_color_helper( sf::Image* image, Optional<sf::Uint8> alpha, sf::Color color)
{
  image->createMaskFromColor( color, alpha.get_value_no_fail( 0 ) );
}

void image_load_from_memory_helper( sf::Image* image, RawDataType d)
{
  image->loadFromMemory( d.data, d.size[0] );
}

void image_copy_helper( sf::Image* img, Optional<sf::IntRect> srcRect, Optional<bool> applyAlpha, sf::Image const& src, unsigned destX, unsigned destY)
{
  img->copy( 	src, destX, destY, 
		srcRect.get_value_no_fail( sf::IntRect(0,0,0,0) ),
		applyAlpha.get_value_no_fail( false ) );
}

BigarrayInterface<sf::Uint8, 3> image_get_pixels_ptr_helper( sf::Image* img )
{
  long size[] = { img->getSize().x, img->getSize().y, 4};
  return BigarrayInterface<sf::Uint8, 3>(const_cast<sf::Uint8*>(img->getPixelsPtr()),  size);
}


typedef sf::Image sf_Image;
#define CAMLPP__CLASS_NAME() sf_Image
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
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
  camlpp__register_external_method0( getPixelsPtr, &image_get_pixels_ptr_helper )
  camlpp__register_method0( flipHorizontally );
  camlpp__register_method0( flipVertically );
}
#undef CAMLPP__CLASS_NAME

custom_enum_conversion( sf::Texture::CoordinateType );
custom_enum_affectation(sf::Texture::CoordinateType );



bool texture_load_from_file_helper( sf::Texture* text, Optional<sf::IntRect> area, std::string filename )
{
  return text->loadFromFile( filename, area.get_value_no_fail( sf::IntRect() ) );
}

bool texture_load_from_stream_helper( sf::Texture* text, Optional<sf::IntRect> area, sf::InputStream& stream )
{
  return text->loadFromStream( stream, area.get_value_no_fail( sf::IntRect() ) );
}

bool texture_load_from_image_helper( sf::Texture* text, Optional<sf::IntRect> area, sf::Image const& image)
{
  return text->loadFromImage( image , area.get_value_no_fail( sf::IntRect() ) );
}


bool texture_load_from_memory_helper( sf::Texture* text, Optional<sf::IntRect> area, RawDataType d)
{
  return text->loadFromMemory( d.data, d.size[0], area.get_value_no_fail( sf::IntRect() ) );
}


void texture_update_from_pixels_helper( sf::Texture* tex, Optional<sf::Vector2<unsigned int> > p, BigarrayInterface<sf::Uint8, 3> const& pixels)
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

void texture_update_from_image_helper( sf::Texture* tex, Optional<sf::Vector2<unsigned int> > p, sf::Image const& img)
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

void texture_update_from_window_helper( sf::Texture* tex, Optional<sf::Vector2<unsigned int> > p, sf::Window const& img)
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
void texture_bind_helper( sf::Texture* tex, Optional<sf::Texture::CoordinateType> coordinateType )
{
  tex->bind( coordinateType.get_value_no_fail( sf::Texture::Normalized ) );
}
typedef sf::Texture sf_Texture;
#define CAMLPP__CLASS_NAME() sf_Texture
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( copy_constructor, sf::Texture const& );
  camlpp__register_method2( create );
  camlpp__register_external_method2( loadFromFile, &texture_load_from_file_helper );
  camlpp__register_external_method2( loadFromStream, &texture_load_from_stream_helper );
  camlpp__register_external_method2( loadFromImage, &texture_load_from_image_helper );
  camlpp__register_external_method2( loadFromMemory, &texture_load_from_memory_helper );
  camlpp__register_method0( getSize );
  camlpp__register_method0( copyToImage );
  camlpp__register_external_method2( updateFromPixels, &texture_update_from_pixels_helper );
  camlpp__register_external_method2( updateFromImage , &texture_update_from_image_helper );
  camlpp__register_external_method2( updateFromWindow, &texture_update_from_window_helper );
  camlpp__register_method1( bind );
  camlpp__register_method1( setSmooth );
  camlpp__register_method0( isSmooth );
  camlpp__register_method1( setRepeated );
  camlpp__register_method0( isRepeated );
} 
#undef CAMLPP__CLASS_NAME

extern "C"
{
  camlpp__register_overloaded_free_function0( Texture_getMaximumSize, &sf::Texture::getMaximumSize)
}



custom_enum_affectation(sf::BlendMode );
custom_enum_conversion( sf::BlendMode );

typedef sf::Vector2f (sf::Transform::*TransformPointFunc)(float,float) const;
typedef sf::Vector2f (sf::Transform::*TransformPointVFunc)(sf::Vector2f const&) const;

void transform_translate_helper(sf::Transform* t, float x, float y)
{
  t->translate(x,y);
}

void transform_translateV_helper(sf::Transform* t, sf::Vector2f v)
{
  t->translate(v);
}

void transform_rotate_helper(sf::Transform* t, Optional< float > x, Optional<float> y, float degrees)
{
  if(x.is_some() && y.is_some())
    {
      t->rotate(degrees, x.get_value(), y.get_value());
    }
  else
    {
      t->rotate(degrees);
    }
}

void transform_rotateV_helper(sf::Transform* t, Optional< sf::Vector2f > v, float degrees)
{
  if(v.is_some())
    {
      t->rotate(degrees, v.get_value());
    }
  else
    {
      t->rotate(degrees);
    }
}

void transform_scale_helper(sf::Transform* t, Optional< float > x, Optional<float> y, float scaleX, float scaleY)
{
  if(x.is_some() && y.is_some())
    {
      t->scale(scaleX, scaleY, x.get_value(), y.get_value());
    }
  else
    {
      t->scale(scaleX, scaleY);
    }
}

void transform_scaleV_helper(sf::Transform* t, Optional< sf::Vector2f > v, sf::Vector2f scale)
{
  if(v.is_some())
    {
      t->scale(scale, v.get_value());
    }
  else
    {
      t->scale(scale);
    }
}

typedef sf::Transform sf_Transform;
#define CAMLPP__CLASS_NAME() sf_Transform
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor9( matrix_constructor,
				 float, float, float,
				 float, float, float,
				 float, float, float );
  camlpp__register_method0( getInverse );
  camlpp__register_external_method2( transformPoint, ((TransformPointFunc) &sf::Transform::transformPoint) );
  camlpp__register_external_method1( transformPointV, ((TransformPointVFunc) &sf::Transform::transformPoint) );
  camlpp__register_method1( transformRect );
  camlpp__register_method1( combine );
  camlpp__register_external_method2( translate, &transform_translate_helper );
  camlpp__register_external_method1( translateV, &transform_translateV_helper );
  camlpp__register_external_method3( rotate, &transform_rotate_helper );
  camlpp__register_external_method2( rotateV, &transform_rotateV_helper );
  camlpp__register_external_method4( scale, &transform_scale_helper );
  camlpp__register_external_method2( scaleV, &transform_scaleV_helper );
}
#undef CAMLPP__CLASS_NAME



typedef sf::Drawable sf_Drawable;
#define CAMLPP__CLASS_NAME() sf_Drawable
camlpp__register_custom_class()
{}
#undef CAMLPP__CLASS_NAME


typedef sf::Transformable sf_Transformable;
typedef void (sf_Transformable::* Transfo2f)(float, float);
typedef void (sf_Transformable::* TransfoVf)(sf::Vector2f const&);


#define CAMLPP__CLASS_NAME() sf_Transformable
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor )
  camlpp__register_external_method2( setPosition, ((Transfo2f)&sf::Transformable::setPosition) );
  camlpp__register_external_method1( setPositionV, ((TransfoVf)&sf::Transformable::setPosition) );
  camlpp__register_external_method2( setScale, ((Transfo2f)&sf::Transformable::setScale) );
  camlpp__register_external_method1( setScaleV, ((TransfoVf)&sf::Transformable::setScale) );
  camlpp__register_external_method2( setOrigin, ((Transfo2f)&sf::Transformable::setOrigin) );
  camlpp__register_external_method1( setOriginV, ((TransfoVf)&sf::Transformable::setOrigin) );
  camlpp__register_method1( setRotation );
  camlpp__register_method0( getPosition );
  camlpp__register_method0( getScale );
  camlpp__register_method0( getOrigin );
  camlpp__register_method0( getRotation );
  camlpp__register_external_method2( move, ((Transfo2f)&sf::Transformable::move) );
  camlpp__register_external_method1( moveV, ((TransfoVf)&sf::Transformable::move) );
  camlpp__register_external_method2( scale, ((Transfo2f)&sf::Transformable::scale) );
  camlpp__register_external_method1( scaleV, ((TransfoVf)&sf::Transformable::scale) );
  camlpp__register_method1( rotate );
  camlpp__register_method0( getTransform );
  camlpp__register_method0( getInverseTransform );
}
#undef CAMLPP__CLASS_NAME

void shape_set_texture_helper( sf::Shape* shape, Optional<sf::Texture const*> texture, Optional<bool> resetRect, UnitTypeHolder)
{
  shape->setTexture( 	texture.get_value_no_fail( 0 ),
			resetRect.get_value_no_fail( false ) );
}

typedef sf::Shape sf_Shape;
#define CAMLPP__CLASS_NAME() sf_Shape
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_inheritance_relationship( sf_Transformable );
  camlpp__register_external_method3( setTexture, &shape_set_texture_helper );
  camlpp__register_method1( setTextureRect );
  camlpp__register_method1( setFillColor );
  camlpp__register_method1( setOutlineColor );
  camlpp__register_method1( setOutlineThickness );
  camlpp__register_method0( getTexture );
  camlpp__register_method0( getTextureRect );
  camlpp__register_method0( getFillColor );
  camlpp__register_method0( getOutlineColor );
  camlpp__register_method0( getOutlineThickness );
  camlpp__register_method0( getPointCount ); // pure virtual
  camlpp__register_method1( getPoint ); // pure virtual
  camlpp__register_method0( getLocalBounds );
  camlpp__register_method0( getGlobalBounds );
}
#undef CAMLPP__CLASS_NAME


typedef sf::RectangleShape sf_RectangleShape;
#define CAMLPP__CLASS_NAME() sf_RectangleShape
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Shape );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( size_constructor, sf::Vector2f );
  camlpp__register_method1( setSize );
  camlpp__register_method0( getSize );
}
#undef CAMLPP__CLASS_NAME

typedef sf::CircleShape sf_CircleShape;
#define CAMLPP__CLASS_NAME() sf_CircleShape
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Shape );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( radius_constructor, float );
  camlpp__register_method1( setRadius );
  camlpp__register_method0( getRadius );
  camlpp__register_method1( setPointCount );
}
#undef CAMLPP__CLASS_NAME


typedef sf::ConvexShape sf_ConvexShape;
#define CAMLPP__CLASS_NAME() sf_ConvexShape
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Shape );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( point_constructor, int );
  camlpp__register_method1( setPointCount );
  camlpp__register_method2( setPoint );
}
#undef CAMLPP__CLASS_NAME




void sprite_set_texture_helper( sf::Sprite* spr, Optional<bool> resize, sf::Texture const& texture )
{
  spr->setTexture( texture, resize.get_value_no_fail( false ) );
}

Optional<sf::Texture const*> sprite_get_texture_helper( sf::Sprite const* spr )
{
  sf::Texture const* res = spr->getTexture();
  return (res ? some(res) : none<sf::Texture const*>());
}

typedef sf::Sprite sf_Sprite;
#define CAMLPP__CLASS_NAME() sf_Sprite
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_inheritance_relationship( sf_Transformable );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( texture_constructor, sf::Texture const&);
  camlpp__register_external_method2( setTexture, &sprite_set_texture_helper );
  camlpp__register_method1( setTextureRect );
  camlpp__register_method1( setColor );
  camlpp__register_external_method0( getTexture, &sprite_get_texture_helper );
  camlpp__register_method0( getTextureRect );
  camlpp__register_method0( getColor );
  camlpp__register_method0( getLocalBounds );
  camlpp__register_method0( getGlobalBounds );
}
#undef CAMLPP__CLASS_NAME



custom_struct_affectation(sf::Glyph,
			  &sf::Glyph::advance,
			  &sf::Glyph::bounds,
			  &sf::Glyph::textureRect );

custom_struct_conversion(sf::Glyph,
			 &sf::Glyph::advance,
			 &sf::Glyph::bounds,
			 &sf::Glyph::textureRect );


bool font_load_from_memory_helper( sf::Font* font, RawDataType const& mem )
{
  return font->loadFromMemory( mem.data, mem.size[0] );
} 

typedef sf::Font sf_Font;
#define CAMLPP__CLASS_NAME() sf_Font
camlpp__register_custom_class()
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

custom_enum_affectation(sf::Text::Style );
custom_enum_conversion( sf::Text::Style );

sf::Text* text_constructor_helper( Optional<sf::Font const*> font, Optional<unsigned> characterSize, char* str)
{
  return new sf::Text( 	sf::String(str),
			font.is_some() ? *font.get_value() : sf::Font::getDefaultFont(), 
			characterSize.get_value_no_fail( 30 ) );
}

void text_set_string_helper( sf::Text* txt, char* str)
{
	txt->setString( sf::String( str ) );
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

typedef sf::Text sf_Text;
#define CAMLPP__CLASS_NAME() sf_Text
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_inheritance_relationship( sf_Transformable );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_external_constructor3( init_constructor, &text_constructor_helper );
  camlpp__register_external_method1( setString, &text_set_string_helper );
  camlpp__register_method1( setFont );
  camlpp__register_method1( setCharacterSize );
  camlpp__register_external_method1( setStyle, &text_set_style_helper );
  camlpp__register_method1( setColor );
  camlpp__register_external_method0( getString, &text_get_string_helper );
  camlpp__register_method0( getFont );
  camlpp__register_method0( getCharacterSize );
  camlpp__register_external_method0( getStyle, &text_get_style_helper );
  camlpp__register_method0( getColor );
  camlpp__register_method1( findCharacterPos );
  camlpp__register_method0( getLocalBounds );
  camlpp__register_method0( getGlobalBounds );
}
#undef CAMLPP__CLASS_NAME

custom_struct_affectation(sf::Vertex,
			  &sf::Vertex::position,
			  &sf::Vertex::color,
			  &sf::Vertex::texCoords );

custom_struct_conversion(sf::Vertex,
			 &sf::Vertex::position,
			 &sf::Vertex::color,
			 &sf::Vertex::texCoords );

custom_enum_affectation( sf::PrimitiveType ) ;
custom_enum_conversion ( sf::PrimitiveType ) ;

typedef sf::Vertex const& (sf::VertexArray::*GetAtIndexFunc)(unsigned int) const;

void vertex_array_set_at_index_helper(sf::VertexArray* va, unsigned int i, sf::Vertex const& v)
{
  (*va)[i] = v;
}

typedef sf::VertexArray sf_VertexArray;
#define CAMLPP__CLASS_NAME() sf_VertexArray
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_method0( getVertexCount );
  camlpp__register_external_method2( setAtIndex , &vertex_array_set_at_index_helper );
  camlpp__register_external_method1( getAtIndex , ((GetAtIndexFunc)&sf::VertexArray::operator[]) );
  camlpp__register_method0( clear );
  camlpp__register_method1( resize );
  camlpp__register_method1( append );
  camlpp__register_method1( setPrimitiveType );
  camlpp__register_method0( getPrimitiveType );
  camlpp__register_method0( getBounds );
}
#undef CAMLPP__CLASS_NAME



typedef void (sf::Shader::*SetFloatParameterType)(std::string const&, float);
typedef void (sf::Shader::*SetVec2ParameterType)(std::string const&, float, float);
typedef void (sf::Shader::*SetVec3ParameterType)(std::string const&, float, float, float);
typedef void (sf::Shader::*SetVec4ParameterType)(std::string const&, float, float, float, float);
typedef void (sf::Shader::*SetVec2ParameterTypeV)(std::string const&, sf::Vector2f const&);
typedef void (sf::Shader::*SetVec3ParameterTypeV)(std::string const&, sf::Vector3f const&);
typedef void (sf::Shader::*SetColorParameterType)(std::string const&, sf::Color const&);
typedef void (sf::Shader::*SetTransformParameterType)(std::string const&, sf::Transform const&);
typedef void (sf::Shader::*SetTextureParameterType)(std::string const&, sf::Texture const&);


#define SHADER_LOAD_FROM_RESOURCE_HELPER_DEF( ResourceName, ResourceType, MemFunc) \
  bool shader_load_from_ ## ResourceName ## _helper( 	sf::Shader* shader, \
							Optional<ResourceType> vertex, \
							Optional<ResourceType> frag, \
							UnitTypeHolder ) \
  {									\
    if( vertex.is_some() && frag.is_some() )				\
      {									\
	return shader->MemFunc( vertex.get_value(), frag.get_value() ); \
      }									\
    else if( vertex.is_some() )						\
      {									\
	return shader->MemFunc( vertex.get_value(), sf::Shader::Vertex ); \
      }									\
    else if( frag.is_some() )						\
      {									\
	return shader->MemFunc( frag.get_value(), sf::Shader::Fragment ); \
      }									\
    else								\
      {									\
	assert(false && "Error: recovering not yet implemented");	\
      }									\
  }

SHADER_LOAD_FROM_RESOURCE_HELPER_DEF( file, std::string, loadFromFile )
SHADER_LOAD_FROM_RESOURCE_HELPER_DEF( stream, sf::InputStream&, loadFromStream )
SHADER_LOAD_FROM_RESOURCE_HELPER_DEF( memory, std::string, loadFromMemory )



void shader_set_current_texture_helper( sf::Shader* s, std::string str )
{
  s->setParameter( str, sf::Shader::CurrentTexture );
}

typedef sf::Shader sf_Shader;
#define CAMLPP__CLASS_NAME() sf_Shader
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_external_method3( loadFromFile, &shader_load_from_file_helper );
  camlpp__register_external_method3( loadFromMemory, &shader_load_from_memory_helper);
  camlpp__register_external_method3( loadFromStream, &shader_load_from_stream_helper );
  camlpp__register_external_method2( setFloatParameter, ((SetFloatParameterType) &sf::Shader::setParameter) );
  camlpp__register_external_method3( setVec2Parameter, ((SetVec2ParameterType) &sf::Shader::setParameter) );
  camlpp__register_external_method4( setVec3Parameter, ((SetVec3ParameterType) &sf::Shader::setParameter) );
  camlpp__register_external_method5( setVec4Parameter, ((SetVec4ParameterType) &sf::Shader::setParameter) );
  camlpp__register_external_method2( setVec2ParameterV, ((SetVec2ParameterTypeV) &sf::Shader::setParameter) );
  camlpp__register_external_method2( setVec3ParameterV, ((SetVec3ParameterTypeV) &sf::Shader::setParameter) );
  camlpp__register_external_method2( setColorParameter, ((SetColorParameterType) &sf::Shader::setParameter)  );
  camlpp__register_external_method2( setTransformParameter, ((SetTransformParameterType) &sf::Shader::setParameter) );
  camlpp__register_external_method2( setTextureParameter, ((SetTextureParameterType) &sf::Shader::setParameter) );
  camlpp__register_external_method1( setCurrentTexture, &shader_set_current_texture_helper);
  camlpp__register_method0( bind );
  camlpp__register_method0( unbind );
}
#undef CAMLPP__CLASS_NAME

extern "C"
{
  camlpp__register_overloaded_free_function0( Shader_isAvailable, &sf::Shader::isAvailable )
}

sf::View* view_rectangle_constructor_helper( sf::FloatRect const& rec)
{
	return new sf::View( rec );
}

sf::View* view_center_and_size_constructor_helper( sf::Vector2f const& center, sf::Vector2f const& size)
{
	return new sf::View( center, size);
}

typedef sf::View sf_View;
#define CAMLPP__CLASS_NAME() sf_View
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_constructor0( default_constructor );
  camlpp__register_external_constructor1( rectangle_constructor, &view_rectangle_constructor_helper );
  camlpp__register_external_constructor2( center_and_size_constructor, &view_center_and_size_constructor_helper );
  camlpp__register_external_method2( setCenter, ((void (sf::View::*)(float, float)) &sf::View::setCenter) );
  camlpp__register_external_method1( setCenterV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::setCenter) );
  camlpp__register_external_method2( setSize, ((void (sf::View::*)(float, float)) &sf::View::setSize) );
  camlpp__register_external_method1( setSizeV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::setSize) );
  camlpp__register_method1( setRotation );
  camlpp__register_method1( setViewport );
  camlpp__register_method1( reset );
  camlpp__register_method0( getCenter );
  camlpp__register_method0( getSize );
  camlpp__register_method0( getRotation );
  camlpp__register_method0( getViewport );
  camlpp__register_external_method2( move, ((void (sf::View::*)(float, float)) &sf::View::move) );
  camlpp__register_external_method1( moveV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::move) );
  camlpp__register_method1( rotate );
  camlpp__register_method1( zoom );
  //	camlpp__register_method0( GetMatrix, &sf::View::GetMatrix );
  //	camlpp__register_method0( GetInverseMatrix, &sf::View::GetInverseMatrix );
}
#undef CAMLPP__CLASS_NAME



custom_struct_affectation(sf::RenderStates,
			  &sf::RenderStates::blendMode,
			  &sf::RenderStates::transform,
			  &sf::RenderStates::texture,
			  &sf::RenderStates::shader );

custom_struct_conversion(sf::RenderStates,
			 &sf::RenderStates::blendMode,
			 &sf::RenderStates::transform,
			 &sf::RenderStates::texture,
			 &sf::RenderStates::shader );


sf::RenderStates mk_sf_RenderStates(Optional< sf::BlendMode > blend,
				  Optional< sf::Transform const* > transform,
				  Optional< sf::Texture const* > text,
				  Optional< sf::Shader const* > shader,
				  UnitTypeHolder)
{
  sf::RenderStates const& def = sf::RenderStates::Default;
  return sf::RenderStates
    (
     blend.get_value_no_fail( def.blendMode ),
     *transform.get_value_no_fail( &def.transform ),
     text.get_value_no_fail( def.texture ),
     shader.get_value_no_fail( def.shader )
     );
}

extern "C"
{
  camlpp__register_free_function5( mk_sf_RenderStates )
}

void render_target_clear_helper( sf::RenderTarget* target, Optional<sf::Color> color, UnitTypeHolder )
{
  return target->clear( color.get_value_no_fail( sf::Color(0, 0, 0, 255) ) );
}

sf::Vector2f render_target_convert_coords_helper( sf::RenderTarget* target, Optional<sf::View const*> opt, sf::Vector2i const& point)
{
  if( opt.is_some() )
    {
      return target->convertCoords(point, *opt.get_value() );
    }
  return target->convertCoords(point);
}

void render_target_draw_helper( sf::RenderTarget* target,
				Optional< sf::RenderStates > rs,
				/* Optional< sf::BlendMode > blend,
				Optional< sf::Transform const* > transform,
				Optional< sf::Texture const* > text,
				Optional< sf::Shader const* > shader, */
				sf::Drawable const& drawable)
{
  sf::RenderStates const& def = sf::RenderStates::Default;
  target->draw
    (
     drawable,
     rs.get_value_no_fail( def )
     /*    sf::RenderStates
     (
      blend.get_value_no_fail( def.blendMode ),
      *transform.get_value_no_fail( &def.transform ),
      text.get_value_no_fail( def.texture ),
      shader.get_value_no_fail( def.shader )
      )
     */
     );
}

/*  
    void render_target_draw_prim_helper( sf::RenderTarget* target, 
    const 
    unsigned verticesCount,
    PrimitiveType type, 
    Optional< sf::RenderStates const* > states )
    {
    }  
*/


typedef sf::RenderTarget sf_RenderTarget;
#define CAMLPP__CLASS_NAME() sf_RenderTarget
camlpp__register_custom_class()
{
  camlpp__register_external_method2( clear, &render_target_clear_helper );
  camlpp__register_external_method2( draw, &render_target_draw_helper );
  //	camlpp__register_method2( DrawPrimitives, &render_target_draw_prim_helper );
  camlpp__register_method0( getSize );
  camlpp__register_method1( setView );
  camlpp__register_method0( getView );
  camlpp__register_method0( getDefaultView );
  camlpp__register_method1( getViewport );
  camlpp__register_external_method2( convertCoords, &render_target_convert_coords_helper );
  camlpp__register_method0( pushGLStates );
  camlpp__register_method0( popGLStates );
  camlpp__register_method0( resetGLStates );
}
#undef CAMLPP__CLASS_NAME
/* 

bool render_image_create_helper( sf::RenderImage* rI, Optional<bool> depthBfr, unsigned w, unsigned h)
{
	return rI->Create( w, h, depthBfr.isSome() ? depthBfr.get_value() : false)
}

void set_active( sf::RenderImage* rI, Optional<bool> active )
{
	return rI->SetActive( active.isSome() ? active.get_value() : true );
}


typedef sf::RenderImage sf_RenderImage;
#define CAMLPP__CLASS_NAME() sf_RenderImage
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_RenderTarget )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method3( Create, &render_image_create_helper )
	camlpp__register_method1( SetSmooth, &sf::RenderImage::SetSmooth )
	camlpp__register_method0( IsSmooth, &sf::RenderImage::IsSmooth )
	camlpp__register_method1( SetActive, &render_image_set_active_helper )
	camlpp__register_method0( Display, &sf::RenderImage::Display )
	camlpp__register_method0( GetImage, &sf::RenderImage::GetImage )	
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

*/

bool render_texture_create_helper( sf::RenderTexture* rI, Optional<bool> depthBfr, unsigned w, unsigned h)
{
  return rI->create( w, h, depthBfr.get_value_no_fail( false ) );
}

bool render_texture_set_active_helper( sf::RenderTexture* rI, Optional<bool> active, UnitTypeHolder )
{
  return rI->setActive( active.get_value_no_fail( true ) );
}

sf::Texture const* render_texture_get_texture_helper(sf::RenderTexture* rT )
{
  return &rT->getTexture();
}

typedef sf::RenderTexture sf_RenderTexture;
#define CAMLPP__CLASS_NAME() sf_RenderTexture
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_RenderTarget );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_external_method3( create, &render_texture_create_helper );
  camlpp__register_method1( setSmooth );
  camlpp__register_method0( isSmooth );
  camlpp__register_external_method2( setActive, &render_texture_set_active_helper );
  camlpp__register_method0( display );
  camlpp__register_external_method0( getTexture, &render_texture_get_texture_helper );
}
#undef CAMLPP__CLASS_NAME

sf::RenderWindow* render_window_constructor_helper(Optional<std::list<unsigned long> > style , Optional<sf::ContextSettings> cs, sf::VideoMode vm, std::string const& title)
{
  unsigned long actualStyle =  
    style.is_some() ? style_of_list_unsigned( style.get_value() ) : sf::Style::Default;
  sf::ContextSettings actualSettings = cs.get_value_no_fail( sf::ContextSettings() );
  return new sf::RenderWindow( vm, title, actualStyle, actualSettings );
}


typedef sf::Window sf_Window;
typedef sf::RenderWindow sf_RenderWindow;
#define CAMLPP__CLASS_NAME() sf_RenderWindow
camlpp__register_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_RenderTarget );
  camlpp__register_inheritance_relationship( sf_Window );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_external_constructor4( create_constructor, &render_window_constructor_helper);
  camlpp__register_method0( capture );
}
#undef CAMLPP__CLASS_NAME



class OverrideDrawable : public sf::Drawable
{
public:
  typedef std::function<void(sf::RenderTarget*, sf::RenderStates )> CallbackType;
private:
  CallbackType callback_; 
private:
  virtual void draw(sf::RenderTarget& target, sf::RenderStates states) const
  {
    callback_(&target, states );
  }
public:
  OverrideDrawable()
  {
  }

  void setCallback(CallbackType c)
  {
    callback_ = c;
  }
};

NewObject< sf::Drawable > sf_Drawable_inherits()
{
  return NewObject<sf::Drawable>( new OverrideDrawable() );
}

void sf_Drawable_override_draw( sf::Drawable* d, OverrideDrawable::CallbackType c )
{
  static_cast<OverrideDrawable*>(d)->setCallback(c);
}


extern "C" 
{
  camlpp__register_free_function0(sf_Drawable_inherits)
  camlpp__register_free_function2(sf_Drawable_override_draw)
}

#if 0

class CamlDrawable : public sf::Drawable
{
private:
  typedef std::function<void(sf::RenderTarget*, sf::RenderStates )> CallbackType;
  CallbackType callback_; 
private:
  virtual void draw(sf::RenderTarget& target, sf::RenderStates states) const
  {
    callback_(&target, states );
  }
public:
  CamlDrawable()
  {
  }

  CamlDrawable(CallbackType c):callback_(c)
  {
  }

  void setCallback(CallbackType c)
  {
    callback_ = c;
  }
};

#define CAMLPP__CLASS_NAME() CamlDrawable
camlpp__register_custom_class()
{
  camlpp__register_inheritance_relationship( sf_Drawable );
  camlpp__register_constructor0( default_constructor );
  camlpp__register_constructor1( callback_constructor, 
				 std::function<void(sf::RenderTarget*, sf::RenderStates)> );
  camlpp__register_method1( setCallback );
}
#undef CAMLPP__CLASS_NAME

#endif


