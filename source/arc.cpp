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
#include "App/preferences.h"
#include "Game/game.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/window.h"
#include "Network/net.h"
#include "Sound/soundsystem.h"
#include "World/map.h"

IO::Console *g_console;

bool g_bActive = true;
int iPlaying;
bool bSound;

void Init_App( char *apppath );
void Init_Game();
void Init_Graphics();
void Init_Interface();
void Init_Sound();

int RunApplication ( int argc, char **argv )
{
    int i = 0;
    char temp[1024];
    
    memset ( temp, 0, sizeof(temp) );

    g_console = new IO::Console ( true, true );
    g_console->SetTitle ( APP_NAME " v" VERSION_STRING );
    
#ifdef TARGET_OS_MACOSX
    sprintf ( temp, "%s", "../Resources/" );
#endif
    
    // first find the location of the EXE.
    for (i = (int)strlen(argv[0]); i > 0; i--)
    {
        if (argv[0][i] == '\\')
        {
            argv[0][i + 1] = '\x0';
            strcat(temp, argv[0]);
            break;
        }
    }

    g_console->SetColour ( IO::Console::FG_GREEN | IO::Console::FG_INTENSITY );
    g_console->WriteLine ( "=====================" );
    g_console->WriteLine ( "=                   =" );
    g_console->WriteLine ( "=       ARC++       =" );
    g_console->WriteLine ( "=                   =" );
    g_console->WriteLine ( "=====================" );
    g_console->SetColour ();
    g_console->WriteLine ( "Version " VERSION_STRING );

    g_console->Write ( "Built for " );
    g_console->SetColour ( IO::Console::FG_GREEN | IO::Console::FG_INTENSITY );
#if defined ( TARGET_OS_WINDOWS )
    g_console->Write ( "Microsoft Windows" );
#elif defined ( TARGET_OS_MACOSX )
    g_console->Write ( "Mac OS X" );
#elif defined ( TARGET_OS_LINUX )
    g_console->Write ( "Linux" );
#else
    g_console->Write ( "Unknown OS" );
#endif
    g_console->SetColour ();
    g_console->Write ( " using " );
    g_console->SetColour ( IO::Console::FG_GREEN | IO::Console::FG_INTENSITY );
#if defined ( TARGET_COMPILER_VC )
    g_console->Write ( "Visual Studio" );
    #if _MSC_VER >= 1500
        g_console->Write ( " 2008" );
    #elif _MSC_VER >= 1400
        g_console->Write ( " 2005" );
    #elif _MSC_VER >= 1310
        g_console->Write ( " .NET 2003" );
    #elif _MSC_VER >= 1300
        g_console->Write ( " .NET 2002" );
    #elif _MSC_VER >= 1200
        g_console->Write ( " 6.0" );
    #endif
#elif defined ( TARGET_COMPILER_GCC )
    g_console->Write ( "GNU C++ Compiler v%d.%d.%d", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__ );
#elif defined ( TARGET_COMPILER_ICC )
    g_console->Write ( "Intel C++ Compiler" );
#else
    g_console->Write ( "Unknown Compiler" );
#endif
    g_console->SetColour ();
    g_console->WriteLine ( "\nBuilt on " __DATE__ " at " __TIME__ );

    g_console->WriteLine ( "written by Steven Noonan\n" );


    Init_App(temp);
    Init_Graphics();
    Init_Interface();
    Init_Sound();
    Init_Game();

    // TODO: Implement dynamic values.
    g_game->Run ( "5.132.88.92", 22000, "Tycho", NULL );

    // deconstruct the classes
    g_console->WriteLine ( "Destroying classes...");
    g_graphics->ShowCursor ( true );
    
    // free up the allocated memory
    delete g_game; g_game = NULL;
    delete g_interface; g_interface = NULL;
    delete g_graphics; g_graphics = NULL;
    delete g_soundSystem; g_soundSystem = NULL;
    
    // notify that the exit operations were successful
    g_console->WriteLine ( "Program is exiting cleanly.\n");
    
    g_prefsManager->Save();

    delete g_prefsManager; g_prefsManager = NULL;
    delete g_app; g_app = NULL;
    delete g_console; g_console = NULL;

    // success!
    return 0;
}

void Init_App( char *apppath )
{
    g_app = new App();
    ARCReleaseAssert ( g_app != NULL );

    char preferencesPath[2048];
#ifndef TARGET_OS_WINDOWS
    sprintf( preferencesPath, "%s%s", g_app->GetApplicationSupportPath(), "preferences.txt" );
#else
    sprintf( preferencesPath, "%s%s", g_app->GetApplicationPath(), "preferences.txt" );
#endif
    g_prefsManager = new Preferences ( preferencesPath );
    ARCReleaseAssert ( g_prefsManager != NULL );

    // We save the preferences here to ensure that preferences.txt exists.
    // If the application prints a blackbox.txt, this file needs to be there.
    g_prefsManager->Save();

	if ( g_prefsManager->GetInt ( "IgnoreDataFiles", 0 ) == 0 )
	{
		char tempPath[2048];
		sprintf ( tempPath, "%s%s", g_app->GetResourcePath(), "data.dat" );
		g_app->m_resource->ParseArchive ( tempPath, NULL );
		sprintf ( tempPath, "%s%s", g_app->GetResourcePath(), "font.dat" );
		g_app->m_resource->ParseArchive ( tempPath, NULL );
		sprintf ( tempPath, "%s%s", g_app->GetResourcePath(), "graphics.dat" );
		g_app->m_resource->ParseArchive ( tempPath, NULL );
		sprintf ( tempPath, "%s%s", g_app->GetResourcePath(), "sounds.dat" );
		g_app->m_resource->ParseArchive ( tempPath, NULL );
		sprintf ( tempPath, "%s%s", g_app->GetResourcePath(), "maps.dat" );
		g_app->m_resource->ParseArchive ( tempPath, NULL );
	}
}

void Init_Game()
{
    g_game = new Game();
    ARCReleaseAssert ( g_game != NULL );
    g_game->Initialise();
}

void Init_Graphics()
{
    const char *graphicsDriver = g_prefsManager->GetString ( "PrimaryRenderer", "opengl" );
    int ret = -1;

	ARCDebugAssert ( g_graphics == NULL );
	while ( !g_graphics )
	{
		// Pick a renderer.
		if ( Data::Compare<const char *> ( graphicsDriver, "opengl" ) == 0 )
		{
			// OpenGL
			g_console->WriteLine ( "Attempting to use OpenGLGraphics..." );
#ifdef ENABLE_OPENGL
			g_graphics = new OpenGLGraphics ();
#else
			g_console->WriteLine ( "OpenGL support not enabled." );
#endif
		}
		else if ( Data::Compare<const char *> ( graphicsDriver, "sdl" ) == 0 )
		{
			// SDL with one of {windib, dga, directx}, etc.
			g_console->WriteLine ( "Attempting to use SDLGraphics..." );
#ifdef ENABLE_SDLGRAPHICS
			g_graphics = new SDLGraphics ( g_prefsManager->GetString ( "SecondaryRenderer" ) );
#else
			g_console->WriteLine ( "SDL graphics support not enabled." );
#endif
		}
		else if ( Data::Compare<const char *> ( graphicsDriver, "direct3d" ) == 0 )
		{
			// Direct3D
			g_console->WriteLine ( "Attempting to use DirectXGraphics..." );
#ifdef TARGET_OS_WINDOWS
#ifdef ENABLE_DIRECT3D
			g_graphics = new DirectXGraphics ();
#else
			g_console->WriteLine ( "Direct3D support not enabled." );
#endif
#else
			g_console->WriteLine ( "Wrong platform. Attempting to use OpenGL..." );
#endif
		}

		// Try and set the window mode.
		if ( g_graphics )
		{
			ret = g_graphics->SetWindowMode (
				g_prefsManager->GetInt ( "ScreenWindowed", 0 ) == 1,
				g_prefsManager->GetInt ( "ScreenWidth", 800 ),
				g_prefsManager->GetInt ( "ScreenHeight", 600 ),
				g_prefsManager->GetInt ( "ScreenColourDepth", 32 )
			);
		}

		// Something went wrong.
		if ( ret )
		{
			delete g_graphics; g_graphics = NULL;
	        
			if ( Data::Compare<const char *> ( graphicsDriver, "opengl" ) == 0  )
			{
				// Well, OpenGL failed for some reason. Revert to SDL.
				graphicsDriver = "sdl";
			}
			else if ( Data::Compare<const char *> ( graphicsDriver, "direct3d" ) == 0  )
			{
				// Direct3D may not be available on this platform.
				graphicsDriver = "opengl";
			}
			else if ( Data::Compare<const char *> ( graphicsDriver, "sdl" ) == 0  )
			{
				// You're screwed.
				break;
			}
			else
			{
				// Er, what the hell -did- they put in preferences?
				graphicsDriver = "opengl";
			}
		} else {
			break;
		}
	}
	    
	// Something's terribly wrong.
	if ( !g_graphics )
		ARCAbort ( "Could not initialize the graphics engine." );

    // Hide the OS cursor
    g_graphics->ShowCursor ( false );
}

void Init_Interface()
{
    g_interface = new Interface();
    ARCReleaseAssert ( g_interface != NULL );
}

void Init_Sound()
{
#if defined(USE_OPENAL)
	g_soundSystem = new OpenALSoundSystem();
#elif defined(USE_SDLMIXER)
	g_soundSystem = new SDLMixerSoundSystem();
#endif
	if ( !g_soundSystem )
		g_soundSystem = new NullSoundSystem();
}
