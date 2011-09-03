/*
 * =====================================================================================
 *
 *       Filename:  unit.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  03/09/2011 12:37:25
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#include "affectation_management.hpp"
#include "conversion_management.hpp"

struct UnitTypeHolder {};

template<>
class ConversionManagement< UnitTypeHolder >
{
	UnitTypeHolder from_value(value const&)
	{
		return UnitTypeHolder();
	}	
};


