/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#ifdef ENABLE_DIRECT3D

#include "Graphics/graphics.h"
#include "Graphics/font_directx.h"

DirectXFont::DirectXFont(const char *_fontFace, int _height, bool _bold, bool _italic)
{
	int nWeight;
	DWORD dwItalic;

	nWeight = _bold ? FW_BOLD : FW_NORMAL;
	dwItalic = _italic ? 1 : 0;

	D3DXFONT_DESC lf;
	ZeroMemory(&lf, sizeof(D3DXFONT_DESC));

	lf.Height = _height;
	lf.Width = 0;
	lf.Weight = nWeight;
	lf.Italic = dwItalic;
	lf.CharSet = DEFAULT_CHARSET;
	strncpy(lf.FaceName, _fontFace, 31);

	D3DXCreateFontIndirect(((DirectXGraphics *)g_graphics)->m_device, &lf, &m_font);
}

DirectXFont::~DirectXFont()
{
	m_font->Release();
	m_font = NULL;
}

void DirectXFont::Draw(Uint16 _x, Uint16 _y, const char *_text, Uint32 _color, bool _center)
{
	RECT rect;
	rect.left = _x;
	rect.top = _y;
	rect.right = 0;
	rect.bottom = 0;

	D3DCOLOR color = _color;

	CoreAssert ( m_font );

	m_font->DrawText(NULL, _text, -1, &rect, DT_CALCRECT, 0);

	if ( _center )
	{
		rect.left = _x - ((rect.right - rect.left) / 2);
		rect.top = _y - ((rect.bottom - rect.top) / 2);
		rect.right = _x + ((rect.right - rect.left) / 2);
		rect.bottom = _y + ((rect.bottom - rect.top) / 2);

		m_font->DrawText(NULL, _text, -1, &rect, DT_LEFT | DT_NOCLIP, color);
	} else
		m_font->DrawText(NULL, _text, -1, &rect, DT_LEFT | DT_NOCLIP, _color);
}

#endif