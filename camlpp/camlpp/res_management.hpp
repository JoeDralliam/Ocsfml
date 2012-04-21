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

extern "C"
{
#include <caml/threads.h>
#include <caml/fail.h>
}

struct raii_caml_rt_lock 
{
  raii_caml_rt_lock ()
  {
    caml_release_runtime_system();
  }
  
  ~raii_caml_rt_lock ()
  {
    caml_acquire_runtime_system();
  }
};

#ifndef _MSC_VER

template<class T>
struct ResManagement 
{
  template<class Func,class... Args>
  void call(value& res, Func&& f, Args&&... args)
  {
    try {
      caml_release_runtime_system();
      auto tmpRes( f(std::forward<Args>(args)...) );
      caml_acquire_runtime_system();
      AffectationManagement<T>::affect(res, tmpRes);
    } 
    catch( std::exception& e ) {
      caml_acquire_runtime_system();
      caml_failwith( e.what() );
    }
    catch( ... ) {
      caml_acquire_runtime_system();
      caml_failwith( "Non standard exception thrown from C++" );
    }
  }
};


struct ResManagementIntegerBase
{
  template<class Func, class... Args>
  void call(value& res, Func&& f, Args&&... args)
  {
    try {
      raii_caml_rt_lock lck;
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
struct ResManagement<void>
{
  template<class Func, class... Args>
  void call(value& res, Func&& f, Args&&... args)
  {
    try {
      raii_caml_rt_lock lck;
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

#define CAMLPP__INVOKE( rm, res, ...) rm.call( res, __VA_ARGS__ )

#else

template<class T>
struct ResManagement {

  template<class Func>
  void call(value& res, Func& ret)
  {
    try {
      caml_release_runtime_system();
      auto tmpRes(ret() );
      caml_acquire_runtime_system();
      AffectationManagement<T>::affect(res, tmpRes);
    } 
    catch( std::exception& e ) {
      caml_acquire_runtime_system();
      caml_failwith( e.what() );
    }
    catch( ... ) {
      caml_acquire_runtime_system();
      caml_failwith( "Non standard exception thrown from C++" );
    }
  }
};


struct ResManagementIntegerBase
{
  template<class Func>
  void call(value& res, Func& ret)
  {
    try {
      raii_caml_rt_lock lck;
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

template<>
struct ResManagement<void>
{
  template<class Func>
  void call(value& res, Func& f)
  {
    try {
      raii_caml_rt_lock lck;
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


#define CAMLPP__INVOKE( rm, res, f, ...)				\
  do									\
    {									\
      auto camlpp__tmp_f = f;						\
      auto camlpp__invoke_func = [&]{ return camlpp__tmp_f( __VA_ARGS__ ); }; \
      rm.call( res, camlpp__invoke_func );				\
    } while( 0 )

#endif

template<>
struct ResManagement<short> : ResManagementIntegerBase
{};

template<>
struct ResManagement<int> : ResManagementIntegerBase
{};

template<>
struct ResManagement<long> : ResManagementIntegerBase
{};

template<>
struct ResManagement<unsigned short> : ResManagementIntegerBase
{};

template<>
struct ResManagement<unsigned int> : ResManagementIntegerBase
{};

template<>
struct ResManagement<unsigned long> : ResManagementIntegerBase
{};

template<>
struct ResManagement<signed char> : ResManagementIntegerBase
{};

template<>
struct ResManagement<unsigned char> : ResManagementIntegerBase
{};








#endif
