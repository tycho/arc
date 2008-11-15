/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_inputwidget_h
#define __included_inputwidget_h

#include "Interface/widget.h"

typedef void (*InputCallback)(Widget *);

class InputWidget : public Widget
{
protected:
    InputCallback m_callback;
    Widget *m_callbackParam;
public:
    InputWidget ( InputCallback _callback, Widget *_callbackParam, Sint32 _x, Sint32 _y, Sint32 _w, Sint32 _h );
    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();
};

#endif
