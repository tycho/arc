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

#include "App/app.h"
#include "Game/game.h"
#include "Game/collide.h"
#include "Game/weapon.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/laser_zap.h"

Weapon::Weapon ( Player *_player, int _lX, int _lY, int _cX, int _cY )
{
    m_expired = false;
    m_hit = false;
    m_player = _player;
    if ( _lX == 0 ) _lX = 1;
    if ( _lY == 0 ) _lY = 1;
    m_angle = atan ( (double)_lY / (double)_lX ) * DIV180BYPI;
    if ( _lX < 0 ) m_angle += 180;
    m_X = _cX + 16;
    m_Y = _cY + 16;
    m_dist = 0;
}

Weapon::Weapon()
 : m_player(NULL), m_X(0), m_Y(0), m_dist(0), m_angle(0), m_hit(false), m_expired(false)
{
}

Weapon::~Weapon()
{
}

bool Weapon::Expired()
{
    return m_expired;
}

void Weapon::LineDraw ( int _type, int _color, int _dist, int _stopMove, int _startX, int _startY, int _stopX, int _stopY )
{
    if ( _startX == _stopX && _startY == _stopY ) return;

    // Attempt to figure out whether we're using OpenGL.
    // TODO: Make a better and faster way to do this.
    bool SupportsLineDraw = true;

    SDLGraphics *graphics = dynamic_cast<SDLGraphics *>(g_graphics);
	if ( graphics ) SupportsLineDraw = false;

    int color = 0;

    if ( m_player && !(_type == 3) )
        color = m_player->GetTeam ();
    else
        color = _color;

    Uint32 pixelColour = 0;

    // Spark
    if ( _type == 4 )
    {
        SDL_PixelFormat *format = g_graphics->GetPixelFormat ( g_graphics->GetScreen() );
        switch ( color )
        {
        case 1:
            pixelColour = SDL_MapRGB ( format, 247, 243, 148 );
            break;
        case 2:
            pixelColour = SDL_MapRGB ( format, 206, 203, 0 );
            break;
        case 3:
            pixelColour = SDL_MapRGB ( format, 222, 198, 0 );
            break;
        case 4:
            pixelColour = SDL_MapRGB ( format, 190, 190, 190 );
            break;
        default:
            ARCAbort ( "Invalid spark colour." );
            break;
        }
        if ( _startX > 1 && _startY > 1 &&
             _startY < g_graphics->GetScreenHeight() + 1 &&
             _startX < g_graphics->GetScreenWidth() + 1 )
        {
            g_graphics->SetPixel ( g_graphics->GetScreen(), _startX, _startY, pixelColour );
        }
        return;
    }

    short md = _stopX - _startX, x_move;
    if ( md < 0 )
    {
        md *= -1;
        x_move = -1;
    } else {
        x_move = 1;
    }

    short mn = _stopY - _startY, y_move;
    if ( mn < 0 )
    {
        mn *= -1;
        y_move = -1;
    } else {
        y_move = 1;
    }

    short newX = _startX, newY = _startY, balance;
    if ( mn < md )
    {
        balance = md;
    } else {
        balance = mn * -1;
    }

    mn *= 2;
    md *= 2;

    short e = 0;
    if ( _type == 1 || _type == 2 )
        if ( _stopMove > 0 ) e = _dist - _stopMove;

    SDL_PixelFormat *format = g_graphics->GetPixelFormat ( g_graphics->GetScreen() );
    short phase = 1;
    short lineStartX = -1, lineStartY = -1, lineStopX = -1, lineStopY = -1, lastPhase = 0, lastDraw = 0;
    while ( newX != _stopX || newY != _stopY )
    {
        e++;
        if ( e > 17 ) phase = 2; else phase = 1;
        if ( e > 25 ) phase = 3;
        if ( e > 33 ) phase = 4;
        if ( _type == 1 )
            if ( _stopMove > 0 )
                if ( e - _dist - _stopMove < 5 ) phase = 1;
        if ( _type == 3 )
        {
            if ( e > 2 ) phase = 2; else phase = 1;
            if ( e > 7 ) phase = 3;
            if ( e > 10 ) phase = 4;
        }
        if ( color == 1 )
        {
            switch ( phase )
            {
            case 1:
                if ( m_hit )
                    pixelColour = SDL_MapRGB ( format, 255, 255, 255 );
                else
                    pixelColour = SDL_MapRGB ( format, 0, 220, 0 );
                break;
            case 2: pixelColour = SDL_MapRGB ( format, 0, 200, 0 );
                break;
            case 3: pixelColour = SDL_MapRGB ( format, 0, 180, 0 );
                break;
            case 4: pixelColour = SDL_MapRGB ( format, 0, 140, 0 );
                break;
            }
        } else if ( color == 2 ) {
            switch ( phase )
            {
            case 1:
                if ( m_hit )
                    pixelColour = SDL_MapRGB ( format, 255, 255, 255 );
                else
                    pixelColour = SDL_MapRGB ( format, 247, 40, 41 );
                break;
            case 2: pixelColour = SDL_MapRGB ( format, 247, 0, 0 );
                break;
            case 3: pixelColour = SDL_MapRGB ( format, 198, 0, 0 );
                break;
            case 4: pixelColour = SDL_MapRGB ( format, 148, 0, 0 );
                break;
            }
        } else if ( color == 3 ) {
            switch ( phase )
            {
            case 1:
                if ( m_hit )
                    pixelColour = SDL_MapRGB ( format, 255, 255, 255 );
                else
                    pixelColour = SDL_MapRGB ( format, 0, 0, 255 );
                break;
            case 2: pixelColour = SDL_MapRGB ( format, 0, 0, 239 );
                break;
            case 3: pixelColour = SDL_MapRGB ( format, 0, 0, 173 );
                break;
            case 4: pixelColour = SDL_MapRGB ( format, 0, 0, 140 );
                break;
            }
        } else if ( color == 4 ) {
            switch ( phase )
            {
            case 1:
                if ( m_hit )
                    pixelColour = SDL_MapRGB ( format, 255, 255, 255 );
                else
                    pixelColour = SDL_MapRGB ( format, 239, 235, 0 );
                break;
            case 2: pixelColour = SDL_MapRGB ( format, 206, 203, 0 );
                break;
            case 3: pixelColour = SDL_MapRGB ( format, 156, 154, 66 );
                break;
            case 4: pixelColour = SDL_MapRGB ( format, 140, 138, 0 );
                break;
            }
        } else if ( color == 5 ) {
            switch ( phase )
            {
            case 1:
                if ( m_hit )
                    pixelColour = SDL_MapRGB ( format, 255, 255, 255 );
                else
                    pixelColour = SDL_MapRGB ( format, 214, 211, 214 );
                break;
            case 2: pixelColour = SDL_MapRGB ( format, 120, 120, 120 );
                break;
            case 3: pixelColour = SDL_MapRGB ( format, 60, 60, 60 );
                break;
            case 4: pixelColour = SDL_MapRGB ( format, 10, 10, 10 );
                break;
            }
        } else if ( color == 6 ) {
            switch ( phase )
            {
            case 1:
                if ( m_hit )
                    pixelColour = SDL_MapRGB ( format, 255, 255, 255 );
                else
                    pixelColour = SDL_MapRGB ( format, 214, 211, 214 );
                break;
            case 2: pixelColour = SDL_MapRGB ( format, 90, 89, 90 );
                break;
            case 3: pixelColour = SDL_MapRGB ( format, 49, 52, 49 );
                break;
            case 4: pixelColour = SDL_MapRGB ( format, 0, 0, 0 );
                break;
            }
        }
        if ( ( _type == 1 && e > 70 ) ||
             ( _type == 2 && e > 90 ) ||
             ( _type == 3 && e > 14 ) )
             return;
        if ( newX > 0 && newY > 0 &&
             newX < g_graphics->GetScreenWidth() &&
             newY < g_graphics->GetScreenHeight() )
        {

            if ( SupportsLineDraw )
            {
                // This code could stand to be a bit better.
                if ( lastPhase == 0 ) {
                    lineStartX = newX;
                    lineStartY = newY;
                    lastPhase = phase;
                } else if ( phase != lastPhase || lastDraw++ > 5 ) {
                    lineStopX = newX;
                    lineStopY = newY;
                    g_graphics->DrawLine ( g_graphics->GetScreen(), pixelColour, lineStartX, lineStartY, lineStopX, lineStopY );
                    lineStartX = newX;
                    lineStartY = newY;
                    lastPhase = phase;
                    lastDraw = 0;
                }

                if ( e == 2 && _type != 2 && _type != 3 )
                {
                    // The + head of the laser.
                    g_graphics->DrawLine ( g_graphics->GetScreen(), pixelColour, newX - 1, newY, newX + 1, newY );
                    g_graphics->DrawLine ( g_graphics->GetScreen(), pixelColour, newX, newY - 1, newX, newY + 1 );
                }

            } else {

                // This code is closer to the original game's behaviour, but
                // it's also far more costly

                if ( e < 50 )
                    g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY, pixelColour );
                else
                {
                    srand ( m_X ^ m_Y );
                    if ( _type == 1 )
                    {
                        if ( e > 60 )
                        {
                            if ( rand() % 100 < 40 )
                                g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY, pixelColour );
                        } else {
                            if ( rand() % 100 < 25 )
                                g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY, pixelColour );
                        }
                    } else if ( _type == 2 ) {
                        if ( e < 70 )
                        {
                            g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY, pixelColour );
                        } else if ( e >= 70 && e < 80 ) {
                            if ( rand() % 100 < 50 )
                                g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY, pixelColour );
                        } else if ( e >= 80 ) {
                            if ( rand() % 100 < 35 )
                                g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY, pixelColour );
                        }
                    }
                }

                if ( e == 2 && _type != 2 && _type != 3 )
                {
                    g_graphics->SetPixel ( g_graphics->GetScreen(), newX + 1, newY, pixelColour );
                    g_graphics->SetPixel ( g_graphics->GetScreen(), newX - 1, newY, pixelColour );
                    g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY + 1, pixelColour );
                    g_graphics->SetPixel ( g_graphics->GetScreen(), newX, newY - 1, pixelColour );
                }
            }
        }
        if ( balance < 0 )
        {
            balance += md;
            newY += y_move;
        } else {
            balance -= mn;
            newX += x_move;
        }
    }
}

int Weapon::PixelIntersect2 ( short lx, short ly, short j, short I )
{
    Map *map = g_game->GetMap ();
    short tx, ty, bx, by, mvx, mvy; Uint32 pixel;
    tx = map->GetSourceTileX ( j, I );
    ty = map->GetSourceTileY ( j, I );
    bx = I * 16;
    by = j * 16;
    if ( bx < 0 || by < 0 ) return 0;
    mvx = lx - bx; mvy = ly - by;
    LegacyRect *lRect = map->GetRoughTile(map->GetSourceTile(j,I));
    if ( mvx > lRect->cLeft - 1 &&
         mvy > lRect->aTop - 1 &&
         mvx < 16 - lRect->dRight && 
         mvy < 16 - lRect->bBottom )
    {
        pixel = g_graphics->GetPixel ( map->GetTileMapID(), tx + mvx, ty + mvy );
        if ( pixel != g_graphics->GetColorKey() )
        {
            return 1;
        }
    }
    return 0;
}

int Weapon::PixelIntersect3 ( short lx, short ly, short j, short I )
{
    Map *map = g_game->GetMap ();
    short tx, ty, bx, by, mvx, mvy; Uint32 pixel;
    tx = map->GetSourceTileX ( j, I );
    ty = map->GetSourceTileY ( j, I );
    bx = I * 16;
    by = j * 16;
    mvx = lx - bx; mvy = ly - by;
    for ( short X = 0; X <= 2; X++ )
    {
        for ( short Y = 0; Y <= 2; Y++ )
        {
            if ( mvx + X > 15 ||
                 mvy + Y > 15 ||
                 mvx + X < 0 ||
                 mvy + Y < 0 )
                 continue;
            pixel = g_graphics->GetPixel ( map->GetTileMapID(), tx + mvx, ty + mvy );
            if ( pixel != g_graphics->GetColorKey() )
            {
                return 1;
            }
        }
    }
    return 0;
}

int Weapon::Touch ( short _newX, short _newY )
{
    SDL_Rect rWho;
    memset ( &rWho, 0, sizeof(SDL_Rect) );

    short SgnX, SgnY; int retval = 0;

    SgnX = _newX - m_X;
    SgnY = _newY - m_Y;

    SgnX = ( SgnX == 0 ) ? 0 : ( (SgnX > 0) ? 1 : -1 );
    SgnY = ( SgnY == 0 ) ? 0 : ( (SgnY > 0) ? 1 : -1 );

    switch ( m_type )
    {
    case WEAPON_TYPE_LASER:
        rWho.y = _newY;
        rWho.x = _newX;
        rWho.w = 1; rWho.h = 1;
        break;
    case WEAPON_TYPE_MISSILE:
        rWho.y = _newY;
        rWho.x = _newX;
        rWho.w = 1; rWho.h = 1;
        break;
    case WEAPON_TYPE_GRENADE:
        rWho.y = _newY;
        rWho.x = _newX;
        rWho.w = 2; rWho.h = 2;
        break;
    case WEAPON_TYPE_BOUNCE:
        rWho.y = _newY;
        rWho.x = _newX;
        rWho.w = 1; rWho.h = 1;
        break;
    case WEAPON_TYPE_SHRAPNEL:
        rWho.y = _newY;
        rWho.x = _newX;
        rWho.w = 3; rWho.h = 3;
        break;
    default:
        break;
    }
    SDL_Rect rPlayer;
    memset ( &rPlayer, 0, sizeof(SDL_Rect) );
    rPlayer.h = 30;
    rPlayer.w = 30;

    Data::DArray<Player *> *players = g_game->GetPlayers();

    for ( size_t i = 0; i < players->size(); i++ )
    {
        if ( players->valid ( i ) )
        {
            Player *player = players->get ( i ),
                   *me = g_game->m_me;
            if ( m_player != player )
            {
                rPlayer.x = (Sint16)(player->GetX() + 1.0f);
                rPlayer.y = (Sint16)(player->GetY() + 1.0f);
                if ( SDL_CollideBoundingBox ( rPlayer, rWho ) )
                {
                    if ( player->GetShip ()->ShipRects ( _newX, _newY, true ) )
                    {
                        retval = 2; // Hit player.

                        short CenterSX = g_graphics->GetCenterX() - 16,
                              CenterSY = g_graphics->GetCenterY() - 16;
                        short MeX = (short)(g_game->m_me->GetX() - CenterSX),
                              MeY = (short)(g_game->m_me->GetY() - CenterSY);
                        if ( _newX - MeX > -10 &&
                            _newY - MeY > -10 &&
                            _newX - MeX < g_graphics->GetScreenWidth() + 10 &&
                            _newY - MeY < g_graphics->GetScreenHeight() + 10 )
                        {
                            if ( player == me && m_player->GetTeam() != me->GetTeam() )
                            {
                                g_game->WeaponHit ( player, m_type );
                            }
                            g_interface->AddLaserZap (
                                new LaserZap ( _newX, _newY ) );
                            return retval;
                        }
                    }
                }
            }
        }
    }

    if ( m_type == WEAPON_TYPE_BOUNCE )
    {
        rWho.x = _newX - 2; rWho.y = _newY - 2;
        rWho.h = 4; rWho.w = 4;
    }

    short x = ( _newX & -16 ) / 16,
          y = ( _newY & -16 ) / 16;

    if ( x < 0 || y < 0 ) return retval;

    Map *map = g_game->GetMap ();

    if ( m_type == WEAPON_TYPE_SPARK )
    {
        short col = map->GetCollision(y, x);
        if ( col == 0 || col == 2 )
        {
            return retval;
        }
        if ( col > -1 && col < 8 )
        {
            SgnX = _newX - m_X;
            SgnY = _newY - m_Y;
            short st = map->GetSourceTile(y, x);
            short an = map->GetAnimation(y, x);
            if ( st == 425 && SgnY <= 0 ) return 1;
            if ( st == 424 && SgnX <= 0 ) return 1;
            if ( st == 422 && SgnX >= 0 ) return 1;
            if ( st == 303 && SgnX <= 0 ) return 1;
            if ( st == 301 && SgnX >= 0 ) return 1;
            if ( st == 225 && SgnY <= 0 ) return 1;
            if ( st == 345 && SgnY >= 0 ) return 1;
            if ( st == 388 && SgnY <= 0 ) return 1;
            if ( st == 308 && SgnY >= 0 ) return 1;
            if ( col == 4 && SgnY <= 0 ) return retval;
            if ( col == 5 && SgnY >= 0 ) return retval;
            if ( col == 6 && SgnX <= 0 ) return retval;
            if ( col == 7 && SgnX >= 0 ) return retval;
            if ( an < 0 ) {
                if ( PixelIntersect2 ( _newX, _newY, y, x ) )
                    return 1;
            } else {
                return 1;
            }
        }
        return retval;
    }

    if ( y < 0 || x < 0 || y > 255 || x > 255 )
    {
        if ( m_type == WEAPON_TYPE_GRENADE )
            return 3;
    }

    short c = x - 1, d = x + 1,
          e = y - 1, f = y + 1;


    SDL_Rect rBlock;
    for ( y = e; y <= f; y++ )
    {
        for ( x = c; x <= d; x++ )
        {
            if ( y < 0 || x < 0 ) continue;
            if ( y > 255 || x > 255 ) continue;
            short st = map->GetSourceTile(y, x);
            LegacyRect *rt = map->GetRoughTile(st);
            if ( st > -1 )
            {
                rBlock.x = x * 16 + rt->cLeft;
                rBlock.y = y * 16 + rt->aTop;
                rBlock.w = 16 - rt->cLeft - rt->dRight;
                rBlock.h = 16 - rt->aTop - rt->bBottom;
            } else {
                rBlock.x = x * 16;
                rBlock.y = y * 16;
                rBlock.w = 16;
                rBlock.h = 16;
            }
            if ( SDL_CollideBoundingBox ( rWho, rBlock ) )
            {
                short col = map->GetCollision ( y, x );
                short st = map->GetSourceTile ( y, x );
                if ( col > -1 && col < 8 )
                {
                    switch ( m_type )
                    {
                    case WEAPON_TYPE_SPARK:
                        break;
                    case WEAPON_TYPE_GRENADE:
                        if ( map->GetAnimation(y,x) == -2 ) {
                            retval = 3;
                            continue; // TODO: BUGBUG: Why continue?
                        }
                    case WEAPON_TYPE_SHRAPNEL:
                    case WEAPON_TYPE_MISSILE:
                    case WEAPON_TYPE_LASER:
                        if ( col == 0 || col == 2 ) continue;
                        if ( st == 425 && SgnY <= 0 ) return 1;
                        if ( st == 424 && SgnX <= 0 ) return 1;
                        if ( st == 422 && SgnX >= 0 ) return 1;
                        if ( st == 303 && SgnX <= 0 ) return 1;
                        if ( st == 301 && SgnX >= 0 ) return 1;
                        if ( st == 225 && SgnY <= 0 ) return 1;
                        if ( st == 345 && SgnY >= 0 ) return 1;
                        if ( st == 388 && SgnY <= 0 ) return 1;
                        if ( st == 308 && SgnY >= 0 ) return 1;
                        if ( col == 4 && SgnY <= 0 ) continue;
                        if ( col == 5 && SgnY >= 0 ) continue;
                        if ( col == 6 && SgnX <= 0 ) continue;
                        if ( col == 7 && SgnX >= 0 ) continue;
                        if ( map->GetAnimation ( y, x ) == -1 ) {
                            if ( m_type == WEAPON_TYPE_GRENADE || m_type == WEAPON_TYPE_SHRAPNEL )
                            {
                                if ( PixelIntersect3 ( _newX, _newY, y, x ) )
                                    return 1;
                            }
                            else
                            {
                                if ( PixelIntersect2 ( _newX, _newY, y, x ) )
                                    return 1;
                            }
                        } else
                            return 1;
                        break;
                    case WEAPON_TYPE_BOUNCE:
                        if ( col == 0 || col == 2 ) continue;
                        if ( st == 425 && SgnY <= 0 ) goto detect;
                        if ( st == 424 && SgnX <= 0 ) goto detect;
                        if ( st == 422 && SgnX >= 0 ) goto detect;
                        if ( st == 303 && SgnX <= 0 ) goto detect;
                        if ( st == 301 && SgnX >= 0 ) goto detect;
                        if ( st == 225 && SgnY <= 0 ) goto detect;
                        if ( st == 345 && SgnY >= 0 ) goto detect;
                        if ( st == 388 && SgnY <= 0 ) goto detect;
                        if ( st == 308 && SgnY >= 0 ) goto detect;
                        if ( col == 4 && SgnY <= 0 ) continue;
                        if ( col == 5 && SgnY >= 0 ) continue;
                        if ( col == 6 && SgnX <= 0 ) continue; // One-way wall (right to left)
                        if ( col == 7 && SgnX >= 0 ) continue; // One-way wall (left to right)
detect:
                        short TestXY = 0;
                        if ( map->GetAnimation ( y, x ) > -1 )
                        {
                            rWho.y = _newY + SgnY;
                            rWho.h = 1;
                            if ( _newX >= x * 16 &&
                                 _newY + SgnY >= y * 16 &&
                                 _newX <= x * 16 + 16 &&
                                 _newY + SgnY <= y * 16 + 16 ) // REDO
                            {
                                retval = 3;
                                TestXY = 1;
                            }
                            if ( TestXY == 0 )
                            {
                                rWho.y = _newY;
                                rWho.x = _newX + SgnX;
                                rWho.h = 1;
                                rWho.w = 1;
                                if ( _newX + SgnX >= x * 16 &&
                                     _newY >= y * 16 &&
                                     _newX + SgnX <= x * 16 + 16 &&
                                     _newY <= y * 16 + 16 ) // REDO
                                {
                                    retval = 3;
                                    TestXY = 2;
                                }
                            }
                        } else {

                            // Is the bouncy INSIDE the object? If so, destroy it immediately,
                            // as we should have made a bounce-back copy earlier.
                            if ( PixelIntersect2 ( _newX, _newY, y, x ) )
                                return 3;

                            // Otherwise, check if it collides.
                            if ( PixelIntersect2 ( _newX, _newY + SgnY, y, x ) )
                            {
                                retval = 3;
                                TestXY = 1;
                            }
                            if ( TestXY == 0 )
                            {
                                if ( PixelIntersect2 ( _newX + SgnX, _newY, y, x ) )
                                {
                                    retval = 3;
                                    TestXY = 2;
                                }
                            }
                        }
                        double h = 0.0;
                        if ( TestXY == 1 )
                        {
                            if ( m_angle < 1 )
                                h = ( m_angle >= 0 ) ? m_angle : m_angle * -1;
                            else if ( m_angle >= 0 && m_angle <= 90 )
                                h = m_angle * -1;
                            else if ( m_angle > 90 && m_angle <= 180 )
                                h = 270 - (m_angle - 90);
                            else if ( m_angle > 180 && m_angle <= 270 )
                                h = 90 + ( 270 - m_angle );
                            Bounce *bounce = dynamic_cast<Bounce *>(this);
                            g_interface->ReBounce ( bounce->m_player, _newX - SgnX, _newY - SgnY, h, bounce );
                            return retval;
                        }
                        else if ( TestXY == 2 )
                        {
                            if ( m_angle < 1 )
                                h = 180 + ( ( m_angle >= 0 ) ? m_angle : m_angle * -1 );
                            else if ( m_angle > 0 && m_angle <= 90 )
                                h = 180 - m_angle;
                            else if ( m_angle > 90 && m_angle <= 180 )
                                h = 90 - (m_angle - 90);
                            else if ( m_angle > 180 && m_angle <= 270 )
                                h = -90 + ( 270 - m_angle );
                            Bounce *bounce = dynamic_cast<Bounce *>(this);
                            g_interface->ReBounce ( bounce->m_player, _newX - SgnX, _newY - SgnY, h, bounce );
                            return retval;
                        }
                        break;
                    } // switch ( m_type )
                } // if ( col > -1 && col < 8 )
            } // CollideBoundingBox
        } // for ( x = c; x <= d; x++ )
    } // for ( y = e; y <= f; y++ )
    return retval;
}
