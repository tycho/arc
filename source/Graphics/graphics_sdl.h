/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_graphics_sdl_h
#define __included_graphics_sdl_h

#include "Graphics/graphics.h"

class SDLGraphics : public Graphics
{
private:
	static const int                     m_rendererVersionMajor = 1;
	static const int                     m_rendererVersionMinor = 0;

    size_t                       m_mainSurface;
    Data::DArray<SDL_Surface *>  m_surfaces;

    Uint32 GetPixel ( SDL_Surface *surface, int x, int y );
    void SetPixel ( SDL_Surface *surface, int x, int y, Uint32 pixel );

public:
    SDLGraphics ( const char *_graphicsDriver = NULL );
    virtual ~SDLGraphics();

	virtual const char *RendererName();

    virtual Uint16 GetMaximumTextureSize();

    virtual Uint32 GetScreen();

    virtual Uint32 LoadImage ( const char *_filename, bool _isColorKeyed = false );

    virtual Uint32 GetSurfaceWidth ( Uint32 _surfaceID );
    virtual Uint32 GetSurfaceHeight ( Uint32 _surfaceID );
    virtual Uint32 GetPixel ( Uint32 _surfaceID, int x, int y );
    virtual void   SetPixel ( Uint32 _surfaceID, int x, int y, Uint32 color );
    virtual void   DrawLine ( Uint32 _surfaceID, Uint32 _color, int _startX, int _startY, int _stopX, int _stopY );

    virtual int    SetSurfaceAlpha ( Uint32 _surfaceID, Uint8 alpha );

    virtual void   ShowCursor ( bool _show );

    virtual SDL_PixelFormat *GetPixelFormat ( Uint32 _surfaceID );
    virtual void   ReplaceColour ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 _findColour, Uint32 _replaceColour );

    virtual int     SetColorKey ( Uint32 _colour );
	virtual void    ApplyColorKey ( Uint32 _surfaceID );
    virtual Uint32  CreateSurface ( Uint32 _width, Uint32 _height, bool _isColorKeyed = false );
    virtual int     DeleteSurface ( Uint32 _surfaceID );
    virtual int     FillRect ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 _color );
    virtual int     Blit ( Uint32 _sourceSurfaceID, SDL_Rect const *_sourceRect,
                           Uint32 _destSurfaceID,   SDL_Rect const *_destRect );
    virtual int     SetWindowMode ( bool _windowed, Sint16 _width, Sint16 _height, Uint8 _colorDepth );
    virtual inline bool Flip();
};

#endif
