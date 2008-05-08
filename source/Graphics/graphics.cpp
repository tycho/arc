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
