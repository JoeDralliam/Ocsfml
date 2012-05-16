/*
 * =====================================================================================
 *
 *       Filename:  big_array.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  03/09/2011 15:51:35
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef BIG_ARRAY_HPP_INCLUDED
#define BIG_ARRAY_HPP_INCLUDED

#include <cstdint>

extern "C"
{
#include <caml/bigarray.h>
}

#include <camlpp/conversion_management.hpp>
#include <camlpp/affectation_management.hpp>

namespace camlpp
{
  namespace details
  {
    template< class IntegerType >
    struct big_array_integer_traits;

    template<>
    struct big_array_integer_traits< void >
    {
      enum { mask_value = BIGARRAY_SINT8 };
    };

    template<>
    struct big_array_integer_traits< std::uint8_t >
    {
      enum { mask_value = BIGARRAY_UINT8 };
    };

    template<>
    struct big_array_integer_traits< std::int8_t >
    {
      enum { mask_value = BIGARRAY_SINT8 };
    };

    template<>
    struct big_array_integer_traits< std::uint16_t >
    {
      enum { mask_value = BIGARRAY_UINT16 };
    };

    template<>
    struct big_array_integer_traits< std::int16_t >
    {
      enum { mask_value = BIGARRAY_SINT16 };
    };
    /*  
	template<>
	struct big_array_integer_traits< std::uint32_t >
	{
	enum { mask_value = BIGARRAY_UINT32 };
	};*/

    template<>
    struct big_array_integer_traits< std::int32_t >
    {
      enum { mask_value = BIGARRAY_INT32 };
    };

  }

  template<class IntegerType, int dimension>
  struct big_array
  {
    big_array( IntegerType const* d, intnat s[dimension])
      :data(const_cast<IntegerType*>(d))
    {
      for(int i = 0; i < dimension; ++i)
	{
	  size[i] = s[i];
	}
    }


    IntegerType* data;
    intnat size[dimension];
  };


  template<class IType, int dim>
  struct conversion_management< big_array<IType, dim> >
  {
    big_array<IType, dim> from_value( value const& v )
    {
      assert( Bigarray_val(v)->num_dims ==  dim );
      assert( Bigarray_val(v)->flags & details::big_array_integer_traits< IType >::mask_value );
      return big_array<IType, dim>( static_cast<IType*>(Data_bigarray_val(v)), Bigarray_val(v)->dim );
    }
  };

  template<class IType, int dim>
  struct affectation_management< big_array<IType, dim> >
  {
    static void affect( value& v, big_array<IType, dim> const& b)
    {
      static intnat size[dim];
      for(int i = 0; i < dim; ++i)
	{
	  size[i] = b.size[i];
	}
      v = alloc_bigarray( details::big_array_integer_traits<typename std::remove_const<IType>::type >::mask_value | BIGARRAY_C_LAYOUT,
			  dim, const_cast<void*>(static_cast<void const*>(b.data)), size);
    }
  };
}

#endif
