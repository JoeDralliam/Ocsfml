/*
 * =====================================================================================
 *
 *       Filename:  test.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  28/10/2011 15:40:44
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include <iostream>
#include "stub_generator.hpp"
#include "channel_streambuf_interface.hpp"
#include "memory_management.hpp"

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
}

#undef flush
//*   
std::pair<double, double> test1()
{
	return { 5.0, 12.0 };
}
extern "C"
{
	camlpp__register_free_function0( test1 );
}
//*/
/*  
void affect_double_to_field( value& v, int field, double val)
{
	CAMLparam0();
	AffectationManagement<double>::affect_field(v, field, val);
	CAMLreturn0;
 
	CAMLparam0();
	CAMLlocal1( p );
	p = caml_copy_double( val );
	Field(v, field) = p;
	CAMLreturn0;

  
}

extern "C"
{
CAMLprim value test1__impl( value unit )
{
//	MemoryManagement<1> mm(unit);
	CAMLparam1(unit);
	value res = 0;
	CAMLxparam1( res );
	double a = 5.0, b = 12.0;

// 	CAMLlocal1(pair);
//	pair = caml_alloc( 2 * Double_wosize, Double_array_tag );
//	Store_double_field( pair, 0, a);
//	Store_double_field( pair, 1, b);
//	CAMLreturn( pair ); 


//	res = caml_alloc_tuple( 2 );

//	AffectationManagement<std::pair<double, double> >::affect(res, std::make_pair(a,b));
//	AffectationManagement<double>::affect_field(res, 0, b);
//	AffectationManagement<double>::affect_field(res, 1, a);

//	affect_double_to_field( res, 0, a);
//	affect_double_to_field( res, 1, b);
 
	res = caml_alloc_tuple( 2 );
	caml_cpp__affect_field( res, 0, a );
	caml_cpp__affect_field( res, 1, b );
	CAMLreturn(res);
} 
}

*/
