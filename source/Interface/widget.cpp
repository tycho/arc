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
#include "Game/collide.h"
#include "Graphics/graphics.h"
#include "Interface/widget.h"

Widget::Widget()
 : m_expired(false), m_widgetClass(NULL), m_cachedSurfaceID(-1),
   m_enterKeyDefault(NULL)
{
    SetWidgetClass ( "Widget" );
    m_expired = false;
    memset ( &m_position, 0, sizeof(m_position) );
}

Widget::Widget ( Sint16 x, Sint16 y, Uint16 w, Uint16 h )
 : m_expired(false), m_widgetClass(NULL), m_cachedSurfaceID(-1),
   m_enterKeyDefault(NULL)
{
    SetWidgetClass ( "Widget" );
    m_expired = false;
    SetSize ( w, h );
    SetPosition ( x, y );
}

Widget::~Widget()
{
    delete [] m_widgetClass; m_widgetClass = NULL;
    if ( (int)m_cachedSurfaceID != -1 )
    {
        g_graphics->DeleteSurface ( m_cachedSurfaceID );
    }
    while ( m_widgets.get(0) )
    {
        delete m_widgets.get(0);
        m_widgets.remove(0);
    }
}

bool Widget::Expired ()
{
    return m_expired;
}

void Widget::AddWidget ( Widget *_widget )
{
    m_widgets.insert ( _widget );
}

Data::LList<Widget *> *Widget::GetWidgetList()
{
    return &m_widgets;
}

bool Widget::IsInsideWidget ( int _mouseX, int _mouseY )
{
    SDL_Rect mousePos;
    mousePos.x = _mouseX;
    mousePos.y = _mouseY;
    mousePos.w = 1; mousePos.h = 1;
    return ( SDL_CollideBoundingBox ( mousePos, m_position ) != 0 );
}

void Widget::Render ()
{
    if ( (int)m_cachedSurfaceID != -1 )
        g_graphics->Blit ( m_cachedSurfaceID, NULL, g_graphics->GetScreen(), &m_position ); // FLAG
    for ( size_t i = 0; i < m_widgets.size(); i++ )
    {
        Widget *widget = m_widgets[i];
        ARCReleaseAssert ( widget );
        widget->Update();
        if ( widget->m_expired )
        {
            m_widgets.remove ( i-- );
            delete widget;
            continue;
        }
        widget->Render ( m_position.x, m_position.y );
    }
}

bool Widget::HasEnterKeyDefault ()
{
    return m_enterKeyDefault != NULL;
}

void Widget::Render ( Sint16 _xOffset, Sint16 _yOffset )
{
    ARCReleaseAssert ( (int)m_cachedSurfaceID != -1 );
    SDL_Rect newPos;
    memcpy ( &newPos, &m_position, sizeof ( SDL_Rect ) );
    newPos.x += _xOffset;
    newPos.y += _yOffset;
    g_graphics->Blit ( m_cachedSurfaceID, NULL, g_graphics->GetScreen(), &newPos );
}

void Widget::SetPosition ( Sint16 x, Sint16 y )
{
    if ( x < 0 ) x = 0; if ( y < 0 ) y = 0;
    m_position.x = x; m_position.y = y;

    if ( m_position.x + m_position.w > (Sint32)g_graphics->GetScreenWidth() )
        m_position.x = g_graphics->GetScreenWidth() - m_position.w;

    if ( m_position.y + m_position.h > (Sint32)g_graphics->GetScreenHeight() )
        m_position.y = g_graphics->GetScreenHeight() - m_position.h;
}

void Widget::SetSize ( Uint16 w, Uint16 h )
{
    m_position.w = w; m_position.h  = h;
}

void Widget::SetWidgetClass ( const char *_id )
{
    if ( m_widgetClass ) { delete [] m_widgetClass; m_widgetClass = NULL; }
    m_widgetClass = newStr ( _id );
}

const char *Widget::GetWidgetClass ()
{
    return m_widgetClass;
}

bool Widget::GetDestroyFlag()
{
    return m_expired;
}

void Widget::SetDestroyFlag ( bool _destroy )
{
    m_expired = _destroy;
}

void Widget::Update()
{
    for ( size_t i = 0; i < m_widgets.size(); i++ )
    {
        Widget *widget = m_widgets[i];
        if ( widget->m_expired )
        {
            m_widgets.remove ( i-- );
            delete widget;
            continue;
        }
        m_widgets[i]->Update();
    }
}
