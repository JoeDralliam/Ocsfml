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


#include "conversion_management.hpp"
#include "affectation_management.hpp"
#include <cstdint>
extern "C"
{
	#include <caml/bigarray.h>
}

template< class IntegerType >
struct BigarrayIntegerTraits;

template<>
struct BigarrayIntegerTraits< std::uint8_t >
{
	enum { mask_value = BIGARRAY_UINT8 };
};

template<>
struct BigarrayIntegerTraits< std::int8_t >
{
	enum { mask_value = BIGARRAY_SINT8 };
};

template<>
struct BigarrayIntegerTraits< std::uint16_t >
{
	enum { mask_value = BIGARRAY_UINT16 };
};

template<>
struct BigarrayIntegerTraits< std::int16_t >
{
	enum { mask_value = BIGARRAY_SINT16 };
};
/*  
template<>
struct BigarrayIntegerTraits< std::uint32_t >
{
	enum { mask_value = BIGARRAY_UINT32 };
};*/

template<>
struct BigarrayIntegerTraits< std::int32_t >
{
	enum { mask_value = BIGARRAY_INT32 };
};

template<class IntegerType, int dimension>
struct BigarrayInterface
{
	BigarrayInterface( IntegerType* d, int s[dimension])
	:data(d)
	{
		for(int i = 0; i < dimension; ++i)
		{
			size[i] = s[i];
		}
	}

	BigarrayInterface( IntegerType* d, intnat s[dimension])
	:data(d)
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
struct ConversionManagement< BigarrayInterface<IType, dim> >
{
	BigarrayInterface<IType, dim> from_value( value const& v )
	{
		assert( Bigarray_val(v)->flags & BigarrayIntegerTraits< IType >::mask_value );
		assert( Bigarray_val(v)->flags & BIGARRAY_C_LAYOUT);
		return BigarrayInterface<IType, dim>( static_cast<IType*>(Data_bigarray_val(v)), Bigarray_val(v)->dim );
	}
};

template<class IType, int dim>
struct AffectationManagement< BigarrayInterface<IType, dim> >
{
	static void affect( value& v, BigarrayInterface<IType, dim> const& b)
	{
		static intnat size[dim];
		for(int i = 0; i < dim; ++i)
		{
			size[i] = b.size[i];
		}
		v = alloc_bigarray( 	BigarrayIntegerTraits<typename std::remove_const<IType>::type >::mask_value | BIGARRAY_C_LAYOUT,
					dim, const_cast<void*>(static_cast<void const*>(b.data)), size);
	}
};

