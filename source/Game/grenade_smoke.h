/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_smoke_h
#define __included_smoke_h

#include "Game/player.h"
#include "Game/weapon.h"

class GrenadeSmoke
{
protected:
    int m_X, m_Y;
    int m_color;
    bool m_expired;
    
    double m_frameXC;
    double m_frameT;

public:
    GrenadeSmoke ( int _x, int _y, int _color );
    virtual ~GrenadeSmoke();

    virtual bool Expired();
    virtual void Render();
};

#endif
