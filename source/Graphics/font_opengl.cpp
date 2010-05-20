/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#ifdef ENABLE_FONTS

#ifdef ENABLE_OPENGL

#include "Graphics/graphics.h"
#include "Graphics/font_opengl.h"

#ifdef TARGET_COMPILER_VC
#  pragma comment (lib, "ftgl.lib")
#  pragma comment (lib, "freetype.lib")
#endif

const float DIRECTX_SCALE_FACTOR = 0.78f;

OpenGLFont::OpenGLFont(const char *_fontFile)
 : m_italic(false)
{
	m_font = new FTGLTextureFont(_fontFile);
	m_font->UseDisplayList(true);
}
OpenGLFont::OpenGLFont(const unsigned char *_data, size_t _size)
 : m_italic(false)
{
	m_font = new FTGLTextureFont(_data, _size);
	m_font->UseDisplayList(true);
}

OpenGLFont::~OpenGLFont()
{
}

void OpenGLFont::SetFontSize(Uint16 _size)
{
	m_font->FaceSize((int)(_size * DIRECTX_SCALE_FACTOR) , 72);
}

void OpenGLFont::SetBold(bool _bold)
{
	m_bold = _bold;
}

void OpenGLFont::SetItalic(bool _italic)
{
	m_italic = _italic;
}

void OpenGLFont::Draw(Uint16 _x, Uint16 _y, const char *_text, Uint32 _color, bool _center)
{
	// TODO: Bold text is unimplemented.

	glPushMatrix();
	glTranslatef(_x, _y + (m_font->LineHeight() * DIRECTX_SCALE_FACTOR), 0.0f);
	glScalef(1.0f, -1.0f, 1.0f);
	if ( m_italic )
	{
		GLfloat matrix[] =
		{
			1.0f, 0.0f, 0.0f, 0.0f,
			0.2f, 1.0f, 0.0f, 0.0f,
			0.0f, 0.0f, 1.0f, 0.0f,
			0.0f, 0.0f, 0.0f, 1.0f
		};
		glMultMatrixf(matrix);
	}
	glColor4ub(GET_R(_color), GET_G(_color), GET_B(_color), GET_A(_color));
	m_font->Render(_text);
	glPopMatrix();
}

#endif

#endif
