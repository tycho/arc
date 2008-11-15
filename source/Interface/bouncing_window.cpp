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
#include "Graphics/graphics_sdl.h"
#include "Interface/bouncing_window.h"
#include "Sound/soundsystem.h"

BouncingWindow::BouncingWindow()
 : Window()
{
    SetVelocity ( 0, 0 );
}

BouncingWindow::BouncingWindow ( Uint16 x, Uint16 y, Uint16 w, Uint16 h, Sint16 xvel, Sint16 yvel )
 : Window ( x, y, w, h )
{
    SetVelocity ( xvel, yvel );
}

BouncingWindow::~BouncingWindow()
{
}

void BouncingWindow::SetVelocity ( Sint16 xvel, Sint16 yvel )
{
    m_xvelocity = xvel;
    m_yvelocity = yvel;
}

void BouncingWindow::Update()
{
    Window::Update();
    if ( m_xvelocity )
    {
        // Advance the X position.
        m_position.x += (Sint16)( m_xvelocity * g_game->GetGameSpeed() );
        if ( m_position.x < 0 )
        {
            // Bounce off the left side.
            m_position.x = 0;
            m_xvelocity *= -1;
            //PlayBounceNoise();
        }
        if ( m_position.x + m_position.w > (Sint32)g_graphics->GetScreenWidth() )
        {
            // Bounce off the right side.
            m_position.x = g_graphics->GetScreenWidth() - m_position.w;
            m_xvelocity *= -1;
            //PlayBounceNoise();
        }
    }
    if ( m_yvelocity )
    {
        // Advance the Y position.
        m_position.y += (Sint16)( m_yvelocity * g_game->GetGameSpeed() );
        if ( m_position.y < 0 )
        {
            // Bounce off the top.
            m_position.y = 0;
            m_yvelocity *= -1;
            //PlayBounceNoise();
        }
        if ( m_position.y + m_position.h > (Sint32)g_graphics->GetScreenHeight() )
        {
            // Bounce off the bottom.
            m_position.y = g_graphics->GetScreenHeight() - m_position.h;
            m_yvelocity *= -1;
            //PlayBounceNoise();
        }
    }
}
