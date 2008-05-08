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
    virtual Errors                Connect ( const char *_hostname, unsigned short _port ) = 0;
    virtual int                   Receive ( int *_packetCount ) = 0;
    virtual int                   Send ( const Packet *_buffer, bool _criticalData ) = 0;
    virtual Network::socketState  State () const = 0;
};

#include "Network/net_crisscross.h"
#include "Network/net_raknet.h"

#endif
