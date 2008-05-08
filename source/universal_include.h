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

#ifndef __included_universal_include_h
#define __included_universal_include_h

#ifdef __cplusplus
#  include <crisscross/crisscross.h>
#  ifndef TARGET_OS_LINUX
#    ifndef SDL_APPLICATION
#      error "SDL_APPLICATION must be defined in CrissCross."
#    endif
#  endif
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

#undef BUILD_NUMBER
#include "build_number.h"

#define TO_C_STRING(s) TO_STRING(s)
#define TO_STRING(s) #s

#define PROTOCOL_VERSION    1

#define VERSION_MAJOR        0
#define VERSION_MINOR        4
#define VERSION_REVISION     6
#define VERSION_NUMBER       TO_C_STRING(VERSION_MAJOR) "." TO_C_STRING(VERSION_MINOR) "." TO_C_STRING(VERSION_REVISION)
#define VERSION_BUILD        TO_C_STRING(BUILD_NUMBER) " (SVN)"
#define VERSION_CODENAME     "Valkyrie"
#define VERSION_NAME         "ARC++"

#define RESOURCE_VERSION VERSION_MAJOR,VERSION_MINOR,VERSION_REVISION,BUILD_NUMBER
#define RESOURCE_VERSION_STRING TO_C_STRING(VERSION_MAJOR) ", " TO_C_STRING(VERSION_MINOR) ", " TO_C_STRING(VERSION_REVISION) ", " TO_C_STRING(BUILD_NUMBER)

#define APP_NAME "Codename " VERSION_CODENAME

//#define BENCHMARK_BUILD
#define BENCHMARK_WIDGETS 2000

//#define REDIRECT_STDOUT

//#define RELEASE_BUILD

#ifdef _DEBUG
#  define INTERNAL_BUILD
#else
#  define BETA_BUILD
#endif

#include "App/debug_utils.h"

#ifndef DETECT_MEMORY_LEAKS
#	ifdef TARGET_OS_WINDOWS
#		define ENABLE_DIRECT3D
#	endif
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

#ifdef TARGET_OS_MACOSX
#  define GL_3DFX_texture_compression_FXT1 1
#  include <OpenGL/GL.h>
#  include <OpenGL/glext.h>
#else
#  include <GL/gl.h>
#  include <gl/glext.h>
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

__inline bool isPowerOfTwo ( Uint32 v ) { return !(v & (v - 1)) && v; }
__inline Uint32 nearestPowerOfTwo ( Uint32 v ) { return (Uint32)pow( 2.0, ceil( log( (double)v ) / log( 2.0 ) ) ); }

#ifndef PI
#    define PI 3.1415926535
#endif

#define DIV180BYPI 180.0 / PI
#define TWOPI PI * 2.0
#define DIVBY360 1.0 / 360.0
#define DIV360MULTPI DIVBY360 * TWOPI

#endif // __cplusplus

#endif
