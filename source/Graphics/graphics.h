/*
 *                           ARC++
 *
 *    Copyright (c) 2007-2008 Steven Noonan. All rights reserved.
 *
 *    NO PART OF THIS PROGRAM OR PUBLICATION MAY BE REPRODUCED,
 *    TRANSMITTED, TRANSCRIBED, STORED IN A RETRIEVAL SYSTEM, OR
 *    TRANSLATED INTO ANY LANGUAGE OR COMPUTER LANGUAGE IN ANY
 *    FORM OR BY ANY MEANS, ELECTRONIC, MECHANICAL, MAGNETIC,
 *    OPTICAL, CHEMICAL, MANUAL, OR OTHERWISE, WITHOUT THE PRIOR
 *    WRITTEN PERMISSION OF:
 *
 *                       STEVEN NOONAN
 *                       4727 BLUFF DR.
 *                 MOSES LAKE, WA 98837-9075
 *
 *    THIS SOURCE CODE IS NOT FOR PUBLIC INSPECTION.
 *    The above copyright notice does not indicate any
 *    actual or intended publication of this source code.
 *
 */

#ifndef __graphics_h_included
#define __graphics_h_included

#if SDL_BYTEORDER == SDL_LIL_ENDIAN
#  define FULL_ALPHA 0xFF000000
#  define ZERO_ALPHA 0x00FFFFFF
#else
#  define FULL_ALPHA 0x000000FF
#  define ZERO_ALPHA 0xFFFFFF00
#endif

class Texture;
class OpenGLTexture;
class DirectXTexture;

class Graphics
{
protected:
    bool    m_windowed;

    Uint16    m_screenX;
    Uint16    m_screenY;

    Uint16    m_colorDepth;

    Uint16    m_centerX;
    Uint16    m_centerY;

    Uint32    m_colorKey;
    bool    m_colorKeySet;

public:
    Graphics ();
    virtual ~Graphics();

	virtual const char *RendererName() = 0;

    virtual Uint16 GetMaximumTextureSize() = 0;

    virtual Sint32 GetCenterX();
    virtual Sint32 GetCenterY();

    virtual Sint32 GetScreenWidth();
    virtual Sint32 GetScreenHeight();

    virtual Uint32 GetScreen() = 0;

    virtual Uint32 GetSurfaceWidth ( Uint32 _surfaceID ) = 0;
    virtual Uint32 GetSurfaceHeight ( Uint32 _surfaceID ) = 0;
    virtual Uint32 GetPixel ( Uint32 _surfaceID, int x, int y ) = 0;
    virtual void   SetPixel ( Uint32 _surfaceID, int x, int y, Uint32 color ) = 0;
    virtual void   DrawLine ( Uint32 _surfaceID, Uint32 _color, int _startX, int _startY, int _stopX, int _stopY ) = 0;

    virtual int    SetSurfaceAlpha ( Uint32 _surfaceID, Uint8 alpha ) = 0;

    virtual void   ShowCursor ( bool _show ) = 0;

    virtual SDL_PixelFormat *GetPixelFormat ( Uint32 _surfaceID ) = 0;
    virtual void   ReplaceColour(Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 findcolor, Uint32 replacecolor) = 0;

    virtual Uint32 LoadImage ( const char *_filename, bool _isColorKeyed = false ) = 0;
    virtual Uint32 GetColorKey ();
    virtual int    SetColorKey ( Uint32 _colour ) = 0;
	virtual void   ApplyColorKey ( Uint32 _surfaceID ) = 0;
    virtual Uint32 CreateSurface ( Uint32 _width, Uint32 _height, bool _isColorKeyed = false ) = 0;
    virtual int    DeleteSurface ( Uint32 _surfaceID ) = 0;
    virtual int    FillRect ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 _color ) = 0;
    virtual int    Blit ( Uint32 _sourceSurfaceID, SDL_Rect const *_sourceRect,
                          Uint32 _destSurfaceID,   SDL_Rect const *_destRect ) = 0;
    virtual int    SetWindowMode ( bool _windowed, Sint16 _width, Sint16 _height, Uint8 _colorDepth ) = 0;
    virtual inline bool Flip() = 0;

	friend class Texture;
	friend class DirectXTexture;
	friend class OpenGLTexture;
};

extern Graphics *g_graphics;

#include "Graphics/graphics_directx.h"
#include "Graphics/graphics_sdl.h"
#include "Graphics/graphics_opengl.h"
#include "Graphics/texture.h"

#endif
