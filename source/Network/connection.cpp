/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#ifdef ENABLE_NETWORKING

#include "App/app.h"
#include "Game/game.h"
#include "Interface/interface.h"
#include "Interface/loading_window.h"
#include "Network/net.h"
#include "Network/packet.h"
#include "Network/connection.h"
#include "Sound/soundsystem.h"

Connection::Connection()
    : m_receivingMap(false), m_mapTransferPercent(0)
{
#if defined ( USE_CRISSCROSS_NET )
    m_net = new Net_CrissCross();
#elif defined ( USE_RAKNET );
    m_net = new Net_RakNet();
#else
#    error    No networking engine defined.
#endif
}

Connection::~Connection()
{
    delete m_net; m_net = NULL;
}

int Connection::Connect ( const char *_host, unsigned short _port )
{
    static System::Stopwatch sw;
    int retval;
    ARCReleaseAssert ( _host != NULL ); ARCReleaseAssert ( _port > 1024 );
    retval = m_net->Connect ( _host, _port );
    if ( retval != CC_ERR_NONE )
    {
        sw.Stop();
        if ( sw.Elapsed() > 10.0 )
            return CC_ERR_TIMED_OUT;
        else
            return retval;
    }
    m_updateTimer.Start();
    m_updateTimeout = -1.0;
    return 0;
}

void Connection::SendLogin ( const char *_nickname, const char *_password )
{
    static int sendCount = 0;

    ARCReleaseAssert ( _nickname != NULL );
    Packet *packet = new Packet();

    char messageType = MSG_LOGIN;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    short clientVersion = PROTOCOL_VERSION;
    packet->AddBufferData ( &clientVersion, sizeof(clientVersion) );

    // TODO: Implement a unique identifier for this.
    unsigned int driveSerial = 31337;
    packet->AddBufferData ( &driveSerial, sizeof(driveSerial) );

    if ( _password == NULL )
    {
        packet->AddBufferString ( "" );
    }
    else
    {
        packet->AddBufferString ( _password );
    }

    packet->AddBufferString ( _nickname );

    if ( sendCount > 3 ) m_net->DisableUDP();
    m_net->Send ( packet, false );
    sendCount++;

    delete packet;
}

void Connection::SendMapRequest ()
{
    Packet *packet = new Packet();

    char messageType = MSG_MAP;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    m_net->Send ( packet, false );

    delete packet;
}

void Connection::SendGameLogin ()
{
    Packet *packet = new Packet();

    char messageType = MSG_GAMELOGIN;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    int mapFileSize = Map::GetFileSize ( g_game->GetMapName() ),
        mapVersion =  Map::GetMapVersion ( g_game->GetMapName() );
    packet->AddBufferData ( &mapVersion, sizeof(mapVersion) );
    packet->AddBufferData ( &mapFileSize, sizeof(mapFileSize) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendGameChat ( const char *_chatText )
{
    Packet *packet = new Packet();

    char messageType = MSG_GAMECHAT;
    packet->AddBufferData ( &messageType, sizeof(messageType) );
    packet->AddBufferString ( _chatText );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendUpdateRequest()
{
    Packet *packet = new Packet();

    char messageType = MSG_UPDATE;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendSwitchRequest()
{
    Packet *packet = new Packet();

    char messageType = MSG_GETSWITCH;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendPing()
{
    Packet *packet = new Packet();

    char messageType = MSG_PING;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    m_net->Send ( packet, false );

    delete packet;
}

void Connection::SendDropFlag()
{
    Packet *packet = new Packet();

    char messageType = MSG_DROPFLAG;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendNewKey ( char _newKey )
{
    Packet *packet = new Packet();

    char messageType = MSG_NEWKEY;
    packet->AddBufferData ( &messageType, sizeof(messageType) );
    packet->AddBufferData ( &_newKey, sizeof(_newKey) );

    m_net->Send ( packet, false );

    delete packet;
}

void Connection::SendLaserFired ( short _lX, short _lY, short _charX, short _charY )
{
    Packet *packet = new Packet();

    char messageType = MSG_LASER;
    packet->AddBufferData ( &messageType, sizeof(messageType) );
    packet->AddBufferData ( &_lX, sizeof(_lX) );
    packet->AddBufferData ( &_lY, sizeof(_lY) );
    packet->AddBufferData ( &_charX, sizeof(_charX) );
    packet->AddBufferData ( &_charY, sizeof(_charY) );

    m_net->Send ( packet, false );

    delete packet;
}

void Connection::SendBouncyFired ( short _lX, short _lY, short _charX, short _charY )
{
    Packet *packet = new Packet();

    char messageType = MSG_BOUNCY;
    packet->AddBufferData ( &messageType, sizeof(messageType) );
    packet->AddBufferData ( &_lX, sizeof(_lX) );
    packet->AddBufferData ( &_lY, sizeof(_lY) );
    packet->AddBufferData ( &_charX, sizeof(_charX) );
    packet->AddBufferData ( &_charY, sizeof(_charY) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendMissileFired ( short _lX, short _lY, short _charX, short _charY )
{
    Packet *packet = new Packet();

    char messageType = MSG_MISS;
    packet->AddBufferData ( &messageType, sizeof(messageType) );
    packet->AddBufferData ( &_lX, sizeof(_lX) );
    packet->AddBufferData ( &_lY, sizeof(_lY) );
    packet->AddBufferData ( &_charX, sizeof(_charX) );
    packet->AddBufferData ( &_charY, sizeof(_charY) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendGrenadeFired ( short _lX, short _lY, short _charX, short _charY )
{
    Packet *packet = new Packet();

    char messageType = MSG_BOMB;
    packet->AddBufferData ( &messageType, sizeof(messageType) );
    packet->AddBufferData ( &_lX, sizeof(_lX) );
    packet->AddBufferData ( &_lY, sizeof(_lY) );
    packet->AddBufferData ( &_charX, sizeof(_charX) );
    packet->AddBufferData ( &_charY, sizeof(_charY) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendNull()
{
    Packet *packet = new Packet();

    char messageType = MSG_NULL;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    m_net->Send ( packet, true );

    delete packet;
}

void Connection::SendUpdate()
{
    if ( !g_game->Playing() ) return;

    Packet *packet = new Packet();

    char messageType = MSG_GAMEDATA;
    packet->AddBufferData ( &messageType, sizeof(messageType) );

    char key = g_game->m_me->GetKey();
    short X = (short)g_game->m_me->GetX(),
          Y = (short)g_game->m_me->GetY();

    packet->AddBufferData ( &key, sizeof ( key ) );
    packet->AddBufferData ( &X, sizeof ( X ) );
    packet->AddBufferData ( &Y, sizeof ( Y ) );

    m_net->Send ( packet, false );

    delete packet;
}

void Connection::Parse ( Packet *_packet )
{
    static int invalidPacketCount = 0;
    char *tempStr = NULL; size_t tempLength;
    char packetID = 0;
    _packet->GetBufferData ( &packetID, sizeof ( packetID ) );

#ifndef _DEBUG
    try
    {
#endif
        switch ( packetID )
        {
        case MSG_NULL:
            g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "WARNING: NULL packet received." );
            g_console->SetColour ();
            break;
        case MSG_LOGIN:
    #ifdef DEBUG_LOGIN_PROCESS
            g_console->WriteLine ( "MSG_LOGIN received." );
    #endif
            g_game->SetLoadState ( LOAD_STATE_REQUEST_MAP );
            break;
        //case MSG_POWERUP:
            // TODO: Implement powerups.
        //    break;
        case MSG_MAPTRANSFER:
            {
                static FILE *file = NULL;
                static int receivedBytes = 0, mapSize = 0;
                int temp, writeBytes;
                if ( !m_receivingMap )
                {
                    _packet->GetBufferData ( &mapSize, sizeof(mapSize) );
                    ARCReleaseAssert ( mapSize > 0 && mapSize < 16384 );
                    char buffer[2048];
                    sprintf ( buffer, "%s/maps/", g_app->GetApplicationSupportPath() );
                    g_app->CreateDirectory ( buffer );
                    strcat ( buffer, g_game->GetMapName() );
                    file = fopen ( buffer, "wb" );
                    m_mapTransferPercent = 0;
                    m_receivingMap = true;
                    break;
                }
                ARCReleaseAssert ( file );
                writeBytes = 4;
                for ( int i = 0; i <= 100; i++ )
                {
                    _packet->GetBufferData ( &temp, sizeof ( temp ) );
                    if ( receivedBytes > mapSize - 3 )
                        writeBytes = mapSize - receivedBytes + 1;
                    size_t ret = fwrite ( &temp, 1, writeBytes, file );
                    receivedBytes += 4;
                    ARCReleaseAssert ( ret == writeBytes );
                    if ( receivedBytes > mapSize )
                        break;
                }
                m_mapTransferPercent = (int)((double)receivedBytes / (double)mapSize * 100.0);
                if ( receivedBytes > mapSize )
                {
                    fclose ( file );

                    // TODO: Find a more elegant solution for this...
                    g_game->SetLoadState ( LOAD_STATE_LOADMAP_MSG );

                    receivedBytes = mapSize = 0;
                    m_mapTransferPercent = 100;
                    m_receivingMap = false;
                }
            }
            break;
        case MSG_MAP:
            if ( strlen ( g_game->GetMapName() ) )
            {
                g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
                g_console->WriteLine ( "MSG_MAP ignored (duplicated)." );
                g_console->SetColour ();
                break;
            }
    #ifdef DEBUG_LOGIN_PROCESS
            g_console->WriteLine ( "MSG_MAP received." );
    #endif
            {
                _packet->GetBufferString ( tempStr, tempLength );
                g_console->WriteLine ( "Server Map: %s", tempStr );
                g_game->SetMapName ( tempStr );
                delete [] tempStr; tempStr = NULL;
                g_game->SetLoadState ( LOAD_STATE_SEND_GAMELOGIN );
            }
            break;
        case MSG_GAMELOGIN:
    #ifdef DEBUG_LOGIN_PROCESS
            g_console->WriteLine ( "MSG_GAMELOGIN received." );
    #endif
            g_game->SetLoadState ( LOAD_STATE_LOADMAP_MSG );
            break;
        case MSG_DEVCHEAT:
            {
                char who, cheat;
                _packet->GetBufferData ( &who, sizeof ( who ) );
                _packet->GetBufferData ( &cheat, sizeof ( cheat ) );

                ARCReleaseAssert ( g_game->GetPlayers()->valid ( who ) );
                Player *player = g_game->GetPlayers()->get ( who );
                ARCReleaseAssert ( player );

                player->m_cheat = cheat;
                g_console->WriteLine ( "Player '%s' is using cheat %d", player->m_nick, player->m_cheat );
            }
            break;
        case MSG_REMOVEPLAYER:
            {
                char index;
                _packet->GetBufferData ( &index, sizeof ( index ) );
                if ( !g_game->GetPlayers()->valid ( index ) ) break;
                Player *player = g_game->GetPlayers()->get ( index );
                if ( player == g_game->m_me ) break;
                g_console->WriteLine ( "Player '%s' is leaving the game...", player->m_nick );
                g_game->RemovePlayer ( index );
            }
            break;
        case MSG_PLAYERS:
            {
    #ifdef DEBUG_LOGIN_PROCESS
                g_console->WriteLine ( "MSG_PLAYERS received." );
    #endif
                char index, ship, admin, cheat;
                short score;
                _packet->GetBufferData ( &index, sizeof ( index ) );
                _packet->GetBufferString ( tempStr, tempLength );
                _packet->GetBufferData ( &ship, sizeof ( ship ) );
                _packet->GetBufferData ( &score, sizeof ( score ) );
                _packet->GetBufferData ( &admin, sizeof ( admin ) );
                _packet->GetBufferData ( &cheat, sizeof ( cheat ) );
                if ( g_game->GetPlayers()->valid ( index ) ) {
                    delete [] tempStr; tempStr = NULL;
                    break;
                }
                g_console->WriteLine ( "Player '%s' is joining the game...", tempStr );
                Player *newplayer =
                    new Player ( tempStr, (ShipType)ship, score,
                                 admin, cheat );
                delete [] tempStr; tempStr = NULL;
                g_game->AddPlayer ( newplayer, index );
                if ( ship == 10 )
                    newplayer->SetVisibility ( false );
            }
            break;
        case MSG_GAMEDATA:
            {
                Data::DArray<Player *> *playerArray = g_game->GetPlayers();
                char players;
                char playerIndex, key; short X, Y;
                _packet->GetBufferData ( &players, sizeof ( players ) );
                for ( char sc = 0; sc < players; sc++ )
                {
                    _packet->GetBufferData ( &playerIndex, sizeof ( playerIndex ) );
                    _packet->GetBufferData ( &key, sizeof ( key ) );
                    _packet->GetBufferData ( &X, sizeof ( X ) );
                    _packet->GetBufferData ( &Y, sizeof ( Y ) );
                    if ( !playerArray->valid ( playerIndex ) ) continue;
                    Player *p = playerArray->get(playerIndex);
                    if ( p != g_game->m_me )
                    {
                        if ( !p->Visible() ) {
                            p->SetDirection ( MOVE_NONE );
                        } else {
                            p->SetDirection ( (MovementDirections)key );
                        }

                        p->m_lastPositionUpdate.Stop();
                        float xMoveTo = ( X + p->GetX() ) / 2,
                              yMoveTo = ( Y + p->GetY() ) / 2;

                        float xDifference = fabs((float)X - p->GetX()),
                              yDifference = fabs((float)Y - p->GetY());

                        if ( p->m_lastPositionUpdate.Elapsed() > 0.25 )
                        {
                            p->SetPosition ( (int)xMoveTo, (int)yMoveTo );

                            g_console->WriteLine ( "Player %s moved to %6.2f, %6.2f (act: %4d, %4d) (diff: %4.2f, %4.2f)",
                                p->m_nick, xMoveTo, yMoveTo, X, Y, xDifference, yDifference );

                            p->m_lastPositionUpdate.Start();
                        }

                        if ( p->m_lastPositionUpdate.Elapsed() > 2.0 || xDifference > 16.0f || yDifference > 16.0f )
                        {
                            g_console->WriteLine ( "Player %s position forcibly corrected.", p->m_nick );
                            p->SetPosition ( X, Y );
                            p->m_lastPositionUpdate.Start();
                        }
                    }
                }
            }
            break;
        case MSG_DIED:
            {
                char who; short weapon, index;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &weapon, sizeof(weapon) );
                _packet->GetBufferData ( &index, sizeof(index) );
                if ( !g_game->Playing() ) break;
                if ( !g_game->GetPlayers()->valid ( who ) ) break;
                Player *player = g_game->GetPlayers()->get ( who );
                ARCReleaseAssert ( player );
                if ( player == g_game->m_me && !player->Visible() ) break;

                player->SetDirection ( MOVE_NONE );
                player->SetVisibility ( false );

                player->GetShip()->Pop();

                // TODO: Destroy the weapon instance that killed this player.

            }
            break;
        case MSG_GOTHEALTH:
            {
                if ( !g_game->m_me->Visible() ) break;
                g_game->m_health += 15;
                if ( g_game->m_health > 60 )
                    g_game->m_health = 60;
                if ( g_game->m_health > 17 )
                    g_game->m_me->SetArmorCritical ( false );
            }
            break;
        case MSG_HEALTHFORCE:
            {
                short newHealth;
                _packet->GetBufferData ( &newHealth, sizeof(newHealth) );
                g_game->m_health = newHealth;
            }
            break;
        case MSG_PLAYERSCORE:
            //g_console->WriteLine ( "MSG_PLAYERSCORE received." );
            {
                char who;
                short score;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &score, sizeof(score) );
                if ( !g_game->Playing() ) break;
                ARCReleaseAssert ( g_game->GetPlayers()->valid ( who ) );
                Player *player = g_game->GetPlayers()->get ( who );
                ARCReleaseAssert ( player );
                player->SetScore ( score );
                g_console->WriteLine ( "%s's score is now %d.", player->m_nick, score );
            }
            break;
        case MSG_ARMORLO:
            g_console->WriteLine ( "MSG_ARMORLO received." );
            {
                char who, crit;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &crit, sizeof(crit) );
                if ( !g_game->Playing() ) break;
                if ( !g_game->GetPlayers()->valid ( who ) ) break;
                Player *player = g_game->GetPlayers()->get ( who );
                ARCReleaseAssert ( player );
                if ( player == g_game->m_me && !player->GetArmorCritical() && crit != 0 )
                    g_soundSystem->PlaySound ( "armorlo", 0, 0 );
                player->SetArmorCritical ( crit != 0 );
            }
            break;
        case MSG_SCORE:
            //g_console->WriteLine ( "MSG_SCORE received." );
            {
                short team, score;
                _packet->GetBufferData ( &team, sizeof (team) );
                _packet->GetBufferData ( &score, sizeof (score) );
                g_game->SetTeamScore ( (ShipType)team, score );
            }
            break;
        case MSG_GAMESETTINGS:
    #ifdef DEBUG_LOGIN_PROCESS
            g_console->WriteLine ( "MSG_GAMESETTINGS received." );
    #endif
            {
                char c;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->SetLaserDamage ( c );
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->SetSpecialDamage ( c );
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->SetRechargeRate ( c );
                _packet->GetBufferData ( &c, sizeof(c) ); // TODO: Remove this later (mines).
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->SetHoldTime ( c );
            }
            break;
        case MSG_PSPEED:
    #ifdef DEBUG_LOGIN_PROCESS
            g_console->WriteLine ( "MSG_PSPEED received." );
    #endif
            {
                short speed;
                _packet->GetBufferData ( &speed, sizeof(speed) );
                m_updateTimeout = (double)speed / 1000.0;
            }
            break;
        case MSG_MODE:
            g_console->WriteLine ( "MSG_MODE received." );
            {
                char i, m;
                _packet->GetBufferData ( &i, sizeof(i) );
                _packet->GetBufferData ( &m, sizeof(m) );
                Player *player = g_game->GetPlayers()->get ( i );
                if ( m == 1 )
                    player->SetVisibility ( false );
                player->SetMode ( m );
            }
            break;
        case MSG_CONNECTED:
    #ifdef DEBUG_LOGIN_PROCESS
            g_console->WriteLine ( "MSG_CONNECTED received." );
    #endif
            {
                char c;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->SetMyIndex ( c );
                g_game->SetLoadState ( LOAD_STATE_SYNCHRONIZING );
            }
            break;
        case MSG_GAMECHAT:
            g_console->WriteLine ( "MSG_GAMECHAT received." );
            {
                char *string = NULL; size_t strlen;
                _packet->GetBufferString ( string, strlen );
                g_interface->AddChat ( string );
                delete [] string;
                string = NULL;
            }
            break;
        case MSG_WEPSYNC:
            //g_console->WriteLine ( "MSG_WEPSYNC received." );
            {
                // TODO: Implement recharge sounds.
                char c; short s;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->m_missileAmmo = c;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->m_grenadeAmmo = c;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->m_bounceAmmo = c;

                _packet->GetBufferData ( &c, sizeof(c) ); // TODO: Remove.

                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->m_missileCharge = c;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->m_grenadeCharge = c;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->m_bounceCharge = c;
                _packet->GetBufferData ( &c, sizeof(c) );
                g_game->m_laserCharge = c;
                _packet->GetBufferData ( &s, sizeof(s) );
                g_game->SetPing ( s );

                SendPing ();
            }
            break;
        case MSG_TEAM:
            //g_console->WriteLine ( "MSG_TEAM received." );
            {
                char who, team;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &team, sizeof(team) );
                if ( !g_game->Playing() ) break;

                ARCReleaseAssert ( g_game->GetPlayers()->valid ( who ) );
                Player *player = g_game->GetPlayers()->get ( who );
                ARCReleaseAssert ( player );

                player->SetDirection ( MOVE_NONE );
                if ( player->Visible() && player->GetMode() != 1 )
                {
                    player->SetVisibility ( false );
                    player->GetShip()->Pop();
                }
                player->SetTeam ( (ShipType)team );

            }
            break;
        case MSG_NEWKEY:
            {
                char who, key;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &key, sizeof(key) );
                if ( !g_game->Playing() ) break;
                ARCReleaseAssert ( g_game->GetPlayers()->valid ( who ) );
                Player *player = g_game->GetPlayers()->get ( who );
                ARCReleaseAssert ( player );
                if ( player != g_game->m_me )
                    player->SetDirection ( (MovementDirections)key );
            }
            break;
        case MSG_DROPFLAG:
            g_console->WriteLine ( "MSG_DROPFLAG received." );
            {
                char who, color, dropreason, flagnum;
                short x, y, newX, newY;
                _packet->GetBufferData ( &dropreason, sizeof(dropreason) );
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &color, sizeof(color) );
                _packet->GetBufferData ( &flagnum, sizeof(flagnum) );
                _packet->GetBufferData ( &newX, sizeof(newX) );
                _packet->GetBufferData ( &newY, sizeof(newY) );

                if ( !g_game->Playing() ) break;

                Map *map = g_game->GetMap();
                ARCReleaseAssert ( map );
                switch ( color )
                {
                case 1:
                    x = map->m_flagPosition1[0][flagnum];
                    y = map->m_flagPosition1[1][flagnum];
                    break;
                case 2:
                    x = map->m_flagPosition2[0][flagnum];
                    y = map->m_flagPosition2[1][flagnum];
                    break;
                case 3:
                    x = map->m_flagPosition3[0][flagnum];
                    y = map->m_flagPosition3[1][flagnum];
                    break;
                case 4:
                    x = map->m_flagPosition4[0][flagnum];
                    y = map->m_flagPosition4[1][flagnum];
                    break;
                case 5:
                    x = map->m_flagPosition5[0][flagnum];
                    y = map->m_flagPosition5[1][flagnum];
                    break;
                }
                if ( x % 16 == 0 && y % 16 == 0 )
                {
                    x /= 16;
                    y /= 16;
                    switch ( color )
                    {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                        if ( map->m_animations[y][x] == 27 + color )
                            map->m_animations[y][x] = 23 + color;
                        if ( map->m_animations[y][x] == 35 + color )
                            map->m_animations[y][x] = 31 + color;
                        if ( map->m_animations[y][x] == 43 + color )
                            map->m_animations[y][x] = 39 + color;
                        if ( map->m_animations[y][x] == 61 + color )
                            map->m_animations[y][x] = 57 + color;
                        break;
                    case 5:
                        if ( map->m_animations[y][x] == 132 )
                            map->m_animations[y][x] = 128;
                        if ( map->m_animations[y][x] == 133 )
                            map->m_animations[y][x] = 129;
                        if ( map->m_animations[y][x] == 134 )
                            map->m_animations[y][x] = 130;
                        if ( map->m_animations[y][x] == 135 )
                            map->m_animations[y][x] = 131;
                        if ( map->m_animations[y][x] == 140 )
                            map->m_animations[y][x] = 136;
                        break;
                    }
                }
                x = newX;
                y = newY;

                ARCReleaseAssert ( g_game->GetPlayers()->valid ( who ) );
                Player *player = g_game->GetPlayers()->get ( who );
                ARCReleaseAssert ( player );

                // TODO: Verify the distance measurement here.
                if ( dropreason != 2 )
                    g_soundSystem->PlaySound ( "dropflag",
                    (short)g_game->m_me->m_charX - x,
                    (short)g_game->m_me->m_charY - y );

                if ( dropreason == 2 )
                {
                    x /= 16;
                    y /= 16;
                    switch ( player->GetTeam() )
                    {
                    case 1:
                        if ( color == 1 && map->m_animations[y][x] == 24 )
                            map->m_animations[y][x] = 28;
                        else if ( color == 2 && map->m_animations[y][x] == 25 )
                            map->m_animations[y][x] = 29;
                        else if ( color == 3 && map->m_animations[y][x] == 26 )
                            map->m_animations[y][x] = 30;
                        else if ( color == 4 && map->m_animations[y][x] == 27 )
                            map->m_animations[y][x] = 31;
                        else if ( color == 5 && map->m_animations[y][x] == 128 )
                            map->m_animations[y][x] = 132;
                        break;
                    case 2:
                        if ( color == 1 && map->m_animations[y][x] == 32 )
                            map->m_animations[y][x] = 36;
                        else if ( color == 2 && map->m_animations[y][x] == 33 )
                            map->m_animations[y][x] = 37;
                        else if ( color == 3 && map->m_animations[y][x] == 34 )
                            map->m_animations[y][x] = 38;
                        else if ( color == 4 && map->m_animations[y][x] == 35 )
                            map->m_animations[y][x] = 39;
                        else if ( color == 5 && map->m_animations[y][x] == 129 )
                            map->m_animations[y][x] = 133;
                        break;
                    case 3:
                        if ( color == 1 && map->m_animations[y][x] == 40 )
                            map->m_animations[y][x] = 44;
                        else if ( color == 2 && map->m_animations[y][x] == 41 )
                            map->m_animations[y][x] = 45;
                        else if ( color == 3 && map->m_animations[y][x] == 42 )
                            map->m_animations[y][x] = 46;
                        else if ( color == 4 && map->m_animations[y][x] == 43 )
                            map->m_animations[y][x] = 47;
                        else if ( color == 5 && map->m_animations[y][x] == 130 )
                            map->m_animations[y][x] = 134;
                        break;
                    case 4:
                        if ( color == 1 && map->m_animations[y][x] == 58 )
                            map->m_animations[y][x] = 62;
                        else if ( color == 2 && map->m_animations[y][x] == 59 )
                            map->m_animations[y][x] = 63;
                        else if ( color == 3 && map->m_animations[y][x] == 60 )
                            map->m_animations[y][x] = 64;
                        else if ( color == 4 && map->m_animations[y][x] == 61 )
                            map->m_animations[y][x] = 65;
                        else if ( color == 5 && map->m_animations[y][x] == 131 )
                            map->m_animations[y][x] = 135;
                        break;
                    case 5:
                        if ( color == 5 && map->m_animations[y][x] == 136 )
                            map->m_animations[y][x] = 140;
                        break;
                    }
                    x *= 16;
                    y *= 16;
                }

                switch ( color )
                {
                case 1:
                    map->m_flagCarry1[flagnum] = 0;
                    map->m_flagPosition1[0][flagnum] = x;
                    map->m_flagPosition1[1][flagnum] = y;
                    break;
                case 2:
                    map->m_flagCarry2[flagnum] = 0;
                    map->m_flagPosition2[0][flagnum] = x;
                    map->m_flagPosition2[1][flagnum] = y;
                    break;
                case 3:
                    map->m_flagCarry3[flagnum] = 0;
                    map->m_flagPosition3[0][flagnum] = x;
                    map->m_flagPosition3[1][flagnum] = y;
                    break;
                case 4:
                    map->m_flagCarry4[flagnum] = 0;
                    map->m_flagPosition4[0][flagnum] = x;
                    map->m_flagPosition4[1][flagnum] = y;
                    break;
                case 5:
                    map->m_flagCarry5[flagnum] = 0;
                    map->m_flagPosition5[0][flagnum] = x;
                    map->m_flagPosition5[1][flagnum] = y;
                    break;
                }
                if ( dropreason == 2 ) g_game->FlagReturnedTo ( (ShipType)player->m_flagWho, (ShipType)player->GetTeam() );
                player->m_flagID = 0;
                player->m_flagWho = 0;
            }
            break;
        case MSG_GETFLAG:
            g_console->WriteLine ( "MSG_GETFLAG received." );
            {
                char who, color, flagnum;
                short x, y;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &color, sizeof(color) );
                _packet->GetBufferData ( &flagnum, sizeof(flagnum) );
                _packet->GetBufferData ( &x, sizeof(x) );
                _packet->GetBufferData ( &y, sizeof(y) );

                if ( !g_game->Playing() ) break;

                Map *map = g_game->GetMap();
                switch ( color )
                {
                case 1:
                    map->m_flagCarry1[flagnum] = who;
                    break;
                case 2:
                    map->m_flagCarry2[flagnum] = who;
                    break;
                case 3:
                    map->m_flagCarry3[flagnum] = who;
                    break;
                case 4:
                    map->m_flagCarry4[flagnum] = who;
                    break;
                case 5:
                    map->m_flagCarry5[flagnum] = who;
                    break;
                }
                if ( g_game->GetPlayers()->get ( who ) )
                {
                    Player *player = g_game->GetPlayers()->get ( who );
                    ARCReleaseAssert ( player );
                    player->m_flagID = flagnum;
                    player->m_flagWho = color;
                    g_game->FlagCapturedBy ( (ShipType)color, (ShipType)player->GetTeam() );
                } else {
                    ARCAbort ( "Player not found" );
                }
                x /= 16;
                y /= 16;
                switch ( color )
                {
                case 1:
                case 2:
                case 3:
                case 4:
                    {
                        if ( map->m_animations[y][x] == 27 + color )
                            map->m_animations[y][x] = 23 + color;
                        if ( map->m_animations[y][x] == 35 + color )
                            map->m_animations[y][x] = 31 + color;
                        if ( map->m_animations[y][x] == 43 + color )
                            map->m_animations[y][x] = 39 + color;
                        if ( map->m_animations[y][x] == 61 + color )
                            map->m_animations[y][x] = 57 + color;
                    }
                    break;
                case 5:
                    {
                        if ( map->m_animations[y][x] == 132 )
                            map->m_animations[y][x] = 128;
                        if ( map->m_animations[y][x] == 133 )
                            map->m_animations[y][x] = 129;
                        if ( map->m_animations[y][x] == 134 )
                            map->m_animations[y][x] = 130;
                        if ( map->m_animations[y][x] == 135 )
                            map->m_animations[y][x] = 131;
                        if ( map->m_animations[y][x] == 140 )
                            map->m_animations[y][x] = 136;
                    }
                    break;
                }
                // Ignoring a few superfluous variables here
            }
            break;
        case MSG_FLAGS:
            //g_console->WriteLine ( "MSG_FLAGS received." );
            {
                char color, flagnum;
                short x, y, carry;
                _packet->GetBufferData ( &color, sizeof(color) );
                _packet->GetBufferData ( &flagnum, sizeof(flagnum) );
                _packet->GetBufferData ( &x, sizeof(x) );
                _packet->GetBufferData ( &y, sizeof(y) );
                _packet->GetBufferData ( &carry, sizeof(carry) );

                Map *map = g_game->GetMap();
                ARCReleaseAssert ( map );
                short xt = x / 16, yt = y / 16;
                // TODO: Funky if statement ignored from the original code. Supposed to be a bounds check?
                switch ( color )
                {
                case 1:
                case 2:
                case 3:
                case 4:
                    {
                        if ( map->m_animations[yt][xt] == 23 + color )
                            map->m_animations[yt][xt] = 27 + color;
                        if ( map->m_animations[yt][xt] == 31 + color )
                            map->m_animations[yt][xt] = 35 + color;
                        if ( map->m_animations[yt][xt] == 39 + color )
                            map->m_animations[yt][xt] = 43 + color;
                        if ( map->m_animations[yt][xt] == 57 + color )
                            map->m_animations[yt][xt] = 61 + color;
                    }
                    break;
                case 5:
                    {
                        if ( map->m_animations[yt][xt] == 128 )
                            map->m_animations[yt][xt] = 132;
                        if ( map->m_animations[yt][xt] == 129 )
                            map->m_animations[yt][xt] = 133;
                        if ( map->m_animations[yt][xt] == 130 )
                            map->m_animations[yt][xt] = 134;
                        if ( map->m_animations[yt][xt] == 131 )
                            map->m_animations[yt][xt] = 135;
                        if ( map->m_animations[yt][xt] == 136 )
                            map->m_animations[yt][xt] = 140;
                    }
                    break;
                }

                // TODO: Funky if statement ignored from the original code. Supposed to be a bounds check?
                switch ( color )
                {
                case 1:
                    {
                        map->m_flagPosition1[0][flagnum] = x;
                        map->m_flagPosition1[1][flagnum] = y;
                        map->m_flagCarry1[flagnum] = carry;
                    }
                    break;
                case 2:
                    {
                        map->m_flagPosition2[0][flagnum] = x;
                        map->m_flagPosition2[1][flagnum] = y;
                        map->m_flagCarry2[flagnum] = carry;
                    }
                    break;
                case 3:
                    {
                        map->m_flagPosition3[0][flagnum] = x;
                        map->m_flagPosition3[1][flagnum] = y;
                        map->m_flagCarry3[flagnum] = carry;
                    }
                    break;
                case 4:
                    {
                        map->m_flagPosition4[0][flagnum] = x;
                        map->m_flagPosition4[1][flagnum] = y;
                        map->m_flagCarry4[flagnum] = carry;
                    }
                    break;
                case 5:
                    {
                        map->m_flagPosition5[0][flagnum] = x;
                        map->m_flagPosition5[1][flagnum] = y;
                        map->m_flagCarry5[flagnum] = carry;
                    }
                    break;
                }
                if ( g_game->GetPlayers()->valid ( carry ) )
                {
                    Player *player = g_game->GetPlayers()->get ( carry );
                    ARCReleaseAssert ( player != NULL );
                    player->m_flagWho = color;
                    player->m_flagID = flagnum;
                }
            }
            break;
        case MSG_TIMELIMIT:
            g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "MSG_TIMELIMIT ignored (unimplemented)." );
            g_console->SetColour ();
            break;
        case MSG_PLAYING:
            g_console->WriteLine ( "MSG_PLAYING received." );
            {
                if ( !g_game->m_me ) ARCAbort ( "We're not playing! I don't exist yet!" );
                g_game->SetPlaying ( true );
                g_soundSystem->PlaySound ( "welcome", 0, 0 );
                LoadingWindow *window = dynamic_cast<LoadingWindow *>(g_interface->GetWidgetOfType ( "LoadingWindow" ));
                if ( window != NULL )
                {
                    ARCReleaseAssert ( g_interface != NULL );
                    g_interface->RemoveWidget ( window );
                }
            }
            break;
        case MSG_FORCEPOS:
            g_console->WriteLine ( "MSG_FORCEPOS received." );
            {
                Data::DArray<Player *> *players = g_game->GetPlayers();
                ARCReleaseAssert ( players != NULL );
                unsigned char playerCount, playerIndex;
                short X, Y;

                _packet->GetBufferData ( &playerIndex, sizeof(playerIndex) );
                _packet->GetBufferData ( &playerCount, sizeof(playerCount) );
                _packet->GetBufferData ( &X, sizeof(X) );
                _packet->GetBufferData ( &Y, sizeof(Y) );

                if ( !players->valid ( playerIndex ) ) break;
                Player *player = players->get ( playerIndex );
                ARCReleaseAssert ( player != NULL );
                if ( playerCount == 254 ) { // In the pen
                    player->SetArmorCritical ( false );
                    player->SetVisibility ( true );
                    player->SetInPen ( true );
                } else if ( playerCount == 253 ) { // Out of pen
                    // TODO: Visibility check.
                    player->SetInPen ( false );
                    if ( player == g_game->m_me )
                        g_soundSystem->PlaySound ( "spawn", 0, 0 );
                } else if ( playerCount == 252 ) { // Warping
                    // Warping. Nothing to do.
                }
                player->SetPosition ( X, Y );
            }
            break;
        case MSG_LASER:
            {
                char who; short lx, ly, cx, cy;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &lx, sizeof(lx) );
                _packet->GetBufferData ( &ly, sizeof(ly) );
                _packet->GetBufferData ( &cx, sizeof(cx) );
                _packet->GetBufferData ( &cy, sizeof(cy) );
                Player *them = g_game->GetPlayers()->get ( who );
                if ( them != g_game->m_me )
                    g_interface->FireLaser ( them, lx, ly, cx, cy );
            }
            break;
        case MSG_BOUNCY:
            {
                char who; short lx, ly, cx, cy;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &lx, sizeof(lx) );
                _packet->GetBufferData ( &ly, sizeof(ly) );
                _packet->GetBufferData ( &cx, sizeof(cx) );
                _packet->GetBufferData ( &cy, sizeof(cy) );
                Player *them = g_game->GetPlayers()->get ( who );
                if ( them != g_game->m_me )
                    g_interface->FireBounce ( them, lx, ly, cx, cy );
            }
            break;
        case MSG_MISS:
            {
                char who; short lx, ly, cx, cy;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &lx, sizeof(lx) );
                _packet->GetBufferData ( &ly, sizeof(ly) );
                _packet->GetBufferData ( &cx, sizeof(cx) );
                _packet->GetBufferData ( &cy, sizeof(cy) );
                Player *them = g_game->GetPlayers()->get ( who );
                if ( them != g_game->m_me )
                    g_interface->FireMissile ( them, lx, ly, cx, cy );
            }
            break;
        case MSG_BOMB:
            {
                char who; short lx, ly, cx, cy;
                _packet->GetBufferData ( &who, sizeof(who) );
                _packet->GetBufferData ( &lx, sizeof(lx) );
                _packet->GetBufferData ( &ly, sizeof(ly) );
                _packet->GetBufferData ( &cx, sizeof(cx) );
                _packet->GetBufferData ( &cy, sizeof(cy) );
                Player *them = g_game->GetPlayers()->get ( who );
                if ( them != g_game->m_me )
                    g_interface->FireGrenade ( them, lx, ly, cx, cy );
            }
            break;
        default:
            g_console->SetColour ( IO::Console::FG_RED | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "Connection: Unknown packet ID '%d' received.", packetID );
            g_console->SetColour ();
            break;
        }
#ifndef _DEBUG
    }
    catch ( int e )
    {
        invalidPacketCount++;
        g_console->SetColour ( IO::Console::FG_RED | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "ERROR: Malformed packet with ID %d dropped (entry %d).", packetID, e );
        g_console->SetColour ();
        if ( invalidPacketCount > 10 )
        {
            ARCAbort ( "Invalid packet count exceeded threshhold" );
        }
    }
#endif
}

void Connection::ParsePackets()
{
    Data::LList<Packet *> *packets = m_net->GetPackets();

    while ( packets->valid ( 0 ) )
    {
        Packet *packet = packets->get(0);
#ifndef _DEBUG
        try
        {
#endif
            Parse ( packet );
#ifndef _DEBUG
        }
        catch ( ... )
        {
            g_console->SetColour ( IO::Console::FG_RED | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "ERROR: Malformed packet dropped." );
            g_console->SetColour ();
        }
#endif
        delete packet;
        packets->remove ( 0 );
    }
}

int Connection::Update()
{
    static System::Stopwatch lastNullPacket;
    int receivedPackets, ret;

    ret = m_net->Receive ( &receivedPackets );

    if ( ret ) return ret;

    ParsePackets();

    if ( m_updateTimeout > -0.5 )
    {
        m_updateTimer.Stop();
        if ( m_updateTimer.Elapsed() > m_updateTimeout )
            SendUpdate();
    }

    lastNullPacket.Stop();
    if ( lastNullPacket.Elapsed() > 10.0 )
    {
        SendNull ();
        lastNullPacket.Start();
    }

    return 0;
}

#endif
