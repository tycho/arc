/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "App/app.h"
#include "App/string_utils.h"

char *newStr ( const char *_string )
{
    ARCReleaseAssert ( _string != NULL );
    char *retval = new char [ strlen ( _string ) + 1 ];
    strcpy ( retval, _string );
    return retval;
}
