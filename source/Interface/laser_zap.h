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

#ifndef __included_laser_zap_h
#define __included_laser_zap_h

#include "Game/player.h"
#include "Interface/widget.h"
#include "Interface/text.h"

class LaserZap : public Widget
{
protected:
    bool    m_damaged;

    bool    m_zapping;
    double  m_zapFrame;

    short   m_x;
    short   m_y;

public:
    LaserZap ( Sint32 _x, Sint32 _y );
    virtual ~LaserZap();

    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

	virtual void Initialise();
    virtual void Update();
    virtual void Render();

};

#endif
