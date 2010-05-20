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
#include "Game/missile.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Sound/soundsystem.h"

Missile::Missile ( Player *_player, int _lX, int _lY, int _cX, int _cY )
 : Weapon ( _player, _lX, _lY, _cX, _cY )
{
    m_type = WEAPON_TYPE_MISSILE;

    // TODO: Send laser signal via network HERE.

    int missX = _cX - (int)g_game->m_me->GetX ();
    int missY = _cY - (int)g_game->m_me->GetY ();
    if ( missX > -60 && missY > -60 &&
         missX < g_graphics->GetScreenWidth() + 60 &&
         missY < g_graphics->GetScreenHeight() + 60 )
    {
        g_soundSystem->PlaySound ( "missile", missX, missY );
    }
}

Missile::~Missile()
{
}

void Missile::Render()
{
}

void Missile::Update()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);
    float oldDist = m_dist;
    short newX = 0, newY = 0, newX2 = 0, newY2 = 0, j = 0, d;

    m_dist += (float)(5.0 * g_game->GetGameSpeed ());

    if ( m_dist > 500 ) {
        m_expired = true;
        return;
    }

    for ( d = (short)oldDist; d <= m_dist; d++ )
    {
        newX = (short)(cos ( m_angle * DIV360MULTPI ) * d + m_X);
        newY = (short)(sin ( m_angle * DIV360MULTPI ) * d + m_Y);
        j = Touch ( newX, newY );
        if ( j > 0 )
        {
            break;
        }
    }

    for ( short x = (short)oldDist; x < d; x += 7 )
    {
        if ( m_dist > 24 )
        {
            newX2 = (short)(cos ( m_angle * DIV360MULTPI ) * (x - 5) + m_X);
            newY2 = (short)(sin ( m_angle * DIV360MULTPI ) * (x - 5) + m_Y);
            g_interface->MissileSmokeTrail ( newX2, newY2, m_player->GetTeam() );
        }
    }

    newX2 = (short)(cos ( m_angle * DIV360MULTPI ) * (d - 14) + m_X);
    newY2 = (short)(sin ( m_angle * DIV360MULTPI ) * (d - 14) + m_Y);

    short missX = (short)(newX - MeX),
          missY = (short)(newY - MeY),
          missX2 = (short)(newX2 - MeX),
          missY2 = (short)(newY2 - MeY);
    if ( missX > -15 &&
         missY > -15 &&
         missX < g_graphics->GetScreenWidth() + 15 &&
         missY < g_graphics->GetScreenHeight() + 15 )
    {
        LineDraw ( 3, 6, 0, 0, missX, missY, missX2, missY2 );
        if ( j > 0 )
        {
            if ( j == 2 )
            {
                g_soundSystem->PlaySound ( "rockhits",
                    missX - g_graphics->GetCenterX(),
                    missY - g_graphics->GetCenterY() );
            } else {
                g_soundSystem->PlaySound ( "rockhitw",
                    missX - g_graphics->GetCenterX(),
                    missY - g_graphics->GetCenterY() );
            }

            newX = (short)(cos ( m_angle * DIV360MULTPI ) * (d - 1) + m_X);
            newY = (short)(sin ( m_angle * DIV360MULTPI ) * (d - 1) + m_Y);

            if ( j != 2 )
                g_interface->ExplodeShrapnel ( m_player, newX, newY, 2.4, 150, 6, 24 );
            g_interface->GrenadeSmokeTrail ( newX, newY, 5 );

            m_expired = true;
        }
    }
}
