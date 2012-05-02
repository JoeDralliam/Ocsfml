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

#include <camlpp/conversion_management.hpp>
#include <camlpp/affectation_management.hpp>
#include <camlpp/field_affectation_management.hpp>

namespace camlpp
{
  namespace details
  {

    template< class T>
    struct remove_qualifiers
    {
      typedef typename std::remove_cv<typename std::remove_reference<T>::type >::type type;
    };


    template<class T, bool floating>
    struct ObtainField
    {
      static T obtain_field( value& v, int fieldCount)
      {
	assert(Tag_val(v) != Double_array_tag);
	conversion_management<T> cm;
	return cm.from_value(Field(v, fieldCount));
      }
    };

    template<class T>
    struct ObtainField<T, true>
    {
      static T obtain_field( value& v, int fieldCount)
      {
	if(Tag_val(v) == Double_array_tag) 
	  {
	    return Double_field(v, fieldCount);
	  }
	conversion_management<T> cm;
	return cm.from_value(Field(v, fieldCount));
      }
    };

    template<class T>
    T obtain_field( value& v, int fieldCount)
    {
      typedef ObtainField< T, std::is_floating_point<T>::value > Helper;
      return Helper::obtain_field(v, fieldCount);
    }
  }
}

#ifndef _MSC_VER

namespace camlpp 
{ 
  namespace details 
  {
    template<class T>
    struct custom_struct_conversion
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
      static void from_value_impl_helper(value& v, int fieldCount, T& t, FieldType f, Args... args)
      {
	typedef typename remove_qualifiers<decltype(t.*f)>::type Type;
	t.*f = obtain_field<Type>(v,fieldCount);
	from_value_impl_helper(v, fieldCount+1, t, args...);
      }
      
      template<class FieldType>
      static void from_value_impl_helper(value& v, int fieldCount, T& t, FieldType f)
      {
	typedef typename remove_qualifiers<decltype(t.*f)>::type Type;
	t.*f = obtain_field<Type>(v,fieldCount);
      }
    };
    
    template<class T>
    struct custom_struct_affectation
    {
    protected:
      template<class... Args>
      static void affect_impl(value& v, T const& t, Args... args)
      {
	v = caml_alloc_tuple( sizeof...(Args) );
	affect_impl_helper(v, 0, t, args...);
      }
    private:
      template<class FieldType, class... Args>
      static void affect_impl_helper(value& v,int fieldCount, T const& t, FieldType f, Args... args)
      {
	field_affectation_management< typename remove_qualifiers<decltype(t.*f)>::type >::affect_field(v, fieldCount, t.*f);
	affect_impl_helper(v, fieldCount+1, t, args...);
      }
      
      template<class FieldType>
      static void affect_impl_helper(value& v,int fieldCount, T const& t, FieldType f)
      {
	field_affectation_management< typename remove_qualifiers<decltype(t.*f)>::type >::affect_field(v, fieldCount, t.*f);
      }
    };
  }
}
    
#define custom_struct_conversion( s, ... )	\
  namespace camlpp				\
  {						\
    template<>					\
      struct conversion_management< s >		\
      : details::custom_struct_conversion< s >	\
    {						\
      static s from_value(value& v)		\
      {						\
	return from_value_impl(	v,		\
				__VA_ARGS__);	\
      }						\
    };						\
  }
  
#define custom_struct_affectation( s, ... )	\
  namespace camlpp				\
  {						\
    template<>					\
      struct affectation_management< s >	\
      : details::custom_struct_affectation< s >	\
    {						\
      static void affect(value& v, s const& t)	\
      {						\
	return affect_impl(	v, t,		\
				__VA_ARGS__);	\
      }						\
    };						\
  }

#define custom_enum_conversion( enum_name )		\
  namespace camlpp					\
  {							\
    template<>						\
      struct conversion_management< enum_name >		\
    {							\
      enum_name from_value( value const& v)		\
      {							\
	return static_cast<enum_name>( Int_val( v ) );	\
      }							\
    };							\
  }

#define custom_enum_affectation( enum_name )			\
  namespace camlpp						\
  {								\
    template<>							\
      struct affectation_management< enum_name >		\
    {								\
      static void affect( value& v, enum_name const& k )	\
      {								\
	v = Val_int( k );					\
      }								\
    };								\
  }

#else

namespace camlpp
{
  namespace details
  {
    template<class T>
    struct custom_struct_conversion
    {
      template<size_t I> class Int2Type {};
    protected:
      template<class Args>
      static T from_value_impl(value& v, Args const& args)
      {
	T t;
	from_value_impl_helper(v, std::tuple_size<Args>::value - 1, t, args, Int2Type<std::tuple_size<Args>::value - 1>());
	return t;
      }
    private:
      template<class Args>
      static void from_value_impl_helper(value& v,int fieldCount, T& t, Args const& args, Int2Type<0>)
      {
	assert( fieldCount == 0 );
	typedef typename remove_qualifiers<decltype(t.*std::get<0>(args))>::type Type;
	t.*std::get<0>(args) = obtain_field<Type>(v,fieldCount);
      }

      template<class Args, size_t I>
      static void from_value_impl_helper(value& v,int fieldCount, T& t, Args const& args, Int2Type<I>)
      {
	typedef typename remove_qualifiers<decltype(t.*std::get<I>(args))>::type Type;
	t.*std::get<I>(args) = obtain_field<Type>(v,fieldCount);
	from_value_impl_helper(v, fieldCount-1, t, args, Int2Type<I - 1>());
      }
    };

    template<class T>
    struct custom_struct_affectation
    {
      template<size_t I> class Int2Type {};
    protected:
      template<class Args>
      static void affect_impl(value& v, T const& t, Args const& args)
      {
	v = caml_alloc_tuple( std::tuple_size<Args>::value );
	affect_impl_helper(v, std::tuple_size<Args>::value - 1, t, args, Int2Type<std::tuple_size<Args>::value - 1>());
      }
    private:
      template<class Args>
      static void affect_impl_helper(value& v,int fieldCount, T const& t, Args const& args, Int2Type<0>)
      {
	assert( fieldCount == 0 );
	field_affectation_management< typename remove_qualifiers<decltype(t.*std::get<0>(args))>::type >::affect_field(v, fieldCount, t.*std::get<0>(args));
      }

      template<class Args, size_t I>
      static void affect_impl_helper(value& v,int fieldCount, T const& t, Args const& args, Int2Type<I>)
      {
	static_assert( I != 0, "Error" );
	field_affectation_management< typename remove_qualifiers<decltype(t.*std::get<I>(args))>::type >::affect_field(v, fieldCount,  t.*std::get<I>(args));
	affect_impl_helper(v, fieldCount-1, t, args, Int2Type<I-1>());
      }
    };
  }
}


#define custom_struct_conversion( s, ... )			\
  namespace camlpp						\
  {								\
    template<>							\
      struct conversion_management< s >				\
      : details::custom_struct_conversion< s >			\
    {								\
      static s from_value(value& v)				\
      {								\
	return from_value_impl(	v,				\
				std::make_tuple(__VA_ARGS__));	\
      }								\
    };								\
  }

#define custom_struct_affectation( s, ... )			\
  namespace camlpp						\
  {								\
    template<>							\
      struct affectation_management< s >			\
      : details::custom_struct_affectation< s >			\
    {								\
      static void affect(value& v, s const& t)			\
      {								\
	return affect_impl(	v, t,				\
				std::make_tuple(__VA_ARGS__));	\
      }								\
    };								\
  }

#define custom_enum_conversion( enum_name )		\
  namespace camlpp					\
  {							\
    template<>						\
      struct conversion_management< enum_name >		\
    {							\
      enum_name from_value( value const& v)		\
      {							\
	return static_cast<enum_name>( Int_val( v ) );	\
      }							\
    };							\
  }

#define custom_enum_affectation( enum_name )			\
  namespace camlpp						\
  {								\
    template<>							\
      struct affectation_management< enum_name >		\
    {								\
      static void affect( value& v, enum_name const& k )	\
      {								\
	v = Val_int( k );					\
      }								\
    };								\
  }

#endif

#endif

