/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_texture_opengl_h
#define __included_texture_opengl_h

#include "Graphics/opengl.h"
#include "Graphics/graphics_opengl.h"
#include "Graphics/texture.h"

class OpenGLTexture : public Texture
{
private:
    GLuint       m_textureID;

public:
    OpenGLTexture();
    OpenGLTexture ( SDL_Surface *_surface );
    ~OpenGLTexture();

    bool Create ( Uint16 _width, Uint16 _height, bool _isColorKeyed );
    void Dispose ();

    void Bind ();

    bool Upload ();

    friend class OpenGLGraphics;
};

#endif
