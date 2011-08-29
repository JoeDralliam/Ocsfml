/*
 * =====================================================================================
 *
 *       Filename:  affectation_management.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 12:17:34
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef AFFECTATION_MANAGEMENT_HPP_INCLUDED
#define AFFECTATION_MANAGEMENT_HPP_INCLUDED

extern "C"
{
	#include <caml/mlvalues.h>
	#include <caml/memory.h>
	#include <caml/alloc.h>
}

#include <string>
#include <type_traits>
#include <tuple>

template< class T>
class AffectationManagement;

template< class T >
struct AffectationManagement<T*>
{
	static void affect(value& v, T* t)
	{
		v = caml_alloc(1, Abstract_tag);
		Store_field(v, 0,reinterpret_cast<value>(t));
	}

	static void affect_field(value& v, int field, T* t)
	{
		value tmp = caml_alloc(1, Abstract_tag);
		Store_field(tmp, 0, reinterpret_cast<value>(t));
		Store_field(v, field, tmp);
	}
};

template<>
struct AffectationManagement<char*>
{
	static void affect(value& v, char* str)
	{
		v = caml_copy_string( str );
	}

	static void affect_field(value& v, int field, char* str)
	{
		Store_field(v, field, caml_copy_string( str ));
	}
};

template<>
struct AffectationManagement<std::string>
{
	static void affect(value& v, std::string const& str)
	{
		v = caml_copy_string( str.c_str() );
	}

	static void affect_field(value& v, int field, std::string const& str)
	{
		Store_field(v, field, caml_copy_string( str.c_str() ));
	}
};

template<>
struct AffectationManagement<double>
{
	static void affect(value& v, double d)
	{
		v = caml_copy_double( d );
	}
	
	static void affect_field(value& v, int field, double d)
	{
		Store_double_field(v, field, d);
	}
};

template<>
struct AffectationManagement<float>
{
	static void affect(value& v, float d)
	{
		v = caml_copy_double( d );
	}

	static void affect_field(value& v, int field, float d)
	{
		Store_double_field(v, field, d);
	}
};

template<>
struct AffectationManagement<short>
{
	static void affect(value& v, short d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field, short d)
	{
		Store_field(v, field,Val_int(d));
	}
};

template<>
struct AffectationManagement<int>
{
	static void affect(value& v, int d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field, int d)
	{
		Store_field(v, field,Val_int(d));
	}
};
template<>
struct AffectationManagement<long>
{
	static void affect(value& v, long d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field, long d)
	{
		Store_field(v, field,Val_int(d));
	}
};
template<>
struct AffectationManagement<unsigned short>
{
	static void affect(value& v,unsigned short d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field,unsigned short d)
	{
		Store_field(v, field,Val_int(d));
	}
};
template<>
struct AffectationManagement<unsigned int>
{
	static void affect(value& v, unsigned int d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field, unsigned int d)
	{
		Store_field(v, field,Val_int(d));
	}
};
template<>
struct AffectationManagement<unsigned long>
{
	static void affect(value& v, unsigned long d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field, unsigned long d)
	{
		Store_field(v, field,Val_int(d));
	}
};
template<>
struct AffectationManagement<signed char>
{
	static void affect(value& v, signed char d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field, signed char d)
	{
		Store_field(v, field,Val_int(d));
	}
};
template<>
struct AffectationManagement<unsigned char>
{
	static void affect(value& v, unsigned char d)
	{
		v = Val_int(d);
	}

	static void affect_field(value& v, int field, unsigned char d)
	{
		Store_field(v, field,Val_int(d));
	}
};


template<class... Args>
struct AffectationManagement< std::tuple< Args... > >
{
	static void affect(value& v, std::tuple< Args... > const& tup)
	{
		v = caml_alloc_tuple( sizeof...( Args ) );
		affect_helper( v, tup, std::integral_constant<size_t, sizeof...(Args) - 1>() );
	}

	static void affect_field(value& v, int field, std::tuple< Args... > const& p)
	{
		CAMLparam0();
		CAMLlocal1( tupleVal );
		affect( tupleVal, p );
		Store_field(v, field, tupleVal);
		CAMLreturn0;
	}
private:
	static void affect_helper( value&, std::tuple< Args... > const&, std::integral_constant<size_t, -1>)
	{}

	template<size_t I>
	static void affect_helper( value& v, std::tuple< Args... > const& tup, std::integral_constant<size_t, I>)
	{
		AffectationManagement< typename std::tuple_element< I, std::tuple< Args... >>::type >::affect_field( v, I, std::move( std::get<I>(tup) ) );
		affect_helper( v, tup, std::integral_constant<size_t, I-1>() );
	}
};

template<class T1, class T2>
struct AffectationManagement< std::pair< T1, T2 > >
{
	static void affect(value& v, std::pair< T1, T2 > const& p)
	{
		v = caml_alloc_tuple( 2 );
		AffectationManagement< T1 >::affect_field(v, 0, p.first);
		AffectationManagement< T2 >::affect_field(v, 1, p.second);
	}

	static void affect_field( value& v, int field, std::pair< T1, T2 > const& p)
	{
		CAMLparam0();
		CAMLlocal1( pairVal );
		affect( pairVal, p);
		Store_field(v, field, pairVal);
		CAMLreturn0;
	}
};

template<class T>
void caml_cpp__affect(value& v, T const& t)
{
	AffectationManagement<T>::affect(v, t);
}



#endif



