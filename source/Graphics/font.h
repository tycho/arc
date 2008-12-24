/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __font_h_included
#define __font_h_included

class Font
{
public:
    Font();
    virtual ~Font();
	virtual void Draw ( Uint16 _x, Uint16 _y, const char *_text, Uint32 _color, bool _center = false ) = 0;
};

#include "Graphics/font_directx.h"

#endif
