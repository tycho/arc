/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_text_input_h
#define __included_text_input_h

#include "Interface/text.h"

class TextInput : public TextUI
{
public:
    TextInput ( const char *_text, bool _smallText, Sint16 x, Sint16 y, Uint16 w, Uint16 h );
    virtual ~TextInput();

    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

    virtual void Update();
    virtual void Render();
};

#endif
