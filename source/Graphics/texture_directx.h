/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
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
	bool Reset ();
    bool Upload ();

    friend class DirectXGraphics;
};

#endif

#endif
