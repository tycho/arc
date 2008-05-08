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

#include "App/app.h"
#include "App/debug_utils.h"

void GenerateBlackBox ( const char *_msg )
{
    FILE *_file = fopen( "blackbox.txt", "wt" );

    fprintf( _file, "==========================\n" );
    fprintf( _file, "= ARC++ BLACK BOX REPORT =\n" );
    fprintf( _file, "==========================\n\n" );

    fprintf( _file, "VERSION : %s\n", APP_NAME " v" VERSION_NUMBER " build " VERSION_BUILD );

    if( _msg ) fprintf( _file, "ERROR   : '%s'\n", _msg );


    //
    // Print preferences information

    char buffer[4096];
#ifndef TARGET_OS_WINDOWS
    sprintf( buffer, "%s%s", g_app->GetApplicationSupportPath(), "preferences.txt" );
#else
    sprintf( buffer, "%s%s", g_app->GetApplicationPath(), "preferences.txt" );
#endif
    FILE *prefsFile = fopen(buffer, "r");
    if( prefsFile )
    {
        fprintf( _file, "\n" );
        fprintf( _file, "=========================\n" );
        fprintf( _file, "====== PREFERENCES ======\n" );
        fprintf( _file, "=========================\n\n" );

        char line[256];
        while ( fgets ( line, 256, prefsFile ) != NULL )
        {
            if ( line[0] != '#' && line[0] != '\n' ) // Skip comment lines
            {
                fprintf( _file, "%s", line );              
            }
        }
        fclose(prefsFile);
    }
    
    //
    // Print stack trace
    // Get our frame pointer, chain upwards

    fprintf( _file, "\n" );
    fprintf( _file, "=========================\n" );
    fprintf( _file, "====== STACKTRACE =======\n" );
    fprintf( _file, "=========================\n\n" );

    CrissCross::IO::CoreIOWriter *cio_file = new CrissCross::IO::CoreIOWriter(_file,false);
    CrissCross::Debug::PrintStackTrace ( cio_file );
    delete cio_file;
    
    fclose( _file );
}

void ARCReleaseAssert_Helper ( const char *_reason )
{
    SDL_Quit();
    GenerateBlackBox(_reason);
#if defined ( TARGET_OS_WINDOWS )
    MessageBox ( NULL, "A fatal error occured in ARC++.\n\n"
                       "The details of this error have been written to\n"
                       "blackbox.txt in the directory ARC++ is installed in.\n\n"
                       "Please report this on the ARC++ forums at\n"
                       "http://www.uplinklabs.net/\n\n"
                       "ARC++ will now shut down.", 
                       "ARC++ Fatal Error", MB_ICONEXCLAMATION | MB_OK );
#endif
#if defined ( INTERNAL_BUILD )
    abort();
#else
    exit(255);
#endif
}
