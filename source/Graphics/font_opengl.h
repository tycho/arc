/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __font_opengl_h_included
#define __font_opengl_h_included

#include "Graphics/font.h"

#ifdef ENABLE_OPENGL

class OpenGLFont : public Font
{
protected:
	bool			 m_bold;
	bool			 m_italic;
	FTGLTextureFont *m_font;

public:
    OpenGLFont(const char *_fontFilename);
    OpenGLFont(const unsigned char *_data, size_t _size);
    virtual ~OpenGLFont();
	virtual void Draw(Uint16 _x, Uint16 _y, const char *_text, Uint32 _color, bool _center = false);
	virtual void SetFontSize(Uint16 _size);
	virtual void SetBold(bool _bold);
	virtual void SetItalic(bool _italic);
};

#endif

#endif
