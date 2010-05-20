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

#include "App/app.h"
#include "App/preferences.h"
#include "App/string_utils.h"

#ifdef TARGET_OS_MACOSX
extern char **NXArgv; // system variable we can exploit
#endif

App::App ()
 : m_appPath ( NULL ),
   m_appSupportPath ( NULL ),
   m_resourcePath ( NULL )
{
    // TODO: Make this ALL prettier...
    // TODO: Set the appPath stuff to go to the application data folder, etc.
    
    char tempPath[2048];
    memset ( tempPath, 0, sizeof ( tempPath ) );

    // Set up the Application Path variable
#if defined ( TARGET_OS_WINDOWS )

    int retval = GetModuleFileName ( NULL, tempPath, sizeof ( tempPath ) );
    ARCDebugAssert ( retval != 0 );
    if ( strlen(tempPath) )
    {
        char *ptr = &tempPath[strlen(tempPath)];
        while ( *(--ptr) != '\\' ) {};
        ptr[1] = '\x0';
    }
    else
        strcpy ( tempPath, ".\\" );

#elif defined ( TARGET_OS_LINUX )

    int retval = readlink ( "/proc/self/exe", tempPath, sizeof ( tempPath ) );
    ARCDebugAssert ( retval != -1 );
    if ( strlen(tempPath) )
    {
        char *ptr = &tempPath[strlen(tempPath)];
        while ( *(--ptr) != '/' ) {};
        ptr[1] = '\x0';
    }
    else
        strcpy ( tempPath, "./" );

#elif defined ( TARGET_OS_MACOSX )

    strncpy ( tempPath, NXArgv[0], sizeof ( tempPath ) );
    if ( strlen(tempPath) )
    {
        char *ptr = &tempPath[strlen(tempPath)];
        while ( *(--ptr) != '/' ) {};
        ptr[1] = '\x0';
    }
    else
        strcpy ( tempPath, "./" );
    
#endif

    m_appPath = newStr ( tempPath );

    // Set up the resources directory variable
#if defined ( TARGET_OS_WINDOWS )

    m_resourcePath = newStr ( m_appPath );

#elif defined ( TARGET_OS_LINUX )
    
    m_resourcePath = newStr ( m_appPath );

#elif defined ( TARGET_OS_MACOSX )
    
    sprintf ( tempPath, "%s../Resources/", m_appPath );
    m_resourcePath = newStr ( tempPath );

#endif

    // Set up the Application Support path
#if defined ( TARGET_OS_WINDOWS )

    memset ( tempPath, 0, sizeof(tempPath) );
    retval = SHGetFolderPath ( NULL, CSIDL_LOCAL_APPDATA | CSIDL_FLAG_CREATE, NULL, 0, tempPath );
    ARCDebugAssert ( retval != E_FAIL );
    strcat ( tempPath, "\\ARC++\\" );
    m_appSupportPath = newStr ( tempPath );

#elif defined ( TARGET_OS_LINUX )

    const char *homePath = getenv ( "HOME" );
    ARCReleaseAssert ( homePath );
    sprintf ( tempPath, "%s/.arc/", homePath );
    m_appSupportPath = newStr ( tempPath );

#elif defined ( TARGET_OS_MACOSX )

    const char *homePath = getenv ( "HOME" );
    ARCReleaseAssert ( homePath );
    sprintf ( tempPath, "%s/Library/Application Support/ARC++/", homePath );
    m_appSupportPath = newStr ( tempPath );

#endif

    CreateDirectory ( m_appSupportPath );

    ARCDebugAssert ( m_appPath != NULL );
    ARCDebugAssert ( m_resourcePath != NULL );
    ARCDebugAssert ( m_appSupportPath != NULL );

#ifdef REDIRECT_STDOUT
    FILE *stdoutfile; FILE *stderrfile;
    sprintf ( tempPath, "%sdebug.log", m_appSupportPath );
    remove ( tempPath );
    stdoutfile = freopen ( tempPath, "a", stdout );
    if ( !stdoutfile ) fprintf ( stderr, "WARNING : Failed to open debug.log for writing stdout\n" );
    stderrfile = freopen ( tempPath, "a", stderr );
    if ( !stderrfile ) fprintf ( stderr, "WARNING : Failed to open debug.log for writing stderr\n" );
#endif

    m_resource = new Resource();
}

App::~App()
{
    delete m_resource;
    m_resource = NULL;
    delete [] m_appPath;
    m_appPath = NULL;
    delete [] m_appSupportPath;
    m_appSupportPath = NULL;
    delete [] m_resourcePath;
    m_resourcePath = NULL;
}

void App::CreateDirectory ( const char *_path )
{
#ifdef TARGET_OS_WINDOWS
    ::CreateDirectoryA ( _path, NULL );
#else
    mkdir ( _path, S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH );
#endif
}

const char *App::GetResourcePath ()
{
    return m_resourcePath;
}

const char *App::GetApplicationPath ()
{
    return m_appPath;
}

const char *App::GetApplicationSupportPath ()
{
    return m_appSupportPath;
}

App *g_app;
