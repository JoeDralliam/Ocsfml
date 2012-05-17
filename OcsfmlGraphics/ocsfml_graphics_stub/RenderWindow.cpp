#include "RenderWindow.hpp"

#include "ContextSettings.hpp"
#include "VideoMode.hpp"
#include "Window.hpp"

#include "Image.hpp"
#include "RenderTarget.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/std/string.hpp>
#include <camlpp/std/list.hpp>

namespace
{
  sf::RenderWindow* render_window_constructor_helper(camlpp::optional<std::list<unsigned long> > style , camlpp::optional<sf::ContextSettings> cs, sf::VideoMode vm, std::string const& title)
  {
    unsigned long actualStyle =  
      style.is_some() ? style_of_list_unsigned( style.get_value() ) : sf::Style::Default;
    sf::ContextSettings actualSettings = cs.get_value_no_fail( sf::ContextSettings() );
    return new sf::RenderWindow( vm, title, actualStyle, actualSettings );
  }
}

#define CAMLPP__CLASS_NAME() sf_RenderWindow
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
{
  camlpp__register_inheritance_relationship( sf_RenderTarget );
  camlpp__register_inheritance_relationship( sf_Window );
  camlpp__register_constructor0( default_constructor, 0);
  camlpp__register_external_constructor4( create_constructor, &render_window_constructor_helper, 0);
  camlpp__register_method0( capture, camlpp::release_caml_runtime);
}
#undef CAMLPP__CLASS_NAME

