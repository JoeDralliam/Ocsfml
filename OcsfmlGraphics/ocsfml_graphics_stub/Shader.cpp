#include "Shader.hpp"

#include "InputStream.hpp"
#include "Vector.hpp"

#include "Color.hpp"
#include "Texture.hpp"
#include "Transform.hpp"

#include <camlpp/custom_ops.hpp>
#include <camlpp/stub_generator.hpp>
#include <camlpp/type_option.hpp>
#include <camlpp/unit.hpp>
#include <camlpp/std/string.hpp>

#include <stdexcept>

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
							camlpp::optional<ResourceType> vertex, \
							camlpp::optional<ResourceType> frag, \
							camlpp::unit ) \
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
	throw std::runtime_error("Error: no source specified");		\
      }									\
  }


namespace
{
  SHADER_LOAD_FROM_RESOURCE_HELPER_DEF( file, std::string, loadFromFile )
  SHADER_LOAD_FROM_RESOURCE_HELPER_DEF( stream, sf::InputStream&, loadFromStream )
  SHADER_LOAD_FROM_RESOURCE_HELPER_DEF( memory, std::string, loadFromMemory )
  
  void shader_set_current_texture_helper( sf::Shader* s, std::string str )
  {
    s->setParameter( str, sf::Shader::CurrentTexture );
  }
}



#define CAMLPP__CLASS_NAME() sf_Shader
camlpp__register_preregistered_custom_operations( CAMLPP__DEFAULT_FINALIZE(), CAMLPP__NO_COMPARE(), CAMLPP__NO_HASH() )
camlpp__register_preregistered_custom_class()
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
