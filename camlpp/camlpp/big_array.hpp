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

extern "C"
{
	#include <caml/bigarray.h>
}

template< IntegerType >
struct BigarrayIntegerTraits;

template<>
struct BigarrayIntegerTraits< sf::Uint8 >
{
	enum { mask_value = BIGARRAY_UINT8 };
}

template<>
struct BigarrayIntegerTraits< sf::Int8 >
{
	enum { mask_value = BIGARRAY_SINT8 };
}

template<>
struct BigarrayIntegerTraits< sf::Uint16 >
{
	enum { mask_value = BIGARRAY_UINT16 };
}

template<>
struct BigarrayIntegerTraits< sf::Int16 >
{
	enum { mask_value = BIGARRAY_SINT16 };
}

template<>
struct BigarrayIntegerTraits< sf::Uint32 >
{
	enum { mask_value = BIGARRAY_UINT32 };
}

template<>
struct BigarrayIntegerTraits< sf::Int32 >
{
	enum { mask_value = BIGARRAY_SINT32 };
}

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


	IntegerType* data;
	int size[dimension];
};


template<class IType, int dim>
struct ConversionManagement< BigarrayInterface<IType, dim> >
{
	BigarrayInterface<IType, dim> from_value( value const& v )
	{
		assert( Bigarray_val(v)->flags & BigarrayIntegerTraits< IType >::mask_value );
		assert( Bigarray_val(v)->flags & BIGARRAY_C_LAYOUT);
		return BigarrayInterface<IType, dim>( Bigarray_data_val(v), Bigarray_val(v)->dim );
	}
};

template<class IType, int dim>
struct AffectationManagement< BigarrayInterface<IType, dim> >
{
	static void affect( value& v, Bigarray const& b)
	{
		v = alloc_bigarray( 	BigarrayIntegerTraits< IType >::mask_value | BIGARRAY_C_LAYOUT,
					b.data, b.size );
	}
};

