/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "Graphics/graphics.h"
#include "App/app.h"

#if defined ( TARGET_COMPILER_VC ) || defined ( TARGET_COMPILER_ICC )
// SDL Dependencies
#    pragma comment (lib, "advapi32.lib")
#    pragma comment (lib, "gdi32.lib")
#    pragma comment (lib, "shell32.lib")
#    pragma comment (lib, "user32.lib")

// SDL
#    pragma comment (lib, "SDL.lib")
#    pragma comment (lib, "SDLmain.lib")
#    pragma comment (lib, "SDL_image.lib")
#    pragma comment (lib, "dxguid.lib")
#    pragma comment (lib, "libpng.lib")
#    pragma comment (lib, "winmm.lib")
#    pragma comment (lib, "zlib.lib")
#endif

Graphics::Graphics()
 : m_windowed(false), m_screenX(0), m_screenY(0), m_colorDepth(0),
   m_centerX(0), m_centerY(0), m_colorKey(0), m_colorKeySet(false)
{
}

Graphics::~Graphics()
{
}

Sint32 Graphics::GetCenterX()
{
    return m_centerX;
}

Sint32 Graphics::GetCenterY()
{
    return m_centerY;
}

Sint32 Graphics::GetScreenWidth()
{
    return m_screenX;
}

Sint32 Graphics::GetScreenHeight()
{
    return m_screenY;
}

Uint32 Graphics::GetColorKey()
{
    ARCReleaseAssert ( m_colorKeySet );
    return m_colorKey;
}

Graphics *g_graphics;
