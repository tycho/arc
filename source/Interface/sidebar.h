/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_sidebar_h
#define __included_sidebar_h

#include "Graphics/graphics.h"
#include "Interface/widget.h"

class Sidebar : public Widget
{
protected:
    Uint32        m_healthBarSurfaceID;
    Uint32        m_chargeBarSurfaceID;
    Uint32        m_radarBackgroundSurfaceID;

public:
    Sidebar();
    ~Sidebar();

    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

	virtual void Initialise();
    virtual void Render();
    virtual void Update();
};

#endif
