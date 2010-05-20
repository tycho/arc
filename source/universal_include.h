/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_universal_include_h
#define __included_universal_include_h

#ifdef __cplusplus
#  include <crisscross/crisscross.h>
#endif

#if defined ( TARGET_COMPILER_VC ) || defined ( TARGET_COMPILER_ICC )
#    pragma warning ( error: 4996 )
#    pragma warning ( error: 4706 )
#    pragma warning ( disable: 4786 )
#    ifdef _DEBUG
#        pragma comment ( lib, "libcpmtd.lib" )
#        pragma comment ( lib, "libcmtd.lib" )
#    else
#        pragma comment ( lib, "libcpmt.lib" )
#        pragma comment ( lib, "libcmt.lib" )
#    endif
#endif

#if defined(TARGET_COMPILER_ICC) && defined(TARGET_OS_WINDOWS)
#    pragma comment ( lib, "libmmds.lib" )
#    pragma comment ( lib, "libircmt.lib" )
#endif

#define TO_C_STRING(s) TO_STRING(s)
#define TO_STRING(s) #s

#define PROTOCOL_VERSION    1

#define VERSION_CODENAME     "Valkyrie"
#define VERSION_NAME         "ARC++"

#define APP_NAME VERSION_NAME

//#define BENCHMARK_BUILD
#define BENCHMARK_WIDGETS 500

//#define REDIRECT_STDOUT

#define RELEASE_BUILD

#ifdef _DEBUG
#  define INTERNAL_BUILD
#else
#  define BETA_BUILD
#endif

#include "App/debug_utils.h"

#define ENABLE_DIRECT3D
#define ENABLE_OPENGL
#define ENABLE_SDLGRAPHICS

//#define ENABLE_FONTS

#if !defined(TARGET_OS_WINDOWS) || defined(DETECT_MEMORY_LEAKS)
#	undef ENABLE_DIRECT3D
#endif

#ifndef BENCHMARK_BUILD
//#define ENABLE_NETWORKING
#endif

/*********************** SOUND ***********************/
//#define USE_OPENAL        // In development
#define USE_SDLMIXER        // Fully functional (best choice)

#if !( defined(USE_OPENAL) ^ defined(USE_SDLMIXER) )
#    error You must select one and ONLY one sound engine.
#endif
/*********************** SOUND ***********************/


/******************** NETWORKING *********************/
#ifdef ENABLE_NETWORKING
//#define USE_RAKNET        // Not implemented
#define USE_CRISSCROSS_NET    // Fully functional (best choice)

#if !( defined(USE_RAKNET) ^ defined(USE_CRISSCROSS_NET) )
#    error You must select one and ONLY one networking engine.
#endif
#endif
/******************** NETWORKING *********************/

// #define FORCE_VSYNC

// Might work...
// #define ANTI_CHEAT_MACRO    { ARCReleaseAssert ( g_graphics->GetScreenWidth() <= 800 ); ARCReleaseAssert ( g_graphics->GetScreenHeight() <= 600 ); }

#ifdef TARGET_COMPILER_VC
#    if _MSC_VER >= 1300 && _MSC_VER < 1400
#        define _INC_MALLOC
#    endif
#endif

#ifdef TARGET_OS_WINDOWS
#   ifdef ENABLE_DIRECT3D
#		ifdef _DEBUG
#			define D3D_DEBUG_INFO
#		endif
#	    include <d3d9.h>
#       include <d3dx9.h>
#   endif
#endif

#ifdef __cplusplus
#if !defined ( TARGET_OS_WINDOWS ) && !defined ( TARGET_OS_MACOSX )
#    include <SDL/SDL.h>
#    include <SDL/SDL_image.h>
#else
#    include <SDL.h>
#    include <SDL_image.h>
#endif

#ifdef USE_SDLMIXER
#if !defined ( TARGET_OS_WINDOWS ) && !defined ( TARGET_OS_MACOSX )
#    include <SDL/SDL_mixer.h>
#else
#    include <SDL_mixer.h>
#endif
#endif

#ifdef TARGET_OS_WINDOWS
#  define FTGL_LIBRARY_STATIC
#endif

#ifdef TARGET_OS_MACOSX
#  define GL_3DFX_texture_compression_FXT1 1
#  include <OpenGL/GL.h>
#  include <OpenGL/glext.h>
#  ifdef ENABLE_FONTS
#    include <FTGL/FTGLTextureFont.h>
#  endif
#else
#  include <GL/gl.h>
#  include <GL/glext.h>
#  ifdef ENABLE_FONTS
#    include <FTGLTextureFont.h>
#  endif
#endif

#include <zlib.h>

#ifdef TARGET_OS_LINUX
#    include <unistd.h>
#    include <signal.h>
#endif

using namespace std;
using namespace CrissCross;

extern IO::Console *g_console;

#ifdef _OPENMP
#  include <omp.h>
#  define TARGET_OPENMP
#endif

#ifndef TARGET_OS_WINDOWS
#    define stricmp strcasecmp
#else
#    define stricmp _stricmp
#endif

#include <cmath>

__inline bool isPowerOfTwo ( Uint32 v ) { return !(v & (v - 1)) && v; }
__inline Uint32 nearestPowerOfTwo ( Uint32 v ) { return (Uint32)pow( 2.0, ceil( log( (double)v ) / log( 2.0 ) ) ); }

#ifndef PI
#    define PI 3.1415926535
#endif

#ifdef TARGET_LITTLE_ENDIAN
#define MASK_ALPHA        0xFF000000
#define MASK_RED          0x00FF0000
#define MASK_GREEN        0x0000FF00
#define MASK_BLUE         0x000000FF
#define GET_A(x)          ((x & MASK_ALPHA) >> 24)
#define GET_R(x)          ((x & MASK_RED) >> 16)
#define GET_G(x)          ((x & MASK_GREEN) >> 8)
#define GET_B(x)           (x & MASK_BLUE)
#define MAKERGB(r,g,b)    (((0xFF) << 24) | ((r) << 16) | ((g) << 8) | (b))
#define MAKERGBA(r,g,b,a) (((a) << 24) | ((r) << 16) | ((g) << 8) | (b))
#else
#define MASK_RED          0xFF000000
#define MASK_GREEN        0x00FF0000
#define MASK_BLUE         0x0000FF00
#define MASK_ALPHA        0x000000FF
#define GET_R(x)          ((x & MASK_RED) >> 24)
#define GET_G(x)          ((x & MASK_GREEN) >> 16)
#define GET_B(x)          ((x & MASK_BLUE) >> 8)
#define GET_A(x)           (x & MASK_ALPHA)
#define MAKERGB(r,g,b)    (((r) << 24) | ((g) << 16) | ((b) << 8) | (0xFF))
#define MAKERGBA(r,g,b,a) (((r) << 24) | ((g) << 16) | ((b) << 8) | (a))
#endif

#define DIV180BYPI 180.0 / PI
#define TWOPI PI * 2.0
#define DIVBY360 1.0 / 360.0
#define DIV360MULTPI DIVBY360 * TWOPI

extern Uint32 fontid;

#endif // __cplusplus

#endif
