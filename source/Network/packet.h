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
