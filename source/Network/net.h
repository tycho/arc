/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_net_h
#define __included_net_h

#include "Network/packet.h"

#define NET_BUFFER_SIZE 16384

class Net
{
protected:
    Data::LList<Packet *> m_packets;

public:
    Net();
    virtual ~Net();

    Data::LList<Packet *> *GetPackets();

    virtual void                  DisableUDP() = 0;
    virtual int                   Connect ( const char *_hostname, unsigned short _port ) = 0;
    virtual int                   Receive ( int *_packetCount ) = 0;
    virtual int                   Send ( const Packet *_buffer, bool _criticalData ) = 0;
    virtual Network::socketState  State () const = 0;
};

#include "Network/net_crisscross.h"
#include "Network/net_raknet.h"

#endif
