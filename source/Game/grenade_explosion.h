/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_grenade_explosion_h
#define __included_grenade_explosion_h

#include <crisscross/stopwatch.h>

#include "Game/player.h"
#include "Game/weapon.h"

class GrenadeExplosion
{
protected:
    int m_X, m_Y;
    bool m_expired;

    CrissCross::System::Stopwatch m_frameTick;
    int m_frame;

public:
    GrenadeExplosion ( int _cX, int _cY );
    virtual ~GrenadeExplosion();

    virtual bool Expired();
    virtual void Render();
};

#endif
