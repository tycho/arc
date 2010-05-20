/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_connection_h
#define __included_connection_h

#ifdef ENABLE_NETWORKING

#include "Network/net.h"

typedef enum
{
    MSG_NULL = 0,
    MSG_LOGIN,
    MSG_PLAYERS,
    MSG_ADDPLAYER,            // OBSOLETE
    MSG_REMOVEPLAYER,
    MSG_GOTHEALTH,
    MSG_CONNECTED,
    MSG_SERVERMSG,
    MSG_GAMELOGIN,
    MSG_GAMEDATA,
    MSG_GAMECHAT,
    MSG_DIED,
    MSG_NULLPLAYER,
    MSG_POWERUP,
    MSG_TEAM,
    MSG_BOMB,
    MSG_MISS,
    MSG_LASER,
    MSG_MINES,
    MSG_GETFLAG,
    MSG_DROPFLAG,
    MSG_FLAGS,
    MSG_PLAYING,
    MSG_BOUNCY,
    MSG_GAMESETTINGS,
    MSG_PLAYERHOME,
    MSG_SCORE,
    MSG_MAP,
    MSG_PLAYERSCORE,
    MSG_ARMORLO,
    MSG_SWITCH,
    MSG_GETSWITCH,
    MSG_PSPEED,
    MSG_GAG,
    MSG_MAPTRANSFER,
    MSG_PING,
    MSG_UPDATE,
    MSG_NEWKEY,
    MSG_FORCEPOS,
    MSG_WEPSYNC,
    MSG_WARPING,
    MSG_UNIBALL,
    MSG_TIMELIMIT,
    MSG_ERROR,
    MSG_UDPOK,
    MSG_MODE,
    MSG_UDPSTOP,
    MSG_HEALTHFORCE,
    MSG_DEVCHEAT
} MessageType;

class Connection
{
public:
    Net *m_net;
    bool m_receivingMap;
    unsigned char m_mapTransferPercent;

private:
    System::Stopwatch m_updateTimer;

    double m_updateTimeout;
public:
    Connection();
    ~Connection();

    int Connect ( const char *_host, unsigned short _port );

    void SendDropFlag ();
    void SendGameChat ( const char *_chatText );
    void SendGameLogin ();
    void SendLogin ( const char *_nickname, const char *_password );
    void SendMapRequest ();
    void SendNewKey ( char _newKey );
    void SendPing ();
    void SendSwitchRequest ();
    void SendUpdateRequest ();

    void SendLaserFired ( short _lX, short _lY, short _charX, short _charY );
    void SendBouncyFired ( short _lX, short _lY, short _charX, short _charY );
    void SendMissileFired ( short _lX, short _lY, short _charX, short _charY );
    void SendGrenadeFired ( short _lX, short _lY, short _charX, short _charY );

    void SendNull ();
    void SendUpdate ();

    void Parse ( Packet *_packet );
    void ParsePackets ();
    int  Update ();
};

#endif
#endif
