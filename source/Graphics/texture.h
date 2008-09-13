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

#ifndef __included_texture_h
#define __included_texture_h

#include "Graphics/opengl.h"
#include "Graphics/graphics_opengl.h"

class Texture
{
protected:

    SDL_Surface *m_sdlSurface;

    Uint16       m_originalWidth;
    Uint16       m_originalHeight;

    bool         m_damaged;

    Uint8        m_alpha;

public:
    Texture();
    Texture ( SDL_Surface *_surface );
    virtual ~Texture();

    virtual bool Create ( Uint16 _width, Uint16 _height, bool _isColorKeyed ) = 0;
    virtual void Dispose ();

    bool IsDamaged ();
    void Damage ();

    Uint32 GetPixel ( Uint16 _x, Uint16 _y );
    void   SetPixel ( Uint16 _x, Uint16 _y, Uint32 _pixel );
    void   ReplaceColour ( SDL_Rect *_rect, Uint32 _find, Uint32 _replace );

    void SetAlpha ( Uint8 _alpha );

    virtual void Bind () = 0;

    virtual bool Upload () = 0;
};

#include "Graphics/texture_directx.h"
#include "Graphics/texture_opengl.h"

#endif
