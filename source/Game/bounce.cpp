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
#include "Game/bounce.h"
#include "Graphics/graphics.h"
#include "Sound/soundsystem.h"

Bounce::Bounce ( Player *_player, int _lX, int _lY, int _cX, int _cY )
 : Weapon ( _player, _lX, _lY, _cX, _cY )
{
    m_type = WEAPON_TYPE_BOUNCE;

    m_stopMove = -11;
    m_trav = 0;

    m_lineStartX = 0;
    m_lineStartY = 0;
    m_lineStopX = 0;
    m_lineStopY = 0;

    // TODO: Send bounce signal via network HERE.

    int lasrX = _cX - (int)g_game->m_me->GetX ();
    int lasrY = _cY - (int)g_game->m_me->GetY ();
    if ( lasrX > -100 && lasrY > -100 &&
         lasrX < g_graphics->GetScreenWidth() + 100 &&
         lasrY < g_graphics->GetScreenHeight() + 100 )
    {
        g_soundSystem->PlaySound ( "bounshot", lasrX, lasrY );
    }
}

Bounce::Bounce ( Player *_player, int _cX, int _cY, double _angle, Bounce *_re )
 : Weapon ( _player, 1, 1, _cX, _cY )
{
    m_type = WEAPON_TYPE_BOUNCE;

    m_angle = _angle;

    m_stopMove = -11;
	m_trav = _re->m_trav;
    m_X = _cX; m_Y = _cY;

    m_lineStartX = 0;
    m_lineStartY = 0;
    m_lineStopX = 0;
    m_lineStopY = 0;
}

Bounce::~Bounce()
{
}

void Bounce::Render()
{
    LineDraw ( 2, 0, (int)m_dist, (int)m_stopMove,
                m_lineStartX, m_lineStartY,
                m_lineStopX,  m_lineStopY );
}

void Bounce::Update()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);
    float oldDist = m_dist, tmpDist;

    m_trav += (float)(8.0 * g_game->GetGameSpeed ());
    m_dist += (float)(8.0 * g_game->GetGameSpeed ());

    tmpDist = m_dist;

    if ( m_trav > 1000 && m_stopMove == -11 )
        m_stopMove = oldDist;

    if ( m_stopMove > -11 )
    {
        if ( tmpDist - m_stopMove > 90 )
        {
            m_expired = true;
            return;
        }
        tmpDist = m_stopMove;
    }

    short newX, newY, j = 0, d, e;

    if ( m_stopMove == -11 )
    {
        e = (int)m_dist;
        d = (int)oldDist + 1;
        if ( d > e )
        {
            newX = (short)(cos ( m_angle * DIV360MULTPI ) * d + m_X);
            newY = (short)(sin ( m_angle * DIV360MULTPI ) * d + m_Y);
        }
        for ( d = d; d <= e; d++ )
        {
            newX = (short)(cos ( m_angle * DIV360MULTPI ) * d + m_X);
            newY = (short)(sin ( m_angle * DIV360MULTPI ) * d + m_Y);
            j = Touch ( newX, newY );
            if ( j > 0 )
            {
                tmpDist = (float)(d - 1);
                m_stopMove = (float)(d - 1);
                m_dist += 8.0f;
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
    if ( lasrX > -100 &&
         lasrY > -100 &&
         lasrX < g_graphics->GetScreenWidth() + 100 &&
         lasrY < g_graphics->GetScreenHeight() + 100 )
    {
        if ( j > 0 )
        {
            if ( j == 2 )
            {
                g_soundSystem->PlaySound ( "bounhits",
                    lasrX - g_graphics->GetCenterX(),
                    lasrY - g_graphics->GetCenterY() );
            } else {
                g_soundSystem->PlaySound ( "bounce",
                    lasrX - g_graphics->GetCenterX(),
                    lasrY - g_graphics->GetCenterY() );
            }
        }
        tmpDist = m_dist;
        if ( tmpDist > 90 )
        {
            tmpDist -= 90;
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
