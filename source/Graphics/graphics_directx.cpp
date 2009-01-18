/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#ifdef ENABLE_DIRECT3D

#include "App/app.h"
#include "App/preferences.h"
#include "Graphics/font_directx.h"
#include "Graphics/graphics_directx.h"

DirectXGraphics::DirectXGraphics()
 : Graphics(),
   m_deviceLost(false),
   m_sdlScreen(NULL),
   m_d3d(NULL),
   m_device(NULL),
   m_vertexBuffer(NULL)
{
    int retval = SDL_Init ( SDL_INIT_VIDEO );
    ARCReleaseAssert ( retval == 0 );
}

DirectXGraphics::~DirectXGraphics()
{
	size_t i;
    for ( i = 0; i < m_textures.size(); i++ )
    {
        if ( m_textures.valid(i) )
        {
            DirectXTexture *tex = m_textures[i];
            m_textures.remove ( i );
            delete tex;
        }
    }
	if ( m_vertexBuffer )
		m_vertexBuffer->Release();
	if ( m_device )
		m_device->Release();
	if ( m_d3d )
		m_d3d->Release();

    delete g_openGL;
    g_openGL = NULL;

    SDL_Quit ();
}

const char *DirectXGraphics::RendererName()
{
	static char renderer[64] = {'\0'};
	if ( !strlen ( renderer ) )
	{
		sprintf ( renderer, "Direct3D 9 (engine v%d.%d)",
			m_rendererVersionMajor, m_rendererVersionMinor );
	}
	return renderer;
}

Uint32 DirectXGraphics::CreateFont ( const char *_fontFace, int _height, bool _bold, bool _italic )
{
#ifdef ENABLE_FONTS
	return m_fonts.insert(new DirectXFont(_fontFace, _height, _bold, _italic));
#else
	return 0;
#endif
}

void DirectXGraphics::DrawText ( Uint32 _font, Uint16 _x, Uint16 _y, const char *_text, Uint32 _color, bool _center )
{
#ifdef ENABLE_FONTS
	DirectXFont *font = m_fonts[_font];
	CoreAssert ( font );

	font->Draw(_x, _y, _text, _color, _center);
#endif
}

void DirectXGraphics::DrawRect ( SDL_Rect *_pos, Uint32 _color )
{
    CoreAssert ( _pos );
	DXVertex *vertices;

	if ( m_deviceLost)
		return;

	D3DCOLOR vertexColour = _color | FULL_ALPHA;

	m_vertexBuffer->Lock(0, 0, (void **)&vertices, NULL);

	vertices[0].x = _pos->x;
	vertices[0].y = _pos->y;
	vertices[0].z = 0.0f;
	vertices[0].colour = vertexColour;
	vertices[0].rhw = 1.0f;
	vertices[0].v = 0.0f;
	vertices[0].u = 0.0f;

	vertices[1].x = _pos->x + _pos->w;
	vertices[1].y = _pos->y;
	vertices[1].z = 0.0f;
	vertices[1].colour = vertexColour;
	vertices[1].rhw = 1.0f;
	vertices[1].v = 0.0f;
	vertices[1].u = 0.0f;

	vertices[2].x = _pos->x + _pos->w;
	vertices[2].y = _pos->y + _pos->h;
	vertices[2].z = 0.0f;
	vertices[2].colour = vertexColour;
	vertices[2].rhw = 1.0f;
	vertices[2].v = 0.0f;
	vertices[2].u = 0.0f;

	vertices[3].x = _pos->x;
	vertices[3].y = _pos->y + _pos->h;
	vertices[3].z = 0.0f;
	vertices[3].colour = vertexColour;
	vertices[3].rhw = 1.0f;
	vertices[3].v = 0.0f;
	vertices[3].u = 0.0f;

	vertices[4].x = _pos->x;
	vertices[4].y = _pos->y;
	vertices[4].z = 0.0f;
	vertices[4].colour = vertexColour;
	vertices[4].rhw = 1.0f;
	vertices[4].v = 0.0f;
	vertices[4].u = 0.0f;

	m_vertexBuffer->Unlock();

	m_device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG2);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

	m_device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG2);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);
 
	m_device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
	m_device->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);

	m_device->DrawPrimitive(D3DPT_LINESTRIP, 0, 4);

	m_device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

	m_device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

	m_device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
	m_device->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
}

void DirectXGraphics::ShowCursor ( bool _show )
{
    SDL_ShowCursor ( _show );
}

int DirectXGraphics::SetSurfaceAlpha ( Uint32 _surfaceID, Uint8 alpha )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );
    ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );
    
    m_textures.get ( _surfaceID )->SetAlpha ( alpha );
    
    return 0;
}

void DirectXGraphics::DrawLine ( Uint32 _surfaceID, Uint32 _color, int _startX, int _startY, int _stopX, int _stopY )
{
    CoreAssert ( _surfaceID == SCREEN_SURFACE_ID );
	DXVertex *vertices;

	if ( m_deviceLost)
		return;

	D3DCOLOR vertexColour = _color | FULL_ALPHA;

	m_vertexBuffer->Lock(0, 0, (void **)&vertices, NULL);

	vertices[0].colour = vertexColour;
	vertices[0].x = (float)_startX;
	vertices[0].y = (float)_startY;
	vertices[0].z = 0.0f;
	vertices[0].rhw = 1.0f;
	vertices[0].u = 0.0f;
	vertices[0].v = 0.0f;

	vertices[1].colour = vertexColour;
	vertices[1].x = (float)_stopX;
	vertices[1].y = (float)_stopY;
	vertices[1].z = 0.0f;
	vertices[1].rhw = 1.0f;
	vertices[1].u = 0.0f;
	vertices[1].v = 0.0f;

	m_vertexBuffer->Unlock();

	m_device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG2);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

	m_device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG2);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

	m_device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
	m_device->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);

	HRESULT hr = m_device->DrawPrimitive ( D3DPT_LINELIST, 0, 1 );

	m_device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

	m_device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

	m_device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
	m_device->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);

	ARCDebugAssert ( !FAILED(hr) );
}


Uint32 DirectXGraphics::GetPixel ( Uint32 _surfaceID, int x, int y )
{
    DirectXTexture *tex = m_textures.get ( _surfaceID );
    return tex->GetPixel ( x, y );
}

void DirectXGraphics::SetPixel ( Uint32 _surfaceID, int x, int y, Uint32 _color )
{
    if ( _surfaceID == SCREEN_SURFACE_ID )
    {
		if ( m_deviceLost)
			return;

		DXVertex *vertices;

		D3DCOLOR vertexColour = _color | FULL_ALPHA;

		m_vertexBuffer->Lock(0, 0, (void **)&vertices, NULL);

		vertices[0].colour = vertexColour;
		vertices[0].x = (float)x;
		vertices[0].y = (float)y;
		vertices[0].z = 0.0f;
		vertices[0].rhw = 1.0f;
		vertices[0].u = 0.0f;
		vertices[0].v = 0.0f;

		m_vertexBuffer->Unlock();

		m_device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG2);
		m_device->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

		m_device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG2);
		m_device->SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

		m_device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
		m_device->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);

		HRESULT hr = m_device->DrawPrimitive ( D3DPT_POINTLIST, 0, 1 );

		m_device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
		m_device->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
		m_device->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

		m_device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
		m_device->SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
		m_device->SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

		m_device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
		m_device->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);

		ARCDebugAssert ( !FAILED(hr) );
    }
    else
    {
        ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );
        DirectXTexture *tex = m_textures.get ( _surfaceID );
        tex->SetPixel ( x, y, _color );
        tex->Damage();
    }
}

Uint32 DirectXGraphics::LoadImage ( const char *_filename, bool _isColorKeyed )
{
    ARCReleaseAssert ( _filename != NULL );
    DirectXTexture *tex = new DirectXTexture();
	tex->Load ( _filename, _isColorKeyed );
    Uint32 ret = m_textures.insert ( tex );
    return ret;
}

int DirectXGraphics::DeleteSurface ( Uint32 _surfaceID )
{
    if ( !m_textures.valid ( _surfaceID ) ) return -1;
    
    DirectXTexture *tex = m_textures.get ( _surfaceID );
    ARCReleaseAssert ( tex != NULL );
    delete tex;
    m_textures.remove ( _surfaceID );

    return 0;
}

Uint32 DirectXGraphics::CreateSurface ( Uint32 _width, Uint32 _height, bool _isColorKeyed )
{
    DirectXTexture *tex = new DirectXTexture();

	bool textureCreated = tex->Create ( _width, _height, _isColorKeyed );
	ARCReleaseAssert ( textureCreated );
    
    Uint32 ret = m_textures.insert ( tex );
    
    return ret;
}

Uint16 DirectXGraphics::GetMaximumTextureSize()
{
	ARCDebugAssert ( m_caps.MaxTextureWidth == m_caps.MaxTextureHeight );
	return (Uint16)m_caps.MaxTextureWidth;
}

int DirectXGraphics::SetColorKey ( Uint32 _color )
{    
    ARCReleaseAssert ( m_sdlScreen != NULL );

    m_colorKey = _color;
    m_colorKeySet = true;
    
    return 0;
}

void DirectXGraphics::ApplyColorKey ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );
    ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );

	DirectXTexture *surface = m_textures.get ( _surfaceID );
	SDL_SetColorKey ( surface->m_sdlSurface, SDL_SRCCOLORKEY | SDL_RLEACCEL, m_colorKey );
}

int DirectXGraphics::FillRect ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 _color )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );

    if ( _color == m_colorKey )
        _color = m_colorKey & ZERO_ALPHA;
    
    if ( _surfaceID == SCREEN_SURFACE_ID )
	{
		if ( m_deviceLost)
			return -1;

		RECT rect;
		if ( _destRect )
		{
			rect.left = _destRect->x;
			rect.top = _destRect->y;
			rect.right = _destRect->x + _destRect->w;
			rect.bottom = _destRect->y + _destRect->h;
		}
		IDirect3DSurface9 *surf;
		m_device->GetBackBuffer ( 0, 0, D3DBACKBUFFER_TYPE_MONO, &surf );
		m_device->ColorFill ( surf, _destRect ? &rect : NULL, _color );
		surf->Release();
        return 0;
    }
    else
    {
        ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );
        DirectXTexture *tex = m_textures.get ( _surfaceID );
        ARCReleaseAssert ( tex != NULL );

        int r = SDL_FillRect ( tex->m_sdlSurface, _destRect, _color );
        
        tex->Damage ();

        return r;
    }
}

int DirectXGraphics::Blit ( Uint32 _sourceSurfaceID, SDL_Rect const *_sourceRect,
                           Uint32 _destSurfaceID,   SDL_Rect const *_destRect )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );
        
    DirectXTexture *fromSurface = NULL;
    DirectXTexture *toSurface = NULL;

    SDL_Rect *sourceRect = NULL;
    SDL_Rect *destRect = NULL;

    if ( _sourceSurfaceID == SCREEN_SURFACE_ID )
    {
        // trying to blit from screen?
        // not at the moment, sadly
        return -1;
    }

	if ( _destSurfaceID == SCREEN_SURFACE_ID )
	{
		// Our device is toasted.
		if ( m_deviceLost )
			return -1;
	}

    // Get the SDL surface for the source surface.
    ARCReleaseAssert ( m_textures.valid ( _sourceSurfaceID ) );
    fromSurface = m_textures.get ( _sourceSurfaceID );
    ARCReleaseAssert ( fromSurface != NULL );

    // Get the SDL surface for the destination surface.
    if ( _destSurfaceID != SCREEN_SURFACE_ID )
    {
        ARCReleaseAssert ( m_textures.valid ( _destSurfaceID ) );
        toSurface = m_textures.get ( _destSurfaceID );
        ARCReleaseAssert ( toSurface != NULL );
    } else {
        toSurface = NULL;
    }

    // With SDL, you can have a NULL destination rectangle if you are just
    // writing to 0,0 and the max possible WxH on the surface.
    SDL_Rect nullDestRect;
    if ( !_destRect )
    {
        nullDestRect.x = 0; nullDestRect.y = 0;
        nullDestRect.w = m_sdlScreen->w;
        nullDestRect.h = m_sdlScreen->h;
        destRect = &nullDestRect;
    } else {
        memcpy ( &nullDestRect, _destRect, sizeof(SDL_Rect) );
        destRect = &nullDestRect;
    }

    // With SDL, you can have a NULL source rectangle if you are just
    // reading from 0,0 and the max possible WxH on the surface.
    SDL_Rect nullSourceRect;
    if ( !_sourceRect )
    {
        nullSourceRect.x = 0; nullSourceRect.y = 0;
        nullSourceRect.w = fromSurface->m_originalWidth;
        nullSourceRect.h = fromSurface->m_originalHeight;
        sourceRect = &nullSourceRect;
    } else {
        memcpy ( &nullSourceRect, _sourceRect, sizeof(SDL_Rect) );
        sourceRect = &nullSourceRect;
    }

	Uint16 surfW, surfH;
	if ( toSurface )
	{
		surfW = toSurface->m_sdlSurface->w;
		surfH = toSurface->m_sdlSurface->h;
	} else {
		surfW = m_sdlScreen->w;
		surfH = m_sdlScreen->h;
	}

    if ( destRect->x > surfW ) {
        // This blit is completely off the surface.
        return 1;
    }
    if ( destRect->y > surfH ) {
        // This blit is completely off the surface.
        return 1;
    }

    // Is this blit is going to be partially off the surface?
    if ( destRect->x + sourceRect->w > surfW )
        sourceRect->w = surfW - destRect->x;
    if ( destRect->y + sourceRect->h > surfH )
        sourceRect->h = surfH - destRect->y;

    // With SDL, you don't have to specify the dest width/height. With OpenGL, we do.
    destRect->w = sourceRect->w;
    destRect->h = sourceRect->h;
    
    // Now we need to do the actual blit!
    if ( _destSurfaceID == SCREEN_SURFACE_ID )
    {
		DXVertex *vertices;
		
		fromSurface->Upload();

        float texW = (float)fromSurface->m_sdlSurface->w,
              texH = (float)fromSurface->m_sdlSurface->h;
        float texX = (float)sourceRect->x,
              texY = (float)sourceRect->y;

		float srcR =  (float)(sourceRect->x + sourceRect->w) / texW,
			  srcB =  (float)(sourceRect->y + sourceRect->h) / texH;
		float srcX =  texX / texW,
			  srcY =  texY / texH;

		float destX = (float)destRect->x,
			  destY = (float)destRect->y;
		float destR = (float)(destRect->x + destRect->w),
			  destB = (float)(destRect->y + destRect->h);

		D3DCOLOR vertexColour = 0x00FFFFFF | (fromSurface->m_alpha << 24);

		if ( FAILED(m_vertexBuffer->Lock(0, 0, (void **)&vertices, NULL)) )
			return -1;

		int i = 0;

		// Top left
		vertices[0].colour = vertexColour;
		vertices[0].x = destX - 0.5f;
		vertices[0].y = destY - 0.5f;
		vertices[0].z = 0.0f;
		vertices[0].rhw = 1.0f;
		vertices[0].u = srcX;
		vertices[0].v = srcY;

		// Top right
		vertices[1].colour = vertexColour;
		vertices[1].x = destR - 0.5f;
		vertices[1].y = destY - 0.5f;
		vertices[1].z = 0.0f;
		vertices[1].rhw = 1.0f;
		vertices[1].u = srcR;
		vertices[1].v = srcY;

		// Bottom right
		vertices[2].colour = vertexColour;
		vertices[2].x = destR - 0.5f;
		vertices[2].y = destB - 0.5f;
		vertices[2].z = 0.0f;
		vertices[2].rhw = 1.0f;
		vertices[2].u = srcR;
		vertices[2].v = srcB;

		// Bottom left
		vertices[3].colour = vertexColour;
		vertices[3].x = destX - 0.5f;
		vertices[3].y = destB - 0.5f;
		vertices[3].z = 0.0f;
		vertices[3].rhw = 1.0f;
		vertices[3].u = srcX;
		vertices[3].v = srcB;

		m_vertexBuffer->Unlock();

		fromSurface->Bind();

		HRESULT hr = m_device->DrawPrimitive ( D3DPT_TRIANGLEFAN, 0, 2 );
		if ( FAILED(hr) )
			return -1;

        return 0;
    }
    else
    {
        // Blit
        int res = SDL_BlitSurface ( fromSurface->m_sdlSurface, sourceRect, toSurface->m_sdlSurface, destRect );

        // We want to upload the textures to graphics memory
        // later in order to make things fast.
        toSurface->Damage();
        
        return res;
    }

}

void DirectXGraphics::ReplaceColour ( Uint32 _surfaceID, SDL_Rect *_destRect, Uint32 findcolor, Uint32 replacecolor )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );
    ARCReleaseAssert ( _surfaceID != SCREEN_SURFACE_ID );
    ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );

    m_textures.get ( _surfaceID )->ReplaceColour ( _destRect, findcolor, replacecolor );

}

SDL_PixelFormat *DirectXGraphics::GetPixelFormat ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );
    
    if (_surfaceID == SCREEN_SURFACE_ID)
        return m_sdlScreen->format;
    
    ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );
    SDL_Surface *surface = m_textures.get ( _surfaceID )->m_sdlSurface;
    ARCReleaseAssert ( surface != NULL );

    return surface->format;
}

Uint32 DirectXGraphics::GetSurfaceHeight ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );
    
    if ( _surfaceID == SCREEN_SURFACE_ID )
        return GetScreenHeight();
    
    ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );

    SDL_Surface *surface = m_textures.get ( _surfaceID )->m_sdlSurface;
    ARCReleaseAssert ( surface != NULL );

    return surface->h;
}

Uint32 DirectXGraphics::GetSurfaceWidth ( Uint32 _surfaceID )
{
    ARCReleaseAssert ( m_sdlScreen != NULL );
    
    if (_surfaceID == SCREEN_SURFACE_ID)
        return GetScreenWidth();
    
    ARCReleaseAssert ( m_textures.valid ( _surfaceID ) );

    SDL_Surface *surface = m_textures.get ( _surfaceID )->m_sdlSurface;
    ARCReleaseAssert ( surface != NULL );

    return surface->w;
}

Uint32 DirectXGraphics::GetScreen ()
{
    return SCREEN_SURFACE_ID;
}

int DirectXGraphics::SetWindowMode ( bool _windowed, Sint16 _width, Sint16 _height, Uint8 _colorDepth )
{
    ARCReleaseAssert ( m_sdlScreen == NULL );

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

    Uint32 flags = SDL_RESIZABLE;

    if ( !m_windowed ) flags |= SDL_FULLSCREEN;

    m_sdlScreen = SDL_SetVideoMode ( _width, _height, m_colorDepth, flags );
    
    if ( !m_sdlScreen )
    {
        g_console->WriteLine ( "SDL couldn't initialise properly: %s", SDL_GetError() );
        return -1;
    }

    // m_sdlScreen->m_textureID = SCREEN_SURFACE_ID;
    
    const char *windowTitle = APP_NAME " v" VERSION_STRING;
    SDL_WM_SetCaption ( windowTitle, NULL );

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


    info = SDL_GetVideoInfo();
    
    g_console->WriteLine ( "Display mode set successfully (%dx%dx%d).", info->current_w, info->current_h, info->vfmt->BitsPerPixel );
    g_console->WriteLine ();

	m_d3d = Direct3DCreate9(D3D_SDK_VERSION);
	if ( !m_d3d ) return -1;

	SDL_SysWMinfo wmInfo;
	SDL_VERSION(&wmInfo.version);
	SDL_GetWMInfo(&wmInfo);
	HWND hWnd = wmInfo.window;

	ZeroMemory ( &m_caps, sizeof ( D3DCAPS9 ) );
	m_d3d->GetDeviceCaps ( D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, &m_caps);

	ZeroMemory ( &m_presentParams, sizeof ( D3DPRESENT_PARAMETERS ) );

	m_presentParams.Windowed = _windowed;
	m_presentParams.MultiSampleType = D3DMULTISAMPLE_NONE;
	m_presentParams.MultiSampleQuality = 0;
	m_presentParams.SwapEffect = D3DSWAPEFFECT_DISCARD;
	m_presentParams.hDeviceWindow = hWnd;
	m_presentParams.BackBufferCount = 1;
	m_presentParams.PresentationInterval =
		g_prefsManager->GetInt ( "WaitVerticalRetrace", 1 ) != 0 ?
		D3DPRESENT_INTERVAL_ONE :		// Wait for vertical retrace (vsync)
		D3DPRESENT_INTERVAL_IMMEDIATE;  // Don't wait for vertical retrace

	if ( _windowed )
	{
		D3DDISPLAYMODE d3ddm;
		RECT rWindow;

		m_d3d->GetAdapterDisplayMode ( D3DADAPTER_DEFAULT, &d3ddm );

		GetClientRect ( hWnd, &rWindow );

		_width = (Sint16)(rWindow.right - rWindow.left);
		_height = (Sint16)(rWindow.bottom - rWindow.top);

		m_presentParams.BackBufferFormat = d3ddm.Format;
	}
	else
	{
		m_presentParams.BackBufferFormat = D3DFMT_A8R8G8B8;
	}

	m_presentParams.BackBufferWidth = _width;
	m_presentParams.BackBufferHeight = _height;

	bool bHwVertexProcessing = (m_caps.DevCaps & D3DDEVCAPS_HWTRANSFORMANDLIGHT) != 0;

	// Set default settings
	UINT AdapterToUse = D3DADAPTER_DEFAULT;
	D3DDEVTYPE DeviceType = D3DDEVTYPE_HAL;
#ifndef USE_NVPERFHUD
	// When building a shipping version, disable PerfHUD (opt-out)
#else
	// Look for 'NVIDIA PerfHUD' adapter
	// If it is present, override default settings
	for ( UINT Adapter = 0; Adapter < m_d3d->GetAdapterCount(); Adapter++ ) {
		D3DADAPTER_IDENTIFIER9 Identifier;
		HRESULT Res;
		Res = m_d3d->GetAdapterIdentifier ( Adapter, 0, &Identifier );
		if ( strstr ( Identifier.Description, "PerfHUD" ) != 0 ) {
			AdapterToUse = Adapter; 
			DeviceType = D3DDEVTYPE_REF;
			break;
		}
	}
#endif

	if (FAILED(m_d3d->CreateDevice (
			AdapterToUse,
			DeviceType,
			hWnd,
			bHwVertexProcessing ? D3DCREATE_HARDWARE_VERTEXPROCESSING : D3DCREATE_SOFTWARE_VERTEXPROCESSING,
			&m_presentParams,
			&m_device)))
		return -1;

	const DWORD D3DFVF_TLVERTEX = D3DFVF_XYZRHW | D3DFVF_DIFFUSE | D3DFVF_TEX1;

	m_device->SetVertexShader ( NULL );
	m_device->SetFVF ( D3DFVF_TLVERTEX );

	if ( FAILED(m_device->CreateVertexBuffer ( sizeof(DXVertex) * 5, NULL, D3DFVF_TLVERTEX, D3DPOOL_MANAGED, &m_vertexBuffer, NULL)) )
		return -1;

	m_device->SetStreamSource ( 0, m_vertexBuffer, 0, sizeof(DXVertex) );
	
	m_device->SetRenderState ( D3DRS_LIGHTING, FALSE );
	m_device->SetRenderState ( D3DRS_ALPHABLENDENABLE, TRUE );
	m_device->SetRenderState ( D3DRS_SRCBLEND, D3DBLEND_SRCALPHA );
	m_device->SetRenderState ( D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA );
	m_device->SetRenderState ( D3DRS_CULLMODE, D3DCULL_NONE );
	m_device->SetRenderState ( D3DRS_ZENABLE, D3DZB_FALSE );
	m_device->SetTextureStageState ( 0, D3DTSS_ALPHAOP, D3DTOP_MODULATE );

	if ( FAILED(m_device->BeginScene()) ) return -1;
	
	if ( FAILED(m_device->Clear(0, NULL, D3DCLEAR_TARGET, 0, 0.0f, 0)) ) return -1;

    return 0;
}

bool DirectXGraphics::Flip()
{
	HRESULT hr;
	bool retval = true;
	if ( !m_deviceLost )
	{
		m_device->EndScene();
		hr = m_device->Present(NULL,NULL,NULL,NULL);
		if ( FAILED(hr) )
		{
			retval = false;
			m_deviceLost = true;
		}
	}
	if ( m_deviceLost )
	{
		retval = false;
		hr = m_device->TestCooperativeLevel();
		if ( hr == D3DERR_DEVICENOTRESET )
		{
			hr = m_device->Reset ( &m_presentParams );
			ARCDebugAssert ( hr == D3D_OK );
		}
		if ( hr == D3D_OK )
		{
			const DWORD D3DFVF_TLVERTEX = D3DFVF_XYZRHW | D3DFVF_DIFFUSE | D3DFVF_TEX1;

			m_device->SetVertexShader ( NULL );
			m_device->SetFVF ( D3DFVF_TLVERTEX );

			m_device->SetStreamSource ( 0, m_vertexBuffer, 0, sizeof(DXVertex) );

			m_device->SetRenderState ( D3DRS_LIGHTING, FALSE );
			m_device->SetRenderState ( D3DRS_ALPHABLENDENABLE, TRUE );
			m_device->SetRenderState ( D3DRS_SRCBLEND, D3DBLEND_SRCALPHA );
			m_device->SetRenderState ( D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA );
			m_device->SetRenderState ( D3DRS_CULLMODE, D3DCULL_NONE );
			m_device->SetRenderState ( D3DRS_ZENABLE, D3DZB_FALSE );
			m_device->SetTextureStageState ( 0, D3DTSS_ALPHAOP, D3DTOP_MODULATE );

			m_deviceLost = false;
			retval = true;
		}
	}
	if ( !m_deviceLost)
	{
		hr = m_device->Clear(0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0,0,0), 1.0f, 0);
		ARCDebugAssert ( hr == D3D_OK );
		hr = m_device->BeginScene();
		ARCDebugAssert ( hr == D3D_OK );
	}
	return retval;
}

#endif
