/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_net_crisscross_h
#define __included_net_crisscross_h

#include "Network/net.h"
#include "Network/packet.h"

#ifdef USE_CRISSCROSS_NET

class Net_CrissCross : public Net
{
protected:
    bool m_udpDisabled;

    CrissCross::Network::TCPSocket *m_tcpSocket;
    CrissCross::Network::UDPSocket *m_udpSocket_out;
    CrissCross::Network::UDPSocket *m_udpSocket_in;

    virtual int ReceiveTCP ( int *_packetCount );
    virtual int ReceiveUDP ( int *_packetCount );

public:
    Net_CrissCross();
    virtual ~Net_CrissCross();

    virtual void                  DisableUDP();
    virtual int                   Connect ( const char *_hostname, unsigned short _port );
    virtual int                   Receive ( int *_packetCount );
    virtual int                   Send ( const Packet *_buffer, bool _criticalData );
    virtual Network::socketState  State () const;
};

#endif

#endif
