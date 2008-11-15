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
