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

#include "Game/game.h"
#include "Game/grenade_smoke.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"

const SDL_Rect rGrenadeSmoke[9]={ //{X, Y, W, H },
                                    {394, 23, 5, 6},
                                    {404, 24, 8, 8},
                                    {415, 22, 13, 13},
                                    {434, 23, 15, 15},
                                    {454, 22, 17, 16},
                                    {477, 23, 17, 17},
                                    {501, 23, 17, 17},
                                    {522, 21, 17, 17},
                                    {546, 21, 17, 17} };

GrenadeSmoke::GrenadeSmoke ( int _x, int _y, int _color )
 : m_X(_x), m_Y(_y), m_color(_color), m_expired(false),
   m_frameXC(0.0), m_frameT(0.0)
{
}

GrenadeSmoke::~GrenadeSmoke()
{
}

bool GrenadeSmoke::Expired()
{
    return m_expired;
}

void GrenadeSmoke::Render()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);

    SDL_Rect rSmoke, rDest;
    int j = (int)m_frameXC;
    memcpy ( &rSmoke, &rGrenadeSmoke[j], sizeof(SDL_Rect) );
    if ( m_color < 5 )
    {
        rSmoke.y += 17 * m_color;
    } else {
        rSmoke.y += 117;
    }
    rDest.x = m_X - MeX - (rSmoke.w / 2);
    rDest.y = m_Y - MeY - (rSmoke.h / 2);
    rDest.h = rSmoke.h; rDest.w = rSmoke.w;

    g_graphics->Blit ( g_interface->GetTuna1SurfaceID(), &rSmoke, g_graphics->GetScreen(), &rDest );

    m_frameXC += g_game->GetGameSpeed() * 0.19;
    if ( m_frameXC > 8 ) m_expired = true;
}
