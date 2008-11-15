/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_missile_h
#define __included_missile_h

#include "Game/player.h"
#include "Game/weapon.h"

class Missile : public Weapon
{
protected:

public:
    Missile ( Player *_player, int _lX, int _lY, int _cX, int _cY );
    virtual ~Missile();

    virtual void Update();
    virtual void Render();
};

#endif
