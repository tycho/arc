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
#include "Game/grenade.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Sound/soundsystem.h"

const SDL_Rect rBomb[5] = { { 389, 4, 5, 5 },
                            { 405, 3, 7, 7 },
                            { 420, 2, 9, 9 },
                            { 435, 1, 11, 11 },
                            { 450, 0, 13, 13 } };

Grenade::Grenade ( Player *_player, int _lX, int _lY, int _cX, int _cY )
 : Weapon ( _player, _lX, _lY, _cX, _cY )
{
    m_type = WEAPON_TYPE_GRENADE;
    m_dest = sqrt ( (double)(_lX * _lX + _lY * _lY) );
    m_speed = ( m_dest * 0.0038 ) + ( ( 477 - m_dest ) * 0.001 );
    m_dist = 0;

    int grenX = _cX - (int)g_game->m_me->GetX ();
    int grenY = _cY - (int)g_game->m_me->GetY ();
    if ( grenX > -60 && grenY > -60 && 
         grenX < g_graphics->GetScreenWidth() + 60 &&
         grenY < g_graphics->GetScreenHeight() + 60 )
    {
        g_soundSystem->PlaySound ( "mortlnch", grenX, grenY );
    }
    m_smokeTick.Start();
}

Grenade::~Grenade()
{
}

void Grenade::Render()
{
}

void Grenade::Update()
{
    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);
    int ExX = 0, ExY = 0, d, j = 0;
    m_dist += m_speed * 1.5 * g_game->GetGameSpeed ();
    ExX = (short)(cos ( m_angle * DIV360MULTPI ) * m_dist + m_X);
    ExY = (short)(sin ( m_angle * DIV360MULTPI ) * m_dist + m_Y);
    int maxDist = max(g_graphics->GetScreenHeight(),g_graphics->GetScreenWidth());
    if ( ExX - MeX > -maxDist && ExY - MeY > -maxDist &&
         ExX - MeX < maxDist &&
         ExY - MeY < maxDist )
    {
        if ( m_dist > m_dest )
        {
            d = Touch ( ExX, ExY );
            if ( d >= 0 && d <= 2 )
            {
                g_interface->ExplodeShrapnel ( m_player, ExX, ExY, 3.5, 700, 0, 12 );
                g_interface->ExplodeGrenade ( ExX, ExY );
            }
            m_expired = true;
        }
        double si = (m_dest - m_dist) / m_dest;
        if ( si > 0.9 ) j = 0;
        else if ( si > 0.8 ) j = 1;
        else if ( si > 0.7 ) j = 2;
        else if ( si > 0.6 ) j = 3;
        else if ( si > 0.5 ) j = 4;
        else if ( si > 0.4 ) j = 4;
        else if ( si > 0.3 ) j = 3;
        else if ( si > 0.2 ) j = 2;
        else if ( si > 0.1 ) j = 1;
        SDL_Rect rWeapon, rDest;
        memcpy ( &rWeapon, &rBomb[j], sizeof(SDL_Rect) );
        m_smokeTick.Stop();
        if ( m_smokeTick.Elapsed () > 0.1 && m_dist > 24 )
        {
            g_interface->GrenadeSmokeTrail ( ExX, ExY, m_player->GetTeam () );
            m_smokeTick.Start();
        }
        rDest.x = ExX - MeX - ( rBomb[j].w / 2 );
        rDest.y = ExY - MeY - ( rBomb[j].h / 2 );

        // TODO: Move this stuff to ::Render!
        g_graphics->Blit ( g_interface->GetTuna1SurfaceID(), &rWeapon, g_graphics->GetScreen(), &rDest );
    }
}
