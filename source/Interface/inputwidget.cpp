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

#include <typeinfo>

#include "App/app.h"
#include "Interface/inputwidget.h"

InputWidget::InputWidget ( InputCallback _callback, Widget *_callbackParam,
                           Sint32 _x, Sint32 _y, Sint32 _w, Sint32 _h )
 : Widget ( _x, _y, _w, _h )
{
    SetWidgetClass ( "InputWidget" );
    m_callback = _callback;
    m_callbackParam = _callbackParam;
}

int InputWidget::SendEnterKey ()
{
    if ( m_callback )
    {
        try {
            m_callback ( m_callbackParam );
        } catch ( std::exception &e ) {
            // TODO: Print out what 'e' provides.
            g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
            g_console->WriteLine ( "WARNING: InputWidget of type '%s' tried to use an invalid callback.", m_widgetClass );
            g_console->WriteLine ( "         m_callback threw exception '%s'", e.what() );
            g_console->SetColour ();
        }
        return -1;
    } else {
        // This widget has no callbacks defined.
        return 0;
    }
}

int InputWidget::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    if ( m_callback )
    {
        // It feels too reactive if it reacts on _mouseDown rather than !_mouseDown
        if ( !_mouseDown )
        {
            try {
                m_callback ( m_callbackParam );
            } catch ( std::exception &e ) {
                // TODO: Print out what 'e' provides.
                g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
                g_console->WriteLine ( "WARNING: InputWidget of type '%s' tried to use an invalid callback.", m_widgetClass );
                g_console->WriteLine ( "         m_callback threw exception '%s'", e.what() );
                g_console->SetColour ();
            }
        }
        // Even if the click wasn't used, we return -1 because this
        // widget does have a callback defined for !_mouseDown calls.
        return -1;
    } else {
        // This widget has no callbacks defined.
        return 0;
    }
}
