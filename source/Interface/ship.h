/*
 *                           ARC++
 *
 *    Copyright (c) 2007-2008 Steven Noonan. All rights reserved.
 *
 *    NO PART OF THIS PROGRAM OR PUBLICATION MAY BE REPRODUCED,
 *    TRANSMITTED, TRANSCRIBED, STORED IN A RETRIEVAL SYSTEM, OR
 *    TRANSLATED INTO ANY LANGUAGE OR COMPUTER LANGUAGE IN ANY
 *    FORM OR BY ANY MEANS, ELECTRONIC, MECHANICAL, MAGNETIC,
 *    OPTICAL, CHEMICAL, MANUAL, OR OTHERWISE, WITHOUT THE PRIOR
 *    WRITTEN PERMISSION OF:
 *
 *                       STEVEN NOONAN
 *                       4727 BLUFF DR.
 *                 MOSES LAKE, WA 98837-9075
 *
 *    THIS SOURCE CODE IS NOT FOR PUBLIC INSPECTION.
 *    The above copyright notice does not indicate any
 *    actual or intended publication of this source code.
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

    virtual void Update();
    virtual void Render();

    friend class Weapon;
};

#endif
