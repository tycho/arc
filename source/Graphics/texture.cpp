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

#include "universal_include.h"

#include "Graphics/opengl.h"
#include "Graphics/texture.h"

Texture::Texture ()
 : m_sdlSurface(NULL),
   m_originalWidth(0),
   m_originalHeight(0),
   m_damaged(true),
   m_alpha(0xFF)
{
}

Texture::Texture ( SDL_Surface *_surface )
 : m_sdlSurface(_surface),
   m_alpha(0xFF),
   m_originalWidth(0),
   m_originalHeight(0),
   m_damaged(true)
{
}

Texture::~Texture()
{
    Dispose();
}

void Texture::Dispose()
{
    if ( m_sdlSurface )
    {
        SDL_FreeSurface ( m_sdlSurface );
        m_sdlSurface = NULL;
    }
}

void Texture::Damage()
{
    m_damaged = true;
}

void Texture::SetPixel ( Uint16 _x, Uint16 _y, Uint32 _pixel )
{
    ARCReleaseAssert ( m_sdlSurface != NULL );

    if ( (Sint16)_x < 0 || (Sint16)_y < 0 ) return;
    if ( _x >= m_sdlSurface->w || _y >= m_sdlSurface->h ) return ;

    SDL_LockSurface ( m_sdlSurface );

    int bpp = m_sdlSurface->format->BytesPerPixel;

    ARCReleaseAssert ( m_sdlSurface->pixels != NULL );

    /* Here p is the address to the pixel we want to set */
    Uint8 *p = (Uint8 *)m_sdlSurface->pixels + _y * m_sdlSurface->pitch + _x * bpp;

    switch(bpp) {
    case 1:
        *p = _pixel;
        break;
    case 2:
        *(Uint16 *)p = _pixel;
        break;
    case 3:
        if(SDL_BYTEORDER == SDL_BIG_ENDIAN) {
            p[0] = (_pixel >> 16) & 0xff;
            p[1] = (_pixel >> 8) & 0xff;
            p[2] = _pixel & 0xff;
        } else {
            p[0] = _pixel & 0xff;
            p[1] = (_pixel >> 8) & 0xff;
            p[2] = (_pixel >> 16) & 0xff;
        }
        break;
    case 4:
        *(Uint32 *)p = _pixel;
        break;
    }

    SDL_UnlockSurface ( m_sdlSurface );

	m_damaged = true;
}

Uint32 Texture::GetPixel ( Uint16 _x, Uint16 _y )
{
    ARCReleaseAssert ( m_sdlSurface != NULL );
    if ( (Sint16)_x < 0 || (Sint16)_y < 0 ) return 0;
    if ( _x >= m_sdlSurface->w || _y >= m_sdlSurface->h ) return 0;

    bool isLocked = false;

    /* Lock only when absolutely necessary. We hate slowness. */
    if ( !m_sdlSurface->pixels )
    {
        SDL_LockSurface ( m_sdlSurface );
        isLocked = true;
    }

    int bpp = m_sdlSurface->format->BytesPerPixel;

    /* Here p is the address to the pixel we want to retrieve */
    Uint8 *p = (Uint8 *)m_sdlSurface->pixels + _y * m_sdlSurface->pitch + _x * bpp;
    Uint32 pixel = 0;

    switch(bpp) {
    case 1:
        pixel = *p;
        break;
    case 2:
        pixel = *(Uint16 *)p;
        break;
    case 3:
        if(SDL_BYTEORDER == SDL_BIG_ENDIAN)
            pixel = p[0] << 16 | p[1] << 8 | p[2];
        else
            pixel = p[0] | p[1] << 8 | p[2] << 16;
        break;
    case 4:
        pixel = *(Uint32 *)p;
        break;
    }

    if ( isLocked )
        SDL_UnlockSurface ( m_sdlSurface );

    return pixel;
}

void Texture::ReplaceColour ( SDL_Rect *_destRect, Uint32 _find, Uint32 _replace )
{
    int x1 = _destRect->x,
        x2 = _destRect->x + _destRect->w,
        y1 = _destRect->y,
        y2 = _destRect->y + _destRect->h;

    SDL_LockSurface ( m_sdlSurface );
    for ( int y = y1; y < y2; y++ ) {
        for ( int x = x1; x < x2; x++ ) {
            if ( GetPixel ( x, y ) == _find )
                SetPixel ( x, y, _replace );
        }
    }
    SDL_UnlockSurface ( m_sdlSurface );

	m_damaged = true;
}

void Texture::SetAlpha ( Uint8 _alpha )
{
    ARCReleaseAssert ( m_sdlSurface != NULL );

    m_alpha = _alpha;

    SDL_SetAlpha ( m_sdlSurface, SDL_SRCALPHA | SDL_RLEACCEL, m_alpha );
}
