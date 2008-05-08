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
