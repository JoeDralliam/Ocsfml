#include "graphics_stub.hpp"
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
/*  
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
*/
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

/*
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
*/

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

#include <SFML/Graphics/Drawable.hpp>

void image_create_with_opt_color_helper( sf::Image* image, Optional<sf::Color> color, unsigned w, unsigned h)
{
	image->Create(w, h, color.isSome() ? color.get_value() : sf::Color(0, 0, 0));
}

void image_create_mask_from_color_helper( sf::Image* image, Optional<sf::Uint8> alpha, sf::Color color)
{
	image->CreateMaskFromColor( color, alpha.isSome() ? alpha.get_value() : 0 );
}

void image_copy_helper( sf::Image* img, Optional<sf::IntRect> srcRect, Optional<bool> applyAlpha, sf::Image const& src, unsigned destX, unsigned destY)
{
	img->Copy( 	src, destX, destY, 
			srcRect.isSome() ? srcRect.get_value() : sf::IntRect(0,0,0,0),
			applyAlpha.isSome() ? applyAlpha.get_value() : false );
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


custom_enum_affectation( sf::Blend::Mode );

custom_enum_conversion( sf::Blend::Mode );


typedef sf::Drawable sf_Drawable;
typedef void (sf::Drawable::* Transfo2f)(float, float);
typedef void (sf::Drawable::* TransfoVf)(sf::Vector2f const&);

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



void shape_add_point_helper( sf::Shape* shape, Optional<sf::Color> col, Optional<sf::Color> outline, float x, float y)
{
	shape->AddPoint(x, y, 
			col.isSome() ? col.get_value() : sf::Color(255, 255, 255),
			outline.isSome() ? outline.get_value() : sf::Color(0, 0, 0) );
}

void shape_add_pointV_helper( sf::Shape* shape, Optional<sf::Color> col, Optional<sf::Color> outline, sf::Vector2f vec)
{
	shape->AddPoint( vec,
			col.isSome() ? col.get_value() : sf::Color(255, 255, 255),
			outline.isSome() ? outline.get_value() : sf::Color(0, 0, 0) );
}

typedef sf::Shape sf_Shape;
#define CAMLPP__CLASS_NAME() sf_Shape
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Drawable )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method4( AddPoint, &shape_add_point_helper)
	camlpp__register_method3( AddPointV, &shape_add_pointV_helper)
	camlpp__register_method0( GetPointsCount, &sf::Shape::GetPointsCount )
	camlpp__register_method1( EnableFill, &sf::Shape::EnableFill )
	camlpp__register_method1( EnableOutline, &sf::Shape::EnableOutline )
	camlpp__register_method2( SetPointPositionV, ((void (sf::Shape::*)(unsigned, sf::Vector2f const&)) &sf::Shape::SetPointPosition ) )
	camlpp__register_method3( SetPointPosition, ((void (sf::Shape::*)(unsigned, float, float)) &sf::Shape::SetPointPosition) )
	camlpp__register_method2( SetPointColor, &sf::Shape::SetPointColor )
	camlpp__register_method2( SetPointOutlineColor, &sf::Shape::SetPointOutlineColor )
	camlpp__register_method1( SetOutlineThickness, &sf::Shape::SetOutlineThickness )
	camlpp__register_method1( GetPointPosition, &sf::Shape::GetPointPosition )
	camlpp__register_method1( GetPointColor, &sf::Shape::GetPointColor )
	camlpp__register_method1( GetPointOutlineColor, &sf::Shape::GetPointOutlineColor )
	camlpp__register_method0( GetOutlineThickness, &sf::Shape::GetOutlineThickness )

camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

//TODO: implement Shape static func : Line(), Circle(), Rectangle(), ....


bool texture_load_from_file_helper( sf::Texture* text, Optional<sf::IntRect> area, std::string filename )
{
	return text->LoadFromFile( filename, area.isSome() ? area.get_value() : sf::IntRect() );
}

bool texture_load_from_stream_helper( sf::Texture* text, Optional<sf::IntRect> area, sf::InputStream& stream )
{
	return text->LoadFromStream( stream, area.isSome() ? area.get_value() : sf::IntRect() );
}

bool texture_load_from_image_helper( sf::Texture* text, Optional<sf::IntRect> area, sf::Image const& image)
{
	return text->LoadFromImage( image , area.isSome() ? area.get_value() : sf::IntRect() );
}

void texture_update_from_image_helper( sf::Texture* tex, sf::Image const& img, Optional<sf::Vector2<unsigned int> > p)
{
	if(p.isSome())
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
	if(p.isSome())
	{
		tex->Update( img, p.get_value().x, p.get_value().y );
	}
	else
	{
		tex->Update( img );
	}
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
	camlpp__register_method0( Bind, &sf::Texture::Bind )
	camlpp__register_method1( SetSmooth, &sf::Texture::SetSmooth )
	camlpp__register_method0( IsSmooth, &sf::Texture::IsSmooth )
	camlpp__register_method1( GetTexCoords, &sf::Texture::GetTexCoords )
camlpp__custom_class_registered() 
#undef CAMLPP__CLASS_NAME

extern "C"
{
	camlpp__register_overloaded_free_function0( Texture_GetMaximumSize, &sf::Texture::GetMaximumSize)
}


void sprite_set_texture_helper( sf::Sprite* spr, Optional<bool> resize, sf::Texture const& texture)
{
	spr->SetTexture( texture, resize.isSome() ? resize.get_value() : false );
}

typedef sf::Sprite sf_Sprite;
#define CAMLPP__CLASS_NAME() sf_Sprite
camlpp__register_custom_class()
	camlpp__register_inheritance_relationship( sf_Drawable )
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( texture_constructor, sf::Texture const&)
	camlpp__register_method2( SetTexture, &sprite_set_texture_helper )
	camlpp__register_method1( SetSubRect, &sf::Sprite::SetSubRect )
	camlpp__register_method2( Resize,((void (sf::Sprite::*)(float, float)) &sf::Sprite::Resize) )
	camlpp__register_method1( ResizeV, ((void (sf::Sprite::*)(sf::Vector2f const&)) &sf::Sprite::Resize) )
	camlpp__register_method1( FlipX, &sf::Sprite::FlipX )
	camlpp__register_method1( FlipY, &sf::Sprite::FlipY )
	camlpp__register_method0( GetTexture, &sf::Sprite::GetTexture )
	camlpp__register_method0( GetSubRect, &sf::Sprite::GetSubRect )
	camlpp__register_method0( GetSize, &sf::Sprite::GetSize )
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
				font.isSome() ? *font.get_value() : sf::Font::GetDefaultFont(), 
				characterSize.isSome() ? characterSize.get_value() : 30);
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
	for(int i = 0; i < 3; ++i)
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
	camlpp__register_constructor0( default_constructor )
	camlpp__register_external_constructor3( init_constructor, &text_constructor_helper )
	camlpp__register_method1( SetString, &text_set_string_helper )
	camlpp__register_method1( SetFont, &sf::Text::SetFont )
	camlpp__register_method1( SetCharacterSize, &sf::Text::SetCharacterSize )
	camlpp__register_method1( SetStyle, &text_set_style_helper )
	camlpp__register_method0( GetString, &text_get_string_helper )
	camlpp__register_method0( GetFont, &sf::Text::GetFont )
	camlpp__register_method0( GetCharacterSize, &sf::Text::GetCharacterSize )
	camlpp__register_method0( GetStyle, &text_get_style_helper )
	camlpp__register_method1( GetCharacterPos, &sf::Text::GetCharacterPos )
	camlpp__register_method0( GetRect, &sf::Text::GetRect )
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME



typedef void (sf::Shader::*SetFloatParameterType)(std::string const&, float);
typedef void (sf::Shader::*SetVec2ParameterType)(std::string const&, float, float);
typedef void (sf::Shader::*SetVec3ParameterType)(std::string const&, float, float, float);
typedef void (sf::Shader::*SetVec4ParameterType)(std::string const&, float, float, float, float);
typedef void (sf::Shader::*SetVec2ParameterTypeV)(std::string const&, sf::Vector2f const&);
typedef void (sf::Shader::*SetVec3ParameterTypeV)(std::string const&, sf::Vector3f const&);

typedef sf::Shader sf_Shader;
#define CAMLPP__CLASS_NAME() sf_Shader
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_constructor1( copy_constructor, sf::Shader const& )
	camlpp__register_method1( LoadFromFile, &sf::Shader::LoadFromFile )
//	camlpp__register_method1( LoadFromMemory
	camlpp__register_method1( LoadFromStream, &sf::Shader::LoadFromStream )
	camlpp__register_method2( SetFloatParameter, ((SetFloatParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method3( SetVec2Parameter, ((SetVec2ParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method4( SetVec3Parameter, ((SetVec3ParameterType) &sf::Shader::SetParameter) )
	camlpp__register_method5( SetVec4Parameter, ((SetVec4ParameterType) &sf::Shader::SetParameter) 
)	camlpp__register_method2( SetVec2ParameterV, ((SetVec2ParameterTypeV) &sf::Shader::SetParameter) )
	camlpp__register_method2( SetVec3ParameterV, ((SetVec3ParameterTypeV) &sf::Shader::SetParameter) )
	camlpp__register_method2( SetTexture, &sf::Shader::SetTexture)
	camlpp__register_method1( SetCurrentTexture, &sf::Shader::SetCurrentTexture)
	camlpp__register_method0( Bind, &sf::Shader::Bind )
	camlpp__register_method0( Unbind, &sf::Shader::Unbind )
	camlpp__register_method1( Affect, &sf::Shader::operator= );	
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
	return target->Clear( color.isSome() ? color.get_value() : sf::Color(0, 0, 0, 255) );
}

sf::Vector2f render_target_convert_coords_helper( sf::RenderTarget* target, Optional<sf::View const*> opt, unsigned int x, unsigned int y)
{
	if( opt.isSome() )
	{
		return target->ConvertCoords(x, y, *opt.get_value() );
	}
	return target->ConvertCoords(x, y);
}

typedef sf::RenderTarget sf_RenderTarget;
#define CAMLPP__CLASS_NAME() sf_RenderTarget
camlpp__register_custom_class()
	camlpp__register_method2( Clear, &render_target_clear_helper );
	camlpp__register_method1( Draw, ((void (sf::RenderTarget::*)(sf::Drawable const&)) &sf::RenderTarget::Draw) )
	camlpp__register_method2( DrawWithShader, ((void (sf::RenderTarget::*)(sf::Drawable const&, sf::Shader const&)) &sf::RenderTarget::Draw) )
	camlpp__register_method0( GetWidth, &sf::RenderTarget::GetWidth )
	camlpp__register_method0( GetHeight, &sf::RenderTarget::GetHeight )
	camlpp__register_method1( SetView, &sf::RenderTarget::SetView )
	camlpp__register_method0( GetView, &sf::RenderTarget::GetView )
	camlpp__register_method0( GetDefaultView, &sf::RenderTarget::GetDefaultView )
	camlpp__register_method1( GetViewport, &sf::RenderTarget::GetViewport )
	camlpp__register_method3( ConvertCoords, &render_target_convert_coords_helper )
	camlpp__register_method0( SaveGLStates, &sf::RenderTarget::SaveGLStates)
	camlpp__register_method0( RestoreGLStates, &sf::RenderTarget::RestoreGLStates )	
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
	return rI->Create( w, h, depthBfr.isSome() ? depthBfr.get_value() : false);
}

bool render_texture_set_active_helper( sf::RenderTexture* rI, Optional<bool> active )
{
	return rI->SetActive( active.isSome() ? active.get_value() : true );
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
	unsigned long actualStyle =  style.isSome() ? style_of_list_unsigned( style.get_value() )
						    : sf::Style::Default;
	sf::ContextSettings actualSettings = cs.isSome() ? cs.get_value() : sf::ContextSettings();
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






