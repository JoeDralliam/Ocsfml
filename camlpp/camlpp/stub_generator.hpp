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

#define camlpp__register_overloaded_free_function0( func_name, func ) \
	CAMLprim value func_name##__impl( value unit ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(unit); \
		ResManagement< FuncTraits::result_type > rm; \
		return rm.call \
		( \
			func \
		); \
	}

#define camlpp__register_overloaded_free_function1( func_name, func ) \
	CAMLprim value func_name##__impl( value param1) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type> cm1; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ) \
		); \
	}




#define camlpp__register_overloaded_free_function2( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ) \
		); \
	}

#define camlpp__register_overloaded_free_function3( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2, value param3 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2, param3 ); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ), \
			cm3.from_value( param3 ) \
		); \
	}

#define camlpp__register_overloaded_free_function4( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2, param3, param4); \
		ResManagement< FuncTraits::result_type>  rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ), \
			cm3.from_value( param3 ), \
			cm4.from_value( param4 ) \
		); \
	}

#define camlpp__register_overloaded_free_function5( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2, param3, param4, param5); \
		ResManagement< FuncTraits::result_type > rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		ConversionManagement< FuncTraits::arg5_type > cm5; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ), \
			cm3.from_value( param3 ), \
			cm4.from_value( param4 ), \
			cm5.from_value( param5 ) \
		); \
	}

#define camlpp__register_overloaded_free_function6( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2, param3, param4, param5, param6); \
		ResManagement< FuncTraits::result_type > rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		ConversionManagement< FuncTraits::arg5_type > cm5; \
		ConversionManagement< FuncTraits::arg6_type > cm6; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ), \
			cm3.from_value( param3 ), \
			cm4.from_value( param4 ), \
			cm5.from_value( param5 ), \
			cm6.from_value( param6 )  \
		); \
	} \
	CAMLprim value func_name##__byte( value* v, int count ) \
	{ \
		assert( count == 6 ); \
		return  func_name##__impl ( v[0], v[1], v[2],v[3], v[4], v[5] ); \
	}

#define camlpp__register_overloaded_free_function7( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6, value param7 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2, param3, param4, param5, param6, param7); \
		ResManagement< FuncTraits::result_type > rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		ConversionManagement< FuncTraits::arg5_type > cm5; \
		ConversionManagement< FuncTraits::arg6_type > cm6; \
		ConversionManagement< FuncTraits::arg7_type > cm7; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ), \
			cm3.from_value( param3 ), \
			cm4.from_value( param4 ), \
			cm5.from_value( param5 ), \
			cm6.from_value( param6 ),  \
			cm7.from_value( param7 )  \
		); \
	} \
	CAMLprim value func_name##__byte( value* v, int count ) \
	{ \
		assert( count == 7 ); \
		return func_name##__impl ( v[0], v[1], v[2],v[3], v[4], v[5], v[6] ); \
	}

#define camlpp__register_overloaded_free_function8( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6, value param7, value param8 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2, param3, param4, param5, param6, param7, param8); \
		ResManagement< FuncTraits::result_type > rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		ConversionManagement< FuncTraits::arg5_type > cm5; \
		ConversionManagement< FuncTraits::arg6_type > cm6; \
		ConversionManagement< FuncTraits::arg7_type > cm7; \
		ConversionManagement< FuncTraits::arg8_type > cm8; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ), \
			cm3.from_value( param3 ), \
			cm4.from_value( param4 ), \
			cm5.from_value( param5 ), \
			cm6.from_value( param6 ), \
			cm7.from_value( param7 ), \
			cm8.from_value( param8 )  \
		); \
	} \
	CAMLprim value func_name##__byte( value* v, int count ) \
	{ \
		assert( count == 8 ); \
		return func_name##__impl ( v[0], v[1], v[2],v[3], v[4], v[5], v[6], v[7] ); \
	}

#define camlpp__register_overloaded_free_function9( func_name, func ) \
	CAMLprim value func_name##__impl( value param1, value param2, value param3, value param4, value param5, value param6, value param7, value param8, value param9 ) \
	{ \
		typedef boost::remove_pointer< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(param1, param2, param3, param4, param5, param6, param7, param8, param9); \
		ResManagement< FuncTraits::result_type > rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		ConversionManagement< FuncTraits::arg5_type > cm5; \
		ConversionManagement< FuncTraits::arg6_type > cm6; \
		ConversionManagement< FuncTraits::arg7_type > cm7; \
		ConversionManagement< FuncTraits::arg8_type > cm8; \
		ConversionManagement< FuncTraits::arg9_type > cm9; \
		return rm.call \
		( \
			func, \
			cm1.from_value( param1 ), \
			cm2.from_value( param2 ), \
			cm3.from_value( param3 ), \
			cm4.from_value( param4 ), \
			cm5.from_value( param5 ), \
			cm6.from_value( param6 ), \
			cm7.from_value( param7 ), \
			cm8.from_value( param8 ), \
			cm9.from_value( param9 )  \
		); \
	} \
	CAMLprim value func_name##__byte( value* v, int count ) \
	{ \
		assert( count == 9 ); \
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

