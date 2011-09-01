#include "graphics_stub.hpp"
#include <SFML/Graphics/Color.hpp>

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



