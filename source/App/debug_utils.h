/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_debug_utils_h
#define __included_debug_utils_h

//! Generates a crash log to the OS-appropriate location.
/*!
	\param _msg The error message to print along with the crash log.
 */
void GenerateBlackBox ( const char *_msg );
void ARCReleaseAssert_Helper ( const char *_msg );

#if defined ( NDEBUG ) && defined ( TARGET_OS_WINDOWS )
#define PAUSE_COMMAND "PAUSE"
#else
#define PAUSE_COMMAND ""
#endif


#define  ARCReleaseAssert(x)  {                                             \
        if (!(x)) {                                                         \
            g_stderr->WriteLine  ( "\n"                                     \
                     "An ARC++ assertion failure has occured\n"             \
                     "=======================================\n"            \
                     " Condition : %s\n"                                    \
                     " Location  : %s, line %d\n\n",                        \
                     #x, __FILE__, __LINE__ );                              \
            CrissCross::Debug::PrintStackTrace ( g_stderr );                \
            g_stderr->WriteLine ();                                         \
            ARCReleaseAssert_Helper ( "Assertion failure" );                \
        }                                                                   \
    }

#ifdef _DEBUG
  #ifdef TARGET_COMPILER_VC
    #define ARCDebugAssert(x)                                               \
        if(!(x)) {                                                          \
            /*GenerateBlackBox();*/                                         \
            ::ShowCursor(true);                                             \
            _ASSERT(x);                                                     \
        }
  #else
    #define ARCDebugAssert(x) { assert(x); }
  #endif
#else
    #define ARCDebugAssert(x)
#endif



//
// Abort - print message then bomb out (reset the resolution, too!)
//

#ifdef DEBUGLOG_ENABLED

    #define  ARCAbort(msg) {                                                \
        char message[1024];                                                 \
        sprintf ( message,  "\n"                                            \
                 "Cobalt has been forced to Abort\n"                        \
                 "===============================\n"                        \
                 " Message   : %s\n"                                        \
                 " Location  : %s, line %d\n\n",                            \
                 msg, __FILE__, __LINE__ );                                 \
        fprintf ( stderr, message );                                        \
        SDL_Quit();                                                         \
        system ( PAUSE_COMMAND );                                           \
        exit(255);                                                          \
    }

#else

    #define  ARCAbort(msg) {                                                \
        g_stderr->WriteLine ( "\n"                                          \
                 "ARC++ has been forced to abort\n"                         \
                 "==============================\n"                         \
                 " Message   : %s\n"                                        \
                 " Location  : %s, line %d\n\n",                            \
                 msg, __FILE__, __LINE__ );                                 \
            CrissCross::Debug::PrintStackTrace ( g_stderr );                \
            g_stderr->WriteLine ();                                         \
            ARCReleaseAssert_Helper ( msg );                                \
    }

#endif

#endif
