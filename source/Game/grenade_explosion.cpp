/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "Game/game.h"
#include "Game/grenade_explosion.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Sound/soundsystem.h"

const SDL_Rect rBombExplosions[11] = {
    { 17, 14, 13, 12 },
    { 74, 8, 25, 22 },
    { 135, 6, 30, 27 },
    { 195, 2, 37, 34 },
    { 257, 0, 41, 37 },
    { 3, 43, 41, 38 },
    { 67, 43, 42, 38 },
    { 130, 42, 44, 40 },
    { 194, 42, 45, 40 },
    { 256, 40, 48, 43 },
    { 319, 40, 50, 43 }
};

GrenadeExplosion::GrenadeExplosion ( int _x, int _y )
{
    m_X = _x; m_Y = _y; m_frame = 0; m_expired = false;
    m_frameTick.Start();

    g_soundSystem->PlaySound ( "morthit",
        (Sint32)(_x - g_game->m_me->GetX() - 16),
        (Sint32)(_y - g_game->m_me->GetY() - 16) );
}

GrenadeExplosion::~GrenadeExplosion()
{
}

bool GrenadeExplosion::Expired()
{
    return m_expired;
}

void GrenadeExplosion::Render()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);

    m_frameTick.Stop();
    if ( m_frameTick.Elapsed() > 0.05 )
    {
        m_frame++;
        if ( m_frame > 10 )
        {
            m_expired = true;
            return;
        }
        m_frameTick.Start();
    }

    SDL_Rect rExplode, rDest;
    memcpy ( &rExplode, &rBombExplosions[m_frame], sizeof(SDL_Rect) );

    rDest.x = m_X - MeX - ( rExplode.w / 2 );
    rDest.y = m_Y - MeY - ( rExplode.h / 2 );
    rDest.w = 0; rDest.h = 0;

    if ( rDest.x > -62 && rDest.y > -48 &&
        rDest.x < g_graphics->GetScreenWidth () + 62 &&
        rDest.y < g_graphics->GetScreenHeight() + 38 )
    {
        g_graphics->Blit ( g_interface->GetTuna1SurfaceID(), &rExplode, g_graphics->GetScreen(), &rDest );
    }
}
