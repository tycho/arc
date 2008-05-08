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

#include "Network/packet.h"

#include <zlib.h>

Packet::Packet()
{
    m_bufferIndex = 0;
    m_serializedBuffer = NULL;
    m_size = m_serializedSize = -1;
}

Packet::Packet ( const char *_serializedData, size_t _dataLength )
{
    m_bufferIndex = 0;
    m_serializedBuffer = NULL;
    m_size = m_serializedSize = -1;

    m_serializedSize = (int)_dataLength;
    m_serializedBuffer = new char[_dataLength];
    memcpy ( m_serializedBuffer, _serializedData, _dataLength );

    // Now deserialize it.
    Deserialize();

}

Packet::~Packet()
{
    for ( size_t i = 0; i < m_buffer.size(); i++ )
    {
        if ( m_buffer.valid ( i ) )
        {
            delete m_buffer[i];
            m_buffer.remove ( i );
        }
    }
    CacheDamaged();
}

void Packet::CacheDamaged()
{
    m_size = -1;
    delete [] m_serializedBuffer;
    m_serializedBuffer = NULL;
}

void Packet::AddBufferData ( const void *_data, size_t _length )
{
    ARCReleaseAssert ( _data != NULL );
    ARCReleaseAssert ( _length > 0 );
    CacheDamaged();
    m_buffer.insert ( new DataBuffer ( _data, _length ) );
}

void Packet::AddBufferString ( const char *_string )
{
    ARCReleaseAssert ( _string != NULL );
    m_size = -1;
    CacheDamaged();
    m_buffer.insert ( new DataBuffer ( _string ) );
}

int Packet::GetBufferData ( void *_data, size_t _length ) const
{
    DataBuffer *buffer = m_buffer[m_bufferIndex++];
    if ( buffer->getSize() != _length )
        throw m_bufferIndex - 1;
    memcpy ( _data, buffer->getData(), _length );
    return 0;
}

int Packet::GetBufferString ( char *&_string, size_t &_length ) const
{
    DataBuffer *buffer = m_buffer[m_bufferIndex++];
    _length = buffer->getSize();
    if ( _length > 1024 )
        throw m_bufferIndex - 1;
    _string = new char[_length+1];
    strncpy ( _string, buffer->getData(), _length );
    _string[_length] = 0;
    return 0;
}

size_t Packet::Size() const
{
    // Is the size cached?
    if ( m_size != -1 ) return m_size;

    // Nope, let's iterate through and find the byte size.
    size_t totalSize = 0;
    for ( size_t i = 0; i < m_buffer.size(); i++ )
        if ( m_buffer.valid ( i ) )
            totalSize += m_buffer.get(i)->getSize();

    m_size = (int)totalSize;

    return totalSize;
}

size_t Packet::SerializedSize() const
{
    // Is the size cached?
    if ( m_serializedSize != -1 ) return m_serializedSize;

    // Nope, let's iterate through and find the byte size.
    size_t totalSize = 0;
    for ( size_t i = 0; i < m_buffer.size(); i++ )
    {
        if ( !m_buffer.valid ( i ) ) continue;
        DataBuffer *buffer = m_buffer.get(i);
        totalSize += buffer->getSize() + 2;
        if ( buffer->isString() ) totalSize--;
    }

    m_serializedSize = (int)totalSize + 5;

    return m_serializedSize;
}

void Packet::Deserialize ()
{
    short dataSize;
    char *ptr = m_serializedBuffer;
    while ( ptr - m_serializedBuffer < m_serializedSize )
    {
        memcpy ( &dataSize, ptr, sizeof ( dataSize ) );
        ARCReleaseAssert ( dataSize > 0 && dataSize < 16384 );
        ptr += sizeof ( dataSize );
        m_buffer.insert ( new DataBuffer ( ptr, dataSize ) );
        ptr += dataSize;
    }
}

void Packet::Serialize ( const char *&_data, size_t &_dataSize ) const
{

    _dataSize = SerializedSize();

    if ( m_serializedBuffer != NULL ) {
        _data = m_serializedBuffer;
        return;
    }

    m_serializedBuffer = new char[SerializedSize()];

    char *ptr = m_serializedBuffer;
    unsigned short dataSize;

    dataSize = SerializedSize() - 2;
    memcpy ( ptr, &dataSize, sizeof(dataSize) );
    ptr += sizeof(dataSize);

    for ( size_t i = 0; i < m_buffer.size(); i++ )
    {
        if ( !m_buffer.valid(i) ) continue;
        DataBuffer *buf = m_buffer.get(i);
        ARCReleaseAssert ( buf != NULL );
        ARCReleaseAssert ( buf->getData() != NULL );
        ARCReleaseAssert ( buf->getSize() > 0 );
        dataSize = (short)buf->getSize();
        if ( buf->isString() ) dataSize--;
        memcpy ( ptr, &dataSize, sizeof(dataSize) );
        ptr += sizeof(dataSize);
        memcpy ( ptr, buf->getData(), dataSize );
        ptr += dataSize;
    }

    unsigned char bufEnd = '\3';
    dataSize = 1;
    memcpy ( ptr, &dataSize, sizeof(dataSize) );
    ptr += sizeof(dataSize);
    memcpy ( ptr, &bufEnd, 1 );
    ptr += dataSize;

    _data = m_serializedBuffer;
}
