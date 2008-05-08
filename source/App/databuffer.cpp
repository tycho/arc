/*
 *                           ARC++
 *
 *    Copyright (c) 2007-2008 Steven Noonan. All rights reserved.
 *
 *    NO PART OF THIS PROGRAM OR PUBLICATION MAY BE REPRODUCED,
 *    TRANSMITTED, TRANSCRIBED, STORED IN A RETRIEVAL SYSTEM, OR
 *    TRANSLATED INTO ANY LANGUAGE OR COMPUTER LANGUAGE IN ANY
 *    FORM OR BY ANY MEANS, ELECTRONIC, MECHANICAL, MAGNETIC,
 *    OPTICAL, CHEMICAL, MANUAL, OR OTHERWISE, WITHOUT THE PRIOR
 *    WRITTEN PERMISSION OF:
 *
 *                       STEVEN NOONAN
 *                       4727 BLUFF DR.
 *                 MOSES LAKE, WA 98837-9075
 *
 *    THIS SOURCE CODE IS NOT FOR PUBLIC INSPECTION.
 *    The above copyright notice does not indicate any
 *    actual or intended publication of this source code.
 *
 */

#include "universal_include.h"
#include "App/databuffer.h"

#ifndef stricmp
#define stricmp strcasecmp
#endif

using namespace CrissCross::Data;

DataBuffer::DataBuffer() :
    m_isString(false),
    m_buffer ( NULL ),
    m_size ( -1 )
{
}

DataBuffer::DataBuffer ( size_t _initialCapacity ) :
    m_isString(false),
    m_buffer ( NULL ),
    m_size ( -1 )
{
    setSize ( _initialCapacity );
}

DataBuffer::DataBuffer ( const char *_initialString ) :
    m_isString(false),
    m_buffer ( NULL ),
    m_size ( -1 )
{
    setDataString ( _initialString );
}


DataBuffer::DataBuffer ( const void *_initialData, size_t _size ) :
    m_isString(false),
    m_buffer ( NULL ),
    m_size ( -1 )
{
    setData ( _initialData, _size );
}

DataBuffer::DataBuffer ( const DataBuffer &_initialData ) :
    m_isString(false),
    m_buffer ( NULL ),
    m_size ( -1 )
{
    setData ( _initialData.getData(), _initialData.getSize() );
}

DataBuffer::~DataBuffer ()
{
    if ( m_buffer )
    {
        free ( m_buffer );
        m_buffer = NULL;
    }
    m_size = -1;
}

void DataBuffer::resize ( size_t _capacity )
{
    if ( !m_buffer )
    {
        setSize ( _capacity );
        return;
    }
    
    char *newBuffer = (char *)malloc(_capacity);
    memcpy ( newBuffer, m_buffer, m_size );
    free ( m_buffer );
    m_buffer = newBuffer;
    m_size = _capacity;
    
}

void DataBuffer::setSize ( size_t _capacity )
{
    if ( m_buffer ) { free ( m_buffer ); m_buffer = NULL; }
    m_size = _capacity;
    m_buffer = (char *)calloc ( m_size, 1 );
    memset ( m_buffer, 0, m_size );
}

int DataBuffer::setData ( const void *_data, size_t _size )
{
    setSize ( _size );
    memcpy ( m_buffer, _data, _size );
    return 0;
}

int DataBuffer::setDataString ( const char *_data )
{
    setSize ( strlen ( _data ) + 1 );
    m_isString = true;
    strcpy ( m_buffer, _data );
    return 0;
}

bool DataBuffer::isString() const
{
    return m_isString;
}

size_t DataBuffer::getSize () const
{
    return m_size;
}

const char *DataBuffer::getData () const
{
    return m_buffer;
}

DataBuffer &DataBuffer::operator= ( const DataBuffer &_buffer )
{
    if ( &_buffer == this ) return *this;
    setData ( _buffer.getData(), _buffer.getSize() );
    return *this;
}

bool DataBuffer::operator> ( const DataBuffer &_buffer ) const
{
    if ( &_buffer == this ) return false;
    return stricmp ( m_buffer, _buffer.getData() ) > 0;
}

bool DataBuffer::operator>= ( const DataBuffer &_buffer ) const
{
    if ( &_buffer == this ) return true;
    return stricmp ( m_buffer, _buffer.getData() ) >= 0;
}

bool DataBuffer::operator< ( const DataBuffer &_buffer ) const
{
    if ( &_buffer == this ) return false;
    return stricmp ( m_buffer, _buffer.getData() ) < 0;
}

bool DataBuffer::operator<= ( const DataBuffer &_buffer ) const
{
    if ( &_buffer == this ) return true;
    return stricmp ( m_buffer, _buffer.getData() ) <= 0;
}

bool DataBuffer::operator== ( const DataBuffer &_buffer ) const
{
    if ( &_buffer == this ) return true;
    return stricmp ( m_buffer, _buffer.getData() ) == 0;
}

bool DataBuffer::operator!= ( const DataBuffer &_buffer ) const
{
    if ( &_buffer == this ) return false;
    return stricmp ( m_buffer, _buffer.getData() ) != 0;
}
