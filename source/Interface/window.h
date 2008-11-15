/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __window_h_included
#define __window_h_included

#include "Interface/widget.h"

class Window : public Widget
{
protected:
    bool m_dragging;
    int m_mouseXOffset, m_mouseYOffset;

    virtual void DrawBox();

public:
    Window ();
    Window ( Sint16 x, Sint16 y, Uint16 w, Uint16 h );
    virtual ~Window();

    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

    virtual void Update();
};

#endif
