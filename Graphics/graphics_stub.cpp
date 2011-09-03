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



void shape_add_point_helper( sf::Shape* shape, Optional<sf::Color> col, Optional<sf::Color> outline, float x, float y)
{
	shape->AddPoint(x, y, 
			col.isSome() ? col.get_value() : sf::Color(255, 255, 255),
			outline.isSome() ? outline.get_value() : sf::Color(0, 0, 0) );
}

void shape_add_pointV_helper( sf::Shape* shape, Optional<sf::Color> col, Optional<sf::Color> outline, sf::Vector2f vec)
{
	shape->AddPoint( vec
			col.isSome() ? col.get_value() : sf::Color(255, 255, 255),
			outline.isSome() ? outline.get_value() : sf::Color(0, 0, 0) );
}

typedef sf::Shape sf_Shape;
#define CAMLPP__CLASS_NAME() sf_Shape
camlpp__register_custom_class()
	camlpp__register_constructor0( default_constructor )
	camlpp__register_method4( AddPoint, shape_add_point_helper)
	camlpp__register_method3( AddPointV, shape_add_pointV_helper)
	camlpp__register_method0( GetPointsCount, &sf::Shape::GetPointsCount )
	camlpp__register_method1( EnableFill, &sf::Shape::EnableFill )
	camlpp__register_method1( EnableOutline, &sf::Shape::EnableOutline )
	camlpp__register_method2( SetPointPositionV, ((void (sf::Shape::*)(unsigned, sf::Vector2f const&)) &sf::Shape::SetPointPosition ) )
	camlpp__register_method3( SetPointPosition, ((void (sf::Shape::*)(unsigned, float, float)) &sf::Shape::SetPointPosition) )
	camlpp__register_method2( SetPointColor, &sf::Shape::SetPointColor )
	camlpp__register_method2( SetPointOutlineColor, &sf::Shape::SetPointOutlineColor )
	camlpp__register_method1( SetOutlineThickness, &sf::Shape::SetOutlineThickness )
	camlpp__register_method1( GetPointPosition, &sf::Shape::SetPointPosition )
	camlpp__register_method1( GetPointColor, &sf::Shape::GetPointColor )
	camlpp__register_method1( GetPointOutlineColor, &sf::Shape::GetPointOutlineColor )
	camlpp__register_method0( GetOutlineThickness, &sf::Shape::GetOutlineThickness )

camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME

//TODO: implement Shape static func : Line(), Circle(), Rectangle(), ....




void image_create_with_opt_color_helper( sf::Image* image, Optional<sf::Color> color, unsigned w, unsigned h)
{
	image->Create(w, h, color.isSome() ? color.get_value() : sf::Color(0, 0, 0));
}

void image_create_mask_from_color_helper( sf::Image* image, Optional<sf::Uint8> alpha, sf::Color color)
{
	image->CreateMaskFromColor( image, color, alpha.isSome() ? alpha.get_value : 0 );
}

void image_copy_helper( sf::Image* img, Optional<sf::IntRect> srcRect, Optional<bool> applyAlpha, sf::Image const& src, unsigned destX, unsigned destY)
{
	image->Copy( 	src, destX, destY, 
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
	camlpp__register_method2( CreateMaskFromColor, image_create_mask_from_color_helper )
	camlpp__register_method5( Copy, image_copy_helper )
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
#undef CAMLPP__CLASS_NAME()

extern "C"
{
	camlpp__register_overloaded_free_function0( GetDefaultFont, &sf::Font::GetDefaultFont)
}

typedef void (sf::Shader::*SetFloatParameterType)(std::string const&, float);
typedef void (sf::Shader::*SetVec2ParameterType)(std::string const&, float, float);
typedef void (sf::Shader::*SetVec3ParameterType)(std::string const&, float, float, float);
typedef void (sf::Shader::*SetVec4ParameterType)(std::string const&, float, float, float, float);
typedef void (sf::Shader::*SetVec3ParameterTypeV)(std::string const&, sf::Vector2f const&);
typedef void (sf::Shader::*SetVec4ParameterTypeV)(std::string const&, sf::Vector3f const&);

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
	camlpp__register_overloaded_free_function( Shader_IsAvailable, &sf::Shader::IsAvailable )
}

void render_target_clear_helper( sf::RenderTarget* target, Optional<sf::Color> color )
{
	return target->Clear( color.isSome() ? color.get_value() : sf::Color(0, 0, 0, 255) );
}

sf::Vector2f render_target_convert_coords_coords( sf::RenderTarget* target, Optional<sf::View const*> opt, unsigned int x, unsigned int y)
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
	camlpp__register_method1( Clear, &render_target_clear_helper );
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
	camlpp__register_method0( RestorGLStates, &sf::RenderTarget::RestorGLStates )	
camlpp__custom_class_registered()
#undef CAMLPP__CLASS_NAME()


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
#undef CAMLPP__CLASS_NAME()


bool render_texture_create_helper( sf::RenderTexture* rI, Optional<bool> depthBfr, unsigned w, unsigned h)
{
	return rI->Create( w, h, depthBfr.isSome() ? depthBfr.get_value() : false)
}

void set_active( sf::RenderTexture* rI, Optional<bool> active )
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






