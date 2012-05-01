#ifndef CAMLPP_STD_LIST_HPP_INCLUDED
#define CAMLPP_STD_LIST_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
}

#include <list>

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>
#include <camlpp/field_affectation_management.hpp>

namespace camlpp
{
  template<class T>
  struct affectation_management< std::list< T > >
  {
    static void affect(value& v, std::list<T> const& lst)
    {
      CAMLparam0();
      CAMLlocal1( tmp );
      tmp = caml_alloc( 2, 0 );
      Store_field( tmp, 1, Val_int(0) );

      for( auto it = lst.rbegin(); it != lst.rend(); ++it)
	{
	  std::list<T>::const_reference val = *it;
	  field_affectation_management< T >::affect_field(tmp, 0, val);
	  v = tmp;
	  tmp = caml_alloc( 2 , 0 );
	  Store_field(tmp, 1, v);
	}
      CAMLreturn0;
    }
  };

  template<class T>
  struct conversion_management< std::list< T > >
  {
  private:
    conversion_management< T > cm;
  public:
    std::list< T > from_value( value const& v)
    {
      std::list< T > res;
      for( value iter = v; iter != Val_int(0); iter = Field(iter, 1))
	{
	  res.push_back( cm.from_value( Field(iter, 0) ) );
	}
      return res; 
    }
  };
}

#endif
