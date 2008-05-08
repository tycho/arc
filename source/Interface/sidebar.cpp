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

#include "Game/game.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/sidebar.h"

const SDL_Rect rWeaponAmmo[2] = { { 465, 374, 4, 3}, {465, 380, 23, 4 } };

Sidebar::Sidebar()
 : Widget()
{
    SetWidgetClass ( "Sidebar" );
    
    SDL_PixelFormat *format;
    
    m_healthBarSurfaceID = g_graphics->CreateSurface ( 60, 15, false );
    format = g_graphics->GetPixelFormat ( m_healthBarSurfaceID );
    g_graphics->FillRect ( m_healthBarSurfaceID, NULL, SDL_MapRGBA ( format, 128, 0, 0, 255 ) );
    g_graphics->SetSurfaceAlpha ( m_healthBarSurfaceID, 192 );
    
    m_chargeBarSurfaceID = g_graphics->CreateSurface ( 60, 15, false );
    format = g_graphics->GetPixelFormat ( m_chargeBarSurfaceID );
    g_graphics->FillRect ( m_chargeBarSurfaceID, NULL, SDL_MapRGBA ( format, 0, 0, 128, 255 ) );
    g_graphics->SetSurfaceAlpha ( m_chargeBarSurfaceID, 192 );
    
    m_radarBackgroundSurfaceID = g_graphics->CreateSurface ( 100, 94, false );
    format = g_graphics->GetPixelFormat ( m_radarBackgroundSurfaceID );
    g_graphics->FillRect ( m_radarBackgroundSurfaceID, NULL, SDL_MapRGBA ( format, 0, 0, 0, 255 ) );
    g_graphics->SetSurfaceAlpha ( m_radarBackgroundSurfaceID, 128 );
}

Sidebar::~Sidebar()
{
    g_graphics->DeleteSurface ( m_healthBarSurfaceID );
    g_graphics->DeleteSurface ( m_chargeBarSurfaceID );
}

int Sidebar::SendEnterKey ()
{
    return 0;
}

int Sidebar::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    return 0;
}

void Sidebar::Render()
{
    SDL_Rect rBuff = {0,0,0,0}, rDest = {0,0,0,0};

    // TODO: Prerender some of this.

    // Render the radar background (black semi-transparent color)
    rDest.x = g_graphics->GetScreenWidth () - 135; rDest.y = 18;
    g_graphics->Blit ( m_radarBackgroundSurfaceID, NULL, g_graphics->GetScreen(), &rDest );


    // Render health bar.
    SDL_Rect healthBarSrc   = { 0, 0, (Uint16)g_game->GetHealth(), 15 },
             healthBarDest  = { g_graphics->GetScreenWidth() - (47 + (Uint16)g_game->GetHealth()), 163,
                                (Uint16)g_game->GetHealth(), 15 };
    g_graphics->Blit ( m_healthBarSurfaceID, &healthBarSrc, g_graphics->GetScreen(), &healthBarDest );


    // Render weapon charge bar.
    SDL_Rect chargeBarSrc   = { 0, 0, (Uint16)g_game->m_laserCharge, 15 },
             chargeBarDest  = { g_graphics->GetScreenWidth() - (47 + (Uint16)g_game->m_laserCharge), 182,
                                (Uint16)g_game->m_laserCharge, 15 };
    g_graphics->Blit ( m_chargeBarSurfaceID, &chargeBarSrc, g_graphics->GetScreen(), &chargeBarDest );


    // Render the special weapon charges on tabs
    WeaponType selectedWeapon = g_game->GetSelectedWeapon();
    memcpy ( &rBuff, &rWeaponAmmo[1], sizeof(SDL_Rect) );

    rBuff.w = g_game->m_missileCharge;
    rDest.x = g_graphics->GetScreenWidth () - 53;
    rDest.y = 250;
    if ( selectedWeapon == WEAPON_TYPE_MISSILE )
    {
        rDest.x -= 10;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
        rDest.x += 10;
    } else {
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
    }

    rBuff.w = g_game->m_grenadeCharge;
    rDest.y += 34;
    if ( selectedWeapon == WEAPON_TYPE_GRENADE )
    {
        rDest.x -= 10;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
        rDest.x += 10;
    } else {
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
    }

    rBuff.w = g_game->m_bounceCharge;
    rDest.y += 35;
    if ( selectedWeapon == WEAPON_TYPE_BOUNCE )
    {
        rDest.x -= 10;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
        rDest.x += 10;
    } else {
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
    }


    // Render special weapon ammo on tabs
    int yBase = 249;
    int xBase = g_graphics->GetScreenWidth () - 36;
	short i;
    memcpy ( &rBuff, &rWeaponAmmo[0], sizeof(SDL_Rect) );

    for ( i = 0; i < g_game->m_missileAmmo; i++ )
    {
        rDest.y = yBase - 4 - i * 4;
        if ( selectedWeapon == WEAPON_TYPE_MISSILE )
            rDest.x = xBase - 10;
        else
            rDest.x = xBase;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
    }

    for ( i = 0; i < g_game->m_grenadeAmmo; i++ )
    {
        rDest.y = 34 + yBase - 3 - i * 4;
        if ( selectedWeapon == WEAPON_TYPE_GRENADE )
            rDest.x = xBase - 10;
        else
            rDest.x = xBase;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
    }

    yBase = 250;
    for ( i = 0; i < g_game->m_bounceAmmo; i++ )
    {
        rDest.y = 68 + yBase - 3 - i * 4;
        if ( selectedWeapon == WEAPON_TYPE_BOUNCE )
            rDest.x = xBase - 10;
        else
            rDest.x = xBase;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
    }


    // Render radar box
    rBuff.y = 0; rBuff.x = 0;
    rBuff.w = 147; rBuff.h = 231;
    rDest.x = g_graphics->GetScreenWidth () - 147;
    rDest.y = 0;
    g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );

    // Render weapon tabs
    if ( selectedWeapon == WEAPON_TYPE_MISSILE )
    {
        rBuff.x = 147; rBuff.y = 0; rBuff.w = 72; rBuff.h = 34;
        rDest.x = g_graphics->GetScreenWidth () - 72; rDest.y = 231;
    } else {
        rBuff.x = 0; rBuff.y = 229; rBuff.w = 147; rBuff.h = 36;
        rDest.x = g_graphics->GetScreenWidth () - 147; rDest.y = rBuff.y;
    }
    g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );

    if ( selectedWeapon == WEAPON_TYPE_GRENADE )
    {
        rBuff.x = 147; rBuff.y = 34; rBuff.w = 72; rBuff.h = 34;
        rDest.x = g_graphics->GetScreenWidth () - 72; rDest.y = 265;
    } else {
        rBuff.x = 0; rBuff.y = 263; rBuff.w = 147; rBuff.h = 36;
        rDest.x = g_graphics->GetScreenWidth () - 147; rDest.y = rBuff.y;
    }
    g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );

    if ( selectedWeapon == WEAPON_TYPE_BOUNCE )
    {
        rBuff.x = 147; rBuff.y = 68; rBuff.w = 72; rBuff.h = 34;
        rDest.x = g_graphics->GetScreenWidth () - 72; rDest.y = 299;
    } else {
        rBuff.x = 0; rBuff.y = 297; rBuff.w = 147; rBuff.h = 34;
        rDest.x = g_graphics->GetScreenWidth () - 147; rDest.y = rBuff.y;
    }
    g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );


    // Render team scores bar
    rBuff.x = 0; rBuff.y = 329; rBuff.w = 147; rBuff.h = 151;
    rDest.x = g_graphics->GetScreenWidth () - 147; rDest.y = rBuff.y;
    g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );


    // Render the bottom part of the sidebar.
    if ( g_graphics->GetScreenHeight() > 480 )
    {
        rBuff.x = 221; rBuff.y = 151; rBuff.h = 16; rBuff.w = 30;
        rDest.x = g_graphics->GetScreenWidth () - 30; rDest.y = 480;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
        
        short limit = ( ( g_graphics->GetScreenWidth() - 480 ) / 16 ) - 1;
        rBuff.x = 226; rBuff.y = 168; rBuff.h = 16; rBuff.w = 25;
        rDest.x = g_graphics->GetScreenWidth () - 25;
        for ( int i = 1; i < limit; i++ )
        {
            rDest.y = 480 + 16 * i;
            g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
        }
    }

    // TODO: Flag capture icon.
    Player *me = g_game->m_me;
    if ( me && me->m_flagWho )
    {
        rBuff.y = 4 * 30;
        rBuff.h = 30;
        rBuff.x = 224;
        rBuff.w = 24;
        rDest.x = g_graphics->GetScreenWidth () - 27;
        rDest.y = 165;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID (), &rBuff, g_graphics->GetScreen(), &rDest );
    }

    // TODO: NavMenu renders
}

void Sidebar::Update()
{
}
