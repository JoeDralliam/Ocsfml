/*
 * =====================================================================================
 *
 *       Filename:  channel_streambuf_interface.hpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  28/10/2011 12:08:54
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef CHANNEL_STREAMBUF_INTERFACE
#define CHANNEL_STREAMBUF_INTERFACE

extern "C"
{
#include "caml/io.h"
}
#include <streambuf>


class ChannelStreambufInterface : public std::basic_streambuf< char >
{
	channel* camlChannel_;
	std::ios_base::openmode mode_;
protected:
	virtual pos_type seekoff (off_type off, std::ios_base::seekdir way, std::ios_base::openmode which )
	{
		bool inputMode = (mode_ & which & std::ios_base::in);
		bool outputMode = (mode_ & which & std::ios_base::out);
		assert( !(inputMode && outputMode) );

		if( inputMode )
		{
			off_type pos;
			if( way == std::ios_base::beg )
			{
				pos = off;
			}
			else if( way == std::ios_base::cur )
			{
				pos = caml_pos_in( camlChannel_ ) + off;
			}
			else
			{
				assert( way == std::ios_base::end );
				pos = caml_channel_size( camlChannel_ ) + off;
			}
			caml_seek_in( camlChannel_, pos );
		}
		else
		{
			assert( outputMode );
			off_type pos;
			if( way == std::ios_base::beg )
			{
				pos = off;
			}
			else if( way == std::ios_base::cur )
			{
				pos = caml_pos_out( camlChannel_ ) + off;
			}
			else
			{
				assert( way == std::ios_base::end );
				pos = caml_channel_size( camlChannel_ ) + off;
			}
			caml_seek_out( camlChannel_, pos );
		}
	}

	virtual int sync ( )
	{
		caml_flush( camlChannel_ );
		return 0;
	}

/*  
	streamsize showmanyc ( )
	{

	}
*/

	virtual std::streamsize xsgetn( char_type* s, std::streamsize n )
	{
		return caml_getblock( camlChannel_, s, n );
	}

	virtual std::streamsize xsputn (const char_type * s, std::streamsize n)
	{
		return caml_putblock( camlChannel_, const_cast<char*>(s), n );
	}

	virtual int overflow( int c )
	{
		if( c != EOF )
		{
			char ch = static_cast<char>(c);
			putch( camlChannel_, ch );
		}
		return c;
	}

	virtual int_type uflow( )
	{
		return getch( camlChannel_);
	}

	virtual int_type underflow( )
	{
		int_type res( uflow() );
		camlChannel_->curr--;
		return res;
	}
public:
	ChannelStreambufInterface( channel* channel, std::ios_base::openmode mode )
	:camlChannel_( channel ), mode_(mode)
	{}

};

template<>
class ConversionManagement< std::ostream& >
{
	std::unique_ptr< ChannelStreambufInterface > streambuf_;
	std::unique_ptr< std::ostream > os_;
public:
	std::ostream& from_value( value const& v )
	{
		streambuf_.reset(new ChannelStreambufInterface( Channel( v ), std::ios_base::out) );
		os_.reset(new std::ostream( streambuf_.get() ) );
		return *os_;
	}
};


template<>
class ConversionManagement< std::istream& >
{
	std::unique_ptr< ChannelStreambufInterface > streambuf_;
	std::unique_ptr< std::istream > is_;
public:
	std::istream& from_value( value const& v )
	{
		streambuf_.reset(new ChannelStreambufInterface( Channel( v ), std::ios_base::in) );
		is_.reset(new std::istream( streambuf_.get() ) );
		return *is_;
	}
};

#endif
