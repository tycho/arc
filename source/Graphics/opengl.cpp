/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "App/preferences.h"
#include "Graphics/opengl.h"

#if defined ( TARGET_COMPILER_VC ) || defined ( TARGET_COMPILER_ICC )
#    pragma comment (lib, "opengl32.lib")
#endif

#ifndef GL_TEXTURE_RECTANGLE_ARB
#    define GL_TEXTURE_RECTANGLE_ARB            0x84F5
#endif

OpenGL *g_openGL = NULL;

OpenGL::OpenGL()
:  m_textureEnabled(false),
   m_renderPath(RENDER_PATH_VERTEX_ARRAY),
   m_boundTexture(0),
   m_clientStateVertexArray(false),
   m_clientStateTexCoordArray(false)
{
    ARCReleaseAssert ( g_openGL == NULL );
    m_vendorString     = cc_strdup((const char *)glGetString ( GL_VENDOR     ));
    m_rendererString   = cc_strdup((const char *)glGetString ( GL_RENDERER   ));
    m_versionString    = cc_strdup((const char *)glGetString ( GL_VERSION    ));
    m_extensionsString = cc_strdup((const char *)glGetString ( GL_EXTENSIONS ));
    SetupExtensions();
    SetupVersion();
}

OpenGL::~OpenGL()
{
    while ( m_freeTextures.count() )
    {
        GLuint texid = m_freeTextures.pop();
        glDeleteTextures ( 1, &texid );
    }
    free ( m_vendorString );     m_vendorString     = NULL;
    free ( m_rendererString );   m_rendererString   = NULL;
    free ( m_versionString );    m_versionString    = NULL;
    free ( m_extensionsString ); m_extensionsString = NULL;
}

void OpenGL::SetupVersion()
{
	ARCDebugAssert ( this );
    Uint16 index = 0;
    memset ( m_version, 0, sizeof ( m_version ) );
    char *tmp = cc_strdup(m_versionString);
    char *ptr = strtok ( tmp, "." );
    do
    {
        if ( !ptr ) break;
        m_version[index++] = atoi ( ptr );
    } while ( index < 8 && ( ptr = strtok ( NULL, "." ) ) != NULL );
    free ( tmp );
}

void OpenGL::SetupExtensions()
{
	ARCDebugAssert ( this );
    //
    // Find the actual extensions and add them to the tree.
    char *ptr = strtok ( m_extensionsString, " " );
    do
    {
        m_extensions.insert ( ptr, 1 );
    } while ( ( ptr = strtok ( NULL, " " ) ) != NULL );

    if ( g_prefsManager->GetInt ( "DumpOpenGLInfo", 0 ) != 0 )
    {
        //
        // We want to print out an OpenGL extension list along with
        // graphics card information.

        g_console->Write ( "Saving OpenGL information... " );

        FILE *file = fopen ( "opengl-info.txt", "wt" );
        if ( !file ) {
            g_console->WriteLine ( "FAILED" );
            return;
        }
        fprintf ( file, "OpenGL Vendor: %s\nOpenGL Renderer: %s\nOpenGL Version: %s\n\n"
            "Supported OpenGL Extensions\n\n",
            m_vendorString, m_rendererString, m_versionString );

        //
        // Convert to DArray because the spec does not require that
        // the extension list be given sorted, and we want the output
        // to be sorted.
        Data::DArray<const char *> *data = m_extensions.ConvertIndexToDArray();
        for ( size_t i = 0; i < data->size(); i++ )
        {
            if ( !data->valid ( i ) ) continue;
            fprintf ( file, "%s\n", data->get ( i ) );
        }
        delete data;

        fclose ( file );
        g_console->WriteLine ( "OK" );
    }

    int renderPreference = g_prefsManager->GetInt ( "RenderMode", 0 );
    if ( renderPreference < m_renderPath && renderPreference >= 0 )
    {
        m_renderPath = (renderPath)renderPreference;
    }
}

bool OpenGL::ExtensionIsSupported ( const char *_extension )
{
	ARCDebugAssert ( this );
    return m_extensions.exists ( _extension );
}

void OpenGL::FillTextureStack ()
{
	ARCDebugAssert ( this );
    GLuint textures[64];
    glGenTextures ( 64, textures );
    ASSERT_OPENGL_ERRORS;
    for ( int i = 0; i < 64; i++ )
        m_freeTextures.push ( textures[i] );
}

GLuint OpenGL::GetFreeTexture ()
{
	ARCDebugAssert ( this );
    if ( !m_freeTextures.count() )
        FillTextureStack();
    ARCReleaseAssert ( m_freeTextures.count() );
    return m_freeTextures.pop();
}

void OpenGL::FreeTexture ( GLuint _texture )
{
	ARCDebugAssert ( this );
    m_freeTextures.push ( _texture );
}

Uint16 OpenGL::GetVersionMajor() const
{
	ARCDebugAssert ( this );
    return m_version[0];
}

Uint16 OpenGL::GetVersionMinor() const
{
	ARCDebugAssert ( this );
    return m_version[1];
}

const char *OpenGL::GetRenderer() const
{
	ARCDebugAssert ( this );
    return m_rendererString;
}

const char *OpenGL::GetVersion() const
{
    return m_versionString;
}

const char *OpenGL::GetVendor() const
{
	ARCDebugAssert ( this );
    return m_vendorString;
}

Uint16 OpenGL::GetMaximumTextureSize() const
{
	ARCDebugAssert ( this );
    static GLint maxTextureSize = -1;
    if ( maxTextureSize == -1 )
    {
        glGetIntegerv ( GL_MAX_TEXTURE_SIZE, &maxTextureSize );
        ASSERT_OPENGL_ERRORS;
    }
    return maxTextureSize;
}

renderPath OpenGL::GetRenderPath() const
{
	ARCDebugAssert ( this );
    return m_renderPath;
}

void OpenGL::VertexArrayStatePrimitive ()
{
	ARCDebugAssert ( this );
    if (!m_clientStateVertexArray)
    {
        glEnableClientState ( GL_VERTEX_ARRAY );
        ASSERT_OPENGL_ERRORS;
        m_clientStateVertexArray = true;
    }
    if (m_clientStateTexCoordArray)
    {
        glDisableClientState ( GL_TEXTURE_COORD_ARRAY );
        ASSERT_OPENGL_ERRORS;
        m_clientStateTexCoordArray = false;
    }
}

void OpenGL::VertexArrayStateTexture ()
{
	ARCDebugAssert ( this );
    if (!m_clientStateVertexArray)
    {
        glEnableClientState ( GL_VERTEX_ARRAY );
        ASSERT_OPENGL_ERRORS;
        m_clientStateVertexArray = true;
    }
    if (!m_clientStateTexCoordArray)
    {
        glEnableClientState ( GL_TEXTURE_COORD_ARRAY );
        ASSERT_OPENGL_ERRORS;
        m_clientStateTexCoordArray = true;
    }
}

void OpenGL::VertexArrayStateOff ()
{
	ARCDebugAssert ( this );
    if (m_clientStateVertexArray)
    {
        glDisableClientState ( GL_VERTEX_ARRAY );
        ASSERT_OPENGL_ERRORS;
        m_clientStateVertexArray = false;
    }
    if (m_clientStateTexCoordArray)
    {
        glDisableClientState ( GL_TEXTURE_COORD_ARRAY );
        ASSERT_OPENGL_ERRORS;
        m_clientStateTexCoordArray = false;
    }
}

void OpenGL::ActivateWhiteWithAlpha ( Uint8 alpha )
{
	ARCDebugAssert ( this );
    glColor4ub ( 0xFF, 0xFF, 0xFF, alpha );
    ASSERT_OPENGL_ERRORS;
}

void OpenGL::ActivateColour ( Uint32 col )
{
	ARCDebugAssert ( this );
#if SDL_BYTEORDER == SDL_LIL_ENDIAN
    // Needs RGBA. SDL uses BGRA??
    col = (col & 0xFF00FF00) | ((col & 0x00FF0000) >> 16) | ((col & 0x000000FF) << 16);
#endif

    glColor4ubv ( (GLubyte *)&col );
    ASSERT_OPENGL_ERRORS;
}

void OpenGL::ActivateTextureRect ()
{
	ARCDebugAssert ( this );
    if (!m_textureEnabled)
    {
        glEnable ( GetTextureTarget() );
        ASSERT_OPENGL_ERRORS;
        m_textureEnabled = true;
    }
}

void OpenGL::DeactivateTextureRect ()
{
	ARCDebugAssert ( this );
    if (m_textureEnabled)
    {
        glDisable ( GetTextureTarget() );
        ASSERT_OPENGL_ERRORS;
        m_textureEnabled = false;
    }
}

void OpenGL::BindTexture ( GLuint _textureID )
{
	ARCDebugAssert ( this );
    ARCReleaseAssert ( _textureID != SCREEN_SURFACE_ID );
    ARCReleaseAssert ( _textureID != INVALID_SURFACE_ID );
    ARCReleaseAssert ( _textureID != 0 );
    if ( _textureID != m_boundTexture )
    {
        glBindTexture ( GetTextureTarget(), _textureID );
        ASSERT_OPENGL_ERRORS;
        m_boundTexture = _textureID;
    }
}

GLenum OpenGL::GetTextureTarget() const
{
	ARCDebugAssert ( this );
    if ( GetSetting ( OPENGL_USE_TEXTURE_RECTANGLES, false ) )
        return GL_TEXTURE_RECTANGLE_ARB;
    else
        return GL_TEXTURE_2D;
}

GLint OpenGL::GetInternalFormat24() const
{
	ARCDebugAssert ( this );
    if ( GetSetting ( OPENGL_TEX_S3_COMPRESSION, false ) )
        return GL_COMPRESSED_RGB_S3TC_DXT1_EXT;
    if ( GetSetting ( OPENGL_TEX_3DFX_COMPRESSION, false ) )
        return GL_COMPRESSED_RGB_FXT1_3DFX;
    return GL_RGB;
}

GLint OpenGL::GetInternalFormat32() const
{
	ARCDebugAssert ( this );
    if ( GetSetting ( OPENGL_TEX_S3_COMPRESSION, false ) )
        return GL_COMPRESSED_RGBA_S3TC_DXT5_EXT;
    if ( GetSetting ( OPENGL_TEX_3DFX_COMPRESSION, false ) )
        return GL_COMPRESSED_RGBA_FXT1_3DFX;
    return GL_RGBA;
}

void OpenGL::SetSetting ( openglSetting _setting, bool _value )
{
	ARCDebugAssert ( this );
    if ( m_settings.exists ( _setting ) )
        m_settings.replace ( _setting, _value );
    else
        m_settings.insert ( _setting, _value );
}

bool OpenGL::GetSetting ( openglSetting _setting, bool _default ) const
{
	ARCDebugAssert ( this );
    bool item = m_settings.find ( _setting, _default );
    return item;
}
