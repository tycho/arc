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
#include "Game/collide.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/ship_explosion.h"
#include "App/app.h"

static const SDL_Rect rShipExp[24] =
{
    {  24, 126, 14, 13 },
    {  85, 123, 19, 18 },
    { 145, 120, 26, 25 },
    { 205, 116, 33, 32 },
    { 266, 113, 40, 39 },
    { 328, 110, 45, 45 },
    {   6, 172, 50, 49 },
    {  69, 170, 52, 52 },
    { 133, 170, 53, 53 },
    { 196, 169, 55, 55 },
    { 260, 168, 56, 56 },
    { 324, 168, 57, 57 },
    {   3, 231, 58, 58 },
    {  67, 231, 59, 59 },
    { 131, 231, 59, 59 },
    { 195, 231, 59, 59 },
    { 258, 230, 60, 60 },
    { 322, 230, 61, 61 },
    {   2, 294, 61, 61 },
    {  66, 294, 61, 61 },
    { 130, 294, 61, 61 },
    { 194, 294, 61, 61 },
    { 258, 294, 61, 61 },
    { 322, 294, 61, 61 },
};

ShipExplosion::ShipExplosion ( float _x, float _y )
 : Widget(0, 0, 61, 61), m_damaged(true), m_popFrame(0), m_x(_x), m_y(_y)
{
    SetWidgetClass ( "ShipExplosion" );
	Initialise();
}

ShipExplosion::~ShipExplosion()
{
}

int ShipExplosion::SendEnterKey ()
{
    return 0;
}

int ShipExplosion::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    return 0;
}

void ShipExplosion::Initialise()
{
	g_graphics->DeleteSurface ( m_cachedSurfaceID );
    m_cachedSurfaceID = g_graphics->CreateSurface ( 61, 61, false );

	Widget::Initialise();
}

void ShipExplosion::Update()
{
    m_popFrame += g_game->GetGameSpeed() * 0.5;

    if ( (int)m_popFrame > 23 )
        m_expired = true;
}

void ShipExplosion::Render()
{
    if ( m_expired ) return;

    SDL_Rect const &rSource = rShipExp[(int)m_popFrame];

    short CenterSX = g_graphics->GetCenterX() - 16,
          CenterSY = g_graphics->GetCenterY() - 16;
    short MeX = (short)(g_game->m_me->GetX() - CenterSX),
          MeY = (short)(g_game->m_me->GetY() - CenterSY);

    m_position.x = (short)m_x - MeX - rSource.w / 2;
    m_position.y = (short)m_y - MeY - rSource.h / 2;

    g_graphics->FillRect ( m_cachedSurfaceID, NULL, g_graphics->GetColorKey() );
    g_graphics->Blit ( g_interface->GetTuna1SurfaceID(), (SDL_Rect *)&rSource, m_cachedSurfaceID, NULL );

    Widget::Render();
}
