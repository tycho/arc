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
#include "Game/laser.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Sound/soundsystem.h"

Laser::Laser ( Player *_player, int _lX, int _lY, int _cX, int _cY )
 : Weapon ( _player, _lX, _lY, _cX, _cY )
{
    m_type = WEAPON_TYPE_LASER;

    m_stopMove = -11;

    m_lineStartX = 0;
    m_lineStartY = 0;
    m_lineStopX = 0;
    m_lineStopY = 0;

    // TODO: Send laser signal via network HERE.

    int lasrX = _cX - (int)g_game->m_me->GetX ();
    int lasrY = _cY - (int)g_game->m_me->GetY ();
    if ( lasrX > -100 && lasrY > -100 && 
         lasrX < g_graphics->GetScreenWidth() + 100 &&
         lasrY < g_graphics->GetScreenHeight() + 100 )
    {
        g_soundSystem->PlaySound ( "laser", lasrX, lasrY );
    }
}

Laser::~Laser()
{
}

void Laser::Render()
{
    LineDraw ( 1, 0, (int)m_dist, (int)m_stopMove,
                m_lineStartX, m_lineStartY,
                m_lineStopX,  m_lineStopY );
}

void Laser::Update()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);
    float oldDist = m_dist, tmpDist;

    m_dist += (float)(6.5 * g_game->GetGameSpeed ());

    if ( m_dist > 570.0f ) {
        if ( m_dist > m_stopMove + 70 )
        {
            m_expired = true;
            return;
        }
    }
    tmpDist = m_dist;
    if ( tmpDist > 500 && m_stopMove == -11 )
        m_stopMove = (short)oldDist;
    if ( m_stopMove > -11 )
    {
        if ( tmpDist - m_stopMove > 70 )
        {
            m_expired = true;
            return;
        }
        tmpDist = m_stopMove;
    }
    short newX = 0, newY = 0, j = 0;
    if ( m_stopMove == -11 )
    {
        for ( short d = (short)oldDist; d < m_dist; d++ )
        {
            newX = (short)(cos ( m_angle * DIV360MULTPI ) * d + m_X);
            newY = (short)(sin ( m_angle * DIV360MULTPI ) * d + m_Y);
            j = Touch ( newX, newY );
            if ( j > 0 )
            {
                tmpDist = (float)(d - 1);
                m_stopMove = d - 1;
                break;
            }
        }
    } else {
        newX = (short)( cos ( m_angle * DIV360MULTPI ) * m_stopMove ) + m_X;
        newY = (short)( sin ( m_angle * DIV360MULTPI ) * m_stopMove ) + m_Y;
    }
    short lasrX = (short)(newX - MeX),
          lasrY = (short)(newY - MeY),
          lasrX2, lasrY2;
    if ( lasrX > -71 && 
         lasrY > -71 &&
         lasrX < g_graphics->GetScreenWidth() + 71 &&
         lasrY < g_graphics->GetScreenHeight() + 71 )
    {
        if ( j > 0 )
        {
            if ( j == 2 )
            {
                g_soundSystem->PlaySound ( "lasrhits",
                    lasrX - g_graphics->GetCenterX(),
                    lasrY - g_graphics->GetCenterY() );
            } else {
                g_soundSystem->PlaySound ( "lasrhitw",
                    lasrX - g_graphics->GetCenterX(),
                    lasrY - g_graphics->GetCenterY() );
                g_interface->ExplodeSpark ( newX, newY );
            }
        }

        tmpDist = m_dist;
        if ( tmpDist > 70 )
        {
            tmpDist -= 70;
        } else {
            tmpDist = 0;
        }
        if ( m_stopMove > -1 )
        {
            if ( m_dist > m_stopMove + 70 )
            {
                return;
            }
        }
        lasrX2 = (short)( cos ( m_angle * DIV360MULTPI ) * tmpDist + m_X - MeX );
        lasrY2 = (short)( sin ( m_angle * DIV360MULTPI ) * tmpDist + m_Y - MeY );
        m_lineStartX = lasrX;
        m_lineStartY = lasrY;
        m_lineStopX = lasrX2;
        m_lineStopY = lasrY2;
    }
}
