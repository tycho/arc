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

#if !defined ( TARGET_OS_WINDOWS )
#    define _putenv putenv
#endif

#include "App/app.h"
#include "Graphics/graphics_sdl.h"

SDLGraphics::SDLGraphics ( const char *_graphicsDriver )
 : Graphics(), m_mainSurface(-1)
{
    if ( _graphicsDriver )
    {

        // Try the provided video driver.
        g_console->WriteLine ( "Attempting to use SDL video driver '%s'.", _graphicsDriver );
        char tempEnv[128];
        sprintf ( tempEnv, "SDL_VIDEODRIVER=%s", _graphicsDriver );
        _putenv( tempEnv );

        if ( SDL_Init ( SDL_INIT_VIDEO ) != 0 )
        {
            g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "Failed to use video driver '%s', falling back to default.", _graphicsDriver );
            g_console->SetColour ();

            // Fallback to default video driver
#if !defined ( TARGET_OS_WINDOWS )
            unsetenv ( "SDL_VIDEODRIVER" );
#else
            // TODO: using _putenv to default it doesn't seem to work... Correct this.
            sprintf ( tempEnv, "SDL_VIDEODRIVER=" );
            _putenv ( tempEnv );
#endif
            ARCReleaseAssert ( SDL_Init ( SDL_INIT_VIDEO ) == 0 );
        }
    } else {
        ARCReleaseAssert ( SDL_Init ( SDL_INIT_VIDEO ) == 0 );
    }
    char name[256];
    SDL_VideoDriverName ( name, 256 );
    g_console->WriteLine ( "Using video driver '%s'", name );
}

SDLGraphics::~SDLGraphics()
{
    for ( size_t i = 0; i < m_surfaces.size(); i++ )
    {
        if ( m_surfaces.valid(i) )
        {
            SDL_FreeSurface ( m_surfaces[i] );
            m_surfaces.remove ( i );
        }
    }
    SDL_Quit ();
}

const char *SDLGraphics::RendererName()
{
	static char renderer[64] = {'\0'};
	if ( !strlen ( renderer ) )
	{
		sprintf ( renderer, "SDL v%d.%d.%d (engine v%d.%d)",
			SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL,
			m_rendererVersionMajor, m_rendererVersionMinor );
	}
	return renderer;
}


void SDLGraphics::ShowCursor ( bool _show )
{
    SDL_ShowCursor ( _show );
}

Uint16 SDLGraphics::GetMaximumTextureSize()
{
    // We have know way of knowing this, yet.

    // Return our best guess (works on hardware we've tested).
    return 4096;
}

void SDLGraphics::DrawLine ( Uint32 _surfaceID, Uint32 _color, int _startX, int _startY, int _stopX, int _stopY )
{
    ARCAbort ( "SDLGraphics::DrawLine() is not implemented." );
    float stopX = (float)cc_max(_stopX,_startX),
          startX = (float)cc_min(_stopX,_startX),
          stopY = (float)cc_max(_stopY,_startY),
          startY = (float)cc_min(_stopY,_startY);
    float xdistance = (stopX - startX),
          ydistance = (stopY - startY),
          distance = sqrtf((xdistance * xdistance) + (ydistance * ydistance));
    float xstep = (stopX - startX) / distance,
          ystep = (stopY - startY) / distance;
    for ( float x = startX, y = startY; x <= stopX && y <= stopY; x += xstep, y += ystep )
    {
        SetPixel ( _surfaceID, (int)x, (int)y, _color );
    }
}

void SDLGraphics::SetPixel ( SDL_Surface *surface, int x, int y, Uint32 pixel )
{
    ARCReleaseAssert ( surface != NULL );
    if ( x < 0 || y < 0 ) return;
    if ( x >= surface->w || y >= surface->h ) return ;

    SDL_LockSurface ( surface );

    int bpp = surface->format->BytesPerPixel;

    ARCReleaseAssert ( surface->pixels != NULL );

    /* Here p is the address to the pixel we want to set */
    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;

    switch(bpp) {
    case 1:
        *p = pixel;
        break;

    case 2:
        *(Uint16 *)p = pixel;
        break;

    case 3:
        if(SDL_BYTEORDER == SDL_BIG_ENDIAN) {
            p[0] = (pixel >> 16) & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = pixel & 0xff;
        } else {
            p[0] = pixel & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = (pixel >> 16) & 0xff;
        }
        break;

    case 4:
        *(Uint32 *)p = pixel;
        break;
    }

    SDL_UnlockSurface ( surface );
}

Uint32 SDLGraphics::GetPixel(SDL_Surface *surface, int x, int y)
{
    ARCReleaseAssert ( surface != NULL );
    if ( x < 0 || y < 0 ) return 0;
    if ( x >= surface->w || y >= surface->h ) return 0;

    bool isLocked = false;

    /* Lock only when absolutely necessary. We hate slowness. */
    if ( !surface->pixels )
    {
        SDL_LockSurface ( surface );
        isLocked = true;
    }

    int bpp = surface->format->BytesPerPixel;

    /* Here p is the address to the pixel we want to retrieve */
    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;
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
        SDL_UnlockSurface ( surface );

    return pixel;
}

Uint32 SDLGraphics::GetPixel ( Uint32 _surfaceID, int x, int y )
{
    return GetPixel ( m_surfaces.get ( _surfaceID ), x, y );
}

void SDLGraphics::SetPixel ( Uint32 _surfaceID, int x, int y, Uint32 color )
{
    SetPixel ( m_surfaces.get ( _surfaceID ), x, y, color );
}

Uint32 SDLGraphics::LoadImage ( const char *_filename, bool _isColorKeyed )
{
    SDL_Surface *loadSurface, *compatibleSurface;
    loadSurface = g_app->m_resource->GetImage ( _filename );
    if ( !loadSurface ) {
        g_console->SetColour ( IO::Console::FG_RED | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "IMG_Load: %s", IMG_GetError() );
    }
    ARCReleaseAssert ( loadSurface != NULL );
    compatibleSurface = SDL_DisplayFormat ( loadSurface );
    if ( !compatibleSurface ) {
        g_console->SetColour ( IO::Console::FG_RED | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "SDL_DisplayFormat: %s", IMG_GetError() );
    }
    ARCReleaseAssert ( compatibleSurface != NULL );
    SDL_FreeSurface ( loadSurface );

    if ( _isColorKeyed && m_colorKeySet )
    {
        SDL_SetColorKey ( compatibleSurface, SDL_SRCCOLORKEY | SDL_RLEACCEL, m_colorKey );
    }
    //SDL_SetAlpha ( compatibleSurface, 0, SDL_ALPHA_OPAQUE );

    size_t retval = m_surfaces.insert ( compatibleSurface );

    return (Uint32)retval;
}

int SDLGraphics::DeleteSurface ( Uint32 _surfaceID )
{
    if ( !m_surfaces.valid ( _surfaceID ) ) return -1;
    
    SDL_Surface *surface = m_surfaces.get ( _surfaceID );
    ARCReleaseAssert ( surface != NULL );

    SDL_FreeSurface ( surface );

    m_surfaces.remove ( _surfaceID );

    return 0;
}

Uint32 SDLGraphics::CreateSurface ( Uint32 _width, Uint32 _height, bool _isColorKeyed )
{
#ifdef USE_GLSDL
    _isColorKeyed = true;
#endif
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( _width > 0 ); ARCReleaseAssert ( _height > 0 );

    Uint32 rmask, gmask, bmask, amask, flags;
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
    flags = SDL_HWSURFACE | SDL_SRCCOLORKEY | SDL_RLEACCEL;

    SDL_Surface *newSurface, *compatibleSurface;

    newSurface = SDL_CreateRGBSurface ( flags, _width, _height, 
        m_surfaces.get(m_mainSurface)->format->BitsPerPixel, rmask, gmask, bmask, amask );
    ARCReleaseAssert ( newSurface != NULL );

    compatibleSurface = SDL_DisplayFormat ( newSurface );
    ARCReleaseAssert ( compatibleSurface != NULL );

    SDL_FreeSurface ( newSurface );

    SDL_FillRect ( compatibleSurface, NULL, m_colorKey );
    if ( _isColorKeyed && m_colorKeySet )
    {
        SDL_SetColorKey ( compatibleSurface, SDL_SRCCOLORKEY | SDL_RLEACCEL, m_colorKey );
    }
    //SDL_SetAlpha ( compatibleSurface, 0, SDL_ALPHA_OPAQUE );

    size_t retval = m_surfaces.insert ( compatibleSurface );

    return (Uint32)retval;
}

int SDLGraphics::SetColorKey ( Uint32 _colour )
{    
    m_colorKey = _colour;
    m_colorKeySet = true;

    return 0;
}

void SDLGraphics::ApplyColorKey ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _surfaceID ) );

	SDL_Surface *surface = m_surfaces.get ( _surfaceID );
	SDL_SetColorKey ( surface, SDL_SRCCOLORKEY | SDL_RLEACCEL, m_colorKey );
}

int SDLGraphics::FillRect ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 _color )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _surfaceID ) );

    SDL_Surface *surface = m_surfaces.get ( _surfaceID );
    ARCReleaseAssert ( surface != NULL );

    return SDL_FillRect ( surface, _destRect, _color );
}

int SDLGraphics::Blit ( Uint32 _sourceSurfaceID, SDL_Rect const *_sourceRect,
                        Uint32 _destSurfaceID,   SDL_Rect const *_destRect )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _sourceSurfaceID ) );
    ARCReleaseAssert ( m_surfaces.valid ( _destSurfaceID ) );

    SDL_Surface *fromSurface, *toSurface;

    fromSurface = m_surfaces.get ( _sourceSurfaceID );
    ARCReleaseAssert ( fromSurface != NULL );

    toSurface = m_surfaces.get ( _destSurfaceID );
    ARCReleaseAssert ( toSurface != NULL );

    return SDL_BlitSurface ( fromSurface, (SDL_Rect *)_sourceRect, toSurface, (SDL_Rect *)_destRect );
}

void SDLGraphics::ReplaceColour ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 findcolor, Uint32 replacecolor )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _surfaceID ) );
    SDL_Surface *s = m_surfaces.get ( _surfaceID );
    ARCReleaseAssert ( s != NULL );

    int x1 = _destRect->x,
        x2 = _destRect->x + _destRect->w,
        y1 = _destRect->y,
        y2 = _destRect->y + _destRect->h;

    SDL_LockSurface(s);
    for ( int y = y1; y < y2; y++ ) {
        for ( int x = x1; x < x2; x++ ) {
            if ( GetPixel ( s, x, y ) == findcolor )
                SetPixel ( s, x, y, replacecolor );
        }
    }
    SDL_UnlockSurface(s);
}

SDL_PixelFormat *SDLGraphics::GetPixelFormat ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _surfaceID ) );
    SDL_Surface *surface = m_surfaces.get ( _surfaceID );
    ARCReleaseAssert ( surface != NULL );

    return surface->format;
}

Uint32 SDLGraphics::GetSurfaceHeight ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _surfaceID ) );
    SDL_Surface *surface = m_surfaces.get ( _surfaceID );
    ARCReleaseAssert ( surface != NULL );

    return surface->h;
}

Uint32 SDLGraphics::GetSurfaceWidth ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _surfaceID ) );
    SDL_Surface *surface = m_surfaces.get ( _surfaceID );
    ARCReleaseAssert ( surface != NULL );

    return surface->w;
}

Uint32 SDLGraphics::GetScreen ()
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    return m_mainSurface;
}

int SDLGraphics::SetSurfaceAlpha ( Uint32 _surfaceID, Uint8 _alpha )
{
    ARCReleaseAssert ( (int)m_mainSurface != -1 );
    ARCReleaseAssert ( m_surfaces.valid ( _surfaceID ) );
    SDL_Surface *surface = m_surfaces.get ( _surfaceID );

    return SDL_SetAlpha ( surface, SDL_SRCALPHA, _alpha );
}

int SDLGraphics::SetWindowMode ( bool _windowed, Sint16 _width, Sint16 _height, Uint8 _colorDepth )
{
    ARCReleaseAssert ( (int)m_mainSurface == -1 );

    if ( _width < 640 || _width > 800 || _height < 480 || _height > 600 )
    {
        _width = 800;
        _height = 600;
    }

    if ( _colorDepth < 16 || _colorDepth > 32 ) _colorDepth = 16;

    m_windowed = _windowed;

    m_screenX = _width;
    m_screenY = _height;

    m_centerX = m_screenX / 2;
    m_centerY = m_screenY / 2;

    const SDL_VideoInfo* info = NULL;
    info = SDL_GetVideoInfo ();
    ARCReleaseAssert ( info != NULL );

    m_colorDepth = _colorDepth;

    g_console->WriteLine ( "The requested color depth is %d, and we're using %d.", _colorDepth, m_colorDepth );

    g_console->WriteLine ( "Setting display mode of %dx%dx%d...", _width, _height, m_colorDepth );

    Uint32 flags = SDL_HWSURFACE | SDL_DOUBLEBUF;

    if ( !m_windowed ) flags |= SDL_FULLSCREEN;

#ifdef USE_GLSDL
    flags |= SDL_GLSDL;
#endif

    m_mainSurface = m_surfaces.insert ( SDL_SetVideoMode ( _width, _height, m_colorDepth, flags ) );
    ARCReleaseAssert ( m_surfaces.get ( m_mainSurface ) != NULL );
    g_console->WriteLine ( "Display mode set successfully.");

    const char *windowTitle = APP_NAME " v" VERSION_NUMBER " build " VERSION_BUILD;
    SDL_WM_SetCaption ( windowTitle, NULL );
#ifdef TARGET_OS_WINDOWS
    if ( _windowed )
    {
        HWND hwnd = FindWindow ( NULL, windowTitle );
        RECT workArea, window;
        GetWindowRect ( hwnd, &window ); 
        SystemParametersInfo ( SPI_GETWORKAREA, 0, &workArea, 0 );
        Uint32 left = workArea.right - (window.right - window.left) - 20;
        Uint32 top =  ( (workArea.top + workArea.bottom) - (window.bottom - window.top) ) / 2;
        SetWindowPos ( hwnd, HWND_TOP, left, top, 0, 0, SWP_NOSIZE );
    }
#endif

    g_console->Write ( "Are the SDL surfaces hardware accelerated? " );
    if ( m_surfaces.get ( m_mainSurface )->flags & SDL_HWSURFACE )
    {
        g_console->SetColour ( IO::Console::FG_GREEN | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "Yes" );
        g_console->SetColour ();
    } else {
        g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "No" );
        g_console->WriteLine ( "WARNING: No hardware acceleration. This may cause unacceptable performance." );
        g_console->SetColour ();
    }

    g_console->Write ( "Is SDL using double buffering as expected? " );
    if ( m_surfaces.get ( m_mainSurface )->flags & SDL_DOUBLEBUF )
    {
        g_console->SetColour ( IO::Console::FG_GREEN | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "Yes" );
        g_console->SetColour ();
    } else {
        g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "No" );
        g_console->WriteLine ( "WARNING: Not using double buffering. This may cause graphical glitches." );
        g_console->SetColour ();
    }

    return 0;
}

bool SDLGraphics::Flip()
{
    if ( m_windowed )
        SDL_UpdateRect ( m_surfaces.get(m_mainSurface), 0, 0, 0, 0 );
    else
        return SDL_Flip ( m_surfaces.get(m_mainSurface) ) == 0;
	return true;
}
