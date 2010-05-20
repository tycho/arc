/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_ship_h
#define __included_ship_h

#include "Game/player.h"
#include "Interface/widget.h"
#include "Interface/text.h"

class Player;
class Weapon;

class Ship : public Widget
{
protected:
    Player *m_player;
    TextUI *m_label;
    bool    m_damaged;

    Data::DArray<short>    m_retCollision;
    Data::DArray<short>    m_rectsRet;

    virtual void CollisionDetect ();
    virtual bool FindRectsRet ( short _findItem );
    virtual bool ShipRects ( short _bx, short _by, bool _isWeaponFire );

public:
    Ship ( Player *_player );
    virtual ~Ship();

    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

    virtual void Pop ();

    virtual void Flush ();
    virtual void FlushText ();

	virtual void Initialise();
    virtual void Update();
    virtual void Render();

    friend class Weapon;
};

#endif
