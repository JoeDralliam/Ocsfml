#include "Drawable.hpp"
#include "BlendMode.hpp"
#include "Transform.hpp"
#include "Texture.hpp"
#include "Shader.hpp"

#include <camlpp/stub_generator.hpp>
#include <camlpp/std/function.hpp>

class OverrideDrawable : public sf::Drawable
{
public:
  typedef std::function<void(sf::RenderTarget*, sf::BlendMode, sf::Transform const&, sf::Texture const*, sf::Shader const* )> CallbackType;
private:
  CallbackType callback_; 
private:
  virtual void draw(sf::RenderTarget& target, sf::RenderStates states) const
  {
    caml_acquire_runtime_system();
    callback_(&target, states.blendMode, states.transform, states.texture, states.shader );
    caml_release_runtime_system();
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


camlpp::new_object< sf::Drawable > sf_Drawable_inherits()
{
  return camlpp::new_object<sf::Drawable>( new OverrideDrawable() );
}

void sf_Drawable_override_draw( sf::Drawable* d, OverrideDrawable::CallbackType c )
{
  static_cast<OverrideDrawable*>(d)->setCallback(c);
}


extern "C" 
{
  camlpp__register_free_function0(sf_Drawable_inherits, 0)
  camlpp__register_free_function2(sf_Drawable_override_draw, 0)
}

