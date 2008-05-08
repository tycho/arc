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
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/window.h"

Window::Window()
 : Widget(), m_dragging(false)
{
    SetWidgetClass ( "Window" );
}

Window::Window ( Sint16 x, Sint16 y, Uint16 w, Uint16 h )
 : Widget(x,y,w,h), m_dragging(false)
{
    SetWidgetClass ( "Window" );
}

Window::~Window()
{
}

int Window::SendEnterKey ()
{
    if ( HasEnterKeyDefault() )
    {
        return m_enterKeyDefault->SendEnterKey ();
    } else {
        return 0;
    }
}

int Window::MouseDown ( bool _mouseDown, Sint32 x, Sint32 y )
{
    if ( !m_dragging )
    {
        SDL_Rect actualPosition;
        for ( int i = m_widgets.size() - 1; i >= 0; i-- )
        {
            Widget *widget = m_widgets[i];
            // Window widget positions are relative to the window's position.
            actualPosition.x = widget->m_position.x + m_position.x;
            actualPosition.y = widget->m_position.y + m_position.y;
            actualPosition.w = widget->m_position.w;
            actualPosition.h = widget->m_position.h;
            if ( x < actualPosition.x || y < actualPosition.y )
                continue;
            if ( x > ( actualPosition.x + actualPosition.w ) ||
                y > ( actualPosition.y + actualPosition.h ) )
                continue;
            if ( !(widget->MouseDown ( _mouseDown, x, y )) )
                break;
            return -1;
            break;
        }
    }
    if ( !m_dragging && _mouseDown )
    {
        g_interface->SetDragWindow ( this );
        m_dragging = true;
        m_mouseXOffset = x - m_position.x;
        m_mouseYOffset = y - m_position.y;
    } else if ( m_dragging && _mouseDown ) {
        SetPosition ( x - m_mouseXOffset, y - m_mouseYOffset );
    } else if ( m_dragging && !_mouseDown ) {
        g_interface->SetDragWindow ( NULL );
        m_dragging = false;
    }
    return 1;
}

void Window::DrawBox ()
{
    SDL_Rect rBox; short x; short y; short xt; short yt;
    short xTo; short yTo; SDL_Rect rTo;

    // TODO: Windows are restricted at heights/widths that are evenly divisible by 16. That's annoying. Fix it.

    m_position.w = (m_position.w - (m_position.w % 8));
    m_position.h = (m_position.h - (m_position.h % 8));

    xTo = m_position.w / 8 - 1;
    yTo = m_position.h / 8 - 1;

    m_cachedSurfaceID = g_graphics->CreateSurface ( m_position.w, m_position.h, true );

    for ( x = 0; x < xTo; x++ )
    {
        for ( y = 0; y < yTo; y++ )
        {
            rBox.y = 0; rBox.h = 0; rBox.x = 0; rBox.w = 0;
            xt = x * 8;
            yt = y * 8;
            if ( y == 1 || x == 1 ) continue;
            if (x > 0 && x != xTo - 1 ) { rBox.x = 16; }
            else if ( x == xTo - 1 ) { rBox.x = 32; }
            if ( y == 0 ) rBox.y = 0;
            if ( y > 0 ) rBox.y = 16; // Middle
            if ( y == yTo - 1 ) rBox.y = 32;
            rBox.h = 16; rBox.w = 16;
            rBox.x += 251;
            rBox.y += 12;
            rTo.x = xt;
            rTo.y = yt;
            g_graphics->Blit ( g_interface->GetSidebarSurfaceID(), &rBox, m_cachedSurfaceID, &rTo );
        }
    }
}

void Window::Update()
{
    Widget::Update();
    if ( (int)m_cachedSurfaceID == -1 )
        DrawBox();
}
