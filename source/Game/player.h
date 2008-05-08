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

#ifndef __included_player_h
#define __included_player_h

#include "Interface/ship.h"

typedef enum
{
    SHIP_TYPE_GREEN = 1,
    SHIP_TYPE_RED = 2,
    SHIP_TYPE_BLUE = 3,
    SHIP_TYPE_YELLOW = 4,
    SHIP_TYPE_NEUTRAL = 5
} ShipType;

typedef enum
{
    MOVE_NONE = 9,
    MOVE_RIGHT = 1,
    MOVE_UP_RIGHT = 2,
    MOVE_UP = 3,
    MOVE_UP_LEFT = 4,
    MOVE_LEFT = 5,
    MOVE_DOWN_LEFT = 6,
    MOVE_DOWN = 7,
    MOVE_DOWN_RIGHT = 8
} MovementDirections;

class Ship;

class Player
{
public:
    System::Stopwatch m_lastPositionUpdate;

    char m_flagWho;
    char m_flagID;
    float m_charX;
    float m_charY;
    char m_cheat;
    char *m_nick;

protected:
    char m_shipType;
    char m_frame;
    char m_admin;
    char m_lastAnim;
    char m_animX;
    //char m_animY;
    //char m_direction;

    short m_score;
    short m_moveX;
    short m_moveY;
    char m_keyIs;
    bool m_visible;

    bool m_inPen;

    int m_holdingPen;

    bool m_armorCritical;
    int m_armorCriticalTime;

    bool m_warping;
    int m_warped;

    int m_tick;

    short m_degrees;
    short m_mode;
    int m_nextSync;

    Ship *m_ship;

public:
    Player ( const char *_nickname, ShipType _ship, short _score,
             char admin, char cheat );
    virtual ~Player();

    virtual bool GetArmorCritical();
    virtual char GetKey();
    virtual float GetX();
    virtual float GetY();
    virtual int  GetMode();
    virtual short GetMoveX();
    virtual short GetMoveY();

    virtual bool InPen();
    virtual bool Visible();

    virtual short GetTeam();
    virtual Ship *GetShip();

    virtual void SetArmorCritical ( bool _isCritical );
    virtual void SetInPen ( bool _isInPen );
    virtual void SetDirection ( MovementDirections _keyIs );
    virtual void SetPosition ( short x, short y );
    virtual void SetNick ( const char *_nick );
    virtual void SetTeam ( ShipType ship );
    virtual void SetVisibility ( bool _isVisible );
    virtual void SetScore ( short _score );
    virtual void SetMode ( char _mode );

    virtual void Update ();
    virtual void Render ();

    friend class Ship;
};

#endif
