#ifndef CAMLPP_DETAILS_FLOAT_ARRAY_SUPPORT_HPP_INCLUDED
#define CAMLPP_DETAILS_FLOAT_ARRAY_SUPPORT_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
}

#include <tuple>
#include <utility>
#include <type_traits>

namespace camlpp
{
  namespace details
  {
    template< class Args >
    struct float_array_support
    {
    private:
#ifndef _MSC_VER
      template<class... ArgsToScan>
      struct are_floating_point_impl;

      template<class T>
      struct are_floating_point_impl<T>
      {
	enum { value = std::is_floating_point<T>::value };
      };

      template<class T, class... ArgsToScan>
      struct are_floating_point_impl<T, ArgsToScan...>
      {
	enum { value = std::is_floating_point<T>::value && are_floating_point_impl<ArgsToScan...>::value };
      };

      template<class T>
      struct are_floating_point;

      template<class... ArgsToScan>
      struct are_floating_point< std::tuple<ArgsToScan...> >
      {
	enum { value = are_floating_point_impl<ArgsToScan...>::value }
      };
#else
      template<class ArgsToScan, size_t I>
      struct are_floating_point_impl;

      template<class ArgsToScan>
      struct are_floating_point_impl<ArgsToScan, 0>
      {
      private:
	typedef typename std::tuple_element<0, ArgsToScan>::type T;
      public:
	enum { value = std::is_floating_point<T>::value };
      };

      template<class ArgsToScan, size_t I>
      struct are_floating_point_impl
      {
      private:
	typedef typename std::tuple_element<I, ArgsToScan>::type T;
      public:
	enum { value = std::is_floating_point<T>::value && are_floating_point_impl<ArgsToScan, I-1>::value };
      };


      template<class ArgsToScan>
      struct are_floating_point
      {
	enum { value = are_floating_point_impl<ArgsToScan, std::tuple_size<ArgsToScan>::value - 1 >::value };
      };
#endif      
    public:
      enum { tag = are_floating_point<Args>::value ? Double_array_tag : 0 };

      enum { word_size = are_floating_point<Args>::value ? Double_wosize : 1 };      
    };
  }
}

#endif
