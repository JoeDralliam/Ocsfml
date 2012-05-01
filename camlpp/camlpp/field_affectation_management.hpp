#ifndef CAMLPP_FIELD_AFFECTATION_MANAGEMENT_HPP_INCLUDED
#define CAMLPP_FIELD_AFFECTATION_MANAGEMENT_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
}

namespace camlpp
{
  template<class T>
  struct field_affectation_management
  {
    template< class Arg >
    static void affect_field(value& v, int field, Arg&& t)
    {
      CAMLparam0();
      CAMLlocal1( tmp );
      affectation_management<T>::affect( tmp, std::forward<Arg>(t) );
      Store_field(v, field, tmp);
      CAMLreturn0;
    }
  };


  namespace details
  {
    struct float_field_affectation_management
    {
      template< class Arg >
      static void affect_field(value& v, int field, Arg&& t)
      {
	if( Tag_val(v) == Double_array_tag )
	  {
	    Store_double_field(v, field, t);
	  }
	else
	  {
	    CAMLparam0();
	    CAMLlocal1( double_val );
	    double_val = caml_copy_double( t );
	    Store_field(v, field, double_val);
	    CAMLreturn0;
	  }
      }
    };
  }
  
  template<>
  struct field_affectation_management<float>
    : details::float_field_affectation_management
  {};

  template<>
  struct field_affectation_management<double>
    : details::float_field_affectation_management
  {};

  template<class T>
  inline void affect_field(value& v, int field, T&& t)
  {
    //	CAMLparam0();
    field_affectation_management< T >::affect_field(v, field,t);
    //	CAMLreturn0;
  }
  

}

#endif
