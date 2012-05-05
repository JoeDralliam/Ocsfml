#include "Transform.hpp"

#include "Vector.hpp"

#include "Rect.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>

typedef sf::Vector2f (sf::Transform::*TransformPointFunc)(float,float) const;
typedef sf::Vector2f (sf::Transform::*TransformPointVFunc)(sf::Vector2f const&) const;

namespace
{
  void transform_translate_helper(sf::Transform* t, float x, float y)
  {
    t->translate(x,y);
  }

  void transform_translateV_helper(sf::Transform* t, sf::Vector2f v)
  {
    t->translate(v);
  }

  void transform_rotate_helper(sf::Transform* t, camlpp::optional< float > x, camlpp::optional<float> y, float degrees)
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

  void transform_rotateV_helper(sf::Transform* t, camlpp::optional< sf::Vector2f > v, float degrees)
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

  void transform_scale_helper(sf::Transform* t, camlpp::optional< float > x, camlpp::optional<float> y, float scaleX, float scaleY)
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

  void transform_scaleV_helper(sf::Transform* t, camlpp::optional< sf::Vector2f > v, sf::Vector2f scale)
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
}

#define CAMLPP__CLASS_NAME() sf_Transform
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
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

