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
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/text.h"
#include "Interface/chat_overlay.h"

ChatOverlay::ChatOverlay ( Sint16 _numRows, Sint16 x, Sint16 y, Uint16 w, Uint16 h )
 : Widget ( x, y, w, h ), m_numRows(_numRows)
{
    SetWidgetClass ( "ChatOverlay" );
    m_lastModification.Start();
}

ChatOverlay::~ChatOverlay ()
{
}

int ChatOverlay::SendEnterKey ()
{
    return 0;
}

int ChatOverlay::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    return 0;
}

void ChatOverlay::AddLine ( const char *_text )
{
    if ( (int)m_widgets.size() == m_numRows )
    {
        KillLine();
    }
    const int MaximumTextLength = 100;
    char *temp = cc_strdup ( _text );
    char *lineBreak = NULL;

    // The line is too long, we need to wrap it.
    if ( (int)strlen ( temp ) > MaximumTextLength )
    {
        lineBreak = strchr ( temp + MaximumTextLength, ' ' );
        if ( lineBreak )
            *lineBreak = '\x0';
    }

    // Add the whole line or the part we truncated it to.
    m_widgets.insert ( new TextUI ( temp, false, 5, 5 + ( 12 * ( m_widgets.size() + 1 ) ), g_graphics->GetScreenWidth() - 150, 12 ) );

    // We have more to add.
    if ( lineBreak )
    {
        // Preserve the colour coding.
        if ( _text[0] < 12 )
            *lineBreak = _text[0];
        else
            lineBreak++;

        // Add the remainder
        AddLine ( lineBreak );
    }

    free ( temp );

    UpdatePositions();
    
    m_lastModification.Start();
}

void ChatOverlay::KillLine()
{
    delete m_widgets.get ( 0 );
    m_widgets.remove ( 0 );
}

void ChatOverlay::UpdatePositions()
{
    for ( size_t i = 0; i < m_widgets.size(); i++ )
    {
        TextUI *widget = dynamic_cast<TextUI *> ( m_widgets.get(i) );
        ARCReleaseAssert ( widget );
        widget->SetPosition ( 5, 5 + ( i * 12 ) );
    }
}

void ChatOverlay::Clear()
{
    while ( m_widgets.size() > 0 )
        KillLine();
}

void ChatOverlay::Update()
{
    m_lastModification.Stop();
    if ( m_lastModification.Elapsed() > 10.0 )
    {
        KillLine ();
        UpdatePositions();
        m_lastModification.Start();
    }
}
