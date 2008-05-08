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

#ifndef __included_texture_directx_h
#define __included_texture_directx_h

#ifdef ENABLE_DIRECT3D

#include "Graphics/graphics_directx.h"
#include "Graphics/texture.h"

class DirectXTexture : public Texture
{
private:
	IDirect3DTexture9		*m_texture;

public:
    DirectXTexture();
    ~DirectXTexture();

	bool Load ( const char *_filename, bool _isColorKeyed );
    bool Create ( Uint16 _width, Uint16 _height, bool _isColorKeyed );
    void Dispose ();

    void Bind ();

    bool Upload ();

    friend class DirectXGraphics;
};

#endif

#endif
