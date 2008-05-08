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
#include "Game/shrapnel.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"

const SDL_Rect rShrapnel[2]={ //{X, Y, W, H },
                                {386, 174, 5, 5},
                                {393, 175, 3, 3} };

Shrapnel::Shrapnel ( Player *_who, int _X, int _Y, double _speed,
                    int _shrapTick, int _explStart, int _explPower)
 : m_angle(30)
{
    m_type = WEAPON_TYPE_SHRAPNEL;

    m_player = _who;

    m_X = _X;
    m_Y = _Y;

    m_speed = _speed;
    m_dist = _explStart;
    m_tick = (double)_shrapTick * 0.001;

    for ( int d = 0; d < 30; d++ )
    {
        m_angle.insert ( -90 + d * _explPower );
    }
    m_timer.Start();

}

Shrapnel::~Shrapnel()
{
}

void Shrapnel::Render()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);
    short d = 0, oldDist = 0, r = 0, ShrapF = 0;
    oldDist = (short)m_dist;
    m_dist += m_speed * g_game->GetGameSpeed();
    SDL_Rect toRect, fromRect;
    memset ( &toRect, 0, sizeof ( SDL_Rect ) );
    memset ( &fromRect, 0, sizeof ( SDL_Rect ) );
    for ( short j = 0; j < 30; j++ )
    {
        d = m_angle[j];
        if ( d != 0 )
        {
            for ( r = oldDist; r < m_dist; r++ )
            {
                toRect.x = (short)(cos ( d * DIV360MULTPI ) * r + m_X);
                toRect.y = (short)(sin ( d * DIV360MULTPI ) * r + m_Y);
                if ( Touch ( toRect.x, toRect.y ) )
                {
                    m_angle[j] = 0;
                    break;
                }
            }
            if ( m_angle[j] == 0 ) continue;
            toRect.x -= MeX;
            toRect.y -= MeY;
            ShrapF = rand() % 2;
            memcpy ( &fromRect, &rShrapnel[ShrapF], sizeof(SDL_Rect) );
            g_graphics->Blit ( g_interface->GetTuna1SurfaceID(),
                               &fromRect,
                               g_graphics->GetScreen(),
                               &toRect );
        }
    }
}

void Shrapnel::Update()
{
    m_timer.Stop(); // Misleading, doesn't really stop it.
    if ( m_timer.Elapsed() > m_tick )
        m_expired = true;
}
