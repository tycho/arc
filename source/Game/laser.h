/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_laser_h
#define __included_laser_h

#include "Game/player.h"
#include "Game/weapon.h"

class Laser : public Weapon
{
protected:
    short m_stopMove;

    short m_lineStartX;
    short m_lineStartY;
    short m_lineStopX;
    short m_lineStopY;

public:
    Laser ( Player *_player, int _lX, int _lY, int _cX, int _cY );
    virtual ~Laser();

    virtual void Update();
    virtual void Render();
};

#endif
