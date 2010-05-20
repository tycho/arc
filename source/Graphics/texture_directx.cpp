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
#include "Graphics/graphics_directx.h"
#include "Graphics/texture_directx.h"

static DirectXGraphics *graphics = NULL;

DirectXTexture::DirectXTexture ()
 : m_texture(NULL),
   Texture()
{
	if ( !graphics )
		graphics = dynamic_cast<DirectXGraphics *>(g_graphics);
	ARCReleaseAssert ( graphics );
}

DirectXTexture::~DirectXTexture()
{
	Dispose();
}

void DirectXTexture::Dispose()
{
	if (m_texture) {
		m_texture->Release();
		m_texture = NULL;
	}
	Texture::Dispose();
}

bool DirectXTexture::Load ( const char *_filename, bool _isColorKeyed )
{
	m_sdlSurface = g_app->m_resource->GetImage ( _filename );
	if ( !m_sdlSurface ) return false;

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
	SDL_Surface *copy = SDL_CreateRGBSurface ( SDL_SWSURFACE, m_sdlSurface->w, m_sdlSurface->h, 32, rmask, gmask, bmask, amask );
    if ( _isColorKeyed && graphics->m_colorKeySet )
    {
		SDL_FillRect ( copy, NULL, ZERO_ALPHA & graphics->m_colorKey );
        SDL_SetColorKey ( copy, SDL_SRCCOLORKEY | SDL_RLEACCEL, g_graphics->m_colorKey );
    }
    SDL_SetAlpha ( copy, 0, SDL_ALPHA_OPAQUE );
	SDL_BlitSurface ( m_sdlSurface, NULL, copy, NULL );
	SDL_FreeSurface ( m_sdlSurface );
	m_sdlSurface = copy;
	copy = NULL;

	MemMappedFile *src = g_app->m_resource->GetUncompressedFile ( _filename );
	if ( !src ) return false;

	D3DCOLOR colorKey = _isColorKeyed ? g_graphics->GetColorKey() : 0;

	if (FAILED(D3DXCreateTexture(
		graphics->m_device,
		m_sdlSurface->w,
		m_sdlSurface->h,
		1,
		0,
		D3DFMT_A8B8G8R8,
		D3DPOOL_MANAGED,
		&m_texture)))
		return false;

	m_damaged = true;

	return true;
}

bool DirectXTexture::Create ( Uint16 _width, Uint16 _height, bool _isColorKeyed )
{
    ARCReleaseAssert ( _width > 0 ); ARCReleaseAssert ( _height > 0 );

    Uint32 oldWidth = _width, oldHeight = _height;
    //if ( !g_openGL->GetSetting ( OPENGL_TEX_ALLOW_NPOT ) ) {
        if ( !isPowerOfTwo ( _width ) )
            _width = nearestPowerOfTwo ( _width );
        if ( !isPowerOfTwo ( _height ) )
            _height = nearestPowerOfTwo ( _height );
        ARCReleaseAssert ( isPowerOfTwo ( _width * _height ) );
    //}

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

    /*if ( _isColorKeyed && graphics->m_colorKeySet )
    {
		SDL_FillRect ( m_sdlSurface, NULL, ZERO_ALPHA & g_graphics->m_colorKey );
        SDL_SetColorKey ( m_sdlSurface, SDL_SRCCOLORKEY | SDL_RLEACCEL, g_graphics->m_colorKey );
    } */
    SDL_SetAlpha ( m_sdlSurface, 0, SDL_ALPHA_OPAQUE );

	if (FAILED(D3DXCreateTexture(
		graphics->m_device,
		_width,
		_height,
		1,
		0,
		D3DFMT_A8R8G8B8,
		D3DPOOL_MANAGED,
		&m_texture)))
		return false;

	//ARCAbort ( "Create() not implemented." );

    m_originalWidth = oldWidth;
    m_originalHeight = oldHeight;

    Damage ();

    return true;
}

bool DirectXTexture::Reset()
{
	if (m_texture) {
		m_texture->Release();
		m_texture = NULL;
	}
	if (FAILED(D3DXCreateTexture(
		graphics->m_device,
		m_originalWidth,
		m_originalHeight,
		1,
		0,
		D3DFMT_A8R8G8B8,
		D3DPOOL_MANAGED,
		&m_texture)))
		return false;
	Damage();
	return true;
}

void DirectXTexture::Bind()
{
	if ( !graphics->m_deviceLost )
	{
		HRESULT hr = graphics->m_device->SetTexture ( 0, m_texture );
		ARCDebugAssert ( hr == D3D_OK );
	}
}

bool DirectXTexture::Upload()
{
    if ( !m_damaged ) return false;

    ARCReleaseAssert ( m_sdlSurface != NULL );
	ARCReleaseAssert ( m_texture != NULL );

	RECT rect = {0, 0, m_sdlSurface->w, m_sdlSurface->h};

	LPDIRECT3DSURFACE9 surf;
	HRESULT hr = m_texture->GetSurfaceLevel (0, &surf);

	if ( FAILED(hr) )
		return false;

	bool isLocked = false;
	if ( !m_sdlSurface->pixels )
	{
		isLocked = true;
		SDL_LockSurface ( m_sdlSurface );
	}

	ARCReleaseAssert ( m_sdlSurface->pixels );

	hr = D3DXLoadSurfaceFromMemory( surf,
		NULL, NULL, m_sdlSurface->pixels, D3DFMT_A8B8G8R8,
		m_sdlSurface->w * 4,
		NULL, &rect, D3DX_FILTER_NONE, graphics->m_colorKey );

	if ( isLocked )
		SDL_UnlockSurface ( m_sdlSurface );

	ARCDebugAssert ( !FAILED(hr) );

    m_damaged = false;

    return true;
}

#endif
