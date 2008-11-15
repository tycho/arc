/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "Network/net.h"

Net::Net()
{
}

Net::~Net()
{
}

Data::LList<Packet *> *Net::GetPackets()
{
    return &m_packets;
}
