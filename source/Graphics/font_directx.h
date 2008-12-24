/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __font_directx_h_included
#define __font_directx_h_included

#include "Graphics/font.h"

#ifdef ENABLE_DIRECT3D

class DirectXFont : public Font
{
protected:
	LPD3DXFONT m_font;

public:
    DirectXFont(const char *_fontFace, int _height, bool _bold, bool _italic);
    virtual ~DirectXFont();
	virtual void Draw ( Uint16 _x, Uint16 _y, const char *_text, Uint32 _color, bool _center = false );
};

#endif

#endif
