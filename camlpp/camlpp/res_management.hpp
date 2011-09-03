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

template<class T, bool shouldReturnObject = true>
struct ResManagement {
	value res;
	ResManagement( ) : res(0)
	{
		CAMLxparam1( res );
	}

	template<class Func,class... Args>
	value& call(Func&& f, Args&&... args)
	{
		caml_cpp__affect<shouldReturnObject>(res, f(std::forward<Args>(args)...));
		return res;
	}
};


struct ResManagementIntegerBase
{
	template<class Func, class... Args>
	value call(Func&& f, Args&&... args)
	{
		return Val_int(f(std::forward<Args>(args)...));
	}
};

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




template<>
struct ResManagement<void>
{
	template<class Func, class... Args>
	value call(Func&& f, Args&&... args)
	{
		f(std::forward<Args>(args)...);
		return Val_unit;
	}
};



#endif
