/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#ifndef TARGET_OS_WINDOWS
#include <sys/stat.h>
#endif

#include "App/file_utils.h"

bool FileExists ( const char *_file )
{
#ifdef TARGET_OS_WINDOWS
    struct _stat fileStats;
#else
    struct stat fileStats;
#endif

#ifdef TARGET_OS_WINDOWS
    if ( _stat ( _file, &fileStats ) == 0 )
#else
    if ( stat ( _file, &fileStats ) == 0 )
#endif
    {
        if ( fileStats.st_size < 1 )
        {
            return false;
        }
    } else {
        return false;
    }

    return true;
}
