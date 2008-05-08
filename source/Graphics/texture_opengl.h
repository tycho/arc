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
