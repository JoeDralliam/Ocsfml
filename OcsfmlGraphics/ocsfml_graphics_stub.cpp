#include "ocsfml_graphics_stub.hpp"
#include <SFML/Graphics.hpp>

#include <camlpp/custom_conversion.hpp>
#include <camlpp/custom_class.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>


custom_struct_affectation(	 sf::FloatRect,
				&sf::FloatRect::Left,
				&sf::FloatRect::Top,
				&sf::FloatRect::Width,
				&sf::FloatRect::Height ); 

custom_struct_conversion(	 sf::FloatRect,
				&sf::FloatRect::Left,
				&sf::FloatRect::Top,
				&sf::FloatRect::Width,
				&sf::FloatRect::Height );

custom_struct_affectation(	 sf::IntRect,
				&sf::IntRect::Left,
				&sf::IntRect::Top,
				&sf::IntRect::Width,
				&sf::IntRect::Height );

custom_struct_conversion(	 sf::IntRect,
				&sf::IntRect::Left,
				&sf::IntRect::Top,
				&sf::IntRect::Width,
				&sf::IntRect::Height );

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
	image->Create(w, h, color.get_value_no_fail( sf::Color(0, 0, 0) ) );
}

void image_create_mask_from_color_helper( sf::Image* image, Optional<sf::Uint8> alpha, sf::Color color)
{
	image->CreateMaskFromColor( color, alpha.get_value_no_fail( 0 ) );
}

void image_copy_helper( sf::Image* img, Optional<sf::IntRect> srcRect, Optional<bool> applyAlpha, sf::Image const& src, unsigned destX, unsigned destY)
{
	img->Copy( 	src, destX, destY, 
			srcRect.get_value_no_fail( sf::IntRect(0,0,0,0) ),
			applyAlpha.get_value_no_fail( false ) );
}

typedef sf::Image sf_Image;
#define CAMLPP__CLASS_NAME() sf_Image
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method3( CreateFromColor, &image_create_with_opt_color_helper )
//	camlpp__register_method3( CreateFromPixels
	camlpp__register_method1( LoadFromFile, &sf::Image::LoadFromFile )
//	camlpp__register_method1( LoadFromMemory, &sf::Image::LoadFromMemory )
	camlpp__register_method1( LoadFromStream, &sf::Image::LoadFromStream )
	camlpp__register_method1( SaveToFile, &sf::Image::SaveToFile )
	camlpp__register_method0( GetWidth, &sf::Image::GetWidth )
	camlpp__register_method0( GetHeight, &sf::Image::GetHeight )
	camlpp__register_method2( CreateMaskFromColor, &image_create_mask_from_color_helper )
	camlpp__register_method5( Copy, &image_copy_helper )
	camlpp__register_method3( SetPixel, &sf::Image::SetPixel )
	camlpp__register_method2( GetPixel, &sf::Image::GetPixel )
	camlpp__register_method0( FlipHorizontally, &sf::Image::FlipHorizontally )
	camlpp__register_method0( FlipVertically, &sf::Image::FlipVertically )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

custom_enum_conversion( sf::Texture::CoordinateType );
custom_enum_affectation(sf::Texture::CoordinateType );



bool texture_load_from_file_helper( sf::Texture* text, Optional<sf::IntRect> area, std::string filename )
{
	return text->LoadFromFile( filename, area.get_value_no_fail( sf::IntRect() ) );
}

bool texture_load_from_stream_helper( sf::Texture* text, Optional<sf::IntRect> area, sf::InputStream& stream )
{
	return text->LoadFromStream( stream, area.get_value_no_fail( sf::IntRect() ) );
}

bool texture_load_from_image_helper( sf::Texture* text, Optional<sf::IntRect> area, sf::Image const& image)
{
	return text->LoadFromImage( image , area.get_value_no_fail( sf::IntRect() ) );
}

void texture_update_from_image_helper( sf::Texture* tex, sf::Image const& img, Optional<sf::Vector2<unsigned int> > p)
{
	if(p.is_some())
	{
		tex->Update( img, p.get_value().x, p.get_value().y );
	}
	else
	{
		tex->Update( img );
	}
}

void texture_update_from_window_helper( sf::Texture* tex, sf::Window const& img, Optional<sf::Vector2<unsigned int> > p)
{
	if(p.is_some())
	{
		tex->Update( img, p.get_value().x, p.get_value().y );
	}
	else
	{
		tex->Update( img );
	}
}
void texture_bind_helper( sf::Texture* tex, Optional<sf::Texture::CoordinateType> coordinateType )
{
	tex->Bind( coordinateType.get_value_no_fail( sf::Texture::Normalized ) );
}
typedef sf::Texture sf_Texture;
#define CAMLPP__CLASS_NAME() sf_Texture
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( copy_constructor, sf::Texture const& )
	camlpp__register_method2( Create, &sf::Texture::Create )
	camlpp__register_method2( LoadFromFile, &texture_load_from_file_helper )
	camlpp__register_method2( LoadFromStream, &texture_load_from_stream_helper )
	camlpp__register_method2( LoadFromImage, &texture_load_from_image_helper )	
	camlpp__register_method0( GetWidth, &sf::Texture::GetWidth )
	camlpp__register_method0( GetHeight, &sf::Texture::GetHeight )
	camlpp__register_method0( CopyToImage, &sf::Texture::CopyToImage )
//	camlpp__register_method2( UpdateFromPixels, &texture_update_from_pixels_helper )
	camlpp__register_method2( UpdateFromImage, &texture_update_from_image_helper )
	camlpp__register_method2( UpdateFromWindow, &texture_update_from_window_helper )
	camlpp__register_method1( Bind, &sf::Texture::Bind )
	camlpp__register_method1( SetSmooth, &sf::Texture::SetSmooth )
	camlpp__register_method0( IsSmooth, &sf::Texture::IsSmooth )
	camlpp__register_method1( SetRepeated, &sf::Texture::SetRepeated )
	camlpp__register_method0( IsRepeated, &sf::Texture::IsRepeated )
camlpp__custom_class_registered() 
#undef CAMLPP__CLASS_NAME

extern "C"
{
	camlpp__register_overloaded_free_function0( Texture_GetMaximumSize, &sf::Texture::GetMaximumSize)
}



custom_enum_affectation( sf::BlendMode );

custom_enum_conversion( sf::BlendMode );

typedef sf::Vector2f (sf::Transform::*TransformPointFunc)(float,float) const;
typedef sf::Vector2f (sf::Transform::*TransformPointVFunc)(sf::Vector2f const&) const;

void transform_translate_helper(sf::Transform* t, float x, float y)
{
	t->Translate(x,y);
}

void transform_translateV_helper(sf::Transform* t, sf::Vector2f v)
{
	t->Translate(v);
}

void transform_rotate_helper(sf::Transform* t, Optional< float > x, Optional<float> y, float degrees)
{
	if(x.is_some() && y.is_some())
	{
		t->Rotate(degrees, x.get_value(), y.get_value());
	}
	else
	{
		t->Rotate(degrees);
	}
}

void transform_rotateV_helper(sf::Transform* t, Optional< sf::Vector2f > v, float degrees)
{
	if(v.is_some())
	{
		t->Rotate(degrees, v.get_value());
	}
	else
	{
		t->Rotate(degrees);
	}
}

void transform_scale_helper(sf::Transform* t, Optional< float > x, Optional<float> y, float scaleX, float scaleY)
{
	if(x.is_some() && y.is_some())
	{
		t->Scale(scaleX, scaleY, x.get_value(), y.get_value());
	}
	else
	{
		t->Scale(scaleX, scaleY);
	}
}

void transform_scaleV_helper(sf::Transform* t, Optional< sf::Vector2f > v, sf::Vector2f scale)
{
	if(v.is_some())
	{
		t->Scale(scale, v.get_value());
	}
	else
	{
		t->Scale(scale);
	}
}

typedef sf::Transform sf_Transform;
#define CAMLPP__CLASS_NAME() sf_Transform
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor9( matrix_constructor,
					float, float, float,
					float, float, float,
					float, float, float )
	camlpp__register_method0( GetInverse, &sf::Transform::GetInverse )
	camlpp__register_method2( TransformPoint, ((TransformPointFunc) &sf::Transform::TransformPoint) )
	camlpp__register_method1( TransformPointV, ((TransformPointVFunc) &sf::Transform::TransformPoint) )
	camlpp__register_method1( TransformRect, &sf::Transform::TransformRect )
	camlpp__register_method1( Combine, &sf::Transform::Combine )
	camlpp__register_method2( Translate, &transform_translate_helper )
	camlpp__register_method1( TranslateV, &transform_translateV_helper )
	camlpp__register_method3( Rotate, &transform_rotate_helper )
	camlpp__register_method2( RotateV, &transform_rotateV_helper )
	camlpp__register_method4( Scale, &transform_scale_helper )
	camlpp__register_method2( ScaleV, &transform_scaleV_helper )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME



typedef sf::Drawable sf_Drawable;
#define CAMLPP__CLASS_NAME() sf_Drawable
camlpp__register_custom_class()
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


typedef sf::Transformable sf_Transformable;
typedef void (sf_Transformable::* Transfo2f)(float, float);
typedef void (sf_Transformable::* TransfoVf)(sf::Vector2f const&);


#define CAMLPP__CLASS_NAME() sf_Transformable
camlpp__register_custom_class()
	camlpp__register_method2( SetPosition, ((Transfo2f)&sf::Transformable::SetPosition) )
	camlpp__register_method1( SetPositionV, ((TransfoVf)&sf::Transformable::SetPosition) )
	camlpp__register_method2( SetScale, ((Transfo2f)&sf::Transformable::SetScale) )
	camlpp__register_method1( SetScaleV, ((TransfoVf)&sf::Transformable::SetScale) )
	camlpp__register_method2( SetOrigin, ((Transfo2f)&sf::Transformable::SetOrigin) )
	camlpp__register_method1( SetOriginV, ((TransfoVf)&sf::Transformable::SetOrigin) )
	camlpp__register_method1( SetRotation, &sf::Transformable::SetRotation)
	camlpp__register_method0( GetPosition, &sf::Transformable::GetPosition )
	camlpp__register_method0( GetScale, &sf::Transformable::GetScale )
	camlpp__register_method0( GetOrigin, &sf::Transformable::GetOrigin )
	camlpp__register_method0( GetRotation, &sf::Transformable::GetRotation )
	camlpp__register_method2( Move, ((Transfo2f)&sf::Transformable::Move) )
	camlpp__register_method1( MoveV, ((TransfoVf)&sf::Transformable::Move) )
	camlpp__register_method2( Scale, ((Transfo2f)&sf::Transformable::Scale) )
	camlpp__register_method1( ScaleV, ((TransfoVf)&sf::Transformable::Scale) )
	camlpp__register_method1( Rotate, &sf::Transformable::Rotate )
	camlpp__register_method0( GetTransform, &sf::Transformable::GetTransform )
	camlpp__register_method0( GetInverseTransform, &sf::Transformable::GetInverseTransform )	
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

void shape_set_texture_helper( sf::Shape* shape, Optional<sf::Texture const*> texture, Optional<bool> resetRect, UnitTypeHolder)
{
	shape->SetTexture( 	texture.get_value_no_fail( 0 ),
				resetRect.get_value_no_fail( false ) );
}

typedef sf::Shape sf_Shape;
#define CAMLPP__CLASS_NAME() sf_Shape
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Drawable )
	camlpp__register_inheritance_relationship( sf_Transformable )
	camlpp__register_method3( SetTexture, &shape_set_texture_helper )
	camlpp__register_method1( SetTextureRect, &sf::Shape::SetTextureRect )
	camlpp__register_method1( SetFillColor, &sf::Shape::SetFillColor )
	camlpp__register_method1( SetOutlineColor, &sf::Shape::SetOutlineColor )
	camlpp__register_method1( SetOutlineThickness, &sf::Shape::SetOutlineThickness )
	camlpp__register_method0( GetTexture, &sf::Shape::GetTexture )
	camlpp__register_method0( GetTextureRect, &sf::Shape::GetTextureRect )
	camlpp__register_method0( GetFillColor, &sf::Shape::GetFillColor )
	camlpp__register_method0( GetOutlineColor, &sf::Shape::GetOutlineColor )
	camlpp__register_method0( GetOutlineThickness, &sf::Shape::GetOutlineThickness )
	camlpp__register_method0( GetPointsCount, &sf::Shape::GetPointsCount ) // pure virtual
	camlpp__register_method1( GetPoint, &sf::Shape::GetPoint ) // pure virtual
	camlpp__register_method0( GetLocalBounds, &sf::Shape::GetLocalBounds )
	camlpp__register_method0( GetGlobalBounds, &sf::Shape::GetGlobalBounds )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


typedef sf::RectangleShape sf_RectangleShape;
#define CAMLPP__CLASS_NAME() sf_RectangleShape
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Shape )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( size_constructor, sf::Vector2f )
	camlpp__register_method1( SetSize, &sf::RectangleShape::SetSize )
	camlpp__register_method0( GetSize, &sf::RectangleShape::GetSize )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

typedef sf::CircleShape sf_CircleShape;
#define CAMLPP__CLASS_NAME() sf_CircleShape
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Shape )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( radius_constructor, float )
	camlpp__register_method1( SetRadius, &sf::CircleShape::SetRadius )
	camlpp__register_method0( GetRadius, &sf::CircleShape::GetRadius )
	camlpp__register_method1( SetPointsCount, &sf::CircleShape::SetPointsCount )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


typedef sf::ConvexShape sf_ConvexShape;
#define CAMLPP__CLASS_NAME() sf_ConvexShape
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Shape )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( points_constructor, int )
	camlpp__register_method1( SetPointsCount, &sf::ConvexShape::SetPointsCount )
	camlpp__register_method2( SetPoint, &sf::ConvexShape::SetPoint )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME




void sprite_set_texture_helper( sf::Sprite* spr, Optional<bool> resize, sf::Texture const& texture )
{
	spr->SetTexture( texture, resize.get_value_no_fail( false ) );
}

Optional<sf::Texture const*> sprite_get_texture_helper( sf::Sprite const* spr )
{
	sf::Texture const* res = spr->GetTexture();
	return (res ? some(res) : none<sf::Texture const*>());
}

typedef sf::Sprite sf_Sprite;
#define CAMLPP__CLASS_NAME() sf_Sprite
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Drawable )
	camlpp__register_inheritance_relationship( sf_Transformable )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( texture_constructor, sf::Texture const&)
	camlpp__register_method2( SetTexture, &sprite_set_texture_helper )
	camlpp__register_method1( SetTextureRect, &sf::Sprite::SetTextureRect )
	camlpp__register_method1( SetColor, &sf::Sprite::SetColor )
	camlpp__register_method0( GetTexture, &sprite_get_texture_helper )
	camlpp__register_method0( GetTextureRect, &sf::Sprite::GetTextureRect )
	camlpp__register_method0( GetColor, &sf::Sprite::GetColor )
	camlpp__register_method0( GetLocalBounds, &sf::Sprite::GetLocalBounds )
	camlpp__register_method0( GetGlobalBounds, &sf::Sprite::GetGlobalBounds )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME



custom_struct_affectation(	 sf::Glyph,
				&sf::Glyph::Advance,
				&sf::Glyph::Bounds,
				&sf::Glyph::TextureRect );

custom_struct_conversion(	 sf::Glyph,
				&sf::Glyph::Advance,
				&sf::Glyph::Bounds,
				&sf::Glyph::TextureRect );


typedef sf::Font sf_Font;
#define CAMLPP__CLASS_NAME() sf_Font
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( copy_constructor, sf::Font const& )
	camlpp__register_method1( LoadFromFile, &sf::Font::LoadFromFile )
//	camlpp__register_method1( LoadFromMemory, &sf::Font::LoadFromMemory )
	camlpp__register_method1( LoadFromStream, &sf::Font::LoadFromStream )
	camlpp__register_method3( GetGlyph, &sf::Font::GetGlyph )
	camlpp__register_method3( GetKerning, &sf::Font::GetKerning )
	camlpp__register_method1( GetLineSpacing, &sf::Font::GetLineSpacing )
	camlpp__register_method1( GetTexture, &sf::Font::GetTexture )
	camlpp__register_method1( Affect, &sf::Font::operator= )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

extern "C"
{
	camlpp__register_overloaded_free_function0( GetDefaultFont, &sf::Font::GetDefaultFont)
}

custom_enum_affectation( sf::Text::Style );

custom_enum_conversion( sf::Text::Style );

sf::Text* text_constructor_helper( Optional<sf::Font const*> font, Optional<unsigned> characterSize, char* str)
{
	return new sf::Text( 	sf::String(str),
				font.is_some() ? *font.get_value() : sf::Font::GetDefaultFont(), 
				characterSize.get_value_no_fail( 30 ) );
}

void text_set_string_helper( sf::Text* txt, char* str)
{
	txt->SetString( sf::String( str ) );
}

std::string text_get_string_helper( sf::Text const* txt )
{
	return txt->GetString().ToAnsiString();
}

void text_set_style_helper( sf::Text* txt, std::list<unsigned long> style)
{
	txt->SetStyle( style_of_list_unsigned( style ) );
}

std::list<unsigned long> text_get_style_helper( sf::Text* txt )
{
	unsigned long style = txt->GetStyle();
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
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Drawable )
	camlpp__register_inheritance_relationship( sf_Transformable )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_external_constructor3( init_constructor, &text_constructor_helper )
	camlpp__register_method1( SetString, &text_set_string_helper )
	camlpp__register_method1( SetFont, &sf::Text::SetFont )
	camlpp__register_method1( SetCharacterSize, &sf::Text::SetCharacterSize )
	camlpp__register_method1( SetStyle, &text_set_style_helper )
	camlpp__register_method1( SetColor, &sf::Text::SetColor )
	camlpp__register_method0( GetString, &text_get_string_helper )
	camlpp__register_method0( GetFont, &sf::Text::GetFont )
	camlpp__register_method0( GetCharacterSize, &sf::Text::GetCharacterSize )
	camlpp__register_method0( GetStyle, &text_get_style_helper )
	camlpp__register_method0( GetColor, &sf::Text::GetColor )
	camlpp__register_method1( FindCharacterPos, &sf::Text::FindCharacterPos )
	camlpp__register_method0( GetLocalBounds, &sf::Text::GetLocalBounds )
	camlpp__register_method0( GetGlobalBounds, &sf::Text::GetGlobalBounds )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

custom_struct_affectation(	 sf::Vertex,
				&sf::Vertex::Position,
				&sf::Vertex::Color,
				&sf::Vertex::TexCoords );

custom_struct_conversion(	 sf::Vertex,
				&sf::Vertex::Position,
				&sf::Vertex::Color,
				&sf::Vertex::TexCoords );

custom_enum_affectation( sf::PrimitiveType ) ;
custom_enum_conversion ( sf::PrimitiveType ) ;

typedef sf::Vertex const& (sf::VertexArray::*GetAtIndexFunc)(unsigned int) const;

void vertex_array_set_at_index_helper(sf::VertexArray* va, unsigned int i, sf::Vertex const& v)
{
  (*va)[i] = v;
}

typedef sf::VertexArray sf_VertexArray;
#define CAMLPP__CLASS_NAME() sf_VertexArray
camlpp__register_custom_class()
camlpp__register_inheritance_relationship( sf_Drawable )
camlpp__register_method0( GetVerticesCount, &sf::VertexArray::GetVerticesCount )
camlpp__register_method2( SetAtIndex , &vertex_array_set_at_index_helper )
camlpp__register_method1( GetAtIndex , ((GetAtIndexFunc)&sf::VertexArray::operator[]) )
camlpp__register_method0( Clear, &sf::VertexArray::Clear )
camlpp__register_method1( Resize, &sf::VertexArray::Resize )
camlpp__register_method1( Append, &sf::VertexArray::Append )
camlpp__register_method1( SetPrimitiveType, &sf::VertexArray::SetPrimitiveType )
camlpp__register_method0( GetPrimitiveType, &sf::VertexArray::GetPrimitiveType )
camlpp__register_method0( GetBounds, &sf::VertexArray::GetBounds )
camlpp__custom_class_registered()
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


#define SHADER__LOAD_FROM_RESOURCE_HELPER_DEF( ResourceName, ResourceType, MemFunc) \
	bool shader__load_from_ ## ResourceName ## _helper( 	sf::Shader* shader, \
					Optional<ResourceType> vertex, \
					Optional<ResourceType> frag, \
					UnitTypeHolder ) \
	{ \
		if( vertex.is_some() && frag.is_some() ) \
		{ \
			return shader->MemFunc( vertex.get_value(), frag.get_value() ); \
		} \
		else if( vertex.is_some() ) \
		{ \
			return shader->MemFunc( vertex.get_value(), sf::Shader::Vertex ); \
		} \
		else if( frag.is_some() ) \
		{ \
			return shader->MemFunc( frag.get_value(), sf::Shader::Fragment ); \
		} \
		else \
		{ \
		} \
	}

SHADER__LOAD_FROM_RESOURCE_HELPER_DEF( file, std::string, LoadFromFile )
SHADER__LOAD_FROM_RESOURCE_HELPER_DEF( stream, sf::InputStream&, LoadFromStream )

typedef sf::Shader sf_Shader;
#define CAMLPP__CLASS_NAME() sf_Shader
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method3( LoadFromFile, &shader__load_from_file_helper )
//	camlpp__register_method1( LoadFromMemory
	camlpp__register_method3( LoadFromStream, &shader__load_from_stream_helper )
	camlpp__register_method2( SetFloatParameter, ((SetFloatParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method3( SetVec2Parameter, ((SetVec2ParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method4( SetVec3Parameter, ((SetVec3ParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method5( SetVec4Parameter, ((SetVec4ParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method2( SetVec2ParameterV, ((SetVec2ParameterTypeV) &sf::Shader::SetParameter) )
	camlpp__register_method2( SetVec3ParameterV, ((SetVec3ParameterTypeV) &sf::Shader::SetParameter) )
	camlpp__register_method2( SetColorParameter, ((SetColorParameterType) &sf::Shader::SetParameter)  )
	camlpp__register_method2( SetTransformParameter, ((SetTransformParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method2( SetTextureParameter, ((SetTextureParameterType) &sf::Shader::SetParameter) ) 
//	camlpp__register_method1( SetCurrentTexture, &sf::Shader::SetCurrentTexture)
	camlpp__register_method0( Bind, &sf::Shader::Bind )
	camlpp__register_method0( Unbind, &sf::Shader::Unbind )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

extern "C"
{
	camlpp__register_overloaded_free_function0( Shader_IsAvailable, &sf::Shader::IsAvailable )
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
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_external_constructor1( rectangle_constructor, &view_rectangle_constructor_helper )
	camlpp__register_external_constructor2( center_and_size_constructor, &view_center_and_size_constructor_helper )
	camlpp__register_method2( SetCenter, ((void (sf::View::*)(float, float)) &sf::View::SetCenter) )
	camlpp__register_method1( SetCenterV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::SetCenter) )
	camlpp__register_method2( SetSize, ((void (sf::View::*)(float, float)) &sf::View::SetSize) )
	camlpp__register_method1( SetSizeV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::SetSize) )
	camlpp__register_method1( SetRotation, &sf::View::SetRotation )
	camlpp__register_method1( SetViewport, &sf::View::SetViewport )
	camlpp__register_method1( Reset, &sf::View::Reset )
	camlpp__register_method0( GetCenter, &sf::View::GetCenter )
	camlpp__register_method0( GetSize, &sf::View::GetSize )
	camlpp__register_method0( GetRotation, &sf::View::GetRotation )
	camlpp__register_method0( GetViewport, &sf::View::GetViewport )
	camlpp__register_method2( Move, ((void (sf::View::*)(float, float)) &sf::View::Move) )
	camlpp__register_method1( MoveV, ((void (sf::View::*)(sf::Vector2f const&)) &sf::View::Move) )
	camlpp__register_method1( Rotate, &sf::View::Rotate )
	camlpp__register_method1( Zoom, &sf::View::Zoom )
//	camlpp__register_method0( GetMatrix, &sf::View::GetMatrix )
//	camlpp__register_method0( GetInverseMatrix, &sf::View::GetInverseMatrix )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME


void render_target_clear_helper( sf::RenderTarget* target, Optional<sf::Color> color, UnitTypeHolder )
{
	return target->Clear( color.get_value_no_fail( sf::Color(0, 0, 0, 255) ) );
}

sf::Vector2f render_target_convert_coords_helper( sf::RenderTarget* target, Optional<sf::View const*> opt, unsigned int x, unsigned int y)
{
	if( opt.is_some() )
	{
		return target->ConvertCoords(x, y, *opt.get_value() );
	}
	return target->ConvertCoords(x, y);
}


void render_target_draw_helper( sf::RenderTarget* target, 
				Optional< sf::BlendMode > blend,
				Optional< sf::Transform const* > Transform,
				Optional< sf::Texture const* > text,
				Optional< sf::Shader const* > shader,
				sf::Drawable const& drawable)
{
	sf::RenderStates const& def = sf::RenderStates::Default;
	target->Draw
	(
		drawable,
		sf::RenderStates
		(
			blend.get_value_no_fail( def.BlendMode ),
			*Transform.get_value_no_fail( &def.Transform ),
			text.get_value_no_fail( def.Texture ),
			shader.get_value_no_fail( def.Shader )
		)
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
	camlpp__register_method2( Clear, &render_target_clear_helper )
	camlpp__register_method5( Draw, &render_target_draw_helper )
//	camlpp__register_method2( DrawPrimitives, &render_target_draw_prim_helper )
	camlpp__register_method0( GetWidth, &sf::RenderTarget::GetWidth )
	camlpp__register_method0( GetHeight, &sf::RenderTarget::GetHeight )
	camlpp__register_method1( SetView, &sf::RenderTarget::SetView )
	camlpp__register_method0( GetView, &sf::RenderTarget::GetView )
	camlpp__register_method0( GetDefaultView, &sf::RenderTarget::GetDefaultView )
	camlpp__register_method1( GetViewport, &sf::RenderTarget::GetViewport )
	camlpp__register_method3( ConvertCoords, &render_target_convert_coords_helper )
	camlpp__register_method0( PushGLStates, &sf::RenderTarget::PushGLStates)
	camlpp__register_method0( PopGLStates, &sf::RenderTarget::PopGLStates )	
camlpp__custom_class_registered()
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
	return rI->Create( w, h, depthBfr.get_value_no_fail( false ) );
}

bool render_texture_set_active_helper( sf::RenderTexture* rI, Optional<bool> active )
{
	return rI->SetActive( active.get_value_no_fail( true ) );
}


typedef sf::RenderTexture sf_RenderTexture;
#define CAMLPP__CLASS_NAME() sf_RenderTexture
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_RenderTarget )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method3( Create, &render_texture_create_helper )
	camlpp__register_method1( SetSmooth, &sf::RenderTexture::SetSmooth )
	camlpp__register_method0( IsSmooth, &sf::RenderTexture::IsSmooth )
	camlpp__register_method1( SetActive, &render_texture_set_active_helper )
	camlpp__register_method0( Display, &sf::RenderTexture::Display )
	camlpp__register_method0( GetTexture, &sf::RenderTexture::GetTexture )	
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

sf::RenderWindow* render_window_constructor_helper(Optional<std::list<unsigned long> > style , Optional<sf::ContextSettings> cs, sf::VideoMode vm, std::string const& title)
{
	unsigned long actualStyle =  style.is_some() ? style_of_list_unsigned( style.get_value() )
						    : sf::Style::Default;
	sf::ContextSettings actualSettings = cs.get_value_no_fail( sf::ContextSettings() );
	return new sf::RenderWindow( vm, title, actualStyle, actualSettings );
}

typedef sf::Window sf_Window;
typedef sf::RenderWindow sf_RenderWindow;
#define CAMLPP__CLASS_NAME() sf_RenderWindow
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_RenderTarget )
	camlpp__register_inheritance_relationship( sf_Window )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_external_constructor4( create_constructor, &render_window_constructor_helper)
	camlpp__register_method0( Capture, &sf::RenderWindow::Capture)
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

class CamlDrawable : public sf::Drawable
{
private:
  typedef std::function<void(sf::RenderTarget* /* , sf::RenderStates*/ )> CallbackType;
  CallbackType callback_; 
private:
  virtual void Draw(sf::RenderTarget& target, sf::RenderStates states) const
  {
    callback_(&target /* , states */ );
  }
public:
  CamlDrawable(CallbackType c):callback_(c)
  {
  }
};

#define CAMLPP__CLASS_NAME() CamlDrawable
camlpp__register_custom_class()
camlpp__register_inheritance_relationship( sf_Drawable )
camlpp__register_constructor1( callback_constructor, 
			       std::function<void(sf::RenderTarget* /* , sf::RenderStates */ )> )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME




