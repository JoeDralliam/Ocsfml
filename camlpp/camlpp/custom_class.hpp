/*
 * =====================================================================================
 *
 *       Filename:  custom_class.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  24/08/2011 10:52:39
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */
#ifndef CUSTOM_CLASS_HPP_INCLUDED
#define CUSTOM_CLASS_HPP_INCLUDED

#include <cstring>
#include <functional>
#include <type_traits>
#include <boost/type_traits.hpp>
#include <boost/function_types/result_type.hpp>
#include <boost/function_types/parameter_types.hpp>
#include <boost/functional/factory.hpp>
#include <boost/preprocessor/stringize.hpp>

#include <camlpp/conversion_management.hpp>
#include <camlpp/res_management.hpp>
#include <camlpp/stub_generator.hpp>

extern "C"
{
#include <caml/custom.h>
#include <caml/callback.h>
}


namespace camlpp
{
  template<class T>
  struct new_object
  {
    new_object(T* p) : pointee(p) 
    {}
    
    T* pointee;
  };
  

  namespace details
  {
    namespace func = boost::function_types;
    namespace mpl = boost::mpl;

    template<class MemFunc>
    struct method_traits
    {
    private:
      typedef typename func::parameter_types< MemFunc>::type param_types;
    public:
      typedef typename func::result_type< MemFunc >::type result_type;
      template<int I>
      struct args_type_
      {
      public:
	typedef typename mpl::at< param_types , mpl::int_<I> >::type type;
      };
      typedef typename func::parameter_types< MemFunc>::type args_type;
    };

    template<class MemFunc>
    struct constructor_traits
    {
    private:
      typedef typename func::result_type< MemFunc >::type pointed_type;
      typedef typename std::remove_pointer< pointed_type >::type real_type;

      typedef typename func::parameter_types< MemFunc>::type param_types;
    public:
      typedef new_object< real_type  > result_type;
      template<int I>
      struct args_type_
      {
      public:
	typedef typename mpl::at< param_types, mpl::int_<I> >::type type;
      };
      typedef typename func::parameter_types< MemFunc>::type args_type;
    };
  }

  template<class T>
  struct affect_class
  {
    static void affect_new( value& v, T const* t)
    {
      affectation_management<T const*>::affect( v, t);
    }
  };
}

using boost::mpl::int_;

#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE1( func_traits )	\
  ( func_traits ::args_type_<0>::type )

#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE2( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE1( func_traits ) ,	\
    func_traits ::args_type_<1>::type )

#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE3( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE2( func_traits ) ,	\
    func_traits ::args_type_<2>::type)

#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE4( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE3( func_traits ) ,	\
    func_traits ::args_type_<3>::type)

#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE5( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE4( func_traits ) ,	\
    func_traits ::args_type_<4>::type)

#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE6( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE5( func_traits ) ,	\
    func_traits ::args_type_<5>::type)


#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE7( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE7( func_traits ) ,	\
    func_traits ::args_type_<6>::type)


#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE8( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE8( func_traits ) ,	\
    func_traits ::args_type_<7>::type)


#define CAMLPP__METHOD_OBTAIN_PARAM_TYPE9( func_traits )		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_OBTAIN_PARAM_TYPE9( func_traits ) ,	\
    func_traits ::args_type_<8>::type)

#define CAMLPP__METHOD_PLACEHOLDERS1(func)	\
  ( func, std::placeholders::_1 )

#define CAMLPP__METHOD_PLACEHOLDERS2(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS1(func),	\
    std::placeholders::_2 )

#define CAMLPP__METHOD_PLACEHOLDERS3(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS2(func),	\
    std::placeholders::_3 )

#define CAMLPP__METHOD_PLACEHOLDERS4(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS3(func),	\
    std::placeholders::_4 )

#define CAMLPP__METHOD_PLACEHOLDERS5(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS4(func),	\
    std::placeholders::_5 )

#define CAMLPP__METHOD_PLACEHOLDERS6(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS5(func),	\
    std::placeholders::_6 )

#define CAMLPP__METHOD_PLACEHOLDERS7(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS6(func),	\
    std::placeholders::_7 )

#define CAMLPP__METHOD_PLACEHOLDERS8(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS7(func),	\
    std::placeholders::_8 )

#define CAMLPP__METHOD_PLACEHOLDERS9(func)		\
  ( CAMLPP__EXPAND CAMLPP__METHOD_PLACEHOLDERS8(func),	\
    std::placeholders::_9 )

#define CAMLPP__METHOD_BODY(func, values_name, params_count, call_flags) \
  CAMLPP__BODY( camlpp::details::method_traits,				\
		decltype(func),						\
		std::bind CAMLPP__METHOD_PLACEHOLDERS ## params_count (func), \
		values_name,						\
		params_count, CAMLPP__METHOD_OBTAIN_PARAM_TYPE, call_flags)


#define camlpp__register_external_method0( method_name, func, call_flags ) \
  CAMLPPprim value  BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _  ## method_name  ## __impl) ( value obj) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj), 1, call_flags);					\
  }


#define camlpp__register_external_method1( method_name, func, call_flags )		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1 ) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1), 2, call_flags);				\
  }
   
#define camlpp__register_external_method2( method_name, func, call_flags )		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2 ) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1, param2), 3, call_flags);		\
  }
  

#define camlpp__register_external_method3( method_name, func, call_flags )		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3 ) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1, param2, param3), 4, call_flags);		\
  }									


#define camlpp__register_external_method4( method_name, func, call_flags )		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4 ) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1, param2, param3, param4), 5, call_flags);	\
  }									


#define camlpp__register_external_method5( method_name, func, call_flags )		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4, value param5 ) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1, param2, param3, param4, param5), 6, call_flags); \
  }									\
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __byte ) ( value* v, int count ) \
  {									\
    assert( count == 6 );						\
    return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5] ); \
  }

#define camlpp__register_external_method6( method_name, func, call_flags )		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4, value param5, value param6 ) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1, param2, param3, param4, param5, param6), 7, call_flags); \
  }									\
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __byte ) ( value* v, int count ) \
  {									\
    assert( count == 7 );						\
    return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5], v[6] ); \
  }

#define camlpp__register_external_method7( method_name, func, call_flags )		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4, value param5, value param6, value param7) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1, param2, param3, param4, param5, param6, param7), 8, call_flags); \
  }									\
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __byte ) ( value* v, int count ) \
  {									\
    assert( count == 8 );						\
    return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5], v[6], v[7]); \
  }

#define camlpp__register_external_method8( method_name, func, call_flags ) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4, value param5, value param6, value param7, value param8 ) \
  {									\
    CAMLPP__METHOD_BODY( func,						\
			 (obj, param1, param2, param3, param4, param5, param6, param7, param8), 9, call_flags); \
  }									\
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __byte ) ( value* v, int count ) \
  {									\
    assert( count == 9 );						\
    return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5], v[6], v[7], v[8] ); \
  }

#define camlpp__register_method0( method_name, call_flags )				\
  camlpp__register_external_method0( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )

#define camlpp__register_method1( method_name, call_flags )				\
  camlpp__register_external_method1( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )
   
#define camlpp__register_method2( method_name, call_flags )				\
  camlpp__register_external_method2( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )  

#define camlpp__register_method3( method_name, call_flags )				\
  camlpp__register_external_method3( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )

#define camlpp__register_method4( method_name, call_flags )				\
  camlpp__register_external_method4( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )

#define camlpp__register_method5( method_name, call_flags )				\
  camlpp__register_external_method5( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )

#define camlpp__register_method6( method_name, call_flags )				\
  camlpp__register_external_method6( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )

#define camlpp__register_method7( method_name, call_flags )				\
  camlpp__register_external_method7( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )

#define camlpp__register_method8( method_name, call_flags )				\
  camlpp__register_external_method8( method_name, & CAMLPP__CLASS_NAME() :: method_name, call_flags )

#define CAMLPP__EXTERNAL_CONSTRUCTOR_BODY(func, values_name, params_count, call_flags) \
  CAMLPP__BODY( camlpp::details::constructor_traits,			\
		decltype(func),						\
		func,							\
		values_name,						\
		params_count,						\
		CAMLPP__METHOD_OBTAIN_PARAM_TYPE, call_flags)

/*
  #define camlpp__register_external_constructor0( constructor_name, func) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value unit) \
  {									\
  typedef std::remove_pointer<decltype(func)>::type FuncType;		\
  typedef method_traits< FuncType > FuncTraits;			\
  CAMLparam1( unit );							\
  <<<<<<< HEAD
  ResManagement< CAMLPP__CLASS_NAME() *, false > rm;			\
  =======
  ResManagement< CAMLPP__CLASS_NAME() *> rm;				\
  >>>>>>> b135c6fff3179e06caf16c7b15114e461f1268c8
  CAMLlocal1(res);							\
  CAMLPP__INVOKE							\
  (									\
  rm, res,								\
  func								\
  ); \
  CAMLreturn( res );							\
  }
*/

#define camlpp__register_external_constructor1( constructor_name, func, call_flags ) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1 ) \
  {									\
    CAMLPP__EXTERNAL_CONSTRUCTOR_BODY( func, (param1), 1, call_flags);		\
  }

#define camlpp__register_external_constructor2( constructor_name, func, call_flags ) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2 ) \
  {									\
    CAMLPP__EXTERNAL_CONSTRUCTOR_BODY( func, (param1, param2), 2, call_flags);	\
  }

#define camlpp__register_external_constructor3( constructor_name, func, call_flags ) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3 ) \
  {									\
    CAMLPP__EXTERNAL_CONSTRUCTOR_BODY( func, (param1, param2, param3), 3, call_flags); \
  }

#define camlpp__register_external_constructor4( constructor_name, func, call_flags ) \
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4 ) \
  {									\
    CAMLPP__EXTERNAL_CONSTRUCTOR_BODY( func, (param1, param2, param3, param4), 4, call_flags); \
  }

#define camlpp__register_external_constructor5( constructor_name, func, call_flags) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5 ) \
  {									\
    CAMLPP__EXTERNAL_CONSTRUCTOR_BODY( func, (param1, param2, param3, param4, param5), 5, call_flags); \
  }

#define CAMLPP__IGNORE1(x) 
#define CAMLPP__IGNORE2(x) 
#define CAMLPP__IGNORE3(x) 
#define CAMLPP__IGNORE4(x) 
#define CAMLPP__IGNORE5(x) 
#define CAMLPP__IGNORE6(x) 
#define CAMLPP__IGNORE7(x) 
#define CAMLPP__IGNORE8(x) 
#define CAMLPP__IGNORE9(x)


#define CAMLPP__CONSTRUCTOR_BODY(class_name, values_name, params_type, params_count, call_flags) \
  CAMLPP__BODY( camlpp::details::constructor_traits,			\
		class_name* (*)(),					\
		boost::factory<class_name*>(),				\
		values_name, params_count,				\
		params_type CAMLPP__IGNORE, call_flags)


#define camlpp__register_constructor0( constructor_name, call_flags)		\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value unit) \
  {									\
    CAMLparam1( unit );							\
    camlpp::res_management< camlpp::new_object<CAMLPP__CLASS_NAME()>, call_flags > rm; \
    CAMLlocal1(res);							\
    CAMLPP__INVOKE							\
      (									\
       rm, res,								\
       boost::factory< CAMLPP__CLASS_NAME() * >()			\
									); \
    CAMLreturn( res );							\
  }

#define camlpp__register_constructor1( constructor_name, param1_type, call_flags)	\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1 ) \
  {									\
    CAMLPP__CONSTRUCTOR_BODY( CAMLPP__CLASS_NAME(), (param1), (param1_type), 1, call_flags); \
  }

#define camlpp__register_constructor2( constructor_name, param1_type, param2_type, call_flags) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2 ) \
  {									\
    CAMLPP__CONSTRUCTOR_BODY( CAMLPP__CLASS_NAME(),			\
			      (param1, param2),				\
			      (param1_type, param2_type), 2, call_flags); \
  }

#define camlpp__register_constructor3( constructor_name, param1_type, param2_type, param3_type, call_flags) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3 ) \
  {									\
    CAMLPP__CONSTRUCTOR_BODY( CAMLPP__CLASS_NAME(),			\
			      (param1, param2, param3),			\
			      (param1_type, param2_type, param3_type), 3, call_flags); \
  }
  
#define camlpp__register_constructor4( constructor_name, param1_type, param2_type, param3_type, param4_type, call_flags) \
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4 ) \
  {									\
    CAMLPP__CONSTRUCTOR_BODY( CAMLPP__CLASS_NAME(),			\
			      (param1, param2, param3, param4),		\
			      (param1_type, param2_type, param3_type, param4_type), 4, call_flags); \
  }

#define camlpp__register_constructor5( constructor_name, param1_type, param2_type, param3_type, param4_type, param5_type, call_flags) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5 ) \
  {									\
    CAMLPP__CONSTRUCTOR_BODY( CAMLPP__CLASS_NAME(),			\
			      (param1, param2, param3, param4, param5), \
			      (param1_type, param2_type, param3_type, param4_type, param5_type), 5, call_flags); \
  }


#define camlpp__register_constructor6( constructor_name, param1_type, param2_type, param3_type, param4_type, param5_type, param6_type, call_flags) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5, value param6 ) \
  {									\
    CAMLPP__CONSTRUCTOR_BODY( CAMLPP__CLASS_NAME(),			\
			      (param1, param2, param3, param4, param5, param6), \
			      (param1_type, param2_type, param3_type, param4_type, param5_type, param6_type), 6, call_flags); \
  }									\
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __byte ) ( value* v, int count ) \
  {									\
    assert( count == 6 );						\
    return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5] ); \
  }

		
#define camlpp__register_constructor9( constructor_name, param1_type, param2_type, param3_type, param4_type, param5_type, param6_type, param7_type, param8_type, param9_type, call_flags) \
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl)  ( value param1, value param2, value param3, value param4, value param5, value param6, value param7, value param8, value param9 ) \
  {									\
    CAMLPP__CONSTRUCTOR_BODY( CAMLPP__CLASS_NAME(),			\
			      (param1, param2, param3, param4, param5, param6, param7, param8, param9), \
			      (param1_type, param2_type, param3_type, param4_type, param5_type, param6_type, param7_type, param8_type, param9_type), 9, call_flags); \
  }									\
  CAMLPPprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __byte ) ( value* v, int count ) \
  {									\
    assert( count == 9 );						\
    return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5], v[6], v[7], v[8] ); \
  }


/*  std::cout << "Creating : " << BOOST_PP_STRINGIZE( superclass_name ) << " (from " << BOOST_PP_STRINGIZE( CAMLPP__CLASS_NAME() ) << " ), at " << dynamic_cast<superclass_name*>(sub) << std::endl; */
  
#define camlpp__register_inheritance_relationship( superclass_name )	\
  superclass_name * BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ) ( CAMLPP__CLASS_NAME() * sub ) \
  {									\
    return sub;								\
  }									\
  CAMLPPprim value BOOST_PP_CAT( BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ), __impl ) ( value param1 ) \
  {									\
    CAMLparam1( param1 );						\
    camlpp::res_management< superclass_name *, 0> rm;			\
    camlpp::conversion_management< CAMLPP__CLASS_NAME() * > cm1;	\
    CAMLPP__CLASS_NAME() * p1 = cm1.from_value( param1 );		\
    CAMLlocal1(res);							\
    CAMLPP__INVOKE							\
      (									\
       rm, res,								\
       BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ), \
       p1								\
									); \
    CAMLreturn( res );							\
  }



#define camlpp__preregister_custom_class( class_name )			\
  namespace camlpp							\
  {									\
    template<>								\
      struct conversion_management< class_name * >			\
    {									\
      class_name* from_value( value const& v)				\
      {									\
	if( Tag_val( v ) == Object_tag )				\
	  {								\
	    static value callback_method = 0;				\
	    if( !callback_method )					\
	      {								\
		callback_method = hash_variant( BOOST_PP_STRINGIZE( BOOST_PP_CAT( rep__, class_name ) ) ); \
	      }								\
	    return from_value(callback(caml_get_public_method( v, callback_method),v)); \
	  }								\
	if( Tag_val( v ) == Abstract_tag )				\
	  {								\
	    return reinterpret_cast< class_name *>( Field(v, 0) );	\
	  }								\
	assert( Tag_val( v ) == Custom_tag );				\
	return *reinterpret_cast< class_name **>( Data_custom_val(v) );	\
      }									\
    };									\
    template<>								\
      struct conversion_management< class_name & > : private conversion_management< class_name * > \
    {									\
      class_name& from_value( value const& v)				\
      {									\
	return *conversion_management< class_name * >::from_value( v ); \
      }									\
    };									\
    template<>								\
      struct conversion_management< class_name const & > : private conversion_management< class_name * > \
    {									\
      class_name const& from_value( value const& v)			\
      {									\
	return *conversion_management< class_name * >::from_value( v );	\
      }									\
    };									\
    template<>								\
      struct conversion_management< class_name const * > : private conversion_management< class_name * > \
    {									\
      class_name const* from_value( value const& v)			\
      {									\
	return conversion_management< class_name * >::from_value( v );	\
      }									\
    };									\
    template<>								\
      struct affectation_management< class_name const&>			\
    {									\
      static void affect( value& v, class_name const& obj )		\
      {									\
	affectation_management< class_name const*>::affect( v, &obj );	\
      }									\
    };									\
    template<>								\
      struct affectation_management< class_name >			\
    {									\
      template<class T>							\
	static void affect( value& v, T obj)				\
      {									\
	affect_class< class_name >::affect_new( v, new T(std::move(obj))); \
      }									\
    };									\
    template<>								\
      struct affectation_management< new_object< class_name > >		\
    {									\
      static void affect( value& v, new_object< class_name > obj)	\
      {									\
	affect_class< class_name >::affect_new( v, obj.pointee );	\
      }									\
    };									\
  }


#define camlpp__preregister_custom_operations( class_name )		\
  extern "C" struct custom_operations BOOST_PP_CAT( BOOST_PP_CAT( camlpp__, class_name ), _custom_operations ); \
  namespace camlpp							\
  {									\
    template<>								\
      struct affect_class< class_name >					\
    {									\
      static void affect_new ( value& v, class_name const* objPtr )	\
      {									\
	v = caml_alloc_custom						\
	  (								\
	   &BOOST_PP_CAT( BOOST_PP_CAT( camlpp__, class_name ), _custom_operations ), \
	   sizeof( class_name * ),					\
	   0, 1								\
									); \
	std::memcpy( Data_custom_val( v ), &objPtr, sizeof( objPtr ) );	\
      }									\
    };									\
  }

#define camlpp__register_preregistered_custom_operations(finalize_func, compare_func, hash_func) \
  extern "C"								\
  {									\
    struct custom_operations BOOST_PP_CAT( BOOST_PP_CAT( camlpp__, CAMLPP__CLASS_NAME() ), _custom_operations ) = { \
      const_cast<char*>(BOOST_PP_STRINGIZE(org.camlpp.CAMLPP__CLASS_NAME())), \
      finalize_func,							\
      compare_func,							\
      hash_func,							\
      custom_serialize_default,						\
      custom_deserialize_default					\
    };									\
  }									\

#define camlpp__register_custom_operations(finalize_func, compare_func, hash_func) \
  camlpp__preregister_custom_operations( CAMLPP__CLASS_NAME() )		\
  camlpp__register_preregistered_custom_operations( finalize_func, compare_func, hash_func ) 


/*

  #define camlpp__preregister_custom_class_and_ops( class_name, finalize_func, compare_func, hash_func, serialize_func, deserialize_func ) \
  									\
									template<>								\
									struct ConversionManagement< class_name * >				\
									{									\
									class_name* from_value( value const& v)				\
									{									\
									assert( Tag_val( v ) == Custom_tag );				\
									return *reinterpret_cast< class_name **>( Data_custom_val(v) );	\
									}									\
									};									\
									template<>								\
									struct ConversionManagement< class_name & > : private ConversionManagement< class_name * > \
									{									\
									class_name& from_value( value const& v)				\
									{									\
									return *ConversionManagement< class_name * >::from_value( v );	\
									}									\
									};									\
									template<>								\
									struct ConversionManagement< class_name const & > : private ConversionManagement< class_name * > \
									{									\
									class_name const& from_value( value const& v)			\
									{									\
									return *ConversionManagement< class_name * >::from_value( v );	\
									}									\
									};									\
									template<>								\
									struct ConversionManagement< class_name const * > : private ConversionManagement< class_name * > \
									{									\
									class_name const* from_value( value const& v)			\
									{									\
									return ConversionManagement< class_name * >::from_value( v );	\
									}									\
									};									\
									template<>								\
									struct AffectationManagement< class_name const*>			\
									{									\
									static void affect( value& v, class_name const* objPtr )		\
									{									\
									v = caml_alloc_custom						\
									(								\
									&BOOST_PP_CAT( BOOST_PP_CAT( camlpp__, CAMLPP__CLASS_NAME() ), _custom_operations ), \
									sizeof( class_name * ),					\
									0, 1								\
									); \
									std::memcpy( Data_custom_val( v ), &objPtr, sizeof( objPtr ) );	\
									}									\
									static void affect_field( value& v, int field, class_name const* objPtr ) \
									{									\
									CAMLparam0();							\
									CAMLlocal1( tmp );						\
									affect( tmp, objPtr );						\
									Store_field(v, field, tmp);					\
									CAMLreturn0;							\
									}									\
									};								        \
									template<>								\
									struct AffectationManagement< class_name*>				\
									{									\
									static void affect( value& v, class_name* objPtr )			\
									{									\
									v = caml_alloc_custom						\
									(								\
									&BOOST_PP_CAT( BOOST_PP_CAT( camlpp__, CAMLPP__CLASS_NAME() ), _custom_operations ), \
									sizeof( class_name * ),					\
									0, 1								\
									); \
									std::memcpy( Data_custom_val( v ), &objPtr, sizeof( objPtr ) );	\
									}									\
									static void affect_field( value& v, int field, class_name* objPtr ) \
									{									\
									CAMLparam0();							\
									CAMLlocal1( tmp );						\
									affect( tmp, objPtr );						\
									Store_field(v, field, tmp);					\
									CAMLreturn0;							\
									}									\
									};									\
									template<>								\
									struct AffectationManagement< class_name const&>			\
									{									\
									static void affect( value& v, class_name const& obj )		\
									{									\
									AffectationManagement< class_name const*>::affect( v, &obj );	\
									}									\
									static void affect_field( value& v, int field, class_name const& obj) \
									{									\
									AffectationManagement< class_name const*>::affect_field(v, field, &obj); \
									}									\
									};

*/


//  std::cout << "Deleting : " << BOOST_PP_STRINGIZE( CAMLPP__CLASS_NAME() ) << ", at : " << sub << std::endl;

#define camlpp__register_preregistered_custom_class()			\
  void BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _destroy) ( CAMLPP__CLASS_NAME() * sub ) \
  {									\
    delete sub;								\
  }									\
  extern "C"								\
  {									\
    camlpp__register_free_function1( BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _destroy ), 0); \
  }									\
  extern "C"


#define camlpp__register_custom_class( )			\
  camlpp__preregister_custom_class( CAMLPP__CLASS_NAME() )	\
  camlpp__register_preregistered_custom_class()

/*
  #define camlpp__register_custom_class_and_ops( finalize_func, compare_func, hash_func, serialize_func, deserialize_func ) \
  camlpp__preregister_custom_class_and_ops( CAMLPP__CLASS_NAME() , finalize_func, compare_func, hash_func, serialize_func, deserialize_func ) \
  camlpp__register_preregistered_custom_class()
*/

#endif


