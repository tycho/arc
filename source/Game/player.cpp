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

#include "App/app.h"
#include "App/string_utils.h"
#include "Game/game.h"
#include "Game/player.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"

Player::Player ( const char *_nickname, ShipType _ship, short _score,
                 char admin, char cheat )
: m_flagWho(0),
  m_flagID(0),
  m_charX(0.0f),
  m_charY(0.0f),
  m_cheat(cheat),
  m_shipType(-1),
  m_frame(0),
  m_admin(admin),
  m_lastAnim(0),
  m_animX(9),
  m_score(_score),
  m_moveX(g_graphics->GetCenterX() - 16),
  m_moveY(g_graphics->GetCenterY() - 16),
  m_keyIs(MOVE_NONE),
  m_visible(true),
  m_inPen(false),
  m_holdingPen(0),
  m_armorCritical(false),
  m_armorCriticalTime(0),
  m_warping(false),
  m_warped(0),
  m_tick(0),
  m_degrees(0), 
  m_mode(0),
  m_nextSync(0)
{
    m_nick = newStr(_nickname);
    m_ship = new Ship(this);
    SetTeam ( _ship );
}

Player::~Player()
{
    delete m_ship; m_ship = NULL;
    delete [] m_nick; m_nick = NULL;
}

bool Player::Visible()
{
    return m_visible;
}

int Player::GetMode()
{
    return m_mode;
}

bool Player::InPen()
{
    return m_inPen;
}

char Player::GetKey()
{
    return m_keyIs;
}

float Player::GetX()
{
    return m_charX;
}

float Player::GetY()
{
    return m_charY;
}

short Player::GetMoveX()
{
    return m_moveX;
}

short Player::GetMoveY()
{
    return m_moveY;
}

short Player::GetTeam()
{
    return m_shipType;
}

Ship *Player::GetShip ()
{
    ARCReleaseAssert ( m_ship != NULL );
    return m_ship;
}

void Player::SetArmorCritical ( bool _isCritical )
{
    m_armorCritical = _isCritical;
}

bool Player::GetArmorCritical ()
{
    return m_armorCritical;
}

void Player::SetInPen ( bool _isInPen )
{
    m_inPen = _isInPen;
}

void Player::SetMode ( char _mode )
{
    m_mode = _mode;
}

void Player::SetNick ( const char *_nick )
{
    m_nick = newStr ( _nick );
}

void Player::SetVisibility ( bool _isVisible )
{
    m_visible = _isVisible;
}

void Player::SetScore ( short _score )
{
    ARCReleaseAssert ( _score >= 0 );
    m_score = _score;
    m_ship->FlushText();
}

void Player::SetDirection ( MovementDirections _keyIs )
{
    if ( m_keyIs != _keyIs )
    {
        m_keyIs = (char)_keyIs;
#ifdef ENABLE_NETWORKING
        if ( g_game->m_me == this )
            g_game->m_connection->SendNewKey ( m_keyIs );
#endif
        m_ship->Flush();
    }
}

void Player::SetPosition ( short x, short y )
{
    m_charX = x; m_charY = y;
}

void Player::SetTeam ( ShipType ship )
{
    m_shipType = (char)ship;
}

void Player::Update ()
{
    m_ship->Update();
}

void Player::Render ()
{
    m_ship->Render();
}
