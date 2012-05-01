#ifndef OCAML_STD_FUNCTION_HPP_INCLUDED
#define OCAML_STD_FUNCTION_HPP_INCLUDED

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>
}

#include <functional>

#include <camlpp/affectation_management.hpp>
#include <camlpp/conversion_management.hpp>

namespace camlpp
{
#ifndef _MSC_VER

#if 0
  template<class Ret, class... Args>
  struct conversion_management< std::function< Ret(Args...) > >
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
	affectation_management< T>::affect(p1, t);
	CAMLreturn( callback( *callback_, p1 ) );
      }

      template<class T1, class T2>
      value call( T1 t1, T2 t2 )
      {
	CAMLparam0();
	CAMLlocal2( p1, p2 );
	affectation_management<T1>::affect(p1, t1);
	affectation_management<T2>::affect(p2, t2);
	CAMLreturn( callback2( *callback_, p1, p2 ) );
      }

      template<class T1, class T2, class T3>
      value call( T1 t1, T2 t2, T3 t3 )
      {
	CAMLparam0();
	CAMLlocal3( p1, p2, p3 );
	affectation_management<T1>::affect(p1, t1);
	affectation_management<T2>::affect(p2, t2);
	affectation_management<T3>::affect(p3, t3);
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
	affectation_management<T>::affect( pN[I-1], tN);
	return callbackN( *callback_, I, pN );
      }

      template<class... OArgs, class T, int I>
      value call_helper( value pN[I], T tN, Args... args )
      {
	affectation_management<T>::affect(pN[ I-sizeof...(Args)-1 ], tN);
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
	conversion_management< Ret > cm;
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
  struct conversion_management< std::function< void(Args...) > >
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
	affectation_management< T>::affect(p1, t);
	CAMLreturn( callback( *callback_, p1 ) );
      }

      template<class T1, class T2>
      value call( T1 t1, T2 t2 )
      {
	CAMLparam0();
	CAMLlocal2( p1, p2 );
	affectation_management<T1>::affect(p1, t1);
	affectation_management<T2>::affect(p2, t2);

	CAMLreturn( callback2( *callback_, p1, p2 ) );
      }

      template<class T1, class T2, class T3>
      value call( T1 t1, T2 t2, T3 t3 )
      {
	CAMLparam0();
	CAMLlocal3( p1, p2, p3 );
	affectation_management<T1>::affect(p1, t1);
	affectation_management<T2>::affect(p2, t2);
	affectation_management<T3>::affect(p3, t3);
	CAMLreturn( callback3( *callback_, p1, p2, p3 ) );
      }

      template<class... OArgs>
      value call( OArgs&&... tN)
      {
	CAMLparam0();
	CAMLlocalN( pN, sizeof...(OArgs) );
	CAMLreturn( call_helper( pN, std::forward<OArgs>(tN)... ) );
      }

      template<class T, int I>
      value call_helper( value (&pN) [I], T tN )
      {
	affectation_management<T>::affect( pN[I-1], tN);

	return callbackN( *callback_, I, pN );
      }

      template<class... OArgs, class T, int I>
      value call_helper( value (&pN) [I], T tN, OArgs&&... args )
      {
	affectation_management<T>::affect(pN[ I-sizeof...(OArgs)-1 ], tN);
	return call_helper( pN, std::forward<OArgs>(args)...);
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
  struct conversion_management< std::function< void(Arg) > >
  {
    class CamlCallback
    {	
      std::shared_ptr<value> callback_;
    private:

      value call( Arg t )
      {
	CAMLparam0();
	CAMLlocal1( p1 );
	affectation_management<Arg>::affect(p1, t);
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
  struct conversion_management< std::function< void(Arg1, Arg2) > >
  {
    class CamlCallback
    {	
      std::shared_ptr<value> callback_;
    private:

      value call( Arg1 t1, Arg2 t2 )
      {
	CAMLparam0();
	CAMLlocal2( p1, p2 );
	affectation_management<Arg1>::affect(p1, t1);
	affectation_management<Arg2>::affect(p2, t2);
      
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

  template< class Arg1, class Arg2, class Arg3, class Arg4, class Arg5>
  struct conversion_management< std::function< void(Arg1, Arg2, Arg3, Arg4, Arg5) > >
  {
    class CamlCallback
    {	
      std::shared_ptr<value> callback_;
    private:

      value call( Arg1 t1, Arg2 t2,  Arg3 t3, Arg4 t4,  Arg5 t5 )
      {
	CAMLparam0();
	CAMLlocalN ( pN, 5 );

	affectation_management<Arg1>::affect(pN[0], t1);
	affectation_management<Arg2>::affect(pN[1], t2);
	affectation_management<Arg3>::affect(pN[2], t3);
	affectation_management<Arg4>::affect(pN[3], t4);
	affectation_management<Arg5>::affect(pN[4], t5);
      
	CAMLreturn( callbackN( *callback_, 5, pN ) );
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
      template<class T1, class T2, class T3, class T4, class T5>
      void operator()(T1&& arg1, T2&& arg2, T3&& arg3, T4&& arg4, T5&& arg5)
      {
	assert( callback_ );
	caml_acquire_runtime_system() ;
	call(std::forward<T1>(arg1), std::forward<T2>(arg2), std::forward<T3>(arg3), std::forward<T4>(arg4), std::forward<T5>(arg5));
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


}



#endif
