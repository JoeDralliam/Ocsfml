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
#include <boost/functional/factory.hpp>
#include <boost/preprocessor/library.hpp>
#include <boost/preprocessor/stringize.hpp>
#include "conversion_management.hpp"
#include "res_management.hpp"
#include "memory_management.hpp"
#include "stub_generator.hpp"

template<class MemFunc>
struct method_traits;

template<class Ret, class C, class... Args>
struct method_traits< Ret (C::*)(Args...) >
{
	typedef Ret type (C*, Args...);
};

template<class Ret, class C, class... Args>
struct method_traits< Ret (C::*)(Args...)const >
{
	typedef Ret type (C const*, Args...);
};

template<class Ret, class C, class... Args>
struct method_traits< Ret (*)(C*, Args...)>
{
	typedef Ret type (C*, Args...);
};



//#define CAMLPP__CLASS_NAME() CAMLPP__CLASS_NAME()

#define camlpp__register_method0( method_name, func ) \
	CAMLprim value  BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _  ## method_name  ## __impl) ( value obj) \
	{ \
		typedef method_traits< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(obj); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		return rm.call \
		( \
			std::bind(func, std::placeholders::_1), \
			cm1.from_value( obj ) \
		); \
	}


#define camlpp__register_method1( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1 ) \
	{ \
		typedef method_traits< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(obj, param1); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		return rm.call \
		( \
			std::bind(func, std::placeholders::_1, std::place_holders::_2), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ) \
		); \
	}

#define camlpp__register_method2( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2 ) \
	{ \
		typedef method_traits< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(obj, param1, param2); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg2_type > cm3; \
		return rm.call \
		( \
			std::bind(func, std::placeholders::_1, std::place_holders::_2, std::place_holders::_3), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ) \
			cm3.from_value( param2 ) \
		); \
	}

#define camlpp__register_method3( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3 ) \
	{ \
		typedef method_traits< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(obj, param1, param2, param3); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		return rm.call \
		( \
			std::bind(func, std::placeholders::_1, std::place_holders::_2, std::place_holders::_3), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ), \
			cm3.from_value( param2 ), \
			cm4.from_value( param3 ) \
		); \
	}


#define camlpp__register_method4( method_name, func ) \
	CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## method_name  ## __impl) ( value obj, value param1, value param2, value param3, value param4 ) \
	{ \
		typedef method_traits< decltype( func ) >::type FuncType; \
		typedef boost::function_traits< FuncType > FuncTraits; \
		MemoryManagement< FuncTraits::arity > mm(obj, param1, param2, param3, param4); \
		ResManagement< FuncTraits::result_type> rm; \
		ConversionManagement< FuncTraits::arg1_type > cm1; \
		ConversionManagement< FuncTraits::arg2_type > cm2; \
		ConversionManagement< FuncTraits::arg3_type > cm3; \
		ConversionManagement< FuncTraits::arg4_type > cm4; \
		ConversionManagement< FuncTraits::arg5_type > cm5; \
		return rm.call \
		( \
			std::bind(func, std::placeholders::_1, std::place_holders::_2, std::place_holders::_3, std;;place_holders::_4), \
			cm1.from_value( obj ), \
			cm2.from_value( param1 ), \
			cm3.from_value( param2 ), \
			cm4.from_value( param3 ), \
			cm5.from_value( param4 ) \
		); \
	}

#define camlpp__register_external_constructor0( constructor_name, func) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value unit) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef boost::function_traits< FuncType > FuncTraits; \
			MemoryManagement< FuncTraits::arity > mm( param1 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			return rm.call \
			( \
				func \
			); \
		}

#define camlpp__register_external_constructor1( constructor_name, func) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef boost::function_traits< FuncType > FuncTraits; \
			MemoryManagement< FuncTraits::arity > mm( param1 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			ConversionManagement< FuncTraits::arg1_type > cm1; \
			return rm.call \
			( \
				func, \
				cm1.from_value( param1 ) \
			); \
		}

#define camlpp__register_external_constructor2( constructor_name, func ) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef boost::function_traits< FuncType > FuncTraits; \
			MemoryManagement< FuncTraits::arity > mm( param1, param2 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			ConversionManagement< FuncTraits::arg1_type > cm1; \
			ConversionManagement< FuncTraits::arg2_type > cm2; \
			return rm.call \
			( \
				func, \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ) \
			); \
		}

#define camlpp__register_external_constructor3( constructor_name, func ) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef boost::function_traits< FuncType > FuncTraits; \
			MemoryManagement< FuncTraits::arity > mm( param1, param2, param3 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
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

#define camlpp__register_external_constructor4( constructor_name, func ) \
		CAMLprim value BOOSt_PP_CAT( CAMLPP__CLASS_NAME(), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef boost::function_traits< FuncType > FuncTraits; \
			MemoryManagement< FuncTraits::arity > mm( param1, param2, param3, param4 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
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

#define camlpp__register_external_constructor5( constructor_name, func) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5 ) \
		{ \
			typedef std::remove_pointer<decltype(func)>::type FuncType; \
			typedef boost::function_traits< FuncType > FuncTraits; \
			MemoryManagement< FuncTraits::arity > mm( param1, param2, param3, param4, param5 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
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
				cm5.from_value( param5 )  \
			); \
		}



#define camlpp__register_constructor0( constructor_name) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value unit) \
		{ \
			MemoryManagement< 0 > mm( unit ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			return rm.call \
			( \
				boost::factory< CAMLPP__CLASS_NAME() * >() \
			); \
		}

#define camlpp__register_constructor1( constructor_name, param1_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1 ) \
		{ \
			MemoryManagement< 1 > mm( param1 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			ConversionManagement< param1_type > cm1; \
			return rm.call \
			( \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				cm1.from_value( param1 ) \
			); \
		}

#define camlpp__register_constructor2( constructor_name, param1_type, param2_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2 ) \
		{ \
			MemoryManagement< 2 > mm( param1, param2 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			return rm.call \
			( \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ) \
			); \
		}

#define camlpp__register_constructor3( constructor_name, param1_type, param2_type, param3_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3 ) \
		{ \
			MemoryManagement< 3 > mm( param1, param2, param3 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			return rm.call \
			( \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ), \
				cm3.from_value( param3 ) \
			); \
		}

#define camlpp__register_constructor4( constructor_name, param1_type, param2_type, param3_type, param4_type) \
		CAMLprim value BOOST_PP_CAT( CAMLPP__CLASS_NAME(), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4 ) \
		{ \
			MemoryManagement< 4 > mm( param1, param2, param3, param4 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			ConversionManagement< param4_type > cm4; \
			return rm.call \
			( \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ), \
				cm3.from_value( param3 ), \
				cm4.from_value( param4 ) \
			); \
		}

#define camlpp__register_constructor5( constructor_name, param1_type, param2_type, param3_type, param4_type, param5_type) \
		CAMLprim value BOOST_PP_CAT( BOOST_PP_EXPAND( CAMLPP__CLASS_NAME()), _ ## constructor_name ## __impl) ( value param1, value param2, value param3, value param4, value param5 ) \
		{ \
			MemoryManagement< 5 > mm( param1, param2, param3, param4, param5 ); \
			ResManagement< CAMLPP__CLASS_NAME() * > rm; \
			ConversionManagement< param1_type > cm1; \
			ConversionManagement< param2_type > cm2; \
			ConversionManagement< param3_type > cm3; \
			ConversionManagement< param4_type > cm4; \
			ConversionManagement< param5_type > cm5; \
			return rm.call \
			( \
				boost::factory< CAMLPP__CLASS_NAME() * >(), \
				cm1.from_value( param1 ), \
				cm2.from_value( param2 ), \
				cm3.from_value( param3 ), \
				cm4.from_value( param4 ), \
				cm5.from_value( param5 )  \
			); \
		}





#define camlpp__register_inheritance_relationship( superclass_name ) \
	superclass_name * BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ) ( CAMLPP__CLASS_NAME() * sub ) \
	{ \
		return sub; \
	} \
	camlpp__register_free_function1( BOOST_PP_CAT( upcast__ ## superclass_name ## _of_, CAMLPP__CLASS_NAME() ) )\


#define camlpp__register_custom_class( ) \
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

#define camlpp__custom_class_registered() }

//#undef CAMLPP__CLASS_NAME
#endif

