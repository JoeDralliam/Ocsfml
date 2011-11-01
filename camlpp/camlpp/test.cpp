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


extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
}

#undef flush

std::pair<double, double> test1()
{
	return { 5.0, 12.0 };
}
extern "C"
{
	camlpp__register_free_function0( test1 );
}
/*  
extern "C"
{
CAMLprim value test1__impl( value unit )
{
	CAMLparam1( unit );
	CAMLlocal3( res, p1, p2 );
	double a = 5.0, b = 12.0;
	CAMLlocal1(pair);
	pair = caml_alloc( 2 * Double_wosize, Double_array_tag );
	Store_double_field( pair, 0, a);
	Store_double_field( pair, 1, b);
	CAMLreturn( pair ); 
	p1 = caml_copy_double( a );
	p2 = caml_copy_double( b );
	res = caml_alloc_tuple( 2 );
	Field( res, 0 ) = p1;
	Field( res, 1 ) = p2;
	CAMLreturn( res );
} 
}

*/

