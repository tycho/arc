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

#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/button.h"

Button::Button ( InputCallback _callback, Widget *_callbackParam, ButtonType _buttonType, Sint32 _x, Sint32 _y )
 : InputWidget ( _callback, _callbackParam, _x, _y, 58, 19 )
{
    SetWidgetClass ( "Button" );
    m_callback = _callback;
    m_callbackParam = _callbackParam;
    m_buttonType = _buttonType;
}

Button::~Button()
{
}

ButtonType Button::GetButtonType()
{
    return m_buttonType;
}

void Button::Update()
{
    if ( (int)m_cachedSurfaceID == -1 )
    {
        m_cachedSurfaceID = g_graphics->CreateSurface ( 58, 19, true );
        SDL_Rect buttonSource;
        buttonSource.y = (int)m_buttonType * 20 + 14;
        buttonSource.h = 19;
        buttonSource.x = 540;
        buttonSource.w = 58;
        g_graphics->Blit ( g_interface->GetSidebarSurfaceID(), &buttonSource, m_cachedSurfaceID, NULL );
    }
}
