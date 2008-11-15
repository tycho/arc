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
#include "Game/spark.h"
#include "Graphics/graphics.h"

Spark::Spark ( int _cX, int _cY )
: m_angle(30), m_speed(30), m_dist(30)
{
    m_type = WEAPON_TYPE_SPARK;
    m_X = _cX; m_Y = _cY;
    double F = 0.0; size_t idx;
    System::SeedRandom();
    for ( int d = 0; d < 30; d++ )
    {
        idx = m_angle.insert ( -90 + d * 12 );
        short j = System::RandomNumber() % 11 + 1;
        if ( j <= 11 ) F = 1.0;
        if ( j <= 9 ) F = 0.5;
        if ( j <= 7 ) F = 0.3;
        if ( j <= 3 ) F = 0.1;
        m_speed.insert ( F, idx );
        m_dist.insert ( 2, idx );
    }
    m_timer.Start();
}

Spark::~Spark()
{
}

void Spark::Render()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);
    short d = 0, oldDist = 0, xt = 0, yt = 0, r = 0;
    for ( short j = 0; j < 30; j++ )
    {
        d = m_angle[j];
        if ( d != 0 )
        {
            oldDist = (short)m_dist[j];
            m_dist[j] += m_speed[j] * g_game->GetGameSpeed();
            for ( r = oldDist; r < m_dist[j]; r++ )
            {
                xt = (short)(cos ( d * DIV360MULTPI ) * r + m_X);
                yt = (short)(sin ( d * DIV360MULTPI ) * r + m_Y);
                if ( Touch ( xt, yt ) )
                {
                    m_angle[j] = 0;
                    break;
                }
            }
            if ( m_angle[j] == 0 ) continue;
            xt -= MeX;
            yt -= MeY;
            if ( m_dist[j] > 0 ) r = 1;
            if ( m_dist[j] > 3 ) r = 2;
            if ( m_dist[j] > 6 ) r = 3;
            if ( m_dist[j] > 11 ) r = 4;
            Weapon::LineDraw ( 4, r, 0, 0, xt, yt, m_X, m_Y ); 
        }
    }
}

void Spark::Update()
{
    m_timer.Stop(); // Misleading, doesn't really stop it.
    if ( m_timer.Elapsed() > 0.15 )
        m_expired = true;
}
