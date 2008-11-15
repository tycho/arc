/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_bounce_h
#define __included_bounce_h

#include "Game/player.h"
#include "Game/weapon.h"

class Bounce : public Weapon
{
protected:
    float m_trav;
    float m_stopMove;

    short m_lineStartX;
    short m_lineStartY;
    short m_lineStopX;
    short m_lineStopY;

public:
    Bounce ( Player *_player, int _lX, int _lY, int _cX, int _cY );
    Bounce ( Player *_player, int _cX, int _cY, double _angle, Bounce *_re );
    virtual ~Bounce();

    virtual void Update();
    virtual void Render();

    friend class Weapon;
};

#endif
