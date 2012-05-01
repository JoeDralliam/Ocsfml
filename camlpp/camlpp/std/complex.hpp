#ifndef CAMLPP_STD_COMPLEX_HPP_INCLUDED
#define CAMLPP_STD_COMPLEX_HPP_INCLUDED

#include <complex>

#include <camlpp/conversion_management.hpp>
#include <camlpp/std/pair.hpp>

namespace camlpp
{
  template<class T>
  class conversion_management< std::complex< T > >
  {
    conversion_management< std::pair< T, T > > cm;
  public:
    std::complex< T > from_value( value const& v)
    {
      std::pair< T, T > p( cm.from_value( v ) );
      return std::complex<T>( p.first, p.second );	
    }
  };
  
}





#endif
