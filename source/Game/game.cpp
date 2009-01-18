/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include <time.h>

#include "App/app.h"
#include "App/file_utils.h"
#include "App/preferences.h"
#include "Game/game.h"
#include "Graphics/graphics.h"
#include "Interface/bouncing_window.h"
#include "Interface/error_window.h"
#include "Interface/loading_window.h"
#include "Interface/quit_window.h"
#include "Interface/text.h"
#include "Interface/text_input.h"
#include "Interface/button.h"
#include "Interface/interface.h"
#include "Network/net.h"
#include "Sound/soundsystem.h"
#include "World/map.h"

Game::Game()
 : 
#ifdef ENABLE_NETWORKING
   m_connection(NULL),
#endif
   m_health(60),
   m_laserCharge(60),
   m_bounceAmmo(3),
   m_missileAmmo(3),
   m_grenadeAmmo(2),
   m_bounceCharge(0),
   m_missileCharge(0),
   m_grenadeCharge(0),
   m_me(NULL),
   m_running(true),
   m_playing(false),
   m_classicControls(false),
   m_gameSpeed(5),
   m_map(NULL),
   m_selectedWeapon(WEAPON_TYPE_BOUNCE),
   m_players(1),
   m_loadState(LOAD_STATE_NULL),
   m_nextLoadState(LOAD_STATE_PRELOAD_SOUNDS_MSG),
   m_loadPauseTime(0.0),
   m_fps(0),
   m_ping(0),
   m_highPing(0),
   m_damageLevel(2)
{
    m_laserDamage[0] = 3;
    m_laserDamage[1] = 5;
    m_laserDamage[2] = 7;
    m_laserDamage[3] = 14;
    m_laserDamage[4] = 18;

    m_bounceDamage[0] = 3;
    m_bounceDamage[1] = 7;
    m_bounceDamage[2] = 12;
    m_bounceDamage[3] = 15;
    m_bounceDamage[4] = 20;

    m_shrapnelDamage[0] = 2.25;
    m_shrapnelDamage[1] = 3.25;
    m_shrapnelDamage[2] = 4.25;
    m_shrapnelDamage[3] = 7;
    m_shrapnelDamage[4] = 3.25;

    m_missileDamage[0] = 8;
    m_missileDamage[1] = 13;
    m_missileDamage[2] = 16;
    m_missileDamage[3] = 35;
    m_missileDamage[4] = 45;
}

Game::~Game()
{
    for ( size_t i = 0; i < m_players.size(); i++ )
    {
        if ( !m_players.valid ( i ) ) continue;
        delete m_players[i];
        m_players.remove ( i );
    }
    delete m_map; m_map = NULL;
#ifdef ENABLE_NETWORKING
    delete m_connection; m_connection = NULL;
#endif
}

WeaponType Game::GetSelectedWeapon ()
{
    return m_selectedWeapon;
}

double Game::GetHealth ()
{
    return m_health;
}

void Game::SetMyIndex ( char _index )
{
    m_me = m_players.get ( _index );
    ARCReleaseAssert ( m_me != NULL );
}

void Game::AddPlayer ( Player *_player, int _index )
{
    ARCReleaseAssert ( _player != NULL );
    if ( m_players.valid ( _index ) )
    {
        g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "WARNING: Player overwritten. Memory leak!" );
        g_console->SetColour ();
    }
    m_players.insert ( _player, _index );
}

void Game::RemovePlayer ( int _index )
{
    ARCReleaseAssert ( m_players.valid ( _index ) );
    Player *player = m_players.get ( _index );
    m_players.remove ( _index );
    delete player;
}

Data::DArray<Player *> *Game::GetPlayers()
{
    return &m_players;
}

double Game::GetWeaponDamage ( WeaponType _type )
{
    switch ( _type )
    {
    case WEAPON_TYPE_LASER:
        return m_laserDamage[m_damageLevel];
        break;
    case WEAPON_TYPE_BOUNCE:
        return m_bounceDamage[m_damageLevel];
        break;
    case WEAPON_TYPE_MISSILE:
        return m_missileDamage[m_damageLevel];
        break;
    case WEAPON_TYPE_GRENADE:
        // Damage from a direct grenade hit comes from the shrapnel.
        return 0;
        break;
    case WEAPON_TYPE_SHRAPNEL:
        return m_shrapnelDamage[m_damageLevel];
        break;
    default:
        ARCAbort ( "Invalid weapon" );
    }
    return 0;
}

void Game::FlagReturnedTo ( ShipType _teamFlag, ShipType _teamCapturedBy )
{
    Data::LList<std::string> *soundQueue = new Data::LList<std::string>();
    switch ( _teamFlag )
    {
    case SHIP_TYPE_GREEN:
        soundQueue->insert ( "green" );
        break;
    case SHIP_TYPE_YELLOW:
        soundQueue->insert ( "yellow" );
        break;
    case SHIP_TYPE_RED:
        soundQueue->insert ( "red" );
        break;
    case SHIP_TYPE_BLUE:
        soundQueue->insert ( "blue" );
        break;
    case SHIP_TYPE_NEUTRAL:
        soundQueue->insert ( "neutral" );
        break;
    }
    soundQueue->insert ( "flagret" );
    switch ( _teamCapturedBy )
    {
    case SHIP_TYPE_GREEN:
        soundQueue->insert ( "green" );
        break;
    case SHIP_TYPE_YELLOW:
        soundQueue->insert ( "yellow" );
        break;
    case SHIP_TYPE_RED:
        soundQueue->insert ( "red" );
        break;
    case SHIP_TYPE_BLUE:
        soundQueue->insert ( "blue" );
        break;
    case SHIP_TYPE_NEUTRAL:
        soundQueue->insert ( "neutral" );
        break;
    }
    soundQueue->insert ( "base" );
    g_soundSystem->AddQueue ( soundQueue );
}

void Game::FlagCapturedBy ( ShipType _teamFlag, ShipType _teamCapturedBy )
{
    Data::LList<std::string> *soundQueue = new Data::LList<std::string>();
    switch ( _teamFlag )
    {
    case SHIP_TYPE_GREEN:
        soundQueue->insert ( "green" );
        break;
    case SHIP_TYPE_YELLOW:
        soundQueue->insert ( "yellow" );
        break;
    case SHIP_TYPE_RED:
        soundQueue->insert ( "red" );
        break;
    case SHIP_TYPE_BLUE:
        soundQueue->insert ( "blue" );
        break;
    case SHIP_TYPE_NEUTRAL:
        soundQueue->insert ( "neutral" );
        break;
    }
    soundQueue->insert ( "flagcap" );
    switch ( _teamCapturedBy )
    {
    case SHIP_TYPE_GREEN:
        soundQueue->insert ( "green" );
        break;
    case SHIP_TYPE_YELLOW:
        soundQueue->insert ( "yellow" );
        break;
    case SHIP_TYPE_RED:
        soundQueue->insert ( "red" );
        break;
    case SHIP_TYPE_BLUE:
        soundQueue->insert ( "blue" );
        break;
    case SHIP_TYPE_NEUTRAL:
        soundQueue->insert ( "neutral" );
        break;
    }
    soundQueue->insert ( "team" );
    g_soundSystem->AddQueue ( soundQueue );
}

void Game::WeaponHit ( Player *_attacker, WeaponType _type )
{
    switch ( _type )
    {
    case WEAPON_TYPE_LASER:
    case WEAPON_TYPE_BOUNCE:
    case WEAPON_TYPE_MISSILE:
    case WEAPON_TYPE_SHRAPNEL:
        m_health -= (short)GetWeaponDamage ( _type );
        break;
    case WEAPON_TYPE_GRENADE:
        if ( !m_me->InPen() )
        {
            m_health -= (short)GetWeaponDamage ( _type );
        }
        break;
    default:
        ARCAbort ( "Invalid weapon" );
    }
    if ( m_health < 0 ) m_health = 0;
}

void Game::Initialise()
{
    LoadingWindow *window = new LoadingWindow();
    g_interface->AddWidget ( window );

#ifndef ENABLE_NETWORKING
    Player *player = new Player ( "Nobody", SHIP_TYPE_GREEN, 0, 1, 0 );
    player->SetPosition ( 1000, 1660 );
    m_players.insert ( player );
    m_me = player;
#endif

    TextUI *text = new TextUI (
        "\2" APP_NAME,
        false, g_graphics->GetScreenWidth () - 290, g_graphics->GetScreenHeight () - 38, 270, 12 );
    g_interface->AddWidget ( text );

    text = new TextUI (
        "\2For testing purposes only. v" VERSION_STRING,
        false, g_graphics->GetScreenWidth () - 290, g_graphics->GetScreenHeight () - 25, 270, 12 );
    g_interface->AddWidget ( text );

#ifndef RELEASE_BUILD
    text = new TextUI (
        "\2NOT FOR PUBLIC INSPECTION OR REDISTRIBUTION",
        false, g_graphics->GetScreenWidth () - 290, g_graphics->GetScreenHeight () - 12, 270, 12 );
    g_interface->AddWidget ( text );
#endif
}

int Game::LoadMap ( const char *_mapFile )
{
    ARCReleaseAssert ( _mapFile != NULL );
    ARCDebugAssert ( m_map == NULL );
    m_map = new Map();
    return m_map->Load ( _mapFile );
}

void Game::Quit()
{
    m_running = false;
}

void Game::RenderShips ()
{
    for ( size_t i = 0; i < m_players.size(); i++ )
    {
        if ( m_players.valid ( i ) )
        {
            if ( m_players[i] == g_game->m_me ) continue;
            m_players[i]->Update ();
            m_players[i]->Render ();
        }
    }
    g_game->m_me->Update ();
    g_game->m_me->Render ();
}

void Game::RenderFlag ( short _team, short _index )
{
    Player *player = NULL;
    Map *map = m_map;
    short g = _team, xt = 0, yt = 0;
    switch ( _team )
    {
    case 1:
        {
            if ( map->m_flagCarry1[_index] > 0 )
            {
                ARCReleaseAssert ( m_players.valid ( map->m_flagCarry1[_index] ) );
                player = m_players.get ( map->m_flagCarry1[_index] );
                ARCReleaseAssert ( player );
                map->m_flagPosition1[0][_index] = (Uint16)player->m_charX + 16;
                map->m_flagPosition1[1][_index] = (Uint16)player->m_charY + 3;
                g = 9;
            }
            xt = map->m_flagPosition1[0][_index];
            yt = map->m_flagPosition1[1][_index];
        }
        break;
    case 2:
        {
            if ( map->m_flagCarry2[_index] > 0 )
            {
                ARCReleaseAssert ( m_players.valid ( map->m_flagCarry2[_index] ) );
                player = m_players.get ( map->m_flagCarry2[_index] );
                ARCReleaseAssert ( player );
                map->m_flagPosition2[0][_index] = (Uint16)player->m_charX + 16;
                map->m_flagPosition2[1][_index] = (Uint16)player->m_charY + 3;
                g = 9;
            }
            xt = map->m_flagPosition2[0][_index];
            yt = map->m_flagPosition2[1][_index];
        }
        break;
    case 3:
        {
            if ( map->m_flagCarry3[_index] > 0 )
            {
                ARCReleaseAssert ( m_players.valid ( map->m_flagCarry3[_index] ) );
                player = m_players.get ( map->m_flagCarry3[_index] );
                ARCReleaseAssert ( player );
                map->m_flagPosition3[0][_index] = (Uint16)player->m_charX + 16;
                map->m_flagPosition3[1][_index] = (Uint16)player->m_charY + 3;
                g = 9;
            }
            xt = map->m_flagPosition3[0][_index];
            yt = map->m_flagPosition3[1][_index];
        }
        break;
    case 4:
        {
            if ( map->m_flagCarry4[_index] > 0 )
            {
                ARCReleaseAssert ( m_players.valid ( map->m_flagCarry4[_index] ) );
                player = m_players.get ( map->m_flagCarry4[_index] );
                ARCReleaseAssert ( player );
                map->m_flagPosition4[0][_index] = (Uint16)player->m_charX + 16;
                map->m_flagPosition4[1][_index] = (Uint16)player->m_charY + 3;
                g = 9;
            }
            xt = map->m_flagPosition4[0][_index];
            yt = map->m_flagPosition4[1][_index];
        }
        break;
    case 5:
        {
            if ( map->m_flagCarry5[_index] > 0 )
            {
                ARCReleaseAssert ( m_players.valid ( map->m_flagCarry5[_index] ) );
                player = m_players.get ( map->m_flagCarry5[_index] );
                ARCReleaseAssert ( player );
                map->m_flagPosition5[0][_index] = (Uint16)player->m_charX + 16;
                map->m_flagPosition5[1][_index] = (Uint16)player->m_charY + 3;
                g = 9;
            }
            xt = map->m_flagPosition5[0][_index];
            yt = map->m_flagPosition5[1][_index];
        }
        break;
    default:
        ARCAbort ( "Invalid team" );
        break;
    }

    // Is the flag being carried?
    if ( g != 9 )
    {
        short x = xt / 16,
              y = yt / 16;
        
        switch ( g )
        {
        case 1:
        case 2:
        case 3:
        case 4:
            if ( map->m_animations[y][x] == 27 + g ) g = 10;
            if ( map->m_animations[y][x] == 35 + g ) g = 10;
            if ( map->m_animations[y][x] == 43 + g ) g = 10;
            if ( map->m_animations[y][x] == 61 + g ) g = 10;
            break;
        case 5:
            if ( map->m_animations[y][x] == 132 ) g = 10;
            if ( map->m_animations[y][x] == 133 ) g = 10;
            if ( map->m_animations[y][x] == 134 ) g = 10;
            if ( map->m_animations[y][x] == 135 ) g = 10;
            if ( map->m_animations[y][x] == 140 ) g = 10;
            break;
        }
    }

    // Is this already rendered by the animations indexes?
    if ( g != 10 )
    {
        short CenterSX = g_graphics->GetCenterX() - 16,
              CenterSY = g_graphics->GetCenterY() - 16;
        short MeX = (short)(g_game->m_me->GetX() - CenterSX),
              MeY = (short)(g_game->m_me->GetY() - CenterSY);

        short ResX = g_graphics->GetScreenWidth(),
              ResY = g_graphics->GetScreenHeight();
        xt -= MeX;
        yt -= MeY;

        if ( xt > -15 && yt > -15 && xt < ResX && yt < ResY )
        {
            SDL_Rect rFlag, rDest;
            rFlag.y = 32 * ( _team - 1 );
            rFlag.x = 570;
            rFlag.w = 12;
            rFlag.h = 12;
            if ( xt < 0 ) { rFlag.x += abs(xt); xt = 0; }
            if ( yt < 0 ) { rFlag.y += abs(yt); yt = 0; }
            if ( xt > ResX - 12 )
            {
                rFlag.w -= (xt - (ResX - 12) );
                xt = ResX - 12 + (xt - (ResX - 12));
            }
            if ( yt > ResY - 12 )
            {
                rFlag.h -= (yt - (ResY - 12) );
                yt = ResY - 12 + (yt - (ResY - 12));
            }
            rDest.x = xt;
            rDest.y = yt;
            // TODO: FlagBlink
            g_graphics->Blit ( g_interface->GetTuna1SurfaceID(), &rFlag, g_graphics->GetScreen(), &rDest );
        }
    }
}

void Game::RenderFlags ()
{
    for ( int i = 0; i < MAX_FLAGPOLES; i++ )
    {
        if ( !m_map->m_flagPosition1[0] ) break;
        if ( m_map->m_flagCarry1[i] == 0 ) RenderFlag ( 1, i );
    }
    for ( int i = 0; i < MAX_FLAGPOLES; i++ )
    {
        if ( !m_map->m_flagPosition2[0] ) break;
        if ( m_map->m_flagCarry2[i] == 0 ) RenderFlag ( 2, i );
    }
    for ( int i = 0; i < MAX_FLAGPOLES; i++ )
    {
        if ( !m_map->m_flagPosition3[0] ) break;
        if ( m_map->m_flagCarry3[i] == 0 ) RenderFlag ( 3, i );
    }
    for ( int i = 0; i < MAX_FLAGPOLES; i++ )
    {
        if ( !m_map->m_flagPosition4[0] ) break;
        if ( m_map->m_flagCarry4[i] == 0 ) RenderFlag ( 4, i );
    }
    for ( int i = 0; i < MAX_FLAGPOLES; i++ )
    {
        if ( !m_map->m_flagPosition5[0] ) break;
        if ( m_map->m_flagCarry5[i] == 0 ) RenderFlag ( 5, i );
    }
}

void Game::RenderCapturedFlags ()
{
    for ( size_t i = 0; i < m_players.size(); i++ )
    {
        if ( !m_players.valid ( i ) ) continue;

        Player *player = m_players.get ( i );
        if ( player->m_flagWho == 0 ) continue;

        switch ( player->m_flagWho )
        {
        case 1:
            if ( m_map->m_flagCarry1[(int)player->m_flagID] > 0 ) RenderFlag ( 1, player->m_flagID );
            break;
        case 2:
            if ( m_map->m_flagCarry2[(int)player->m_flagID] > 0 ) RenderFlag ( 2, player->m_flagID );
            break;
        case 3:
            if ( m_map->m_flagCarry3[(int)player->m_flagID] > 0 ) RenderFlag ( 3, player->m_flagID );
            break;
        case 4:
            if ( m_map->m_flagCarry4[(int)player->m_flagID] > 0 ) RenderFlag ( 4, player->m_flagID );
            break;
        case 5:
            if ( m_map->m_flagCarry5[(int)player->m_flagID] > 0 ) RenderFlag ( 5, player->m_flagID );
            break;
        }
    }
}

void Game::SubtractLaserCharge ( double _amount )
{
    if ( m_me->m_cheat != 0 && m_me->m_cheat != 5 )
        return;
    m_laserCharge -= _amount;
    if ( m_laserCharge < 0.0 )
        m_laserCharge = 0.0;
}

void Game::LoadSounds ()
{
    g_soundSystem->LoadWave ( "armorlo" );
    g_soundSystem->LoadWave ( "base" );
    g_soundSystem->LoadWave ( "blue" );
    g_soundSystem->LoadWave ( "bounce" );
    g_soundSystem->LoadWave ( "bounhits" );
    g_soundSystem->LoadWave ( "bounshot" );
    g_soundSystem->LoadWave ( "dropflag" );
    g_soundSystem->LoadWave ( "flagcap" );
    g_soundSystem->LoadWave ( "flagret" );
    g_soundSystem->LoadWave ( "got_boun" );
    g_soundSystem->LoadWave ( "got_miss" );
    g_soundSystem->LoadWave ( "got_mort" );
    g_soundSystem->LoadWave ( "gotpup" );
    g_soundSystem->LoadWave ( "green" );
    g_soundSystem->LoadWave ( "laser" );
    g_soundSystem->LoadWave ( "lasrhits" );
    g_soundSystem->LoadWave ( "lasrhitw" );
    g_soundSystem->LoadWave ( "lose" );
    g_soundSystem->LoadWave ( "mine" );
    g_soundSystem->LoadWave ( "missile" );
    g_soundSystem->LoadWave ( "morthit" );
    g_soundSystem->LoadWave ( "mortlnch" );
    g_soundSystem->LoadWave ( "neutral" );
    g_soundSystem->LoadWave ( "rd_close" );
    g_soundSystem->LoadWave ( "rd_open" );
    g_soundSystem->LoadWave ( "red" );
    g_soundSystem->LoadWave ( "rockhits" );
    g_soundSystem->LoadWave ( "rockhitw" );
    g_soundSystem->LoadWave ( "shipexpl" );
    g_soundSystem->LoadWave ( "spawn" );
    g_soundSystem->LoadWave ( "sw_flip" );
    g_soundSystem->LoadWave ( "sw_spec" );
    g_soundSystem->LoadWave ( "sysinit" );
    g_soundSystem->LoadWave ( "team" );
    g_soundSystem->LoadWave ( "teamwins" );
    g_soundSystem->LoadWave ( "warp" );
    g_soundSystem->LoadWave ( "welcome" );
    g_soundSystem->LoadWave ( "win" );
    g_soundSystem->LoadWave ( "yellow" );
}

void Game::SetLoadState ( LoadState _loadState )
{
    m_nextLoadState = m_loadState = _loadState;
    m_loadPauseTime = 0.0;
}

void Game::SetMapName ( const char *_mapfile )
{
    ARCReleaseAssert ( _mapfile != NULL );
    m_mapName = string(_mapfile);
}

const char *Game::GetMapName()
{
    return m_mapName.c_str();
}

void Game::SetTeamScore ( ShipType _team, short _score )
{
    ARCReleaseAssert ( _team >= 0 && _team <= 4 );
    m_teamScores[(int)_team] = _score;
}

void Game::SetLaserDamage ( char _damage )
{
     m_laserDamageSetting = _damage;
}

void Game::SetSpecialDamage ( char _damage )
{
     m_specialDamageSetting = _damage;
}

void Game::SetRechargeRate ( char _rate )
{
    m_rechargeRate = _rate;
}

void Game::SetHoldTime ( char _time )
{
    m_holdTime = _time;
}

void Game::SetPing ( short _ping )
{
    m_ping = _ping;
    if ( _ping > m_highPing ) m_highPing = _ping;
}

void Game::Run ( const char *_hostname, unsigned short _port, const char *_nickname, const char *_password )
{
    int framesThisSecond = 0;
	bool deviceLost = false;

    //g_interface->UpdateFPS ( 0 );

    m_tmrFPS.Start();
    m_loadPause.Start();
    m_tmrGameSpeed.Start();

    System::Stopwatch lastFrame;
    lastFrame.Start();

    ARCReleaseAssert ( g_interface != NULL );
    ARCReleaseAssert ( g_graphics != NULL );

    SDL_EnableUNICODE ( 1 );

#ifdef BENCHMARK_BUILD
    for ( int i = 0; i < BENCHMARK_WIDGETS; i++ )
    {
        short xpos = rand() % (g_graphics->GetScreenWidth() - 48),
              ypos = rand() % (g_graphics->GetScreenHeight() - 48);
        g_interface->AddWidget ( new BouncingWindow ( xpos, ypos, 48, 48, rand() % 20 - 10, rand() % 20 - 10 ) );
    }
#endif

	g_interface->UpdateRendererWidget();

    while ( m_running )
    {
        // Force 60fps max.
#ifndef FORCE_VSYNC
        if ( g_prefsManager->GetInt ( "WaitVerticalRetrace", 1 ) != 0 )
#endif
        {
            int sleepTime;
            lastFrame.Stop();
            sleepTime = (int)( ( 1000.0 / 60.0 ) - ( lastFrame.Elapsed() * 1000.0 ) );
            if ( sleepTime > 0 )
                System::ThreadSleep ( sleepTime );
            lastFrame.Start();
        }

        ProcessEvents();
        g_interface->ProcessMouseEvents();

        if ( m_playing )
        {
            g_interface->RenderFarplane ( (short)m_me->GetX(), (short)m_me->GetY() );
#ifndef BENCHMARK_BUILD
            g_interface->RenderMap ();
            RenderFlags();
            g_interface->RenderLasers();
            g_interface->RenderBouncies();
            g_interface->RenderSparks();
            g_interface->RenderMissiles();
            g_interface->RenderShrapnel();
            g_interface->RenderMissileSmoke();
            RenderShips();
            g_interface->RenderLaserZaps();
            RenderCapturedFlags();
            g_interface->RenderGrenadeSmoke();
            g_interface->RenderShipExplosions();
            g_interface->RenderGrenades();
            g_interface->RenderGrenadeExplosions();
            /// RENDER UI
            g_interface->RenderGameUI();
#endif

            /// UPDATE WEAPON CHARGES
            if ( m_laserCharge < 60 )
                m_laserCharge += GetGameSpeed() * 0.21;

            if ( m_laserCharge > 60 )
                m_laserCharge = 60;
        } else {
            //g_graphics->FillRect ( g_graphics->GetScreen(), NULL, 0 );
            LoadingWindow *window = dynamic_cast<LoadingWindow *>(g_interface->GetWidgetOfType ( "LoadingWindow" ));

            if ( m_loadState != 500 )
            {
                // Don't render the farplane on a post-game error state.
                g_interface->RenderFarplane (
                    (short)(( ( 1280 / 2 ) - ( g_graphics->GetScreenWidth()  / 2 ) ) / 0.1568 - 250.0),
                    (short)(( ( 960  / 2 ) - ( g_graphics->GetScreenHeight() / 2 ) ) / 0.1176 + 100.0)
                );
            }

            m_loadPause.Stop();
            if ( m_loadPause.Elapsed() > m_loadPauseTime )
            {
                switch ( m_loadState = m_nextLoadState )
                {
                case LOAD_STATE_SPINWAIT:
                case LOAD_STATE_NULL:
                    m_nextLoadState = m_loadState;
                    m_loadPauseTime = 1.0;
                    break;
                case LOAD_STATE_PRELOAD_SOUNDS_MSG: // Load sounds.
                    ARCReleaseAssert ( window != NULL );
                    window->SetCaption ( "Preloading sounds..." );
                    m_nextLoadState = LOAD_STATE_PRELOAD_SOUNDS;
                    m_loadPauseTime = 0.1;
                    break;
                case LOAD_STATE_PRELOAD_SOUNDS:
                    LoadSounds();
#ifdef ENABLE_NETWORKING
                    m_nextLoadState = LOAD_STATE_CONNECTING_MSG;
#else
                    m_nextLoadState = LOAD_STATE_LOADMAP_MSG;
#endif
                    m_loadPauseTime = 0.1;
                    break;
#ifdef ENABLE_NETWORKING
                case LOAD_STATE_CONNECTING_MSG:
                    {
                        char temp[1024];
                        sprintf ( temp, "Connecting to %s:%d...", _hostname, _port );
                        ARCReleaseAssert ( window != NULL );
                        window->SetCaption ( temp );
                        m_nextLoadState = LOAD_STATE_CONNECTING;
                        m_loadPauseTime = 0.1;
                    }
                    break;
                case LOAD_STATE_CONNECTING:
                    {
                        int err = 0;

                        
                        // First run through this state. Create the connection class.
                        if ( !m_connection )
                            m_connection = new Connection ();

                        // This call will not reinstantiate sockets if they already exist.
                        // It acts as a poll for non-blocking sockets
                        err = m_connection->Connect ( _hostname, _port );

                        // Check for errors.
                        if ( err == CC_ERR_WOULD_BLOCK )
                        {
                            // We're waiting for the connection to establish.
                            m_nextLoadState = LOAD_STATE_CONNECTING;
                            m_loadPauseTime = 0.5;
                        }
                        else if ( err != CC_ERR_NONE )
                        {
                            // An error has occurred
                            delete m_connection; m_connection = NULL;
                            char buffer[512];
                            sprintf ( buffer, "Connection failed: %s", GetErrorDescription ( (CrissCross::Errors)err ) );
                            g_interface->RemoveWidget ( window );
                            g_interface->AddWidget ( new ErrorWindow ( buffer, true ) );
                            SetLoadState ( LOAD_STATE_SPINWAIT );
                        } else {
                            // We'de better be connected by now.
                            ARCReleaseAssert ( m_connection->m_net->State() == Network::SOCKET_STATE_CONNECTED );
                            SetLoadState ( LOAD_STATE_SEND_LOGIN );
                        }
                    }
                    break;
                case LOAD_STATE_SEND_LOGIN:
                    ARCReleaseAssert ( window != NULL );
                    window->SetCaption ( "Sending login request..." );
                    m_connection->SendLogin ( _nickname, _password );
                    m_loadPauseTime = 2.0;
                    m_nextLoadState = m_loadState;
                    break;
                case LOAD_STATE_REQUEST_MAP:
                    ARCReleaseAssert ( window != NULL );
                    window->SetCaption ( "Requesting map..." );
                    m_connection->SendMapRequest ();
                    m_nextLoadState = m_loadState;
                    m_loadPauseTime = 2.0;
                    break;
                case LOAD_STATE_SEND_GAMELOGIN:
                    ARCReleaseAssert ( window != NULL );
                    window->SetCaption ( "Negotiating..." );
                    m_connection->SendGameLogin ();
                    m_nextLoadState = m_loadState;
                    m_loadPauseTime = 2.0;
                    break;
                case LOAD_STATE_TRANSFER_MAP:
                    if ( m_connection->m_receivingMap )
                    {
                        window->SetCaption ( "Transferring map..." );
                        g_interface->RenderMapTransfer ( m_connection->m_mapTransferPercent );
                        m_loadPauseTime = 0.0;
                        m_nextLoadState = LOAD_STATE_TRANSFER_MAP;
                    }
                    break;
                case LOAD_STATE_LOADMAP_MSG:
                    ARCReleaseAssert ( window != NULL );
                    window->SetCaption ( "Loading map..." );
                    m_nextLoadState = LOAD_STATE_LOADMAP;
                    m_loadPauseTime = 0.2;
                    break;
                case LOAD_STATE_LOADMAP:
                    LoadMap ( m_mapName.c_str() );
                    ARCReleaseAssert ( window != NULL );
                    m_nextLoadState = LOAD_STATE_RECEIVE_WORLDSTATE;
                    m_loadPauseTime = 0.0;
                    break;
                case LOAD_STATE_RECEIVE_WORLDSTATE:
                    window->SetCaption ( "Receiving world state..." );
                    m_connection->SendUpdateRequest();
                    m_nextLoadState = LOAD_STATE_SPINWAIT;
                    m_loadPauseTime = 0.0;
                    break;
                case LOAD_STATE_SYNCHRONIZING:
                    ARCReleaseAssert ( window != NULL );
                    window->SetCaption ( "Synchronizing..." );
                    m_connection->SendSwitchRequest();
                    m_nextLoadState = m_loadState;
                    m_loadPauseTime = 2.0;
                    break;

#else
                case LOAD_STATE_LOADMAP_MSG:
                    ARCReleaseAssert ( window != NULL );
                    window->SetCaption ( "Loading map..." );
                    m_nextLoadState = LOAD_STATE_LOADMAP;
                    m_loadPauseTime = 0.1;
                    break;
                case LOAD_STATE_LOADMAP:
#ifndef BENCHMARK_BUILD
                    LoadMap ( "cobalt_madwarse_v3.map" );
#endif
                    m_nextLoadState = LOAD_STATE_RUN_GAME;
                    m_loadPauseTime = 0.1;
                    break;
                case LOAD_STATE_RUN_GAME:
#ifndef BENCHMARK_BUILD
                    ARCReleaseAssert ( window != NULL );
                    g_interface->RemoveWidget ( window );
                    g_soundSystem->PlaySound ( "welcome", 0, 0 );
#endif
                    m_nextLoadState = LOAD_STATE_SPINWAIT;
                    m_loadPauseTime = 0.1;
                    m_playing = true;
                    break;
#endif
                default:
                    ARCAbort ( "Unrecognised runlevel" );
                    break;
                }
                m_loadPause.Start();
            }
        }

        /// RENDER WIDGETS
        g_interface->RenderWidgets();

        /// RENDER MOUSE
        g_interface->RenderMouse();

        // Play any queued sounds.
        if ( g_soundSystem != NULL )
            g_soundSystem->Update();

        if ( !g_graphics->Flip() )
		{
			if ( !deviceLost )
			{
				g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
				g_console->WriteLine ( "WARNING: Device lost, textures need to be recreated." );
				g_console->SetColour ();
				deviceLost = true;
			}
		} else {
			if ( deviceLost )
			{
				g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
				g_console->WriteLine ( "WARNING: Device recaptured. Recreating textures." );
				g_console->SetColour ();
				/*
				g_interface->InitSurfaces();
				if (m_map) m_map->BlitEntireMap();
				g_interface->InitWidgets();
				*/
				deviceLost = false;
			}
		}

        // Add a frame to the count.
        framesThisSecond++;

        // Now make sure we haven't used up a second yet.
        m_tmrFPS.Stop();
        if ( m_tmrFPS.Elapsed() >= 1.0 )
        {
            g_interface->UpdateFPS ( framesThisSecond );
            framesThisSecond = 0;
            m_tmrFPS.Start();
        }

#ifdef ENABLE_NETWORKING
        int retval = CC_ERR_NONE;

        if ( m_connection != NULL && m_connection->m_net->State() == Network::SOCKET_STATE_CONNECTED )
        {
            retval = m_connection->Update();

            // TODO: This error message isn't always entirely accurate.
            if ( retval != CC_ERR_NONE )
            {
                delete m_connection; m_connection = NULL;
                delete m_map; m_map = NULL;
                m_playing = false;

                char buffer[512];
                sprintf ( buffer, "Connection error: %s", GetErrorDescription ( (CrissCross::Errors)retval ) );
                g_interface->AddWidget ( new ErrorWindow ( buffer, true ) );

                SetLoadState ( LOAD_STATE_SPINWAIT );
            }
        }
#endif

        // Let's hold movement speed at a constant.
        m_tmrGameSpeed.Stop();
        m_gameSpeed = 71.5 * m_tmrGameSpeed.Elapsed();
        if ( m_gameSpeed > 50.0 ) m_gameSpeed = 50.0;
        m_tmrGameSpeed.Start();
    }
}

void Game::SetPlaying ( bool _playing )
{
    m_playing = _playing;
}

bool Game::Playing()
{
    return m_playing;
}

void Game::ProcessEvents ()
{
    static bool chatting;
    static char chatBuffer[1024], *chatBufPtr = NULL;

    SDL_Event event;
    while ( SDL_PollEvent ( &event ) )
    {
        switch ( event.type )
        {
        case SDL_QUIT:
            m_running = false;
            break;
        case SDL_KEYDOWN:
            {
                switch ( event.key.keysym.sym )
                {
                case SDLK_TAB:
                    {
#ifdef ENABLE_NETWORKING
                        if ( m_me->m_flagWho > 0 )
                            m_connection->SendDropFlag();
#endif
                    }
                    break;
                case SDLK_BACKQUOTE:
                    {
                        char buffer[64];
                        sprintf ( buffer, "\6Weighted Ping: %d, Highest Ping: %d, Current FPS: %d", m_ping, m_highPing, m_fps );
                        g_interface->AddChat ( buffer );
                    }
                    break;
                case SDLK_RCTRL:
                case SDLK_LCTRL:
                    {
                        switch ( m_selectedWeapon )
                        {
                        case WEAPON_TYPE_GRENADE:
                            m_selectedWeapon = WEAPON_TYPE_BOUNCE;
                            g_soundSystem->PlaySound ( "got_boun", 0, 0 );
                            break;
                        case WEAPON_TYPE_BOUNCE:
                            m_selectedWeapon = WEAPON_TYPE_MISSILE;
                            g_soundSystem->PlaySound ( "got_miss", 0, 0 );
                            break;
                        case WEAPON_TYPE_MISSILE:
                            m_selectedWeapon = WEAPON_TYPE_GRENADE;
                            g_soundSystem->PlaySound ( "got_mort", 0, 0 );
                            break;
                        default:
                            ARCAbort ( "Invalid weapon" );
                            break;
                        }
                    }
                    break;
                case SDLK_KP_ENTER:
                case SDLK_RETURN:
                    {
                        int sendKeyResult = g_interface->SendEnterKey ();
                        if ( !chatting && !sendKeyResult && m_playing )
                        {
                            chatting = true;

                            memset ( &chatBuffer, 0, sizeof ( chatBuffer ) );
                            chatBuffer[0] = (char)9;
                            chatBufPtr = chatBuffer + 1;

                            g_interface->AddWidget (
                                new TextInput ( chatBuffer, false,
                                5, g_graphics->GetScreenHeight() - 17,
                                g_graphics->GetScreenWidth() - 20, 13 ) );

                        }
                        else if ( chatting && !sendKeyResult )
                        {
                            TextInput *ti = (TextInput *)g_interface->GetWidgetOfType ( "TextInput" );
                            ARCReleaseAssert ( ti );
                            g_interface->RemoveWidget ( ti );
                            ti = NULL;

#ifdef ENABLE_NETWORKING
                            if ( strlen(&chatBuffer[1]) > 0 )
                                m_connection->SendGameChat ( &chatBuffer[1] );
#endif

                            chatting = false;
                        }
                    }
                    break;
                case SDLK_ESCAPE:
                    if ( m_playing )
                    {
                        QuitWindow *quitWindow;
                        if ( (quitWindow = (QuitWindow *)g_interface->GetWidgetOfType ( "QuitWindow" )) != NULL )
                        {
                            g_interface->RemoveWidget ( quitWindow );
                        } else {
                            QuitWindow *quitWindow = new QuitWindow();
                            g_interface->AddWidget ( quitWindow );
                            quitWindow = NULL;
                        }
                    } else {
                        m_running = false;
                    }
                    break;
                case SDLK_BACKSPACE:
                    break;
                default:
                    if ( !chatting )
                    {
                        chatting = true;

                        memset ( &chatBuffer, 0, sizeof ( chatBuffer ) );
                        chatBuffer[0] = (char)9;
                        chatBufPtr = chatBuffer + 1;

                        g_interface->AddWidget (
                            new TextInput ( chatBuffer, false,
                            5, g_graphics->GetScreenHeight() - 17,
                            g_graphics->GetScreenWidth() - 20, 13 ) );
                    }
                    if ( chatting && event.key.keysym.unicode < 0x80 && event.key.keysym.unicode > 0 )
                    {
                        if ( (unsigned long)(chatBufPtr - chatBuffer) >= sizeof ( chatBuffer ) - 1 )
                            break;
                        *chatBufPtr++ = (char)event.key.keysym.unicode;
                        *chatBufPtr = '\0';

                        TextInput *ti = (TextInput *)g_interface->GetWidgetOfType ( "TextInput" );
                        ARCReleaseAssert ( ti );
                        ti->SetText ( chatBuffer );
                    }
                    break;
                }
            }
            break;
        }
    }
    
    int arraySz = 0;
    Uint8 *keyState = SDL_GetKeyState(&arraySz);
    MovementDirections keyIs = MOVE_NONE;
    bool keyIsSet = false;

    static System::Stopwatch lastBackspace;
    lastBackspace.Stop();
    if ( keyState[SDLK_BACKSPACE] && chatting && chatBufPtr > &chatBuffer[1] && lastBackspace.Elapsed() > 0.1 )
    {
        *--chatBufPtr = '\0';
        TextInput *ti = (TextInput *)g_interface->GetWidgetOfType ( "TextInput" );
        ARCReleaseAssert ( ti );
        ti->SetText ( chatBuffer );
        lastBackspace.Start();
    }

    // Handle Command+Q on Mac OS X
#ifdef TARGET_OS_MACOSX
    static bool cmdQ = false;
    if ( !cmdQ && ( keyState[SDLK_LMETA] || keyState[SDLK_RMETA] ) && keyState[SDLK_q] )
    {
        cmdQ = true;
        if ( m_playing )
        {
            QuitWindow *quitWindow;
            if ( (quitWindow = (QuitWindow *)g_interface->GetWidgetOfType ( "QuitWindow" )) != NULL )
            {
                g_interface->RemoveWidget ( quitWindow );
            } else {
                QuitWindow *quitWindow = new QuitWindow();
                g_interface->AddWidget ( quitWindow );
                quitWindow = NULL;
            }
        } else {
            m_running = false;
        }
    } else if ( cmdQ && ( !keyState[SDLK_LMETA] && !keyState[SDLK_RMETA] ) || !keyState[SDLK_q] ) {
        cmdQ = false;
    }
#endif

    // Process movement keys, if alive
    if ( m_playing )
    {
        if ( keyState[SDLK_UP] && keyState[SDLK_LEFT] && !keyIsSet )
        {
            keyIs = MOVE_UP_LEFT;
            keyIsSet = true;
        }
        if ( keyState[SDLK_UP] && keyState[SDLK_RIGHT] && !keyIsSet )
        {
            keyIs = MOVE_UP_RIGHT;
            keyIsSet = true;
        }
        if ( keyState[SDLK_DOWN] && keyState[SDLK_LEFT] && !keyIsSet )
        {
            keyIs = MOVE_DOWN_LEFT;
            keyIsSet = true;
        }
        if ( keyState[SDLK_DOWN] && keyState[SDLK_RIGHT] && !keyIsSet )
        {
            keyIs = MOVE_DOWN_RIGHT;
            keyIsSet = true;
        }
        if ( keyState[SDLK_DOWN] && !keyIsSet )
        {
            keyIs = MOVE_DOWN;
            keyIsSet = true;
        }
        if ( keyState[SDLK_UP] && !keyIsSet )
        {
            keyIs = MOVE_UP;
            keyIsSet = true;
        }
        if ( keyState[SDLK_LEFT] && !keyIsSet )
        {
            keyIs = MOVE_LEFT;
            keyIsSet = true;
        }
        if ( keyState[SDLK_RIGHT] && !keyIsSet )
        {
            keyIs = MOVE_RIGHT;
            keyIsSet = true;
        }
        if ( (keyState[SDLK_RIGHT] && keyState[SDLK_LEFT]) ||
             (keyState[SDLK_UP] && keyState[SDLK_DOWN]) )
        {
            keyIs = MOVE_NONE;
        }

        m_me->SetDirection ( keyIs );
    }
}

Map *Game::GetMap()
{
    return m_map;
}

double Game::GetGameSpeed()
{
    return m_gameSpeed;
}

Game *g_game;
