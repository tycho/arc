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
