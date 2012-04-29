/*
 * =====================================================================================
 *
 *       Filename:  conversion_management.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  23/08/2011 13:35:30
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef CONVERSION_MANAGEMENT_HPP_INCLUDED
#define CONVERSION_MANAGEMENT_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/threads.h>

  value caml_gc_full_major(value v);
}

#include <functional>
#include <cassert>
#include <string>
#include <tuple>
#include <memory>
#include <list>
#include <complex>
#include <type_traits>

#include "affectation_management.hpp"

template<class T>
struct ConversionManagement
{
  ConversionManagement< T const* > cm;
  T from_value( value const& v)
  {
    return *cm.from_value(v);
  }
};


template<class T>
struct ConversionManagement<T*>
{
  T* from_value(value& v)
  {
    assert( Is_block( v ) ); 
    assert( Tag_val(v) == Abstract_tag );
    return reinterpret_cast<T*>(Field(v, 0));
  }
};

template<class T>
struct ConversionManagement<T&>
{
  ConversionManagement<T> cm;
  std::unique_ptr<T> ptr;
  T& from_value(value& v)
  {
    ptr.reset(new T( cm.from_value(v) ) );
    return *ptr;
  }
};

template<>
struct ConversionManagement<char>
{
  char from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};

template<>
struct ConversionManagement<signed char>
{
  char from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};


template<>
struct ConversionManagement<short>
{
  short from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};

template<>
struct ConversionManagement<int>
{
  int from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};
template<>
struct ConversionManagement<long>
{
  long from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};

template<>
struct ConversionManagement<long long>
{
  long long from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};

template<>
struct ConversionManagement<unsigned char>
{
  char from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};

template<>
struct ConversionManagement<unsigned short>
{
  unsigned short from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};
template<>
struct ConversionManagement<unsigned int>
{
  unsigned int from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};
template<>
struct ConversionManagement<unsigned long>
{
  unsigned long from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};

template<>
struct ConversionManagement<unsigned long long>
{
  unsigned long long from_value(value& v)
  {
    assert( Is_long( v ) );
    return Int_val(v);
  }
};

template<>
struct ConversionManagement<bool>
{
  bool from_value(value& v)
  {
    return Bool_val(v);
  }
};

template<>
struct ConversionManagement<float>
{
  float from_value(value& v)
  {
    assert( Tag_val( v ) == Double_tag );
    return Double_val(v);
  }
};

template<>
struct ConversionManagement<double>
{
  double from_value(value& v)
  {
    assert( Tag_val( v ) == Double_tag );
    return Double_val(v);
  }
};


template<>
struct ConversionManagement<std::string>
{
  std::string from_value(value& v)
  {
    assert( Tag_val( v ) == String_tag );
    return String_val(v);
  }
};

template<>
struct ConversionManagement<char*>
{
  char* from_value(value& v)
  {
    assert( Tag_val( v ) == String_tag );
    return String_val(v);
  }
};

template<class Tuple, int I>
struct TupleConversionHelper
{
  ConversionManagement< typename std::tuple_element< I, Tuple>::type > cm;
};


template<class T, int I>
struct TupleHelper : public TupleConversionHelper<T, I>, public TupleHelper<T, I-1>
{};


template<class Tuple>
struct TupleHelper<Tuple, -1>
{};


#ifndef _MSC_VER
template<class... Args>
struct ConversionManagement< std::tuple< Args...> > : private TupleHelper< std::tuple<Args...>, sizeof...( Args ) - 1 >
{
  std::tuple< Args... > from_value( value const& v )
  {
    assert( Is_block( v ) );
    assert( Tag_val( v ) == 0 );
    assert( Wosize_val( v ) == sizeof...( Args ) );
    std::tuple< Args... > res;
    from_value_helper( v, res, std::integral_constant<size_t, sizeof...( Args ) - 1 >() );
    return std::move( res );
  }
private:
  void from_value_helper( value const&, std::tuple< Args... >& , std::integral_constant<size_t, -1>)
  {}

  template<size_t I>
  void from_value_helper( value const& v, std::tuple< Args... >& res, std::integral_constant<size_t, I> )
  {
    std::get< I >( res ) =   TupleConversionHelper< std::tuple< Args... >, I >::cm.from_value( Field(v, I) );
    from_value_helper( v, res, std::integral_constant<size_t, I-1>() );
  }
};
#endif

template< class T1, class T2>
class ConversionManagement< std::pair< T1, T2 > >
{
  ConversionManagement< T1 > cm1;
  ConversionManagement< T2 > cm2;
public:
  std::pair< T1, T2 > from_value( value const& v )
  {
    assert( Is_block( v ) );
    assert( Tag_val( v ) == 0 );
    assert( Wosize_val( v ) == 2 );
    return std::make_pair( 	cm1.from_value( Field(v, 0 ) ),
				cm2.from_value( Field(v, 1 ) ) );
  }
};

#ifndef _MSC_VER


#if 0
template<class Ret, class... Args>
struct ConversionManagement< std::function< Ret(Args...) > >
{
  class CamlCallback
  {	
    std::unique_ptr<value> callback_;
  private:

    value call()
    {
      return callback( *callback_, Val_unit );
    }

    template<class T>
    value call( T t )
    {
      CAMLparam0();
      CAMLlocal1( p1 );
      AffectationManagement< T>::affect(p1, t);
      CAMLreturn( callback( *callback_, p1 ) );
    }

    template<class T1, class T2>
    value call( T1 t1, T2 t2 )
    {
      CAMLparam0();
      CAMLlocal2( p1, p2 );
      AffectationManagement<T1>::affect(p1, t1);
      AffectationManagement<T2>::affect(p2, t2);
      CAMLreturn( callback2( *callback_, p1, p2 ) );
    }

    template<class T1, class T2, class T3>
    value call( T1 t1, T2 t2, T3 t3 )
    {
      CAMLparam0();
      CAMLlocal3( p1, p2, p3 );
      AffectationManagement<T1>::affect(p1, t1);
      AffectationManagement<T2>::affect(p2, t2);
      AffectationManagement<T3>::affect(p3, t3);
      CAMLreturn( callback3( *callback_, p1, p2, p3 ) );
    }

    template<class... OArgs>
    value call( OArgs... tN)
    {
      CAMLparam0();
      CAMLlocalN( pN, sizeof...(Args) );
      CAMLreturn( call_helper( tN..., pN ) );
    }

    template<class T, int I>
    value call_helper( value pN[I], T tN )
    {
      AffectationManagement<T>::affect( pN[I-1], tN);
      return callbackN( *callback_, I, pN );
    }

    template<class... OArgs, class T, int I>
    value call_helper( value pN[I], T tN, Args... args )
    {
      AffectationManagement<T>::affect(pN[ I-sizeof...(Args)-1 ], tN);
      return call_helper( pN, args...);
    }
		
    CamlCallback( CamlCallback const& ) /* = delete */;
    CamlCallback& operator=( CamlCallback const& ) /*= delete*/ ;


  public:
    CamlCallback( value const& v ) : callback_(new value(v))
    {
      caml_register_generational_global_root(callback_.get());
    }

    ~CamlCallback()
    {
      if(callback_)
	{
	  caml_remove_generational_global_root(callback_.get());
	}
    }
	
    CamlCallback( CamlCallback&& other ) : callback_( std::move( other.callback_ ) )
    {}
	
    template<class... OArgs>
    Ret operator()(OArgs... args)
    {
      ConversionManagement< Ret > cm;
      return cm.from_value( call( std::forward<OArgs>(args)... ) );
    }
  };
  CamlCallback from_value( value const& v)
  {
		
    assert( Tag_val( v ) == Closure_tag );
    return CamlCallback( v );
  }
};

#endif // 0


template<class... Args>
struct ConversionManagement< std::function< void(Args...) > >
{
  class CamlCallback
  {	
    std::shared_ptr<value> callback_;
  private:

    value call()
    {
      return callback( *callback_, Val_unit );
    }

    template<class T>
    value call( T t )
    {
      CAMLparam0();
      CAMLlocal1( p1 );
      AffectationManagement< T>::affect(p1, t);
      CAMLreturn( callback( *callback_, p1 ) );
    }

    template<class T1, class T2>
    value call( T1 t1, T2 t2 )
    {
      CAMLparam0();
      CAMLlocal2( p1, p2 );
      AffectationManagement<T1>::affect(p1, t1);
      AffectationManagement<T2>::affect(p2, t2);

      caml_gc_full_major(0);

      CAMLreturn( callback2( *callback_, p1, p2 ) );
    }

    template<class T1, class T2, class T3>
    value call( T1 t1, T2 t2, T3 t3 )
    {
      CAMLparam0();
      CAMLlocal3( p1, p2, p3 );
      AffectationManagement<T1>::affect(p1, t1);
      AffectationManagement<T2>::affect(p2, t2);
      AffectationManagement<T3>::affect(p3, t3);
      CAMLreturn( callback3( *callback_, p1, p2, p3 ) );
    }

    template<class... OArgs>
    value call( OArgs... tN)
    {
      CAMLparam0();
      CAMLlocalN( pN, sizeof...(Args) );
      CAMLreturn( call_helper( pN, tN... ) );
    }

    template<class T, int I>
    value call_helper( value pN[I], T tN )
    {
      AffectationManagement<T>::affect( pN[I-1], tN);
      return callbackN( *callback_, I, pN );
    }

    template<class... OArgs, class T, int I>
    value call_helper( value pN[I], T tN, Args... args )
    {
      AffectationManagement<T>::affect(pN[ I-sizeof...(Args)-1 ], tN);
      return call_helper( pN, args...);
    }
		
    CamlCallback& operator=( CamlCallback const& );
  public:
    CamlCallback( value const& v ) : callback_(new value(v))
    {
      caml_register_generational_global_root(callback_.get());
    }

    ~CamlCallback()
    {
      if(callback_ && callback_.unique()) 
	{
	  caml_remove_generational_global_root(callback_.get());
	}
    }

    CamlCallback( CamlCallback const& other)
      :callback_(other.callback_)
    {}


    //		CamlCallback( CamlCallback&& other ) : callback_( std::move( other.callback_ ) )
    //	{}
    template<class... OArgs>
    void operator()(OArgs&&... args)
    {
      assert( callback_ );
      caml_acquire_runtime_system() ;
      call(std::forward<OArgs>(args)...);
      caml_release_runtime_system() ;
    }
  };
  CamlCallback from_value( value const& v)
  {
		
    assert( Tag_val( v ) == Closure_tag );
    return CamlCallback( v );
  }
};

#else // VC++


template< class Arg>
struct ConversionManagement< std::function< void(Arg) > >
{
  class CamlCallback
  {	
    std::shared_ptr<value> callback_;
  private:

    value call( Arg t )
    {
      CAMLparam0();
      CAMLlocal1( p1 );
      AffectationManagement<Arg>::affect(p1, t);
      CAMLreturn( callback( *callback_, p1 ) );
    }
		
    CamlCallback& operator=( CamlCallback const& );
  public:
    CamlCallback( value const& v ) : callback_(new value(v))
    {
      caml_register_generational_global_root(callback_.get());
    }

    ~CamlCallback()
    {
      if(callback_ && callback_.unique()) 
	{
	  caml_remove_generational_global_root(callback_.get());
	}
    }

    CamlCallback( CamlCallback const& other)
      :callback_(other.callback_)
    {}


    //		CamlCallback( CamlCallback&& other ) : callback_( std::move( other.callback_ ) )
    //	{}
    template<class T>
    void operator()(T&& args)
    {
      assert( callback_ );
      caml_acquire_runtime_system() ;
      call(std::forward<T>(args));
      caml_release_runtime_system() ;
    }
  };
  CamlCallback from_value( value const& v)
  {
		
    assert( Tag_val( v ) == Closure_tag );
    return CamlCallback( v );
  }
};

template< class Arg1, class Arg2>
struct ConversionManagement< std::function< void(Arg1, Arg2) > >
{
  class CamlCallback
  {	
    std::shared_ptr<value> callback_;
  private:

    value call( Arg1 t1, Arg2 t2 )
    {
      CAMLparam0();
      CAMLlocal2( p1, p2 );
      AffectationManagement<Arg1>::affect(p1, t1);
      AffectationManagement<Arg2>::affect(p2, t2);
      
      caml_gc_full_major(0);
      
      CAMLreturn( callback2( *callback_, p1, p2 ) );
    }
		
    CamlCallback& operator=( CamlCallback const& );
  public:
    CamlCallback( value const& v ) : callback_(new value(v))
    {
      caml_register_generational_global_root(callback_.get());
    }

    ~CamlCallback()
    {
      if(callback_ && callback_.unique()) 
	{
	  caml_remove_generational_global_root(callback_.get());
	}
    }

    CamlCallback( CamlCallback const& other)
      :callback_(other.callback_)
    {}


    //		CamlCallback( CamlCallback&& other ) : callback_( std::move( other.callback_ ) )
    //	{}
    template<class T1, class T2>
    void operator()(T1&& arg1, T2&& arg2)
    {
      assert( callback_ );
      caml_acquire_runtime_system() ;
      call(std::forward<T1>(arg1), std::forward<T2>(arg2));
      caml_release_runtime_system() ;
    }
  };
  CamlCallback from_value(value const& v)
  {
		
    assert( Tag_val( v ) == Closure_tag );
    return CamlCallback( v );
  }
};


#endif

template<class T>
struct ConversionManagement< T const& >: public ConversionManagement< T >
{};

template<class T>
class ConversionManagement< std::vector< T > >
{
  ConversionManagement< T > cm;
public:
  std::vector< T > from_value( value const& v)
  {
    std::vector< T > res;
    res.reserve( Wosize_val( v ) );
    for(int i = 0; i < res.capacity(); ++i)
      {
	res.push_back( cm.from_value( Field(v, i) ) );
      }
    return std::move( res );
  }
};

template<class T>
class ConversionManagement< std::list< T > >
{
  ConversionManagement< T > cm;
public:
  std::list< T > from_value( value const& v)
  {
    std::list< T > res;
    for( value iter = v; iter != Val_int(0); iter = Field(iter, 1))
      {
	res.push_back( cm.from_value( Field(iter, 0) ) );
      }
    return std::move( res ); 
  }
};

template<class T>
class ConversionManagement< std::complex< T > >
{
  ConversionManagement< std::pair< T, T > > cm;
public:
  std::complex< T > from_value( value const& v)
  {
    std::pair< T, T > p( cm.from_value( v ) );
    return std::complex<T>( p.first, p.second );	
  }
};

#endif
