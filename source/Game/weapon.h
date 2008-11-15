/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_weapon_h
#define __included_weapon_h

#include "Game/player.h"
#include "Interface/ship.h"

typedef enum
{
    WEAPON_TYPE_LASER = 0,
    WEAPON_TYPE_MISSILE = 1,
    WEAPON_TYPE_GRENADE = 2,
    WEAPON_TYPE_BOUNCE = 3,
    WEAPON_TYPE_SHRAPNEL = 4,
    WEAPON_TYPE_SPARK = 5
} WeaponType;

class Weapon
{
protected:

    WeaponType m_type;

    Player *m_player;

    short m_X;
    short m_Y;
    float m_dist;

    double m_angle;

    bool m_hit;

    bool m_expired;

public:
    Weapon ();
    Weapon ( Player *_player, int _lX, int _lY, int _cX, int _cY );
    virtual ~Weapon();

    virtual int PixelIntersect2 ( short lx, short ly, short j, short I );
    virtual int PixelIntersect3 ( short lx, short ly, short j, short I );
    virtual int Touch ( short _newX, short _newY );
    virtual void LineDraw ( int _type, int _color, int _dist,
        int _stopMove, int _startX, int _startY, int _stopX, int _stopY );

    virtual void Update () = 0;
    virtual void Render () = 0;

    virtual bool Expired();
};

#endif
