/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "Graphics/opengl.h"
#include "Graphics/texture_opengl.h"

OpenGLTexture::OpenGLTexture ()
 : Texture(),
   m_textureID(INVALID_SURFACE_ID)
{
}

OpenGLTexture::OpenGLTexture ( SDL_Surface *_surface )
 : Texture(_surface),
   m_textureID(INVALID_SURFACE_ID)
{
}

OpenGLTexture::~OpenGLTexture()
{
}

void OpenGLTexture::Dispose()
{
    if ( m_textureID != INVALID_SURFACE_ID &&
         m_textureID != SCREEN_SURFACE_ID )
    {
	    g_openGL->ActivateTextureRect();
        Bind();
        glTexImage2D ( g_openGL->GetTextureTarget(), 0, g_openGL->GetInternalFormat32(), 0, 0, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL );
        ASSERT_OPENGL_ERRORS;

        g_openGL->FreeTexture ( m_textureID );
        m_textureID = INVALID_SURFACE_ID;
    }

	Texture::Dispose();
}

bool OpenGLTexture::Create ( Uint16 _width, Uint16 _height, bool _isColorKeyed )
{
    ARCReleaseAssert ( m_textureID != SCREEN_SURFACE_ID );
    ARCReleaseAssert ( _width > 0 ); ARCReleaseAssert ( _height > 0 );
    
    Uint32 oldWidth = _width, oldHeight = _height;
    if ( !g_openGL->GetSetting ( OPENGL_TEX_ALLOW_NPOT ) ) {
        if ( !isPowerOfTwo ( _width ) )
            _width = nearestPowerOfTwo ( _width );
        if ( !isPowerOfTwo ( _height ) )
            _height = nearestPowerOfTwo ( _height );
        ARCReleaseAssert ( isPowerOfTwo ( _width * _height ) );
    }

    Uint32 rmask, gmask, bmask, amask;
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
    rmask = 0xff000000;
    gmask = 0x00ff0000;
    bmask = 0x0000ff00;
    amask = 0x000000ff;
#else
    rmask = 0x000000ff;
    gmask = 0x0000ff00;
    bmask = 0x00ff0000;
    amask = 0xff000000;
#endif

    m_sdlSurface = SDL_CreateRGBSurface ( SDL_SWSURFACE, _width, _height, 32, rmask, gmask, bmask, amask );
    ARCReleaseAssert ( m_sdlSurface != NULL );

    SDL_SetAlpha ( m_sdlSurface, 0, SDL_ALPHA_OPAQUE );
        
    m_textureID = g_openGL->GetFreeTexture();
    ARCReleaseAssert ( m_textureID != 0 );
    ASSERT_OPENGL_ERRORS;

    Bind();

    glTexParameteri ( g_openGL->GetTextureTarget(), GL_TEXTURE_MIN_FILTER, GL_LINEAR ); // set up for linear scaling
    ASSERT_OPENGL_ERRORS;
    glTexParameteri ( g_openGL->GetTextureTarget(), GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    ASSERT_OPENGL_ERRORS;

    g_openGL->VertexArrayStateTexture();

    m_originalWidth = oldWidth;
    m_originalHeight = oldHeight;

    Damage ();

    return true;
}

void OpenGLTexture::Bind()
{
    ARCReleaseAssert ( m_textureID != SCREEN_SURFACE_ID );
    g_openGL->BindTexture ( m_textureID );
}

bool OpenGLTexture::Upload()
{
    ARCReleaseAssert ( m_textureID != SCREEN_SURFACE_ID );
    if ( !m_damaged ) return false;

    ARCReleaseAssert ( m_sdlSurface != NULL );
    ARCReleaseAssert ( m_textureID != 0 );

	if ( !g_openGL->GetSetting ( OPENGL_TEX_ALLOW_NPOT ) )
    {
        if ( !isPowerOfTwo ( m_sdlSurface->w ) ) {
            g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "WARNING: OpenGLTexture has a width of %u (NOT a power of two)", m_sdlSurface->w );
            g_console->SetColour ();
        }
        if ( !isPowerOfTwo ( m_sdlSurface->h ) ) {
            g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "WARNING: OpenGLTexture has a height of %u (NOT a power of two)", m_sdlSurface->h );
            g_console->SetColour ();
        }
    }
	
#ifdef _DEBUG
	if ( m_sdlSurface->w > g_graphics->GetMaximumTextureSize() )
	{
        g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
		g_console->WriteLine ( "WARNING: Uploading texture with width larger than hardware supported size." );
        g_console->SetColour ();
	}
	if ( m_sdlSurface->h > g_graphics->GetMaximumTextureSize() )
	{
        g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
		g_console->WriteLine ( "WARNING: Uploading texture with height larger than hardware supported size." );
        g_console->SetColour ();
	}
#endif

	g_openGL->ActivateTextureRect();
    Bind();
    glPixelStorei ( GL_UNPACK_ROW_LENGTH, m_sdlSurface->pitch / m_sdlSurface->format->BytesPerPixel );
    ASSERT_OPENGL_ERRORS;
    
    switch ( m_sdlSurface->format->BytesPerPixel )
    {
        case 1: // palette-based sprite!?
            ARCReleaseAssert(false);
            break;
        case 2: // VERY low quality
            ARCReleaseAssert(false);
            break;
        case 3:
            glTexImage2D ( g_openGL->GetTextureTarget(), 0, g_openGL->GetInternalFormat24(),
                m_sdlSurface->w, m_sdlSurface->h, 0, GL_RGB, GL_UNSIGNED_BYTE, m_sdlSurface->pixels );
            break;
        case 4:
            glTexImage2D ( g_openGL->GetTextureTarget(), 0, g_openGL->GetInternalFormat32(),
                m_sdlSurface->w, m_sdlSurface->h, 0, GL_RGBA, GL_UNSIGNED_BYTE, m_sdlSurface->pixels );
            break;
    }

    ARCDebugAssert ( glIsTexture ( m_textureID ) );

    ASSERT_OPENGL_ERRORS;

    m_damaged = false;

    return true;
}
