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
}

#ifndef _MSC_VER

template<class T, bool shouldReturnObject = true>
struct ResManagement 
{
    template<class Func,class... Args>
    void call(value& res, Func&& f, Args&&... args)
    {
		caml_release_runtime_system();
		auto tmpRes( f(std::forward<Args>(args)...) );
		caml_acquire_runtime_system();
		caml_cpp__affect<shouldReturnObject, T >(res, tmpRes);
    }
};


struct ResManagementIntegerBase
{
	template<class Func, class... Args>
	void call(value& res, Func&& f, Args&&... args)
	{
		caml_release_runtime_system();
		res = Val_int(f(std::forward<Args>(args)...));
		caml_acquire_runtime_system();
	}
};

template<>
struct ResManagement<void>
{
	template<class Func, class... Args>
	void call(value& res, Func&& f, Args&&... args)
	{
		caml_release_runtime_system();
		f(std::forward<Args>(args)...);
		res = Val_unit;
		caml_acquire_runtime_system();
	}
};

#define CAMLPP__INVOKE( rm, res, ...) rm.call( res, __VA_ARGS__ )

#else

template<class T, bool shouldReturnObject = true>
struct ResManagement {

	template<class Func>
	void call(value& res, Func& ret)
	{
		caml_release_runtime_system();
		auto tmpRes(ret());
		caml_acquire_runtime_system();
		caml_cpp__affect<shouldReturnObject, T>(res, tmpRes);
	}
};


struct ResManagementIntegerBase
{
	template<class Func>
	void call(value& res, Func& ret)
	{
		caml_release_runtime_system();
		res = Val_int(ret());
		caml_acquire_runtime_system();
	}
};

template<>
struct ResManagement<void>
{
	template<class Func>
	void call(value& res, Func& f)
	{
		caml_release_runtime_system();
		f();
		res = Val_unit;
		caml_acquire_runtime_system();
	}
};


#define CAMLPP__INVOKE( rm, res, f, ...) \
		do \
		{ \
			auto camlpp__tmp_f = f; \
			auto camlpp__invoke_func = [&]{ return camlpp__tmp_f( __VA_ARGS__ ); }; \
			rm.call( res, camlpp__invoke_func ); \
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
