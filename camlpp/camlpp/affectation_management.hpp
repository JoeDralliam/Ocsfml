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
#include <boost/type_traits.hpp>

#include <iostream>
#include <string>
#include <type_traits>
#include <tuple>
#include <vector>
#include <list>


template< class T, bool shouldReturnObject = true>
class AffectationManagement;

template<class T, bool cpConstructor>
struct copy_instance_helper2
{
  template< class T2 >
  static void affect( value& v, T2&& obj )
  {
    AffectationManagement< T const*, true >::affect( v, new T( std::forward<T2>(obj) ) );
  }
	
  template<class T2>
  static void affect_field( value& v, int field, T2&& obj)
  {
    AffectationManagement< T const*, true>::affect_field(v, field, new T( std::forward<T2>(obj) ));
  }
};

template<class T>
struct copy_instance_helper2< T, false >
{};

template<class T, bool abstract>
struct copy_instance_helper : public copy_instance_helper2<T, std::is_convertible<T&&, T>::value>
{};

template<class T>
struct copy_instance_helper< T, true >
{};

#ifndef _MSC_VER

template<class... ArgsToScan>
struct ShouldUseRegularTag;

template<class T, class... ArgsToScan>
struct ShouldUseRegularTag<T, ArgsToScan...>
{
  enum { value = ((!std::is_floating_point<T>::value) || (ShouldUseRegularTag<ArgsToScan...>::value)) };
};

template<class T>
struct ShouldUseRegularTag<T>
{
  enum { value = !std::is_floating_point<T>::value };
};


template<class... Args>
class RegularOrDoubleArrayTag
{
public:
  enum { result_value = ShouldUseRegularTag<Args...>::value ? 0 : Double_array_tag };
};

template<class... Args>
class LengthDoubleFactor
{
public:
  enum { result_value = ShouldUseRegularTag<Args...>::value ? 1 : Double_wosize };
};

#else

template<class Args, size_t I>
struct ShouldUseRegularTag;

template<class Args>
struct ShouldUseRegularTag<Args, 0>
{
  enum { value = !std::is_floating_point<typename std::tuple_element<0, Args>::type >::value };
};

template<class Args, size_t I>
struct ShouldUseRegularTag
{
  enum { value = ((!std::is_floating_point<typename std::tuple_element<I, Args>::type>::value)
		  || (ShouldUseRegularTag<Args, I-1>::value)) };
};




template<class Args>
class RegularOrDoubleArrayTag
{
public:
  enum { result_value = ShouldUseRegularTag<Args, std::tuple_size<Args>::value - 1 >::value ? 0 : Double_array_tag };
};

template<class Args>
class LengthDoubleFactor
{
public:
  enum { result_value = ShouldUseRegularTag<Args, std::tuple_size<Args>::value - 1 >::value ? 1 : Double_wosize };
};

#endif

template< class T >
struct AffectationManagement<T*, false>
{
  static void affect(value& v, T* t)
  {
    v = caml_alloc(1, Abstract_tag);
    Store_field(v, 0,reinterpret_cast<value>(t));
  }
  
  static void affect_field(value& v, int field, T* t)
  {
    CAMLparam0();
    CAMLlocal1( tmp );
    affect( tmp, t );
    Store_field(v, field, tmp);
  }
};



template<class T>
struct AffectationManagement< T*, true > 
{ 
  static void affect( value& v, T* obj ) 
  { 
    AffectationManagement< T const*, true >::affect( v, obj ); 
  } 
  static void affect_field( value& v, int field, T* obj) 
  { 
    AffectationManagement< T const*, true>::affect_field(v, field, obj);
  } 
}; 

template<class T>
struct AffectationManagement< T&, true > 
{ 
  static void affect( value& v, T& obj ) 
  { 
    AffectationManagement< T const*, true >::affect( v, &obj ); 
  } 
  static void affect_field( value& v, int field, T& obj) 
  { 
    AffectationManagement< T const*, true>::affect_field(v, field, &obj);
  } 
}; 

template<class T> 
struct AffectationManagement< T, true > : public copy_instance_helper< T, boost::is_abstract<T>::value > 
{ 
};

template< class T >
struct AffectationManagement<T const&> : AffectationManagement<T>
{
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
    if( Tag_val(v) == Double_array_tag )
      {
	Store_double_field(v, field, d);
      }
    else
      {
	CAMLparam0();
	CAMLlocal1( double_val );
	affect(double_val, d);
	Field(v, field) = double_val;
	CAMLreturn0;
      }
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
    if( Tag_val(v) == Double_array_tag )
      {
	Store_double_field(v, field, d);
      }
    else
      {
	CAMLparam0();
	CAMLlocal1( double_val );
	affect(double_val, d);
	Field(v, field) = double_val;
	CAMLreturn0;
      }
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
struct AffectationManagement<bool>
{
  static void affect(value& v, bool d)
  {
    v = Val_int(d);
  }

  static void affect_field(value& v, int field, bool d)
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
struct AffectationManagement<long long>
{
  static void affect(value& v, long long d)
  {
    v = Val_int(d);
  }

  static void affect_field(value& v, int field, long long d)
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
struct AffectationManagement<unsigned long long>
{
  static void affect(value& v, unsigned long long d)
  {
    v = Val_int(d);
  }

  static void affect_field(value& v, int field, unsigned long long d)
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


#ifndef _MSC_VER
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
#else
template<class T1, class T2, class T3>
struct AffectationManagement< std::tuple< T1, T2, T3 > >
{
  static void affect(value& v, std::tuple< T1, T2, T3 > const& tup)
  {
    v = caml_alloc_tuple( 3 );
    AffectationManagement< T1 >::affect_field(v, 0, std::get<0>(tup));
    AffectationManagement< T2 >::affect_field(v, 1, std::get<1>(tup));
    AffectationManagement< T3 >::affect_field(v, 2, std::get<2>(tup));
  }

  static void affect_field(value& v, int field, std::tuple< Args... > const& p)
  {
    CAMLparam0();
    CAMLlocal1( tupleVal );
    affect( tupleVal, p );
    Store_field(v, field, tupleVal);
    CAMLreturn0;
  }
};
#endif

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
struct AffectationManagement< std::vector< T > >
{
  static void affect(value& v, std::vector<T> const& vec)
  {
    v = caml_alloc( vec.size() * LengthDoubleFactor<std::tuple<T> >::result_value , RegularOrDoubleArrayTag<std::tuple<T>>::result_value );
    for(int i = 0; i < vec.size(); ++i)
      {
	AffectationManagement< T >::affect_field(v, i, vec[i]);
      }
  }

  static void affect_field( value& v, int field, std::vector<T> const& vec)
  {
    CAMLparam0();
    CAMLlocal1( vecVal );
    affect( vecVal, vec);
    Store_field(v, field, vecVal);
    CAMLreturn0;
  }
};

template<class T>
struct AffectationManagement< std::list< T > >
{
  static void affect(value& v, std::list<T> const& lst)
  {
    CAMLparam0();
    CAMLlocal1( tmp );
    tmp = caml_alloc( 2, 0 );
    AffectationManagement<T>::affect_field( tmp, 1, Val_int(0) );
    for( auto it = lst.begin(); it != lst.end(); ++it)
      {
	T const& val = *it;
	AffectationManagement< T >::affect_field(tmp, 0, val);
	v = tmp;
	tmp = caml_alloc( 2 , 0 );
	Store_field(tmp, 1, v);
      }
    CAMLreturn0;
  }

  static void affect_field( value& v, int field, std::list<T> const& lst)
  {
    CAMLparam0();
    CAMLlocal1( lstVal );
    affect( lstVal, lst);
    Store_field(v, field, lstVal);
    CAMLreturn0;
  }
};

template<bool shouldReturnObject, class T>
inline void caml_cpp__affect(value& v, T const& t)
{
  AffectationManagement< T, shouldReturnObject >::affect(v,t);
}

template<class T>
inline void caml_cpp__affect_field(value& v, int field, T&& t)
{
  //	CAMLparam0();
  AffectationManagement< T >::affect_field(v, field,t);
  //	CAMLreturn0;
}

#endif



