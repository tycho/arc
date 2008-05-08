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

#ifndef __game_h_included
#define __game_h_included

#include "Game/player.h"
#include "Game/weapon.h"
#include "Network/connection.h"
#include "World/map.h"

typedef enum
{
    LOAD_STATE_NULL,
    LOAD_STATE_SPINWAIT,
    LOAD_STATE_PRELOAD_SOUNDS_MSG,
    LOAD_STATE_PRELOAD_SOUNDS,
    LOAD_STATE_CONNECTING_MSG,
    LOAD_STATE_CONNECTING,
    LOAD_STATE_SEND_LOGIN,
    LOAD_STATE_REQUEST_MAP,
    LOAD_STATE_SEND_GAMELOGIN,
    LOAD_STATE_TRANSFER_MAP,
    LOAD_STATE_LOADMAP_MSG,
    LOAD_STATE_LOADMAP,
#ifndef ENABLE_NETWORKING
    LOAD_STATE_RUN_GAME,
#endif
    LOAD_STATE_RECEIVE_WORLDSTATE,
    LOAD_STATE_SYNCHRONIZING
} LoadState;

class Game
{
public:
#ifdef ENABLE_NETWORKING
    Connection *m_connection;
#endif

    short m_health;
    double m_laserCharge;
    short m_bounceAmmo;
    short m_missileAmmo;
    short m_grenadeAmmo;
    short m_bounceCharge;
    short m_missileCharge;
    short m_grenadeCharge;

    Player *m_me;

protected:
    System::Stopwatch m_loadPause;
    System::Stopwatch m_tmrGameSpeed;
    System::Stopwatch m_tmrFPS;
    bool m_running;
    bool m_playing;
    bool m_classicControls;
    double m_gameSpeed;
    std::string m_mapName;
    Map *m_map;

    WeaponType m_selectedWeapon;

    Data::DArray<Player *> m_players;

    LoadState m_loadState;
    LoadState m_nextLoadState;
    double m_loadPauseTime;

    short m_fps;
    short m_ping;
    short m_highPing;

    int m_damageLevel;

    //short m_moveBufferSpeed;
    //short m_moveBufferSize;

    char m_laserDamageSetting;
    char m_specialDamageSetting;
    char m_rechargeRate;
    char m_holdTime;

    double m_laserDamage[5];
    double m_bounceDamage[5];
    double m_missileDamage[5];
    double m_shrapnelDamage[5];

    short m_teamScores[5];

public:
    Game();
    virtual ~Game();
    virtual void Run ( const char *_hostname, unsigned short _port,
                       const char *_nickname, const char *_password );
    virtual void Quit();
    virtual void Initialise();
    
    virtual void SetMapName ( const char *_mapfile );
    virtual const char *GetMapName ();

    virtual int LoadMap ( const char *_mapfile );
    virtual double GetGameSpeed();
    virtual Map *GetMap();
    virtual void SetMyIndex ( char _index );
    virtual void AddPlayer ( Player *_player, int _index );
    virtual void RemovePlayer ( int _index );
    virtual Data::DArray<Player *> *GetPlayers();
    virtual void RenderShips ();
    virtual void RenderFlag ( short _team, short _index );
    virtual void RenderFlags ();
    virtual void RenderCapturedFlags ();

    virtual void WeaponHit ( Player *_attacker, WeaponType _type );

    virtual void SetTeamScore ( ShipType _team, short _score );

    virtual double GetWeaponDamage ( WeaponType _type );
    virtual WeaponType GetSelectedWeapon ();
    virtual double GetHealth();
    virtual void SubtractLaserCharge ( double _amount );

    virtual void SetPing ( short _ping );

    virtual void SetLaserDamage ( char _damage );
    virtual void SetSpecialDamage ( char _damage );
    virtual void SetRechargeRate ( char _rate );
    virtual void SetHoldTime ( char _time );

    virtual void SetLoadState ( LoadState _loadState );

    virtual void FlagCapturedBy ( ShipType _teamFlag, ShipType _teamCapturedBy );
    virtual void FlagReturnedTo ( ShipType _teamFlag, ShipType _teamCapturedBy );

    virtual void SetPlaying ( bool _playing );
    virtual bool Playing();

    virtual void ProcessEvents ();

    virtual void LoadSounds();
};

extern Game *g_game;

#endif
