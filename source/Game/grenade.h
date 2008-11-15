/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_grenade_h
#define __included_grenade_h

#include <crisscross/stopwatch.h>

#include "Game/player.h"
#include "Game/weapon.h"

class Grenade : public Weapon
{
protected:
    CrissCross::System::Stopwatch m_smokeTick;
    double m_dest;
    double m_dist;
    double m_speed;

public:
    Grenade ( Player *_player, int _lX, int _lY, int _cX, int _cY );
    virtual ~Grenade();

    virtual void Update();
    virtual void Render();
};

#endif
