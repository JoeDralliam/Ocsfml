/*
 * =====================================================================================
 *
 *       Filename:  stub_generator.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 11:47:01
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 *
 */

#ifndef STUB_GEBERATOR_HPP_INCLUDED
#define STUB_GEBERATOR_HPP_INCLUDED


#include "res_management.hpp"
#include "affectation_management.hpp"
#include "conversion_management.hpp"
#include "memory_management.hpp"
#include <type_traits>
#include <boost/type_traits.hpp>
#include "common.hpp"


#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE1( func_traits )	\
  ( func_traits ::arg1_type)

#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE2( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE1( func_traits ) , \
    func_traits ::arg2_type )

#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE3( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE2( func_traits ) , \
    func_traits ::arg3_type )

#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE4( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE3( func_traits ) , \
    func_traits ::arg4_type )

#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE5( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE4( func_traits ) , \
    func_traits ::arg5_type )

#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE6( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE5( func_traits ) , \
    func_traits ::arg6_type )


#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE7( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE7( func_traits ) , \
    func_traits ::arg7_type )


#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE8( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE8( func_traits ) , \
    func_traits ::arg8_type )


#define CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE9( func_traits )	\
  ( CAMLPP__EXPAND CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE9( func_traits ) , \
    func_traits ::arg9_type )



#define CAMLPP__FREE_FUNCTION_BODY(func, values_name, params_count) \
  CAMLPP__BODY( boost::function_traits, decltype(func), func, values_name, params_count, CAMLPP__FREE_FUNCTION_OBTAIN_PARAM_TYPE)

#define camlpp__register_overloaded_free_function0( func_name, func )	\
  CAMLprim value func_name##__impl( value unit )			\
  {									\
    typedef boost::remove_pointer< decltype( func ) >::type FuncType;	\
    typedef boost::function_traits< FuncType > FuncTraits;		\
    CAMLparam1(unit);							\
    camlpp::res_management< FuncTraits::result_type > rm;		\
    CAMLlocal1(res);							\
    CAMLPP__INVOKE							\
      (									\
       rm, res,								\
       func								\
									); \
    CAMLreturn(res);							\
  }

#define camlpp__register_overloaded_free_function1( func_name, func )	\
  CAMLprim value func_name##__impl( value param1)			\
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1), 1);			\
  }



#define camlpp__register_overloaded_free_function2( func_name, func )  \
  CAMLprim value func_name##__impl( value param1, value param2 )       \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2), 2);		\
  }


#define camlpp__register_overloaded_free_function3( func_name, func ) \
  CAMLprim value func_name##__impl( value param1, value param2, value param3 ) \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2, param3), 3);	\
  }


#define camlpp__register_overloaded_free_function4( func_name, func )	\
  CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4 ) \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2, param3, param4), 4); \
  }

#define camlpp__register_overloaded_free_function5( func_name, func ) \
  CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5 ) \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2, param3, param4, param5), 5); \
  }

#define camlpp__register_overloaded_free_function6( func_name, func )	\
  CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6 ) \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2, param3, param4, param5, param6), 6); \
  }									\
  value func_name##__byte( value* v, int count )			\
  {									\
    assert( count == 6 );						\
    return  func_name##__impl ( v[0], v[1], v[2],v[3], v[4], v[5] );	\
  }

#define camlpp__register_overloaded_free_function7( func_name, func )	\
  CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6, value param7 ) \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2, param3, param4, param5, param6, param7), 7); \
  }									\
  value func_name##__byte( value* v, int count )			\
  {									\
    assert( count == 7 );						\
    return func_name##__impl ( v[0], v[1], v[2],v[3], v[4], v[5], v[6] ); \
  }

#define camlpp__register_overloaded_free_function8( func_name, func )	\
  CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6, value param7, value param8 ) \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2, param3, param4, param5, param6, param7, param8), 8); \
  }									\
  value func_name##__byte( value* v, int count )			\
  {									\
    assert( count == 8 );						\
    return func_name##__impl ( v[0], v[1], v[2],v[3], v[4], v[5], v[6], v[7] ); \
  }

#define camlpp__register_overloaded_free_function9( func_name, func )	\
  CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6, value param7, value param8, value param9 ) \
  {									\
    CAMLPP__FREE_FUNCTION_BODY( func, (param1, param2, param3, param4, param5, param6, param7, param8, param9), 9); \
  }									\
  value func_name##__byte( value* v, int count )			\
  {									\
    assert( count == 9 );						\
    return func_name##__impl ( v[0], v[1], v[2],v[3], v[4], v[5], v[6], v[7], v[8] ); \
  }

#define camlpp__register_free_function0( func_name ) camlpp__register_overloaded_free_function0( func_name, & func_name ) 

#define camlpp__register_free_function1( func_name ) camlpp__register_overloaded_free_function1( func_name, & func_name ) 

#define camlpp__register_free_function2( func_name ) camlpp__register_overloaded_free_function2( func_name, & func_name ) 

#define camlpp__register_free_function3( func_name ) camlpp__register_overloaded_free_function3( func_name, & func_name ) 

#define camlpp__register_free_function4( func_name ) camlpp__register_overloaded_free_function4( func_name, & func_name ) 

#define camlpp__register_free_function5( func_name ) camlpp__register_overloaded_free_function5( func_name, & func_name ) 

#define camlpp__register_free_function6( func_name ) camlpp__register_overloaded_free_function6( func_name, & func_name ) 

#define camlpp__register_free_function7( func_name ) camlpp__register_overloaded_free_function7( func_name, & func_name )

#define camlpp__register_free_function8( func_name ) camlpp__register_overloaded_free_function8( func_name, & func_name ) 

#define camlpp__register_free_function9( func_name ) camlpp__register_overloaded_free_function9( func_name, & func_name ) 

#endif

