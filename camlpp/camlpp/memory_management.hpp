#ifndef MEMORY_MANAGEMENT_HPP_INCLUDED
#define MEMORY_MANAGEMENT_HPP_INCLUDED

extern "C"
{
	#include <caml/memory.h>
}

template<int N>
class MemoryManagement;

template<>
struct MemoryManagement<0> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a)
	{
		CAMLparam1( a );
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<1> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a)
	{
		CAMLparam1( a );
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};


template<>
struct MemoryManagement<2> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b)
	{
		CAMLparam2( a, b);
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<3> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b, value& c)
	{
		CAMLparam3( a, b, c);
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<4> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b, value& c, value& d)
	{
		CAMLparam4( a, b, c, d);
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<5> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b, value& c, value& d, value& e)
	{
		CAMLparam5( a, b, c, d, e);
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<6> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b, value& c, value& d, value& e, value& f)
	{
		CAMLparam5( a, b, c, d, e);
		CAMLxparam1( f );
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<7> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b, value& c, value& d, value& e, 
			 value& f, value& g)
	{
		CAMLparam5( a, b, c, d, e);
		CAMLxparam2( f, g );
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<8> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b, value& c, value& d, value& e, 
			 value& f, value& g, value& h)
	{
		CAMLparam5( a, b, c, d, e);
		CAMLxparam3( f, g, h );
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};

template<>
struct MemoryManagement<9> {
	caml__roots_block* caml_cpp__frame;
	MemoryManagement(value& a, value& b, value& c, value& d, value& e, 
			 value& f, value& g, value& h, value& i)
	{
		CAMLparam5( a, b, c, d, e);
		CAMLxparam4( f, g, h, i );
		caml_cpp__frame = caml__frame;
	}

	~MemoryManagement()
	{
		caml_local_roots = caml_cpp__frame;
	}
};
#endif


