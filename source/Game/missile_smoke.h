/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_missile_smoke_h
#define __included_missile_smoke_h

#include "Game/player.h"
#include "Game/weapon.h"

class MissileSmoke
{
protected:
    int m_X, m_Y;
    int m_color;
    bool m_expired;

    double m_frameXC;
    double m_frameT;

public:
    MissileSmoke ( int _x, int _y, int _color );
    virtual ~MissileSmoke();

    virtual bool Expired();
    virtual void Render();
};

#endif
