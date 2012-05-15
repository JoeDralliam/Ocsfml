#ifndef CAMLPP_COMMON_HPP_INCLUDED
#define CAMLPP_COMMON_HPP_INCLUDED

#include <boost/preprocessor/expand.hpp>

#include <boost/preprocessor/list/enum.hpp>
#include <boost/preprocessor/tuple/to_list.hpp>

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
}

#include <camlpp/res_management.hpp>
#include <camlpp/conversion_management.hpp>

#define CAMLPP__CONVERT_PARAM1( param1_name, value1_name, type1 )	\
  camlpp::conversion_management< type1 > BOOST_PP_CAT(cm_, param1_name); \
  auto&& param1_name ( BOOST_PP_CAT(cm_, param1_name) . from_value ( value1_name ) )

#define CAMLPP__CONVERT_PARAM2(param1_name, param2_name,	\
			       value1_name, value2_name,	\
			       type1, type2 )			\
  CAMLPP__CONVERT_PARAM1( param1_name, value1_name, type1);	\
  CAMLPP__CONVERT_PARAM1( param2_name, value2_name, type2)	      

#define CAMLPP__CONVERT_PARAM3(param1_name, param2_name, param3_name,	\
			       value1_name, value2_name, value3_name,	\
			       type1, type2, type3 )			\
  CAMLPP__CONVERT_PARAM2(param1_name, param2_name,			\
			 value1_name, value2_name,			\
			 type1, type2 );				\
  CAMLPP__CONVERT_PARAM1( param3_name, value3_name, type3)	      

#define CAMLPP__CONVERT_PARAM4(param1_name, param2_name, param3_name, param4_name, \
			       value1_name, value2_name, value3_name, value4_name, \
			       type1, type2, type3, type4 )		\
  CAMLPP__CONVERT_PARAM3(param1_name, param2_name, param3_name,		\
			 value1_name, value2_name, value3_name,		\
			 type1, type2, type3 );				\
  CAMLPP__CONVERT_PARAM1( param4_name, value4_name, type4)	      

#define CAMLPP__CONVERT_PARAM5(param1_name, param2_name, param3_name, param4_name, param5_name, \
			       value1_name, value2_name, value3_name, value4_name, value5_name, \
			       type1, type2, type3, type4, type5 )	\
  CAMLPP__CONVERT_PARAM4(param1_name, param2_name, param3_name, param4_name, \
			 value1_name, value2_name, value3_name, value4_name, \
			 type1, type2, type3, type4 );			\
  CAMLPP__CONVERT_PARAM1( param5_name, value5_name, type5)	      

#define CAMLPP__CONVERT_PARAM6(param1_name, param2_name, param3_name, param4_name, param5_name, param6_name, \
			       value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, \
			       type1, type2, type3, type4, type5, type6 ) \
  CAMLPP__CONVERT_PARAM5(param1_name, param2_name, param3_name, param4_name, param5_name, \
			 value1_name, value2_name, value3_name, value4_name, value5_name, \
			 type1, type2, type3, type4, type5 );		\
  CAMLPP__CONVERT_PARAM1( param6_name, value6_name, type6)	      

#define CAMLPP__CONVERT_PARAM7(param1_name, param2_name, param3_name, param4_name, param5_name, param6_name, param7_name, \
			       value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name, \
			       type1, type2, type3, type4, type5, type6, type7 ) \
  CAMLPP__CONVERT_PARAM6(param1_name, param2_name, param3_name, param4_name, param5_name, param6_name, \
			 value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, \
			 type1, type2, type3, type4, type5, type6 );	\
  CAMLPP__CONVERT_PARAM1( param7_name, value7_name, type7)	      

#define CAMLPP__CONVERT_PARAM8(param1_name, param2_name, param3_name, param4_name, param5_name, param6_name, param7_name, param8_name, \
			       value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name, value8_name, \
			       type1, type2, type3, type4, type5, type6, type7, type8 ) \
  CAMLPP__CONVERT_PARAM7(param1_name, param2_name, param3_name, param4_name, param5_name, param6_name, param7_name, \
			 value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name, \
			 type1, type2, type3, type4, type5, type6, type7 ); \
  CAMLPP__CONVERT_PARAM1( param8_name, value8_name, type8)	      

#define CAMLPP__CONVERT_PARAM9(param1_name, param2_name, param3_name, param4_name, param5_name, param6_name, param7_name, param8_name, param9_name, \
			       value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name, value8_name, value9_name, \
			       type1, type2, type3, type4, type5, type6, type7, type8, type9 ) \
  CAMLPP__CONVERT_PARAM8(param1_name, param2_name, param3_name, param4_name, param5_name, param6_name, param7_name, param8_name, \
			 value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name, value8_name, \
			 type1, type2, type3, type4, type5, type6, type7, type8 ); \
  CAMLPP__CONVERT_PARAM1( param9_name, value9_name, type9)	      


#define CAMLPP__EXPAND(...) __VA_ARGS__

#define CAMLPP__REGISTER_PARAMS1( values_name ) CAMLparam1  values_name 
#define CAMLPP__REGISTER_PARAMS2( values_name ) CAMLparam2  values_name 
#define CAMLPP__REGISTER_PARAMS3( values_name ) CAMLparam3  values_name 
#define CAMLPP__REGISTER_PARAMS4( values_name ) CAMLparam4  values_name 
#define CAMLPP__REGISTER_PARAMS5( values_name ) CAMLparam5  values_name 

#define CAMLPP__REGISTER_PARAMS_HELPER6( value1_name, value2_name, value3_name, value4_name, value5_name, value6_name ) \
  CAMLparam5(value1_name, value2_name, value3_name, value4_name, value5_name); CAMLxparam1( value6_name )

#define CAMLPP__REGISTER_PARAMS_HELPER7( value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name ) \
  CAMLparam5(value1_name, value2_name, value3_name, value4_name, value5_name); CAMLxparam2( value6_name, value7_name)

#define CAMLPP__REGISTER_PARAMS_HELPER8( value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name, value8_name) \
  CAMLparam5(value1_name, value2_name, value3_name, value4_name, value5_name); CAMLxparam3( value6_name, value7_name, value8_name)

#define CAMLPP__REGISTER_PARAMS_HELPER9( value1_name, value2_name, value3_name, value4_name, value5_name, value6_name, value7_name, value8_name, value9_name ) \
  CAMLparam5(value1_name, value2_name, value3_name, value4_name, value5_name); CAMLxparam4( value6_name, value7_name, value8_name, value9_name )

#define CAMLPP__REGISTER_PARAMS6( values_name ) CAMLPP__REGISTER_PARAMS_HELPER6 values_name 
#define CAMLPP__REGISTER_PARAMS7( values_name ) CAMLPP__REGISTER_PARAMS_HELPER7 values_name 
#define CAMLPP__REGISTER_PARAMS8( values_name ) CAMLPP__REGISTER_PARAMS_HELPER8 values_name 
#define CAMLPP__REGISTER_PARAMS9( values_name ) CAMLPP__REGISTER_PARAMS_HELPER9 values_name 


#define CAMLPP__GENERATE_PARAMS_NAME1()		\
  (camlpp__p1)

#define CAMLPP__GENERATE_PARAMS_NAME2()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME1(), camlpp__p2)

#define CAMLPP__GENERATE_PARAMS_NAME3()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME2(), camlpp__p3)

#define CAMLPP__GENERATE_PARAMS_NAME4()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME3(), camlpp__p4)

#define CAMLPP__GENERATE_PARAMS_NAME5()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME4(), camlpp__p5)

#define CAMLPP__GENERATE_PARAMS_NAME6()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME5(), camlpp__p6)

#define CAMLPP__GENERATE_PARAMS_NAME7()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME6(), camlpp__p7)

#define CAMLPP__GENERATE_PARAMS_NAME8()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME7(), camlpp__p8)

#define CAMLPP__GENERATE_PARAMS_NAME9()				\
  (CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME8(), camlpp__p9)


#define CAMLPP__OBTAIN_PARAMS_HELPER(params_count, params_name, values_name , params_type) \
  ( BOOST_PP_LIST_ENUM( BOOST_PP_TUPLE_TO_LIST(params_count, params_name) ), \
    BOOST_PP_LIST_ENUM( BOOST_PP_TUPLE_TO_LIST(params_count, values_name) ), \
    BOOST_PP_LIST_ENUM( BOOST_PP_TUPLE_TO_LIST(params_count, params_type) ) )

#define CAMLPP__OBTAIN_PARAMS( params_count, params_name, values_name , params_type) \
  BOOST_PP_EXPAND( CAMLPP__CONVERT_PARAM ## params_count CAMLPP__OBTAIN_PARAMS_HELPER(params_count, params_name, values_name , params_type) )


#define CAMLPP__BODY( traits, func_type, call_func, values_name, params_count, obtain_params_type) \
  typedef boost::remove_pointer< func_type >::type FuncType;		\
  typedef traits< FuncType > FuncTraits;				\
  CAMLPP__REGISTER_PARAMS ## params_count (values_name);		\
  CAMLPP__OBTAIN_PARAMS( params_count,					\
			 CAMLPP__GENERATE_PARAMS_NAME ## params_count(), \
			 values_name,					\
			 obtain_params_type ## params_count (FuncTraits) ); \
  camlpp::res_management< FuncTraits::result_type> rm;			\
  CAMLlocal1( res );							\
  CAMLPP__INVOKE( rm, res, call_func, CAMLPP__EXPAND CAMLPP__GENERATE_PARAMS_NAME ## params_count()); \
  CAMLreturn( res )


#if defined(__GNUC__) && __GNUC__ >= 4
#define CAMLPPprim __attribute__ (( visibility ("default") ))
#else
#define CAMLPPprim
#endif

#endif
