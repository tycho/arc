/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_graphics_directx_h
#define __included_graphics_directx_h

#ifdef ENABLE_DIRECT3D

#include "Graphics/graphics.h"

class Texture;
class DirectXFont;
class DirectXTexture;

struct DXVertex
{
	float x;			// Normalised X coord
	float y;			// Normalised Y coord
	float z;			// Always 0.0f
	float rhw;			// Always 1.0f
	D3DCOLOR colour;	// ARGB colour
	float u;			// 0.0f = left, 1.0f = right
	float v;			// 0.0f = top, 1.0f = bottom
};

class DirectXGraphics : public Graphics
{
protected:
	static const int                     m_rendererVersionMajor = 1;
	static const int                     m_rendererVersionMinor = 0;

	bool								 m_deviceLost;

    SDL_Surface                         *m_sdlScreen;
    Data::DArray<DirectXTexture *>       m_textures;
	Data::DArray<DirectXFont *>          m_fonts;

	D3DPRESENT_PARAMETERS                m_presentParams;
	D3DCAPS9                             m_caps;
	IDirect3D9                          *m_d3d;
	IDirect3DDevice9                    *m_device;
	IDirect3DVertexBuffer9              *m_vertexBuffer;

public:
    DirectXGraphics();
    virtual ~DirectXGraphics();

	virtual const char *RendererName();

	virtual Uint32 CreateFont ( const char *_fontFace, int _height, bool _bold, bool _italic );
	virtual void   DrawText ( Uint32 _font, Uint16 _x, Uint16 _y, const char *_text, Uint32 _color, bool _center = false );
	virtual void   DrawRect ( SDL_Rect *_pos, Uint32 _color );

    virtual Uint32 CreateSurface ( Uint32 _width, Uint32 _height, bool _isColorKeyed = false );
    virtual int    DeleteSurface ( Uint32 _surfaceID );
    virtual Uint32 LoadImage ( const char *_filename, bool _isColorKeyed = false );

    virtual void   DrawLine ( Uint32 _surfaceID, Uint32 _color, int _startX, int _startY, int _stopX, int _stopY );
    virtual int    FillRect ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 _color );
    virtual Uint32 GetPixel ( Uint32 _surfaceID, int x, int y );
    virtual void   SetPixel ( Uint32 _surfaceID, int x, int y, Uint32 color );
    virtual void   ReplaceColour ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 _findColour, Uint32 _replaceColour );

    virtual Uint16 GetMaximumTextureSize();
    virtual SDL_PixelFormat *GetPixelFormat ( Uint32 _surfaceID );
    virtual Uint32 GetScreen();
    virtual Uint32 GetSurfaceHeight ( Uint32 _surfaceID );
    virtual Uint32 GetSurfaceWidth ( Uint32 _surfaceID );

    virtual void   ShowCursor ( bool _show );

    virtual int    SetSurfaceAlpha ( Uint32 _surfaceID, Uint8 alpha );
    virtual int    SetColorKey ( Uint32 _colour );
	virtual void   ApplyColorKey ( Uint32 _surfaceID );
    virtual int    Blit ( Uint32 _sourceSurfaceID, SDL_Rect const *_sourceRect,
                          Uint32 _destSurfaceID,   SDL_Rect const *_destRect );
    virtual int    SetWindowMode ( bool _windowed, Sint16 _width, Sint16 _height, Uint8 _colorDepth );
    virtual inline bool Flip();

	friend class DirectXTexture;
	friend class DirectXFont;
};

#include "Graphics/texture.h"
#include "Graphics/font.h"

#endif

#endif
