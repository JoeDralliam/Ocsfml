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

#include <functional>
#include <type_traits>
#include <boost/type_traits.hpp>
#include <boost/function_types/result_type.hpp>
#include <boost/function_types/parameter_types.hpp>
#include <boost/functional/factory.hpp>
#include <boost/preprocessor/library.hpp>
#include <boost/preprocessor/stringize.hpp>
#include "conversion_management.hpp"
#include "res_management.hpp"
#include "memory_management.hpp"
#include "stub_generator.hpp"

extern "C"
{
	#include <caml/custom.h>
}

template<class MemFunc>
struct method_traits
{
	typedef typename boost::function_types::result_type< MemFunc >::type result_type;
	typedef boost::function_types::parameter_types< MemFunc/*, boost::function_types::add_pointer< boost::mpl::_ > */ > args_type;
};

using boost::mpl::int_;
//#define CAMLPP__CLASS_NAME() CAMLPP__CLASS_NAME()

#define camlpp__register_method0( method_name, func ) \
	CAMLprim value  BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _  ## method_name  ## __impl) ( value obj) \
	{ \
		typedef std::remove_pointer< decltype( func ) >::type FuncType; \
		typedef method_traits< FuncType > FuncTraits; \
		CAMLparam1(obj); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
		CAMLlocal1(res);\
		CAMLPP__INVOKE \
		( \
			rm, res, \
			std::bind(func, std::placeholders::_1), \
			cm1.from_value( obj ) \
		); \
		CAMLreturn( res ); \
	}


#define camlpp__register_method1( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1 ) \
	{ \
		typedef std::remove_pointer<decltype( func ) >::type FuncType; \
		typedef method_traits< FuncType > FuncTraits; \
		CAMLparam2(obj, param1); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
		CAMLlocal1(res);\
		CAMLPP__INVOKE \
		( \
			rm, res, \
			std::bind(func, std::placeholders::_1, std::placeholders::_2), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ) \
		); \
		CAMLreturn( res ); \
	}

#define camlpp__register_method2( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2 ) \
	{ \
		typedef std::remove_pointer<decltype( func ) >::type FuncType; \
		typedef method_traits< FuncType > FuncTraits; \
		CAMLparam3(obj, param1, param2); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<2> >::type > cm3; \
		CAMLlocal1(res);\
		CAMLPP__INVOKE \
		( \
			rm, res, \
			std::bind(func, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ),	\
			cm3.from_value( param2 ) \
		); \
		CAMLreturn( res ); \
	}

#define camlpp__register_method3( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3 ) \
	{ \
		typedef std::remove_pointer<decltype( func ) >::type FuncType; \
		typedef method_traits< FuncType > FuncTraits; \
		CAMLparam4(obj, param1, param2, param3); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<2> >::type > cm3; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<3> >::type > cm4; \
		CAMLlocal1(res);\
		CAMLPP__INVOKE \
		( \
			rm, res, \
			std::bind(func, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ), \
			cm3.from_value( param2 ), \
			cm4.from_value( param3 ) \
		); \
		CAMLreturn( res ); \
	}


#define camlpp__register_method4( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4 ) \
	{ \
		typedef std::remove_pointer<decltype( func ) >::type FuncType; \
		typedef method_traits< FuncType > FuncTraits; \
		CAMLparam5(obj, param1, param2, param3, param4); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<2> >::type > cm3; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<3> >::type > cm4; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<4> >::type > cm5; \
		CAMLlocal1(res);\
		CAMLPP__INVOKE \
		( \
			rm, res, \
			std::bind(func, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ), \
			cm3.from_value( param2 ), \
			cm4.from_value( param3 ), \
			cm5.from_value( param4 ) \
		); \
		CAMLreturn( res ); \
	}

#define camlpp__register_method5( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4, value param5 ) \
	{ \
		typedef std::remove_pointer<decltype( func ) >::type FuncType; \
		typedef method_traits< FuncType > FuncTraits; \
		CAMLparam5(obj, param1, param2, param3, param4); \
		CAMLxparam1(param5); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<2> >::type > cm3; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<3> >::type > cm4; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<4> >::type > cm5; \
		ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<5> >::type > cm6; \
		CAMLlocal1(res);\
		CAMLPP__INVOKE \
		( \
			rm, res, \
			std::bind(func, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5, std::placeholders::_6), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ), \
			cm3.from_value( param2 ), \
			cm4.from_value( param3 ), \
			cm5.from_value( param4 ), \
			cm6.from_value( param5 ) \
		); \
		CAMLreturn( res ); \
	} \
	CAMLprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __byte ) ( value* v, int count ) \
	{ \
		assert( count == 6 ); \
		return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## method_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5] ); \
	}


#define camlpp__register_external_constructor0( constructor_name, func) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value unit) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef method_traits< FuncType > FuncTraits; \
			CAMLparam1( param1 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				func \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_external_constructor1( constructor_name, func) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef method_traits< FuncType > FuncTraits; \
			CAMLparam1( param1 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				func, \
				cm1.from_value( param1 ) \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_external_constructor2( constructor_name, func ) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef method_traits< FuncType > FuncTraits; \
			CAMLparam2( param1, param2 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				func, \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ) \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_external_constructor3( constructor_name, func ) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef method_traits< FuncType > FuncTraits; \
			CAMLparam3( param1, param2, param3 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<2> >::type > cm3; \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				func, \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ), \
				cm3.from_value( param3 ) \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_external_constructor4( constructor_name, func ) \
		CAMLprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef method_traits< FuncType > FuncTraits; \
			CAMLparam4( param1, param2, param3, param4 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<2> >::type > cm3; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<3> >::type > cm4; \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res,\
				func, \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ), \
				cm3.from_value( param3 ), \
				cm4.from_value( param4 ) \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_external_constructor5( constructor_name, func) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef method_traits< FuncType > FuncTraits; \
			CAMLparam5( param1, param2, param3, param4, param5 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<0> >::type > cm1; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<1> >::type > cm2; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<2> >::type > cm3; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<3> >::type > cm4; \
			ConversionManagement< boost::mpl::at< FuncTraits::args_type, int_<4> >::type > cm5; \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				func, \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ), \
				cm3.from_value( param3 ), \
				cm4.from_value( param4 ), \
				cm5.from_value( param5 )  \
			); \
			CAMLreturn( res ); \
		}



#define camlpp__register_constructor0( constructor_name) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value unit) \
		{ \
			CAMLparam1( unit ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >() \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_constructor1( constructor_name, param1_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1 ) \
		{ \
			CAMLparam1( param1 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< param1_type > cm1; \
			auto p1 = cm1.from_value( param1 ); \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				p1 \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_constructor2( constructor_name, param1_type, param2_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2 ) \
		{ \
			CAMLparam2( param1, param2 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			auto p1 = cm1.from_value( param1 ); \
			auto p2 = cm2.from_value( param2 ); \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				p1, \
				p2 \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_constructor3( constructor_name, param1_type, param2_type, param3_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3 ) \
		{ \
			CAMLparam3( param1, param2, param3 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			auto p1 = cm1.from_value( param1 ); \
			auto p2 = cm2.from_value( param2 ); \
			auto p3 = cm3.from_value( param3 ); \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				p1, \
				p2, \
				p3 \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_constructor4( constructor_name, param1_type, param2_type, param3_type, param4_type) \
		CAMLprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4 ) \
		{ \
			CAMLparam4( param1, param2, param3, param4 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			ConversionManagement< param4_type > cm4; \
			auto p1 = cm1.from_value( param1 ); \
			auto p2 = cm2.from_value( param2 ); \
			auto p3 = cm3.from_value( param3 ); \
			auto p4 = cm4.from_value( param4 ); \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				p1, \
				p2, \
				p3, \
				p4 \
			); \
			CAMLreturn( res ); \
		}

#define camlpp__register_constructor5( constructor_name, param1_type, param2_type, param3_type, param4_type, param5_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5 ) \
		{ \
			CAMLparam5( param1, param2, param3, param4, param5 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			ConversionManagement< param4_type > cm4; \
			ConversionManagement< param5_type > cm5; \
			auto p1 = cm1.from_value( param1 ); \
			auto p2 = cm2.from_value( param2 ); \
			auto p3 = cm3.from_value( param3 ); \
			auto p4 = cm4.from_value( param4 ); \
			auto p5 = cm5.from_value( param5 ); \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				p1, \
				p2, \
				p3, \
				p4, \
				p5  \
			); \
			CAMLreturn( res ); \
		}


#define camlpp__register_constructor6( constructor_name, param1_type, param2_type, param3_type, param4_type, param5_type, param6_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5, value param6 ) \
		{ \
			CAMLparam5( param1, param2, param3, param4, param5 ); \
			CAMLxparam1( param6 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			ConversionManagement< param4_type > cm4; \
			ConversionManagement< param5_type > cm5; \
			ConversionManagement< param6_type > cm6; \
			auto p1 = cm1.from_value( param1 ); \
			auto p2 = cm2.from_value( param2 ); \
			auto p3 = cm3.from_value( param3 ); \
			auto p4 = cm4.from_value( param4 ); \
			auto p5 = cm5.from_value( param5 ); \
			auto p6 = cm6.from_value( param6 ); \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				p1, \
				p2, \
				p3, \
				p4, \
				p5, \
				p6  \
			); \
			CAMLreturn( res ); \
		} \
		CAMLprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __byte ) ( value* v, int count ) \
		{ \
			assert( count == 6 ); \
			return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5] ); \
		}

		
#define camlpp__register_constructor9( constructor_name, param1_type, param2_type, param3_type, param4_type, param5_type, param6_type, param7_type, param8_type, param9_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5, value param6, value param7, value param8, value param9) \
		{ \
			CAMLparam5( param1, param2, param3, param4, param5 ); \
			CAMLxparam4( param6, param7, param8, param9 ); \
			ResManagement< CAMLPP__CLASS_NAME() *, false > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			ConversionManagement< param4_type > cm4; \
			ConversionManagement< param5_type > cm5; \
			ConversionManagement< param6_type > cm6; \
			ConversionManagement< param7_type > cm7; \
			ConversionManagement< param8_type > cm8; \
			ConversionManagement< param9_type > cm9; \
			auto p1 = cm1.from_value( param1 ); \
			auto p2 = cm2.from_value( param2 ); \
			auto p3 = cm3.from_value( param3 ); \
			auto p4 = cm4.from_value( param4 ); \
			auto p5 = cm5.from_value( param5 ); \
			auto p6 = cm6.from_value( param6 ); \
			auto p7 = cm7.from_value( param7 ); \
			auto p8 = cm8.from_value( param8 ); \
			auto p9 = cm9.from_value( param9 ); \
			CAMLlocal1(res);\
			CAMLPP__INVOKE \
			( \
				rm, res, \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				p1, \
				p2, \
				p3, \
				p4, \
				p5, \
				p6, \
				p7, \
				p8, \
				p9  \
			); \
			CAMLreturn( res ); \
		} \
		CAMLprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __byte ) ( value* v, int count ) \
		{ \
			assert( count == 9 ); \
			return BOOST_PP_CAT( CAMLPP__CLASS_NAME() , _## constructor_name ## __impl ) ( v[0], v[1], v[2],v[3], v[4], v[5], v[6], v[7], v[8] ); \
		}



#define camlpp__register_inheritance_relationship( superclass_name ) \
	superclass_name * BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ) ( CAMLPP__CLASS_NAME() * sub ) \
	{ \
		return sub; \
	} \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ), __impl ) ( value param1 ) \
	{ \
		CAMLparam1( param1 ); \
		ResManagement< superclass_name *, false> rm; \
		ConversionManagement< CAMLPP__CLASS_NAME() * > cm1;\
		CAMLlocal1(res);\
		CAMLPP__INVOKE \
		( \
			rm, res, \
			BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ), \
			cm1.from_value( param1 ) \
		); \
		CAMLreturn( res ); \
	}


#define camlpp__preregister_custom_class( class_name ) \
	template<> \
	struct ConversionManagement< class_name * > \
	{ \
		class_name* from_value( value const& v) \
		{ \
			if( Tag_val( v ) == Object_tag ) \
			{ \
				return reinterpret_cast< class_name*>( Field(callback( caml_get_public_method( v, hash_variant( BOOST_PP_STRINGIZE( BOOST_PP_CAT( rep__, class_name ) ) ) ), v), 0)); \
			} \
			assert( Tag_val( v ) == Abstract_tag ); \
			return reinterpret_cast< class_name *>( Field(v, 0) ); \
		} \
	}; \
	template<> \
	struct ConversionManagement< class_name & > : private ConversionManagement< class_name * > \
	{ \
	        class_name& from_value( value const& v)		\
		{ \
			return *ConversionManagement< class_name * >::from_value( v ); \
		} \
	}; \
	template<> \
	struct ConversionManagement< class_name const & > : private ConversionManagement< class_name * > \
	{ \
	        class_name const& from_value( value const& v)		\
		{ \
			return *ConversionManagement< class_name * >::from_value( v ); \
		} \
	}; \
	template<> \
	struct ConversionManagement< class_name const * > : private ConversionManagement< class_name * > \
	{ \
	        class_name const* from_value( value const& v)		\
		{ \
			return ConversionManagement< class_name * >::from_value( v ); \
		} \
	}; \
	template<> \
	struct AffectationManagement< class_name const*, true > \
	{ \
		static void affect( value& v, class_name const* obj ) \
		{  \
			CAMLparam0(); \
			CAMLlocal1( objPtrVal ); \
			AffectationManagement< class_name const*, false >::affect(objPtrVal, obj); \
			v = callback( *caml_named_value( BOOST_PP_STRINGIZE( BOOST_PP_CAT(external_cpp_create_, class_name ) ) ),  objPtrVal ); \
			CAMLreturn0; \
		} \
		static void affect_field( value& v, int field, class_name const* obj) \
		{ \
			CAMLparam0(); \
			CAMLlocal1( objVal ); \
			affect( objVal, obj ); \
			Store_field(v, 0, objVal); \
			CAMLreturn0; \
		} \
	}; \
	template<>  \
	struct AffectationManagement< class_name const&, true > \
	{ \
		static void affect( value& v, class_name const& obj ) \
		{ \
			AffectationManagement< class_name const*, true >::affect( v, &obj ); \
		} \
		static void affect_field( value& v, int field, class_name const& obj) \
		{ \
			AffectationManagement< class_name const*, true>::affect_field(v, field, &obj); \
		} \
	}; 


#define camlpp__preregister_custom_class_and_ops( class_name, finalize_func, compare_func, hash_func, serialize_func, deserialize_func ) \
	extern "C" \
	{ \
		static struct custom_operations BOOST_PP_CAT( BOOST_PP_CAT( camlpp__, CAMLPP__CLASS_NAME() ), _custom_operations ) = { \
			BOOST_PP_STRINGIZE( org.camlpp.CAMLPP__CLASS_NAME() ), \
			finalize_func, \
			compare_func, \
			hash_func, \
			serialize_func, \
			deserialize_func \
		}; \
	} \
	template<> \
	struct ConversionManagement< class_name * > \
	{ \
		class_name* from_value( value const& v) \
		{ \
			if( Tag_val( v ) == Object_tag ) \
			{ \
				return *reinterpret_cast< class_name**> \
					( \
						Data_custom_val \
						( \
							callback \
							( \
								caml_get_public_method \
								( \
									 v, \
									 hash_variant( BOOST_PP_STRINGIZE( BOOST_PP_CAT( rep__, class_name ) ) ) \
								), \
								v \
							) \
						) \
					); \
			} \
			assert( Tag_val( v ) == Custom_tag ); \
			return *reinterpret_cast< class_name **>( Data_custom_val(v) ); \
		} \
	}; \
	template<> \
	struct ConversionManagement< class_name & > : private ConversionManagement< class_name * > \
	{ \
	        class_name& from_value( value const& v)		\
		{ \
			return *ConversionManagement< class_name * >::from_value( v ); \
		} \
	}; \
	template<> \
	struct ConversionManagement< class_name const & > : private ConversionManagement< class_name * > \
	{ \
	        class_name const& from_value( value const& v)		\
		{ \
			return *ConversionManagement< class_name * >::from_value( v ); \
		} \
	}; \
	template<> \
	struct ConversionManagement< class_name const * > : private ConversionManagement< class_name * > \
	{ \
	        class_name const* from_value( value const& v)		\
		{ \
			return ConversionManagement< class_name * >::from_value( v ); \
		} \
	}; \
	template<> \
	struct AffectationManagement< class_name*, false > \
	{ \
		static void affect( value& v, class_name* objPtr ) \
		{ \
			v = caml_alloc_custom \
				( \
					&BOOST_PP_CAT( BOOST_PP_CAT( camlpp__, CAMLPP__CLASS_NAME() ), _custom_operations ), \
					sizeof( class_name * ), \
					0, 1 \
				); \
			std::memcpy( Data_custom_val( v ), &objPtr, sizeof( objPtr ) ); \
		} \
		static void affect_field( value& v, int field, class_name* objPtr ) \
		{ \
			CAMLparam0(); \
			CAMLlocal1( tmp ); \
			affect( tmp, objPtr ); \
			Store_field(v, field, tmp); \
			CAMLreturn0; \
		} \
	}; \
	template<> \
	struct AffectationManagement< class_name const*, true > \
	{ \
		static void affect( value& v, class_name const* obj ) \
		{  \
			CAMLparam0(); \
			CAMLlocal1( objPtrVal ); \
			AffectationManagement< class_name const*, false >::affect(objPtrVal, obj); \
			v = callback( *caml_named_value( BOOST_PP_STRINGIZE( BOOST_PP_CAT(external_cpp_create_, class_name ) ) ),  objPtrVal ); \
			CAMLreturn0; \
		} \
		static void affect_field( value& v, int field, class_name const* obj) \
		{ \
			CAMLparam0(); \
			CAMLlocal1( objVal ); \
			affect( objVal, obj ); \
			Store_field(v, 0, objVal); \
			CAMLreturn0; \
		} \
	}; \
	template<>  \
	struct AffectationManagement< class_name const&, true > \
	{ \
		static void affect( value& v, class_name const& obj ) \
		{ \
			AffectationManagement< class_name const*, true >::affect( v, &obj ); \
		} \
		static void affect_field( value& v, int field, class_name const& obj) \
		{ \
			AffectationManagement< class_name const*, true>::affect_field(v, field, &obj); \
		} \
	};




#define camlpp__register_preregistered_custom_class() \
	void  BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _destroy) ( CAMLPP__CLASS_NAME() * sub ) \
	{ \
		delete sub; \
	} \
	extern "C" \
	{ \
		camlpp__register_free_function1( BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _destroy) )


#define camlpp__register_custom_class( ) \
	camlpp__preregister_custom_class( CAMLPP__CLASS_NAME() ) \
	camlpp__register_preregistered_custom_class()


#define camlpp__register_custom_class_and_ops( finalize_func, compare_func, hash_func, serialize_func, deserialize_func ) \
	camlpp__preregister_custom_class_and_ops( CAMLPP__CLASS_NAME() , finalize_func, compare_func, hash_func, serialize_func, deserialize_func ) \
	camlpp__register_preregistered_custom_class()


/*
 	template<> \
	struct ConversionManagement< CAMLPP__CLASS_NAME() * > \
	{ \
		CAMLPP__CLASS_NAME()* from_value( value const& v) \
		{ \
			if( Tag_val( v ) == Object_tag ) \
			{ \
				return reinterpret_cast< CAMLPP__CLASS_NAME()*>( Field(callback( caml_get_public_method( v, hash_variant( BOOST_PP_STRINGIZE( BOOST_PP_CAT( rep__, CAMLPP__CLASS_NAME() ) ) ) ), v), 0)); \
			} \
			assert( Tag_val( v ) == Abstract_tag ); \
			return reinterpret_cast< CAMLPP__CLASS_NAME() *>( Field(v, 0) ); \
		} \
	}; \
	template<> \
	struct ConversionManagement< CAMLPP__CLASS_NAME() & > : private ConversionManagement< CAMLPP__CLASS_NAME() * > \
	{ \
		CAMLPP__CLASS_NAME()& from_value( value const& v) \
		{ \
			return *ConversionManagement< CAMLPP__CLASS_NAME() * >::from_value( v ); \
		} \
	}; \
	void  BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _destroy) ( CAMLPP__CLASS_NAME() * sub ) \
	{ \
		delete sub; \
	} \
	extern "C" \
	{ \
		camlpp__register_free_function1( BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _destroy) )

*/

#define camlpp__custom_class_registered() }

//#undef CAMLPP__CLASS_NAME
#endif

