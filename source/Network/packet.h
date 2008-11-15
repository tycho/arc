/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_packet_h
#define __included_packet_h

#include <crisscross/darray.h>

#include "App/databuffer.h"

class Packet
{
private:
    // TODO: Make this one long char array. This method's too slow.
    CrissCross::Data::DArray<DataBuffer *> m_buffer;
    mutable int m_bufferIndex;
    mutable int m_size;
    mutable int m_serializedSize;
    mutable char *m_serializedBuffer;

    inline void CacheDamaged ();
    void Deserialize ();

public:
    Packet();
    Packet ( const char *_serializedData, size_t _dataLength ); // Deserializes a stream of data.
    ~Packet();

    void AddBufferData ( const void *_data, size_t _length );
    void AddBufferString ( const char *_string );
    int GetBufferData ( void *_data, size_t _length ) const;
    int GetBufferString ( char *&_string, size_t &_length ) const;

    void Serialize ( const char *&_data, size_t &_dataSize ) const;
    inline size_t SerializedSize () const;
    inline size_t Size () const;

};

#endif
