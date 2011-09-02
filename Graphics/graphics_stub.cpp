#include "graphics_stub.hpp"
#include <SFML/Graphics.hpp>

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

bool FloatRect_Contains( sf::FloatRect f, float x, float y)
{
	return f.Contains(x, y);
}

bool FloatRect_ContainsV( sf::FloatRect f, sf::Vector2f vec)
{
	return f.Contains( vec );
}

bool FloatRect_Intersects( sf::FloatRect f1, sf::FloatRect f2 )
{
	return f1.Intersects( f2 )
}

Optional< FloatRect > FloatRect_Intersection( sf::FloatRect f1, sf::FloatRect f2)
{
	sf::FloatRect res;
	if( f1.Intersects( f2, res) )
	{
		return some( res );
	}
	return none< sf::FloatRect >();
}

extern "C"
{
	camlpp__register_free_function3( FloatRect_Contains )
	camlpp__register_free_function2( FloatRect_ContainsV )
	camlpp__register_free_function2( FloatRect_Intersects )
	camlpp__register_free_function2( FloatRect_Intersection )
}

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


bool IntRect_Contains( sf::IntRect f,int x, int y)
{
	return f.Contains(x, y);
}

bool IntRect_ContainsV( sf::IntRect f, sf::Vector2f vec)
{
	return f.Contains( vec );
}

bool IntRect_Intersects( sf::IntRect f1, sf::IntRect f2 )
{
	return f1.Intersects( f2 )
}

Optional< IntRect > IntRect_Intersection( sf::IntRect f1, sf::IntRect f2)
{
	sf::IntRect res;
	if( f1.Intersects( f2, res) )
	{
		return some( res );
	}
	return none< sf::IntRect >();
}

extern "C"
{
	camlpp__register_free_function3( IntRect_Contains )
	camlpp__register_free_function2( IntRect_ContainsV )
	camlpp__register_free_function2( IntRect_Intersects )
	camlpp__register_free_function2( IntRect_Intersection )
}

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

#include <SFML/Graphics/Drawable.hpp>


custom_enum_affectation( sf::Blend::Mode )

custom_enum_conversion( sf::Blend::Mode )


typedef sf::Drawable sf_Drawable;
typedef void (sf::Drawable::* Transfo2f)(float, float);
typedef void (sf::Drawable::* TransfoVf)(sf::Vector2f);

#define CAMLPP__CLASS_NAME() sf_Drawable
camlpp__register_custom_class()
	camlpp__register_method2( SetPosition, ((Transfo2f)&sf::Drawable::SetPosition) )
	camlpp__register_method1( SetPositionV, ((TransfoVf)&sf::Drawable::SetPosition) )
	camlpp__register_method1( SetX, &sf::Drawable::SetX )
	camlpp__register_method1( SetY, &sf::Drawable::SetY )
	camlpp__register_method2( SetScale, ((Transfo2f)&sf::Drawable::SetScale) )
	camlpp__register_method1( SetScaleV, ((TransfoVf)&sf::Drawable::SetScale) )
	camlpp__register_method1( SetScaleX, &sf::Drawable::SetScaleX )
	camlpp__register_method1( SetScaleY, &sf::Drawable::SetScaleY )
	camlpp__register_method2( SetOrigin, ((Transfo2f)&sf::Drawable::SetOrigin) )
	camlpp__register_method1( SetOriginV, ((TransfoVf)&sf::Drawable::SetOrigin) )
	camlpp__register_method1( SetRotation, &sf::Drawable::SetRotation)
	camlpp__register_method1( SetColor, &sf::Drawable::SetColor)
	camlpp__register_method1( SetBlendMode, &sf::Drawable::SetBlendMode)
	camlpp__register_method0( GetPosition, &sf::Drawable::GetPosition )
	camlpp__register_method0( GetScale, &sf::Drawable::GetScale )
	camlpp__register_method0( GetOrigin, &sf::Drawable::GetOrigin )
	camlpp__register_method0( GetRotation, &sf::Drawable::GetRotation )
	camlpp__register_method0( GetColor, &sf::Drawable::GetColor )
	camlpp__register_method0( GetBlendMode, &sf::Drawable::GetBlendMode )
	camlpp__register_method2( Move, ((Transfo2f)&sf::Drawable::Move) )
	camlpp__register_method1( MoveV, ((TransfoVf)&sf::Drawable::Move) )
	camlpp__register_method2( Scale, ((Transfo2f)&sf::Drawable::Scale) )
	camlpp__register_method1( ScaleV, ((TransfoVf)&sf::Drawable::Scale) )
	camlpp__register_method1( Rotate, &sf::Drawable::Rotate )
	camlpp__register_method1( TransformToLocal, &sf::Drawable::TransformToLocal )
	camlpp__register_method1( TransformToGlobal, &sf::Drawable::TransformToGlobal )	
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

void image_create_with_opt_color_helper( sf::Image* image, Optional<sf::Color> color, unsigned w, unsigned h)
{
	image->Create(w, h, color.isSome() ? color.get_value() : sf::Color(0, 0, 0));
}

void image_create_mask_from_color_helper( sf::Image* image, Optional<sf::Uint8> alpha, sf::Color color)
{
	image->CreateMaskFromColor( image, color, alpha.isSome() ? alpha.get_value : 0 );
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
	camlpp__register_method2( CreateMaskFromColor, image_create_mask_from_color_helper )
//	camlpp__register_method5( Copy,
	camlpp__register_method3( SetPixel, &sf::Image::SetPixel )
	camlpp__register_method2( GetPixel, &sf::Image::GetPixel )
	camlpp__register_method0( FlipHorizontally, &sf::Image::FlipHorizontally )
	camlpp__register_method0( FlipVertically, &sf::Image::FlipVertically )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME



custom_struct_affectation(	 sf::Glyph,
				&sf::Glyph::Advance,
				&sf::Glyph::Bounds,
				&sf::Glyph::SubRect );

custom_struct_conversion(	 sf::Glyph,
				&sf::Glyph::Advance,
				&sf::Glyph::Bounds,
				&sf::Glyph::SubRect );


typedef sf::Font sf_Font;
#define CAMLPP__CLASS_NAME() sf_Font
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( copy_constructor, sf::Font )
	camlpp__register_method1( LoadFromFile, &sf::Font::LoadFromFile )
//	camlpp__register_method1( LoadFromMemory, &sf::Font::LoadFromMemory )
	camlpp__register_method1( LoadFromStream, &sf::Font::LoadFromStream )
	camlpp__register_method3( GetGlyph, &sf::Font::GetGlyph )
	camlpp__register_method3( GetKerning, &sf::Font::GetKerning )
	camlpp__register_method1( GetLineSpacing, &sf::Font::GetLineSpacing )
	camlpp__register_method1( GetTexture, &sf::Font::GetTexture )
	camlpp__register_method1( Affect, &sf::Font::operator= )
camlpp__custom_class_registered()

extern "C"
{
	camlpp__register_overloaded_free_function0( GetDefaultFont, &sf::Font::GetDefaultFont)
}

