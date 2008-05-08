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

#ifndef __included_grenade_explosion_h
#define __included_grenade_explosion_h

#include <crisscross/stopwatch.h>

#include "Game/player.h"
#include "Game/weapon.h"

class GrenadeExplosion
{
protected:
    int m_X, m_Y;
    bool m_expired;
    
    CrissCross::System::Stopwatch m_frameTick;
    int m_frame;

public:
    GrenadeExplosion ( int _cX, int _cY );
    virtual ~GrenadeExplosion();

    virtual bool Expired();
    virtual void Render();
};

#endif
