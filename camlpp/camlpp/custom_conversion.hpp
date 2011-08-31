/*
 * =====================================================================================
 *
 *       Filename:  custom_conversion.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 14:26:34
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef CUSTOM_CONVERSION_HPP_INCLUDED
#define CUSTOM_CONVERSION_HPP_INCLUDED

#include "conversion_management.hpp"
#include "affectation_management.hpp"

template< class T>
struct remove_qualifiers
{
	typedef typename std::remove_cv<typename std::remove_reference<T>::type >::type type;
};


template<class T>
struct CustomStructConversion
{
protected:
	template<class... Args>
	static T from_value_impl(value& v, Args... args)
	{
		T t;
		from_value_impl_helper(v, 0, t, args...);
		return t;
	}
private:
	template<class FieldType, class... Args>
	static void from_value_impl_helper(value& v,int fieldCount, T& t, FieldType f, Args... args)
	{
		ConversionManagement< typename remove_qualifiers<decltype(t.*f)>::type > cm;
		t.*f = cm.from_value(Field(v,fieldCount));
		from_value_impl_helper(v, fieldCount+1, t, args...);
	}

	template<class FieldType>
	static void from_value_impl_helper(value& v,int fieldCount, T& t, FieldType f)
	{

		ConversionManagement< typename remove_qualifiers<decltype(t.*f)>::type > cm;
		t.*f = cm.from_value(Field(v,fieldCount));
	}
};

template<class T>
struct CustomStructAffectation
{
protected:
	template<class... Args>
	static void affect_impl(value& v, T const& t, Args... args)
	{
		v = caml_alloc_tuple( sizeof...(Args) );
		affect_impl_helper(v, 0, t, args...);
	}

	template<class... Args>
	static void affect_field_impl(value& v, int field, T const& t, Args... args)
	{
		CAMLparam0();
		CAMLlocal1(tmp);
		tmp = caml_alloc_tuple( sizeof...(Args) );
		affect_impl_helper(tmp, 0, t, args...);
		Store_field(v, field, tmp);
		CAMLreturn0;
	}
private:
	template<class FieldType, class... Args>
	static void affect_impl_helper(value& v,int fieldCount, T const& t, FieldType f, Args... args)
	{
		AffectationManagement< typename remove_qualifiers<decltype(t.*f)>::type >::affect_field(v, fieldCount, t.*f);
		affect_impl_helper(v, fieldCount+1, t, args...);
	}

	template<class FieldType>
	static void affect_impl_helper(value& v,int fieldCount, T const& t, FieldType f)
	{
		AffectationManagement< typename remove_qualifiers<decltype(t.*f)>::type >::affect_field(v, fieldCount, t.*f);
	}
};

#define custom_struct_conversion( s, ... ) \
	template<> \
	struct ConversionManagement< s > \
		: CustomStructConversion< s > \
	{ \
		static s from_value(value& v) \
		{ \
			return from_value_impl(	v, \
						__VA_ARGS__); \
		} \
	}

#define custom_struct_affectation( s, ... ) \
	template<> \
	struct AffectationManagement< s > \
		: CustomStructAffectation< s > \
	{ \
		static void affect(value& v, s const& t) \
		{ \
			return affect_impl(	v, t, \
						__VA_ARGS__); \
		} \
		static void affect_field(value& v, int f, s const& t) \
		{ \
			return affect_field_impl(v, f, t, \
						__VA_ARGS__); \
		} \
	}

#define custom_enum_conversion( enum_name ) \
	template<> \
	struct ConversionManagement< enum_name > \
	{ \
		enum_name from_value( value const& v) \
		{ \
			return static_cast<enum_name>( Int_val( v ) ); \
		} \
	}

#define custom_enum_affectation( enum_name ) \
	template<> \
	struct AffectationManagement< enum_name > \
	{ \
		static void affect( value& v, enum_name const& k ) \
		{ \
			v = Val_int( k ); \
		} \
		static void affect_field( value& v, int field, enum_name const& k ) \
		{ \
			Store_field(v, field, Val_int( k )); \
		} \
	}

#endif

