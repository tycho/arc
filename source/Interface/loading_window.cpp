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
#include "Graphics/graphics.h"
#include "Interface/button.h"
#include "Interface/loading_window.h"
#include "Interface/text.h"

LoadingWindow::LoadingWindow()
: Window ( g_graphics->GetCenterX() - 150, g_graphics->GetCenterY() - 40, 300, 80 )
{
    SetWidgetClass ( "LoadingWindow" );

    m_caption = new TextUI ( "[null]", false, 35, 35, 300, 9 );
    SetCaption ( "Loading..." );
    AddWidget ( m_caption );

}

LoadingWindow::~LoadingWindow()
{
}

void LoadingWindow::SetCaption ( const char *_caption )
{
    ARCReleaseAssert ( _caption != NULL );
    if ( strlen ( _caption ) != strlen ( m_caption->GetText() ) )
    {
        int newWidth = (int)strlen ( _caption ) * 5 + 72;
        m_position.w = newWidth;
        m_position.x = g_graphics->GetCenterX() - (newWidth / 2);
        if ( (int)m_cachedSurfaceID != -1 )
        {
            g_graphics->DeleteSurface ( m_cachedSurfaceID ); m_cachedSurfaceID = -1;
        }
        m_caption->SetPosition ( (Sint16)((m_position.w / 2) - ( (strlen ( _caption ) * 5.32) / 2 )), 35 );
        m_caption->SetText ( _caption );
    }
}
