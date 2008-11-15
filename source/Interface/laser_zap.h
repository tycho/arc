/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
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
