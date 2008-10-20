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
#include "Game/game.h"
#include "Game/collide.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/laser_zap.h"

static const SDL_Rect rShipHit[7] =
{
    { 387, 157,  2,  2 },
    { 391, 157,  4,  4 },
    { 396, 157,  6,  6 },
    { 403, 157,  9,  9 },
    { 413, 157, 11, 11 },
    { 426, 157, 11, 11 },
    { 440, 157, 13, 13 }
};

LaserZap::LaserZap ( Sint32 _x, Sint32 _y )
 : Widget(0, 0, 61, 61), m_damaged(true), m_zapFrame(0), m_x(_x), m_y(_y)
{
    SetWidgetClass ( "LaserZap" );
	Initialise();
}

LaserZap::~LaserZap()
{
}

int LaserZap::SendEnterKey ()
{
    return 0;
}

int LaserZap::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    return 0;
}

void LaserZap::Initialise()
{
	g_graphics->DeleteSurface(m_cachedSurfaceID);
    m_cachedSurfaceID = g_graphics->CreateSurface ( 13, 13, false );
	Widget::Initialise();
}

void LaserZap::Update()
{
    m_zapFrame += g_game->GetGameSpeed() * 0.5;
    
    if ( (int)m_zapFrame > 6 )
        m_expired = true;
}

void LaserZap::Render()
{
    if ( m_expired ) return;

    SDL_Rect const &rSource = rShipHit[(int)m_zapFrame];

    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);

    m_position.x = m_x - MeX - rSource.w / 2;
    m_position.y = m_y - MeY - rSource.h / 2;

    g_graphics->FillRect ( m_cachedSurfaceID, NULL, g_graphics->GetColorKey() );
    g_graphics->Blit ( g_interface->GetTuna1SurfaceID(), (SDL_Rect *)&rSource, m_cachedSurfaceID, NULL );

    Widget::Render();
}
