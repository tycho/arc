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

#include <time.h>

#include "Game/game.h"
#include "Game/missile_smoke.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"

const SDL_Rect rMissileSmoke[9]={ //{X, Y, W, H },
                                    {395, 111, 3, 4},
                                    {400, 111, 4, 5},
                                    {405, 111, 8, 7},
                                    {415, 111, 8, 9},
                                    {425, 110, 9, 10},
                                    {436, 111, 9, 10},
                                    {448, 111, 9, 9},
                                    {459, 110, 9, 9},
                                    {471, 110, 9, 9} };

MissileSmoke::MissileSmoke ( int _X, int _Y, int _color )
 : m_X(_X), m_Y(_Y), m_color(_color), m_expired(false),
   m_frameXC(0.0), m_frameT(0.0)
{
}

MissileSmoke::~MissileSmoke()
{
}

bool MissileSmoke::Expired()
{
    return m_expired;
}

void MissileSmoke::Render()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);
    short ExX = 0, ExY = 0;

    SDL_Rect rSmoke, rDest;
    int j = (int)m_frameXC;
    memcpy ( &rSmoke, &rMissileSmoke[j], sizeof(SDL_Rect) );

    switch ( m_color )
    {
    case 2:
        ExX = 90;
        break;
    case 3:
        ExY = 11;
        break;
    case 4:
        ExX = 90; ExY = 11;
        break;
    case 5:
        ExX = 90; ExY = 54;
        break;
    }

    rSmoke.x += ExX;
    rSmoke.y += ExY;

    rDest.x = m_X - MeX - (rSmoke.w / 2);
    rDest.y = m_Y - MeY - (rSmoke.h / 2);
    rDest.h = rSmoke.h; rDest.w = rSmoke.w;

    g_graphics->Blit ( g_interface->GetTuna1SurfaceID(), &rSmoke, g_graphics->GetScreen(), &rDest );

    m_frameXC += g_game->GetGameSpeed() * 0.5;
    if ( m_frameXC > 8 ) m_expired = true;
}
