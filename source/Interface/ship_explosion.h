/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_ship_explosion_h
#define __included_ship_explosion_h

#include "Game/player.h"
#include "Interface/widget.h"
#include "Interface/text.h"

class Player;
class Weapon;

class ShipExplosion : public Widget
{
protected:
    bool    m_damaged;
    double  m_popFrame;

    float   m_x;
    float   m_y;

public:
    ShipExplosion ( float _x, float _y );
    virtual ~ShipExplosion();

    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

	virtual void Initialise();
    virtual void Update();
    virtual void Render();

};

#endif
