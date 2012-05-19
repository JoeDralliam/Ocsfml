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


#include <camlpp/affectation_management.hpp>
#include <functional>
#include <tuple>

extern "C"
{
#include <caml/misc.h>
#include <caml/threads.h>
#include <caml/fail.h>
}

namespace camlpp
{

  template<bool enabled>
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

  template<>
  struct scoped_release_rt<false>
  {};
}

namespace camlpp
{
  enum call_flags
    {
      release_caml_runtime = 1,
      catch_exceptions = 1 << 1,
    };
}

#ifndef _MSC_VER
namespace camlpp
{

  template<class T, int flags>
  struct res_management 
  {
  private:
    template<class Func, class... Args>
    T call_helper(Func&& f, Args&&... args)
    {
      scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
      return f(std::forward<Args>(args)...);
    }

    template<class Func, class... Args>
    void call_exception_flag(std::true_type, value& res, Func&& f, Args&&... args)
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

    template<class Func, class... Args>
    void call_exception_flag(std::false_type, value& res, Func&& f, Args&&... args)
    {
      affectation_management<T>::affect(res, call_helper(std::forward<Func>(f), std::forward<Args>(args)...) );
    }

  public:
    template<class Func,class... Args>
    void call(value& res, Func&& f, Args&&... args)
    {
      call_exception_flag(std::integral_constant<bool, (flags & catch_exceptions) != 0>() ,
			  res, std::forward<Func>(f), std::forward<Args>(args)... );
    }
  };
  
  namespace details
  {
    template<int flags>
    struct res_management_integer_base
    {
    private:
      template<class Func, class... Args>
      void call_exception_flag(std::true_type, value& res, Func&& f, Args&&... args)
      {
	try {
	  scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
	  res = Val_int(f(std::forward<Args>(args)...));
	}
	catch( std::exception& e ) {
	  caml_failwith( e.what() );
	}
	catch( ... ) {
	  caml_failwith( "Non standard exception thrown from C++" );
	}
      }
      
      template<class Func, class... Args>
      void call_exception_flag(std::false_type, value& res, Func&& f, Args&&... args)
      {
	scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
	res = Val_int(f(std::forward<Args>(args)...));
      }
    public:
      template<class Func, class... Args>
      void call(value& res, Func&& f, Args&&... args)
      {
	call_exception_flag(std::integral_constant<bool, (flags & catch_exceptions) != 0>() ,
			    res, std::forward<Func>(f), std::forward<Args>(args)... );
      }
    };
  }
  
  template<int flags>
  struct res_management<void, flags>
  {
  private:
    template<class Func, class... Args>
    void call_exception_flag(std::true_type, Func&& f, Args&&... args)
    {
      try {
	scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
	f(std::forward<Args>(args)...);
      }
      catch( std::exception& e ) {
	caml_failwith( e.what() );
      }
      catch( ... ) {
	caml_failwith( "Non standard exception thrown from C++" );
      }
    }
      
    template<class Func, class... Args>
    void call_exception_flag(std::false_type, Func&& f, Args&&... args)
    {
      scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
      f(std::forward<Args>(args)...);
    }
  public:
    template<class Func, class... Args>
    void call(value& res, Func&& f, Args&&... args)
    {
      call_exception_flag( std::integral_constant<bool, (flags & catch_exceptions) != 0>(),
			   std::forward<Func>(f), std::forward<Args>(args)... );
      res = Val_unit;
    }
  };
}

#define CAMLPP__INVOKE( rm, ...) rm.call( __VA_ARGS__ )

#else
namespace camlpp
{
  template<class T, int flags>
  struct res_management 
  {
  private:
    template<class Func>
    typename auto call_helper(Func&& f) -> decltype(f())
    {
      scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
      return f();
    }

    template<class Func>
    void call_exception_flag(value& res, Func&& f, std::true_type)
    {
      try {
	affectation_management<T>::affect(res, call_helper(std::forward<Func>(f)) );
      }
      catch( std::exception& e ) {
	caml_failwith( e.what() );
      }
      catch( ... ) {
	caml_failwith( "Non standard exception thrown from C++" );
      }
    }
    
    template<class Func>
    void call_exception_flag(value& res, Func&& f, std::false_type)
    {
      affectation_management<T>::affect(res, call_helper(std::forward<Func>(f)) );
    }

  public:
    template<class Func>
    void call(value& res, Func&& f)
    {
      call_exception_flag(res, std::forward<Func>(f), 
			  std::integral_constant<bool, (flags & catch_exceptions) != 0>());
    }
  };
  
  namespace details
  {
    template<int flags>
    struct res_management_integer_base
    {
    private:
      template<class Func>
      void call_exception_flag(value& res, Func&& f, std::true_type)
      {
	try {
	  scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
	  res = Val_int( f() );
	}
	catch( std::exception& e ) {
	  caml_failwith( e.what() );
	}
	catch( ... ) {
	  caml_failwith( "Non standard exception thrown from C++" );
	}
      }
    
      template<class Func>
      void call_exception_flag(value& res, Func&& f, std::false_type)
      {
	scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
	res = Val_int( f() );
      }

    public:
      template<class Func>
      void call(value& res, Func& f)
      {
	call_exception_flag(res, std::forward<Func>(f), 
			    std::integral_constant<bool, (flags & catch_exceptions) != 0>());
      }
    };
  }
  
  template<int flags>
  struct res_management<void, flags>
  {
    private:
      template<class Func>
      void call_exception_flag(Func&& f, std::true_type)
      {
	try {
	  scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
	  f();
	}
	catch( std::exception& e ) {
	  caml_failwith( e.what() );
	}
	catch( ... ) {
	  caml_failwith( "Non standard exception thrown from C++" );
	}
      }
    
      template<class Func>
      void call_exception_flag(Func&& f, std::false_type)
      {
	scoped_release_rt<(flags & release_caml_runtime) != 0> runtime_released;
	f();
      }
    public:

    template<class Func>
    void call(value& res, Func& f)
    {
      call_exception_flag(std::forward<Func>(f), 
			  std::integral_constant<bool, (flags & catch_exceptions) != 0>());
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
  template<int flags>
  struct res_management<short, flags> : details::res_management_integer_base<flags>
  {};

  template<int flags>
  struct res_management<int, flags> : details::res_management_integer_base<flags>
  {};

  template<int flags>
  struct res_management<long, flags> : details::res_management_integer_base<flags>
  {};

  template<int flags>
  struct res_management<unsigned short, flags> : details::res_management_integer_base<flags>
  {};

  template<int flags>
  struct res_management<unsigned int, flags> : details::res_management_integer_base<flags>
  {};

  template<int flags>
  struct res_management<unsigned long, flags> : details::res_management_integer_base<flags>
  {};

  template<int flags>
  struct res_management<signed char, flags> : details::res_management_integer_base<flags>
  {};

  template<int flags>
  struct res_management<unsigned char, flags> : details::res_management_integer_base<flags>
  {};
}







#endif
