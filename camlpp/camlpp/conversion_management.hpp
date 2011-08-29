/*
 * =====================================================================================
 *
 *       Filename:  conversion_management.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 13:35:30
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef CONVERSION_MANAGEMENT_HPP_INCLUDED
#define CONVERSION_MANAGEMENT_HPP_INCLUDED

extern "C"
{
	#include <caml/mlvalues.h>
	#include <caml/callback.h>
}

#include <functional>
#include <cassert>
#include <string>
#include <tuple>
#include <memory>

template<class T> class ConversionManagement;

template<class T>
struct ConversionManagement<T*>
{
	T* from_value(value& v)
	{
		assert( Is_block( v ) ); 
		assert( Tag_val(v) == Abstract_tag );
		return reinterpret_cast<T*>(Field(v, 0));
	}
};

template<class T>
struct ConversionManagement<T&>
{
	std::unique_pointer<T> ptr;
	T& from_value(value& v)
	{
		ptr.reset(new T( ConversionManagement<T>::from_value() ) );
		return *ptr;
	}
};


template<>
struct ConversionManagement<short>
{
	short from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};

template<>
struct ConversionManagement<int>
{
	int from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};
template<>
struct ConversionManagement<long>
{
	int from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};
template<>
struct ConversionManagement<unsigned short>
{
	int from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};
template<>
struct ConversionManagement<unsigned int>
{
	int from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};
template<>
struct ConversionManagement<unsigned long>
{
	int from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};
template<>
struct ConversionManagement<signed char>
{
	int from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};
template<>
struct ConversionManagement<unsigned char>
{
	int from_value(value& v)
	{
		assert( Is_long( v ) );
		return Int_val(v);
	}
};

template<>
struct ConversionManagement<float>
{
	float from_value(value& v)
	{
		assert( Tag_val( v ) == Double_tag );
		return Double_val(v);
	}
};

template<>
struct ConversionManagement<double>
{
	double from_value(value& v)
	{
		assert( Tag_val( v ) == Double_tag );
		return Double_val(v);
	}
};


template<>
struct ConversionManagement<std::string>
{
	std::string from_value(value& v)
	{
		assert( Tag_val( v ) == String_tag );
		return String_val(v);
	}
};

template<>
struct ConversionManagement<char*>
{
	char* from_value(value& v)
	{
		assert( Tag_val( v ) == String_tag );
		return String_val(v);
	}
};

template<class Tuple, int I>
struct TupleConversionHelper
{
	ConversionManagement< typename std::tuple_element< I, Tuple>::type > cm;
};


template<class T, int I>
struct TupleHelper : public TupleConversionHelper<T, I>, public TupleHelper<T, I-1>
{};


template<class Tuple>
struct TupleHelper<Tuple, -1>
{};



template<class... Args>
struct ConversionManagement< std::tuple< Args...> > : private TupleHelper< std::tuple<Args...>, sizeof...( Args ) - 1 >
{
	std::tuple< Args... > from_value( value const& v )
	{
		assert( Is_block( v ) );
		assert( Tag_val( v ) == 0 );
		assert( Wosize_val( v ) == sizeof...( Args ) );
		std::tuple< Args... > res;
		from_value_helper( v, res, std::integral_constant<size_t, sizeof...( Args ) - 1 >() );
		return std::move( res );
	}
private:
	void from_value_helper( value const&, std::tuple< Args... >& , std::integral_constant<size_t, -1>)
	{}

	template<size_t I>
	void from_value_helper( value const& v, std::tuple< Args... >& res, std::integral_constant<size_t, I> )
	{
		std::get< I >( res ) =   TupleConversionHelper< std::tuple< Args... >, I >::cm.from_value( Field(v, I) );
		from_value_helper( v, res, std::integral_constant<size_t, I-1>() );
	}
};

template< class T1, class T2>
class ConversionManagement< std::pair< T1, T2 > >
{
	ConversionManagement< T1 > cm1;
	ConversionManagement< T2 > cm2;
public:
	std::pair< T1, T2 > from_value( value const& v )
	{
		assert( Is_block( v ) );
		assert( Tag_val( v ) == 0 );
		assert( Wosize_val( v ) == 2 );
		return std::make_pair( 	cm1.from_value( Field(v, 0 ) ),
					cm2.from_value( Field(v, 1 ) ) );
	}
};

template<class Ret, class... Args>
struct ConversionManagement< std::function< Ret(Args...) > >
{
	class CamlCallback
	{	
		value callback_;
	private:

		value call()
		{
			return callback( callback_, Val_unit );
		}

		template<class T>
		value call( T t )
		{
			CAMLparam0();
			CAMLlocal1( p1 );
			AffectationManagement< T>::affect(p1, t);
			CAMLreturn( callback( callback_, p1 ) );
		}

		template<class T1, class T2>
		value call( T1 t1, T2 t2 )
		{
			CAMLparam0();
			CAMLlocal2( p1, p2 );
			AffectationManagement<T1>::affect(p1, t1);
			AffectationManagement<T2>::affect(p2, t2);
			CAMLreturn( callback2( callback_, p1, p2 ) );
		}

		template<class T1, class T2, class T3>
		value call( T1 t1, T2 t2, T3 t3 )
		{
			CAMLparam0();
			CAMLlocal3( p1, p2, p3 );
			AffectationManagement<T1>::affect(p1, t1);
			AffectationManagement<T2>::affect(p2, t2);
			AffectationManagement<T3>::affect(p3, t3);
			CAMLreturn( callback3( callback_, p1, p2, p3 ) );
		}

		template<class... OArgs>
		value call( OArgs... tN)
		{
			CAMLparam0();
			CAMLlocalN( pN, sizeof...(Args) );
			CAMLreturn( call_helper( tN..., pN ) );
		}

		template<class T, int I>
		value call_helper( value pN[I], T tN )
		{
			AffectationManagement<T>::affect( pN[I-1], tN);
			return callbackN( callback_, I, pN );
		}

		template<class... OArgs, class T, int I>
		value call_helper( value pN[I], T tN, Args... args )
		{
			AffectationManagement<T>::affect(pN[ I-sizeof...(Args)-1 ], tN);
			return call_helper( pN, args...);
		}

	public:
		CamlCallback( value const& v ) : callback_(v)
		{
			caml_register_generational_global_root(&callback_);
		}

		~CamlCallback()
		{
			caml_remove_generational_global_root(&callback_);
		}
		
		template<class... OArgs>
		Ret operator()(OArgs... args)
		{
			ConversionManagement< Ret > cm;
			return cm.from_value( call( std::forward<OArgs>(args)... ) );
		}
	};
	std::function< Ret(Args...) > from_value( value const& v)
	{
		
		assert( Tag_val( v ) == Closure_tag );
		return CamlCallback( v );
	}
};

template< class... Args>
struct ConversionManagement< std::function< void(Args...) > >
{
	class CamlCallback
	{	
		value callback_;
	private:

		value call()
		{
			return callback( callback_, Val_unit );
		}

		template<class T>
		value call( T t )
		{
			CAMLparam0();
			CAMLlocal1( p1 );
			AffectationManagement< T>::affect(p1, t);
			CAMLreturn( callback( callback_, p1 ) );
		}

		template<class T1, class T2>
		value call( T1 t1, T2 t2 )
		{
			CAMLparam0();
			CAMLlocal2( p1, p2 );
			AffectationManagement<T1>::affect(p1, t1);
			AffectationManagement<T2>::affect(p2, t2);
			CAMLreturn( callback2( callback_, p1, p2 ) );
		}

		template<class T1, class T2, class T3>
		value call( T1 t1, T2 t2, T3 t3 )
		{
			CAMLparam0();
			CAMLlocal3( p1, p2, p3 );
			AffectationManagement<T1>::affect(p1, t1);
			AffectationManagement<T2>::affect(p2, t2);
			AffectationManagement<T3>::affect(p3, t3);
			CAMLreturn( callback3( callback_, p1, p2, p3 ) );
		}

		template<class... OArgs>
		value call( OArgs... tN)
		{
			CAMLparam0();
			CAMLlocalN( pN, sizeof...(Args) );
			CAMLreturn( call_helper( tN..., pN ) );
		}

		template<class T, int I>
		value call_helper( value pN[I], T tN )
		{
			AffectationManagement<T>::affect( pN[I-1], tN);
			return callbackN( callback_, I, pN );
		}

		template<class... OArgs, class T, int I>
		value call_helper( value const pN[I], T tN, Args... args )
		{
			AffectationManagement<T>::affect(pN[ I-sizeof...(Args)-1 ], tN);
			return call_helper( pN, args...);
		}

	public:
		CamlCallback( value const& v ) : callback_(v)
		{
			caml_register_generational_global_root(&callback_);
		}

		~CamlCallback()
		{
			caml_remove_generational_global_root(&callback_);
		}

		template<class... OArgs>
		void operator()(OArgs&&... args)
		{
			call(std::forward<OArgs>(args)...);
		}
	};
	std::function< void(Args...) > from_value( value const& v)
	{
		
		assert( Tag_val( v ) == Closure_tag );
		return CamlCallback( v );
	}
};

template<class T>
struct ConversionManagement< T const& >: public ConversionManagement< T >
{};

#endif
