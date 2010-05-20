/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "App/app.h"
#include "Game/game.h"
#include "Game/collide.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/ship.h"
#include "Interface/ship_explosion.h"
#include "Sound/soundsystem.h"

Ship::Ship ( Player *_player )
 : Widget(0, 0, 32, 32), m_player(_player), m_label(NULL), m_damaged(true)
{
    SetWidgetClass ( "Ship" );
    char temp[64];
    m_player = _player;
    sprintf ( temp, "\3%s\1 [%d]", m_player->m_nick, m_player->m_score );
    m_label = new TextUI ( temp, true, 0 - ((int)strlen(m_player->m_nick) / 2), 35, 50, 7 );
    AddWidget ( m_label );
	Initialise();
}

Ship::~Ship()
{
}

int Ship::SendEnterKey ()
{
    return 0;
}

int Ship::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    return 0;
}

void Ship::Initialise()
{
	m_damaged = true;
	Widget::Initialise();
}

void Ship::Update()
{
    char temp[64];
    sprintf ( temp, "\2%s\1 [%d]", m_player->m_nick, m_player->m_score );
    m_label->SetText ( temp );

    float MoveSpeed = (float)g_game->GetGameSpeed() * 1.1f;

    if ( m_player->m_flagWho > 0 ) MoveSpeed *= 0.75f;
    if ( m_player->m_cheat > 2 ) MoveSpeed *= 3.0f;
    if ( m_player->m_mode == 1 ) MoveSpeed *= 6.0f;

    float chs = MoveSpeed / ( (int)MoveSpeed + 1 );
    const float DiagMoveSpeed = 0.7f * 1.1f;

    // TODO: Ship6 movement in CharUpdate?

    // It's possible that something caused a spike.
    if ( MoveSpeed > 100.0f ) return;

    m_player->m_animX = m_player->m_keyIs;

    float lastX, lastY;

    for ( short j = 0; j <= (int)MoveSpeed; j++ )
    {
        lastX = m_player->m_charX; lastY = m_player->m_charY;
        switch ( m_player->m_keyIs )
        {
        case 1: // Right
            m_player->m_charX += chs;
            break;
        case 2: // Up-right
            m_player->m_charX += chs * DiagMoveSpeed;
            m_player->m_charY -= chs * DiagMoveSpeed;
            break;
        case 3: // Up
            m_player->m_charY -= chs;
            break;
        case 4: // Up-left
            m_player->m_charX -= chs * DiagMoveSpeed;
            m_player->m_charY -= chs * DiagMoveSpeed;
            break;
        case 5: // Left
            m_player->m_charX -= chs;
            break;
        case 6: // Down-left
            m_player->m_charX -= chs * DiagMoveSpeed;
            m_player->m_charY += chs * DiagMoveSpeed;
            break;
        case 7: // Down
            m_player->m_charY += chs;
            break;
        case 8: // Down-right
            m_player->m_charX += chs * DiagMoveSpeed;
            m_player->m_charY += chs * DiagMoveSpeed;
            break;
        }

        CollisionDetect(); unsigned short e;
        for ( e = 0; e < m_retCollision.size(); e++ )
        {
            // RAMPS
            if ( m_retCollision.valid ( e ) )
            {
                short d = m_retCollision[e];
                if ( d == 8 ) {

                    if ( m_player->m_flagWho && m_player->m_keyIs == 7 )
                        m_player->m_charY = lastY;
                    else
                        m_player->m_charY -= chs * 0.7f;

                } else if ( d == 9 ) {

                    if ( m_player->m_flagWho && m_player->m_keyIs == 3 )
                        m_player->m_charY = lastY;
                    else
                        m_player->m_charY += chs * 0.7f;

                } else if ( d == 10 ) {

                    if ( m_player->m_flagWho && m_player->m_keyIs == 1 )
                        m_player->m_charX = lastX;
                    else
                        m_player->m_charX -= chs * 0.7f;

                } else if ( d == 11 ) {

                    if ( m_player->m_flagWho && m_player->m_keyIs == 5 )
                        m_player->m_charX = lastX;
                    else
                        m_player->m_charX += chs * 0.7f;

                }
            }
        }
        //GOSUB

        float sx = m_player->m_charX, sy = m_player->m_charY;
        CollisionDetect();
        if ( m_rectsRet.used() > 0 )
        {
            m_player->m_charX = lastX;
            m_player->m_charY = lastY;
            if ( (FindRectsRet ( 104 ) && FindRectsRet ( 105 )) ||
                 (FindRectsRet ( 112 ) && FindRectsRet ( 113 )) ) {
                m_player->m_charY = sy;
                CollisionDetect();
                if ( m_player->m_charY == lastY )
                {
                    if ( FindRectsRet ( 112 ) && FindRectsRet ( 113 ) )
                    {
                        // Touch right
                        m_player->m_charX -= 1;
                    }
                    CollisionDetect();
                    if ( FindRectsRet ( 104 ) && FindRectsRet ( 105 ) )
                    {
                        // Touch left
                        m_player->m_charX += 1;
                    }
                }
                if ( m_rectsRet.used() > 0 )
                {
                    m_player->m_charY = lastY;
                }
                continue;
            }
            if ( (FindRectsRet ( 101 ) && FindRectsRet ( 109 )) ||
                 (FindRectsRet ( 108 ) && FindRectsRet ( 116 )) ) {
                m_player->m_charX = sx;
                CollisionDetect();
                if ( m_player->m_charY == lastY )
                {
                    if ( FindRectsRet ( 101 ) && FindRectsRet ( 109 ) )
                    {
                        // Touch top
                        m_player->m_charY += 1;
                    }
                    CollisionDetect();
                    if ( FindRectsRet ( 108 ) && FindRectsRet ( 116 ) )
                    {
                        // Touch bottom
                        m_player->m_charY -= 1;
                    }
                }
                if ( m_rectsRet.used() > 0 )
                {
                    m_player->m_charX = lastX;
                }
                continue;
            }
        }
        for ( e = 0; e < m_rectsRet.used(); e++ )
        {
            if ( m_rectsRet.valid ( e ) )
            {
                short d = m_rectsRet[e];
                if ( d == 101 || d == 104 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY += chs * 0.8f;
                    if ( sy - lastY != 0 ) m_player->m_charX += chs * 0.8f;
                }
                if ( d == 102 || d == 103 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY += chs * 0.4f;
                    if ( sy - lastY != 0 ) m_player->m_charX += chs * 0.4f;
                }
                if ( d == 105 || d == 108 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY -= chs * 0.8f;
                    if ( sy - lastY != 0 ) m_player->m_charX += chs * 0.8f;
                }
                if ( d == 106 || d == 107 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY -= chs * 0.4f;
                    if ( sy - lastY != 0 ) m_player->m_charX += chs * 0.4f;
                }
                if ( d == 109 || d == 112 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY += chs * 0.8f;
                    if ( sy - lastY != 0 ) m_player->m_charX -= chs * 0.8f;
                }
                if ( d == 110 || d == 111 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY += chs * 0.4f;
                    if ( sy - lastY != 0 ) m_player->m_charX -= chs * 0.4f;
                }
                if ( d == 113 || d == 116 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY -= chs * 0.8f;
                    if ( sy - lastY != 0 ) m_player->m_charX -= chs * 0.8f;
                }
                if ( d == 114 || d == 115 )
                {
                    if ( sx - lastX != 0 ) m_player->m_charY -= chs * 0.4f;
                    if ( sy - lastY != 0 ) m_player->m_charX -= chs * 0.4f;
                }
            }
        }
        CollisionDetect();
        if ( m_rectsRet.used() > 0 )
        {
            m_player->m_charX = lastX;
            m_player->m_charY = lastY;
            if ( (FindRectsRet(104) && FindRectsRet(105)) ||
                 (FindRectsRet(112) && FindRectsRet(113)) )
            {
                m_player->m_charY = sy;
                CollisionDetect();
                if ( m_rectsRet.used() > 0 )
                    m_player->m_charY = lastY;
                continue;
            }
            if ( (FindRectsRet(101) && FindRectsRet(109)) ||
                 (FindRectsRet(108) && FindRectsRet(116)) )
            {
                m_player->m_charX = sx;
                CollisionDetect();
                if ( m_rectsRet.used() > 0 )
                    m_player->m_charX = lastX;
                continue;
            }
        }
    }

    // TODO: Figure out proper placement for this.
    //if ( !(m_shipType > 0 && m_shipType < 10) ) return;


    if ( m_player != g_game->m_me )
    {
        short CenterSX = g_graphics->GetCenterX() - 16,
              CenterSY = g_graphics->GetCenterY() - 16;
        short MeX = (short)(g_game->m_me->GetX() - CenterSX),
              MeY = (short)(g_game->m_me->GetY() - CenterSY);

        m_player->m_moveX = (short)m_player->m_charX - MeX;
        m_player->m_moveY = (short)m_player->m_charY - MeY;
    }

}

void Ship::CollisionDetect()
{
    m_rectsRet.setSize(0); m_retCollision.setSize(0);
    Map *map = g_game->GetMap ();
    SDL_Rect playerPosition, tilePosition;
    if ( m_player->m_cheat == 2 || m_player->m_cheat == 4 ) return;
    if ( m_player->m_mode == 1 ) return;
    playerPosition.y = (Sint32)m_player->m_charY + 2;
    playerPosition.x = (Sint32)m_player->m_charX + 2;
    playerPosition.h = 29;
    playerPosition.w = 29;
    short startX = ((short)m_player->m_charX & -16) / 16,
          startY = ((short)m_player->m_charY & -16) / 16,
          finishX = startX + 2,
          finishY = startY + 2;
    unsigned short retArray = 0, e;

    for ( short y = startY; y <= finishY; y++ )
    {
        for ( short x = startX; x <= finishX; x++ )
        {
            if ( y < 0 || x < 0 ) continue;
            if ( y > 255 || x > 255 ) continue;
            short G = map->GetCollision(y,x);
            if ( !G ) continue;
            tilePosition.y = y * 16;
            tilePosition.x = x * 16;
            tilePosition.h = 16;
            tilePosition.w = 16;
            if ( SDL_CollideBoundingBox ( playerPosition, tilePosition ) )
            {
                retArray = (unsigned short)m_rectsRet.used();
                if ( ShipRects ( x, y, false ) )
                {
                    for ( e = 0; e < m_retCollision.size(); e++ )
                        if ( m_retCollision.valid ( e ) )
                            if ( m_retCollision[e] == G )
                                break;
                    if ( FindRectsRet ( 117 ) )
                    {
                        if ( e >= m_retCollision.size() )
                            m_retCollision.insert ( G );
                    }
                }
                if ( G != 1 && G != 2 && !(G > 3 && G < 8) )
                {
                    m_rectsRet.setSize ( retArray );
                }
            }
        }
    }
}

bool Ship::ShipRects ( short bx, short by, bool _isWeaponFire )
{
    bool retval = false;
    Map *map = g_game->GetMap ();
    SDL_Rect rWho, rBlock;
    short tile;
    if ( _isWeaponFire )
    {
        rBlock.x = bx;
        rBlock.y = by;
        rBlock.w = 1;
        rBlock.h = 1;
    } else {
        tile = map->GetSourceTile(by,bx);
        if ( tile > -1 )
        {
            rBlock.x = bx * 16 + map->GetRoughTile(tile)->cLeft;
            rBlock.w = 16 - map->GetRoughTile(tile)->cLeft - map->GetRoughTile(tile)->dRight;
            rBlock.y = by * 16 + map->GetRoughTile(tile)->aTop;
            rBlock.h = 16 - map->GetRoughTile(tile)->aTop - map->GetRoughTile(tile)->bBottom;
        } else {
            rBlock.x = bx * 16;
            rBlock.w = 16;
            rBlock.y = by * 16;
            rBlock.h = 16;
        }
    }

    // 1
    rWho.x = (short)m_player->m_charX + 12;
    rWho.w = 4;
    rWho.y = (short)m_player->m_charY + 1;
    rWho.h = 3;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 101 );
        retval = true;
    }

    // 2
    rWho.x = (short)m_player->m_charX + 8;
    rWho.w = 8;
    rWho.y = (short)m_player->m_charY + 4;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 102 );
        retval = true;
    }

    // 3
    rWho.x = (short)m_player->m_charX + 4;
    rWho.w = 12;
    rWho.y = (short)m_player->m_charY + 8;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 103 );
        retval = true;
    }

    // 4
    rWho.x = (short)m_player->m_charX + 1;
    rWho.w = 15;
    rWho.y = (short)m_player->m_charY + 12;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 104 );
        retval = true;
    }

    // 5
    rWho.x = (short)m_player->m_charX + 1;
    rWho.w = 15;
    rWho.y = (short)m_player->m_charY + 16;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 105 );
        retval = true;
    }

    // 6
    rWho.x = (short)m_player->m_charX + 4;
    rWho.w = 12;
    rWho.y = (short)m_player->m_charY + 20;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 106 );
        retval = true;
    }

    // 7
    rWho.x = (short)m_player->m_charX + 8;
    rWho.w = 8;
    rWho.y = (short)m_player->m_charY + 24;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 107 );
        retval = true;
    }

    // 8
    rWho.x = (short)m_player->m_charX + 12;
    rWho.w = 4;
    rWho.y = (short)m_player->m_charY + 28;
    rWho.h = 3;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 108 );
        retval = true;
    }

    // 9
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 4;
    rWho.y = (short)m_player->m_charY + 1;
    rWho.h = 3;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 109 );
        retval = true;
    }

    // 10
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 8;
    rWho.y = (short)m_player->m_charY + 4;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 110 );
        retval = true;
    }

    // 11
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 12;
    rWho.y = (short)m_player->m_charY + 8;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 111 );
        retval = true;
    }

    // 12
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 15;
    rWho.y = (short)m_player->m_charY + 12;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 112 );
        retval = true;
    }

    // 13
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 15;
    rWho.y = (short)m_player->m_charY + 16;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 113 );
        retval = true;
    }

    // 14
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 12;
    rWho.y = (short)m_player->m_charY + 20;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 114 );
        retval = true;
    }

    // 15
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 8;
    rWho.y = (short)m_player->m_charY + 24;
    rWho.h = 4;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 115 );
        retval = true;
    }

    // 16
    rWho.x = (short)m_player->m_charX + 16;
    rWho.w = 4;
    rWho.y = (short)m_player->m_charY + 28;
    rWho.h = 3;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 116 );
        retval = true;
    }

    // 17
    rWho.x = (short)m_player->m_charX + 15;
    rWho.w = 2;
    rWho.y = (short)m_player->m_charY + 15;
    rWho.h = 2;
    if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
    {
        m_rectsRet.insert ( 117 );
        retval = true;
    }

    return retval;

}

bool Ship::FindRectsRet ( short _findItem )
{
    // TODO: OPTIMIZE
    for ( size_t i = 0; i < m_rectsRet.used(); i++ )
    {
        if ( m_rectsRet.valid ( i ) )
        {
            if ( m_rectsRet[i] == _findItem )
            {
                return true;
            }
        }
    }
    return false;
}

void Ship::Flush()
{
    m_damaged = true;
}

void Ship::FlushText()
{
    char temp[64];
    sprintf ( temp, "\2%s\1 [%d]", m_player->m_nick, m_player->m_score );
    m_label->SetText ( temp );
}

void Ship::Pop()
{
    g_interface->AddShipExplosion ( new ShipExplosion ( m_player->m_charX + 16.0f, m_player->m_charY + 16.0f ) );

    short ResX = g_graphics->GetScreenWidth(),
          ResY = g_graphics->GetScreenHeight();
    if ( m_player->GetMoveX() > -50 && m_player->GetMoveY() > -50 &&
         m_player->GetMoveX() < ResX + 50 && m_player->GetMoveY() < ResY + 50 )
    {
        g_soundSystem->PlaySound ( "shipexpl",
            g_graphics->GetCenterX() - m_player->GetMoveX(),
            g_graphics->GetCenterY() - m_player->GetMoveY() );
    }
}

void Ship::Render()
{
    // Player is invisible.
    if ( m_player->m_mode == 1 || !m_player->m_visible ) return;

    // Invalid ship.
    if ( m_player->m_shipType < 1 || m_player->m_shipType > 6 ) return;

    // Player hasn't been positioned yet.
    if ( m_player->m_charX == 0 && m_player->m_charY == 0 ) return;

    // Not in visible range.
    if ( m_player->m_moveX <= -32 || m_player->m_moveY <= -32 ||
        m_player->m_moveX >= (Sint32)g_graphics->GetScreenWidth() + 32 ||
        m_player->m_moveY >= (Sint32)g_graphics->GetScreenHeight() + 32 )
        return;

    // TODO: Render the player label.

    if ( (int)m_cachedSurfaceID == -1 || m_damaged )
    {
        SDL_Rect sprite = {0,0,0,0};
        if ( !m_player->m_warping )
        {
            sprite.x = (m_player->m_animX - 1) * 32;
            sprite.y = (m_player->m_shipType - 1) * 32;
            sprite.w = 32; sprite.h = 32;
        } else {
            // TODO: Warping anim.
        }

        if ( (int)m_cachedSurfaceID == -1 )
            m_cachedSurfaceID = g_graphics->CreateSurface ( 32, 32, true );
        else
            g_graphics->FillRect ( m_cachedSurfaceID, NULL, g_graphics->GetColorKey() );

        g_graphics->Blit ( g_interface->GetShipsSurfaceID(), &sprite, m_cachedSurfaceID, NULL );

        m_damaged = false;
    }

    m_position.x = m_player->m_moveX;
    m_position.y = m_player->m_moveY;

    m_position.w = 32; m_position.h = 32;

    // Render.
    Widget::Render();
}
