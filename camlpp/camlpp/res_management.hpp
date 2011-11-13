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

#ifdef _MSC_VER

template<class T, bool shouldReturnObject = true>
struct ResManagement {

	template<class Func,class... Args>
	void call(value& res, Func&& f, Args&&... args)
	{
		caml_cpp__affect<shouldReturnObject>(res, f(std::forward<Args>(args)...));
	}
};


struct ResManagementIntegerBase
{
	template<class Func, class... Args>
	void call(value& res, Func&& f, Args&&... args)
	{
		res = Val_int(f(std::forward<Args>(args)...));
	}
};

template<>
struct ResManagement<void>
{
	template<class Func, class... Args>
	void call(value& res, Func&& f, Args&&... args)
	{
		f(std::forward<Args>(args)...);
		res = Val_unit;
	}
};

#define CAMLPP__INVOKE( rm, res, ...) rm.call( res, __VA_ARGS__ )

#else

template<class T, bool shouldReturnObject = true>
struct ResManagement {

	template<class Func>
	void call(value& res, Func& ret)
	{
		caml_cpp__affect<shouldReturnObject>(res, ret() );
	}
};


struct ResManagementIntegerBase
{
	template<class Func>
	void call(value& res, Func& ret)
	{
		res = Val_int(ret());
	}
};

template<>
struct ResManagement<void>
{
	template<class Func>
	void call(value& res, Func& f)
	{
		f();
		res = Val_unit;
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
