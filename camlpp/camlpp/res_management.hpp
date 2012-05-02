/*
 * =====================================================================================
 *
 *       Filename:  res_management.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 12:27:43
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef RES_MANAGEMENT_HPP_INCLUDED
#define RES_MANAGEMENT_HPP_INCLUDED

#include "affectation_management.hpp"
#include <functional>
#include <tuple>

extern "C"
{
#include <caml/threads.h>
#include <caml/fail.h>
}

namespace camlpp
{

  struct scoped_release_rt
  {
    scoped_release_rt ()
    {
      caml_release_runtime_system();
    }
    
    ~scoped_release_rt ()
    {
      caml_acquire_runtime_system();
    }
  };
}

#ifndef _MSC_VER
namespace camlpp
{
  template<class T>
  struct res_management 
  {
  private:
    template<class Func, class... Args>
    typename std::result_of<Func(Args...)>::type call_helper(Func&& f, Args&&... args)
    {
      scoped_release_rt runtime_released;
      return f(std::forward<Args>(args)...);
    }
  public:
    template<class Func,class... Args>
    void call(value& res, Func&& f, Args&&... args)
    {
      try {
	affectation_management<T>::affect(res, call_helper(f, std::forward<Args>(args)...) );
      }
      catch( std::exception& e ) {
	caml_failwith( e.what() );
      }
      catch( ... ) {
	caml_failwith( "Non standard exception thrown from C++" );
      }
    }
  };
  
  
  struct res_management_integer_base
  {
    template<class Func, class... Args>
    void call(value& res, Func&& f, Args&&... args)
    {
      try {
	scoped_release_rt runtime_released;
	res = Val_int(f(std::forward<Args>(args)...));
      } 
      catch( std::exception& e ) {
	caml_failwith( e.what() );
      }
      catch( ... ) {
	caml_failwith( "Non standard exception thrown from C++" );
      }
    }
  };
  
  template<>
  struct res_management<void>
  {
    template<class Func, class... Args>
    void call(value& res, Func&& f, Args&&... args)
    {
      try {
	scoped_release_rt runtime_released;
	f(std::forward<Args>(args)...);
      } 
      catch( std::exception& e ) {
	caml_failwith( e.what() );
      }
      catch( ... ) {
	caml_failwith( "Non standard exception thrown from C++" );
      }
      res = Val_unit;
    }
  };
}

#define CAMLPP__INVOKE( rm, ...) rm.call( __VA_ARGS__ )

#else
namespace camlpp
{
  template<class T>
  struct res_management 
  {
  private:
    template<class Func>
    typename auto call_helper(Func&& f) -> decltype(f())
    {
      scoped_release_rt runtime_released;
      return f();
    }
  public:
    template<class Func>
    void call(value& res, Func&& f)
    {
      try {
	affectation_management<T>::affect(res, call_helper(f) );
      } 
      catch( std::exception& e ) {
	caml_failwith( e.what() );
      }
      catch( ... ) {
	caml_failwith( "Non standard exception thrown from C++" );
      }
    }
  };
  
  namespace details
  {
    struct res_management_integer_base
    {
      template<class Func>
      void call(value& res, Func& ret)
      {
	try {
	  scoped_release_rt runtime_released;
	  res = Val_int( ret() );
	} 
	catch( std::exception& e ) {
	  caml_failwith( e.what() );
	}
	catch( ... ) {
	  caml_failwith( "Non standard exception thrown from C++" );
	}
	
      }
    };
  }
  
  template<>
  struct res_management<void>
  {
    template<class Func>
    void call(value& res, Func& f)
    {
      try {
	scoped_release_rt runtime_released;
	f();
      } 
      catch( std::exception& e ) {
	caml_failwith( e.what() );
      }
      catch( ... ) {
	caml_failwith( "Non standard exception thrown from C++" );
      }
      res = Val_unit;
    }
  };
}

#define CAMLPP__INVOKE( rm, res, f, ...)				\
  do									\
    {									\
      auto camlpp__tmp_f = f;						\
      auto camlpp__invoke_func = [&]{ return camlpp__tmp_f( __VA_ARGS__ ); }; \
      rm.call( res, camlpp__invoke_func );				\
    } while( 0 )

#endif
namespace camlpp
{
  template<>
  struct res_management<short> : details::res_management_integer_base
  {};

  template<>
  struct res_management<int> : details::res_management_integer_base
  {};

  template<>
  struct res_management<long> : details::res_management_integer_base
  {};

  template<>
  struct res_management<unsigned short> : details::res_management_integer_base
  {};

  template<>
  struct res_management<unsigned int> : details::res_management_integer_base
  {};

  template<>
  struct res_management<unsigned long> : details::res_management_integer_base
  {};

  template<>
  struct res_management<signed char> : details::res_management_integer_base
  {};

  template<>
  struct res_management<unsigned char> : details::res_management_integer_base
  {};
}







#endif
