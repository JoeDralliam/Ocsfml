#ifndef CAMLPP_STD_TUPLE_HPP_INCLUDED
#define CAMLPP_STD_TUPLE_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/alloc.h>
}

#include <tuple>

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>
#include <camlpp/field_affectation_management.hpp>

namespace camlpp
{
#ifndef _MSC_VER
  template<class... Args>
  struct affectation_management< std::tuple< Args... > >
  {
    static void affect(value& v, std::tuple< Args... > const& tup)
    {
      v = caml_alloc_tuple( sizeof...( Args ) );
      affect_helper( v, tup, std::integral_constant<size_t, sizeof...(Args) - 1>() );
    }
  private:
    static void affect_helper( value&, std::tuple< Args... > const&, std::integral_constant<size_t, -1>)
    {}

    template<size_t I>
    static void affect_helper( value& v, std::tuple< Args... > const& tup, std::integral_constant<size_t, I>)
    {
      typedef typename std::tuple_element< I, std::tuple< Args... >>::type CurrentElemType;
      field_affectation_management< CurrentElemType >::affect_field( v, I, std::move( std::get<I>(tup) ) );
      affect_helper( v, tup, std::integral_constant<size_t, I-1>() );
    }
  };
#else
  template<class T1, class T2, class T3>
  struct affectation_management< std::tuple< T1, T2, T3 > >
  {
    static void affect(value& v, std::tuple< T1, T2, T3 > const& tup)
    {
      v = caml_alloc_tuple( 3 );
      field_affectation_management< T1 >::affect_field(v, 0, std::get<0>(tup));
      field_affectation_management< T2 >::affect_field(v, 1, std::get<1>(tup));
      field_affectation_management< T3 >::affect_field(v, 2, std::get<2>(tup));
    }
  };

  template<class T1, class T2, class T3, class T4>
  struct affectation_management< std::tuple< T1, T2, T3, T4 > >
  {
    static void affect(value& v, std::tuple< T1, T2, T3, T4 > const& tup)
    {
      v = caml_alloc_tuple( 4 );
      field_affectation_management< T1 >::affect_field(v, 0, std::get<0>(tup));
      field_affectation_management< T2 >::affect_field(v, 1, std::get<1>(tup));
      field_affectation_management< T3 >::affect_field(v, 2, std::get<2>(tup));
      field_affectation_management< T4 >::affect_field(v, 3, std::get<3>(tup));
    }
  };

  template<class T1, class T2, class T3, class T4, class T5>
  struct affectation_management< std::tuple< T1, T2, T3, T4, T5 > >
  {
    static void affect(value& v, std::tuple< T1, T2, T3, T4, T5 > const& tup)
    {
      v = caml_alloc_tuple( 5 );
      field_affectation_management< T1 >::affect_field(v, 0, std::get<0>(tup));
      field_affectation_management< T2 >::affect_field(v, 1, std::get<1>(tup));
      field_affectation_management< T3 >::affect_field(v, 2, std::get<2>(tup));
      field_affectation_management< T4 >::affect_field(v, 3, std::get<3>(tup));
      field_affectation_management< T5 >::affect_field(v, 4, std::get<4>(tup));
    }
  };


  template<class T1, class T2, class T3, class T4, class T5, class T6>
  struct affectation_management< std::tuple< T1, T2, T3, T4, T5, T6 > >
  {
    static void affect(value& v, std::tuple< T1, T2, T3, T4, T5, T6 > const& tup)
    {
      v = caml_alloc_tuple( 6 );
      field_affectation_management< T1 >::affect_field(v, 0, std::get<0>(tup));
      field_affectation_management< T2 >::affect_field(v, 1, std::get<1>(tup));
      field_affectation_management< T3 >::affect_field(v, 2, std::get<2>(tup));
      field_affectation_management< T4 >::affect_field(v, 3, std::get<3>(tup));
      field_affectation_management< T5 >::affect_field(v, 4, std::get<4>(tup));
      field_affectation_management< T6 >::affect_field(v, 5, std::get<5>(tup));
    }
  };


#endif


  //////////////////////////////////////////////////////////////////////////////
  
#ifndef _MSC_VER
  namespace details
  {
    template<class Tuple, int I>
    struct tuple_conversion_helper
    {
      conversion_management< typename std::tuple_element< I, Tuple>::type > cm;
    };


    template<class T, int I>
    struct tuple_helper : public tuple_conversion_helper<T, I>, public tuple_helper<T, I-1>
    {};


    template<class Tuple>
    struct tuple_helper<Tuple, -1>
    {};

    
  }
  

  template<class... Args>
  struct conversion_management< std::tuple< Args...> > : private details::tuple_helper< std::tuple<Args...>, sizeof...( Args ) - 1 >
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
      std::get< I >( res ) = details::tuple_conversion_helper< std::tuple< Args... >, I >::cm.from_value( Field(v, I) );
      from_value_helper( v, res, std::integral_constant<size_t, I-1>() );
    }
  };
#else
  template<class T1, class T2>
  struct conversion_management< std::tuple< T1, T2> >
  {
    std::tuple< T1, T2 > from_value( value const& v )
    {
      assert( Is_block( v ) );
      assert( Tag_val( v ) == 0 );
      assert( Wosize_val( v ) == 2 );
    
      std::tuple< T1, T2 > res;
      std::get< 0 >( res ) = cm1.from_value( Field(v, 0) );
      std::get< 1 >( res ) = cm2.from_value( Field(v, 1) );

      return res;
    }
  private:
    conversion_management<T1> cm1;
    conversion_management<T2> cm2;
  };

  template<class T1, class T2, class T3>
  struct conversion_management< std::tuple< T1, T2, T3> >
  {
    std::tuple< T1, T2, T3 > from_value( value const& v )
    {
      assert( Is_block( v ) );
      assert( Tag_val( v ) == 0 );
      assert( Wosize_val( v ) == 3 );

      std::tuple< T1, T2, T3 > res;
      std::get< 0 >( res ) = cm1.from_value( Field(v, 0) );
      std::get< 1 >( res ) = cm2.from_value( Field(v, 1) );
      std::get< 2 >( res ) = cm3.from_value( Field(v, 2) );


      return res;
    }
  private:
    conversion_management<T1> cm1;
    conversion_management<T2> cm2;
    conversion_management<T3> cm3;
  };

  template<class T1, class T2, class T3, class T4>
  struct conversion_management< std::tuple< T1, T2, T3, T4> >
  {
    std::tuple< T1, T2, T3, T4 > from_value( value const& v )
    {
      assert( Is_block( v ) );
      assert( Tag_val( v ) == 0 );
      assert( Wosize_val( v ) == 4 );

      std::tuple< T1, T2, T3, T4 > res;
      std::get< 0 >( res ) = cm1.from_value( Field(v, 0) );
      std::get< 1 >( res ) = cm2.from_value( Field(v, 1) );
      std::get< 2 >( res ) = cm3.from_value( Field(v, 2) );
      std::get< 3 >( res ) = cm4.from_value( Field(v, 3) );

      return res;
    }
  private:
    conversion_management<T1> cm1;
    conversion_management<T2> cm2;
    conversion_management<T3> cm3;
    conversion_management<T4> cm4;
  };

  template<class T1, class T2, class T3, class T4, class T5>
  struct conversion_management< std::tuple< T1, T2, T3, T4, T5 > >
  {


    std::tuple< T1, T2, T3, T4, T5 > from_value( value const& v )
    {
      assert( Is_block( v ) );
      assert( Tag_val( v ) == 0 );
      assert( Wosize_val( v ) == 5 );

      std::tuple< T1, T2, T3, T4, T5 > res;
      std::get< 0 >( res ) = cm1.from_value( Field(v, 0) );
      std::get< 1 >( res ) = cm2.from_value( Field(v, 1) );
      std::get< 2 >( res ) = cm3.from_value( Field(v, 2) );
      std::get< 3 >( res ) = cm4.from_value( Field(v, 3) );
      std::get< 4 >( res ) = cm5.from_value( Field(v, 4) );

      return res;
    }
  private:
    conversion_management<T1> cm1;
    conversion_management<T2> cm2;
    conversion_management<T3> cm3;
    conversion_management<T4> cm4;
    conversion_management<T5> cm5;
  };

  template<class T1, class T2, class T3, class T4, class T5, class T6>
  struct conversion_management< std::tuple< T1, T2, T3, T4, T5, T6> > 
  {


    std::tuple< T1, T2, T3, T4, T5, T6 > from_value( value const& v )
    {
      assert( Is_block( v ) );
      assert( Tag_val( v ) == 0 );
      assert( Wosize_val( v ) == 6 );

      std::tuple< T1, T2, T3, T4, T5, T6 > res;
      std::get< 0 >( res ) = cm1.from_value( Field(v, 0) );
      std::get< 1 >( res ) = cm2.from_value( Field(v, 1) );
      std::get< 2 >( res ) = cm3.from_value( Field(v, 2) );
      std::get< 3 >( res ) = cm4.from_value( Field(v, 3) );
      std::get< 4 >( res ) = cm5.from_value( Field(v, 4) );
      std::get< 5 >( res ) = cm6.from_value( Field(v, 5) );
    
      return res;
    }
  private:
    conversion_management<T1> cm1;
    conversion_management<T2> cm2;
    conversion_management<T3> cm3;
    conversion_management<T4> cm4;
    conversion_management<T5> cm5;
    conversion_management<T6> cm6;
  };
#endif

}


#endif
