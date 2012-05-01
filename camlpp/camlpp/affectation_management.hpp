/*
 * =====================================================================================
 *
 *       Filename:  affectation_management.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 12:17:34
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef AFFECTATION_MANAGEMENT_HPP_INCLUDED
#define AFFECTATION_MANAGEMENT_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
}

#include <boost/type_traits.hpp>
#include <type_traits>

namespace camlpp
{
  template<class T>
  class affectation_management;

  namespace details
  {
    template<class T, bool cpConstructor>
    struct copy_instance_helper2
    {
      template< class T2 >
      static void affect( value& v, T2&& obj )
      {
	affectation_management< T const*>::affect( v, new T( std::forward<T2>(obj) ) );
      }
    };

    template<class T>
    struct copy_instance_helper2< T, false >
    {};

    template<class T, bool abstract>
    struct copy_instance_helper : public copy_instance_helper2<T, std::is_convertible<T&&, T>::value>
    {};

    template<class T>
    struct copy_instance_helper< T, true >
    {};
  }

  
  template< class T >
  struct affectation_management : public details::copy_instance_helper< T, boost::is_abstract<T>::value > 
  { 
  };


  template< class T >
  struct affectation_management<T const*>
  {
    static void affect(value& v, T const* t)
    {
      v = caml_alloc(1, Abstract_tag);
      Store_field(v, 0,reinterpret_cast<value>(t));
    }
  };



  template<class T>
  struct affectation_management< T*> 
  {
    static void affect( value& v, T* obj ) 
    { 
      affectation_management< T const*>::affect( v, obj ); 
    } 
  }; 

  template<class T>
  struct affectation_management< T&> 
  { 
    static void affect( value& v, T& obj ) 
    { 
      affectation_management< T const*>::affect( v, &obj ); 
    } 
  }; 

  template< class T >
  struct affectation_management<T const&> : affectation_management<T>
  {
  };

  template<>
  struct affectation_management<char*>
  {
    static void affect(value& v, char* str)
    {
      v = caml_copy_string( str );
    }
  };


  template<>
  struct affectation_management<double>
  {
    static void affect(value& v, double d)
    {
      v = caml_copy_double( d );
    }
  };

  template<>
  struct affectation_management<float>
  {
    static void affect(value& v, float d)
    {
      v = caml_copy_double( d );
    }
  };

  template<>
  struct affectation_management<short>
  {
    static void affect(value& v, short d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<bool>
  {
    static void affect(value& v, bool d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<int>
  {
    static void affect(value& v, int d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<long>
  {
    static void affect(value& v, long d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<long long>
  {
    static void affect(value& v, long long d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<unsigned short>
  {
    static void affect(value& v,unsigned short d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<unsigned int>
  {
    static void affect(value& v, unsigned int d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<unsigned long>
  {
    static void affect(value& v, unsigned long d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<unsigned long long>
  {
    static void affect(value& v, unsigned long long d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<signed char>
  {
    static void affect(value& v, signed char d)
    {
      v = Val_int(d);
    }
  };

  template<>
  struct affectation_management<unsigned char>
  {
    static void affect(value& v, unsigned char d)
    {
      v = Val_int(d);
    }
  };

  template< class T>
  inline void affect(value& v, T const& t)
  {
    affectation_management< T >::affect(v,t);
  }

}
#endif



