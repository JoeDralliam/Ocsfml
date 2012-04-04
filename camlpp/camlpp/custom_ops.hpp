/*
 * =====================================================================================
 *
 *       Filename:  custom_ops.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  07/11/2011 18:07:25
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef CAMLPP_CUSTOM_OPS_HPP_INCLUDED
#define CAMLPP_CUSTOM_OPS_HPP_INCLUDED

#include "conversion_management.hpp"
#include <fstream>

template<class T>
void camlpp__default_finalize( value v )
{
  //  std::cout << "Deleting : " << typeid(T).name() << std::endl;
  ConversionManagement<T*> cm;
  delete cm.from_value( v );
}

template<class T>
int camlpp__default_compare( value v1, value v2 )
{
  ConversionManagement<T*> cm1, cm2;
  T* t1 ( cm1.from_value( v1 ) );
  T* t2 ( cm2.from_value( v2 ) );
  if( *t1 < *t2 )
    {
      return -1;
    }
  if( *t2 < *t1 )
    {
      return 1;
    }
  return 0;
}

template<class T>
long camlpp__default_hash( value v )
{
  ConversionManagement<T*> cm;
  return std::hash<T>()( *cm.from_value( v ) );
}

#define CAMLPP__DEFAULT_FINALIZE() 	&camlpp__default_finalize< CAMLPP__CLASS_NAME() >
#define CAMLPP__DEFAULT_COMPARE() 	&camlpp__default_compare< CAMLPP__CLASS_NAME() >
#define CAMLPP__DEFAULT_HASH() 		&camlpp__default_hash< CAMLPP__CLASS_NAME() >
#define CAMLPP__NO_FINALIZE() 	custom_finalize_default
#define CAMLPP__NO_COMPARE() 	custom_compare_default
#define CAMLPP__NO_HASH() 	custom_hash_default

#endif


