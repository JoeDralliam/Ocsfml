/*
 * =====================================================================================
 *
 *       Filename:  test.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  28/10/2011 15:40:44
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include <iostream>
#include <future>
#include <camlpp/stub_generator.hpp>
#include <camlpp/memory_management.hpp>
#include <camlpp/std/function.hpp>

extern "C"
{
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/threads.h>
}


#undef flush

#include <SFML/System/Thread.hpp>

std::function<void()>& gF()
{
  static std::function<void()> impl;
  return impl;
}

std::unique_ptr<sf::Thread>& t()
{
  static std::unique_ptr<sf::Thread> impl;
  return impl;
}


void fil(std::function<void()> f)
{
  if(!caml_c_thread_register()) {
    std::cout << "Could not register thread" << std::endl;
  }
  else {
    std::cout << "\nOk" << std::endl;
  }

  f();


  if(!caml_c_thread_unregister()) {
    std::cout << "Could not unregister thread" << std::endl;
  }

}

void test1(std::function<void()> f)
{
  f() ;
}

void test2(std::function<void()> f)
{
  t().reset(new sf::Thread(fil, f));
  t()->launch();
}

void test2bis()
{
  caml_release_runtime_system() ;
  t()->wait();
  t().reset();
  caml_acquire_runtime_system() ;
}

extern "C"
{
  camlpp__register_free_function1( test1, 0);
  camlpp__register_free_function1( test2, 0);
  camlpp__register_free_function0( test2bis, 0);
}

/*
  extern "C"
  {
  value test3(value unit)
  {
  CAMLparam1(unit);
  //    t.reset(new std::thread(fil));
  pthread_create( &pTh, 0, &fil, 0); 
  CAMLreturn( Val_unit );
  }
  }

*/
