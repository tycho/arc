/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_text_h
#define __included_text_h

#include "Interface/widget.h"

class TextUI : public Widget
{
protected:
    bool            m_smallText;
    char           *m_text;

protected:
    virtual int MakeText ( const char *_text );

public:
    TextUI ( const char *_text, bool _smallText, Sint16 x, Sint16 y, Uint16 w, Uint16 h );
    virtual ~TextUI();

    virtual const char *GetText ();
    virtual void SetText ( const char *_text );
    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

    virtual void Update();
};

#endif
