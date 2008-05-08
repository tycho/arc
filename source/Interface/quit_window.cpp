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

#include "Game/game.h"
#include "Graphics/graphics.h"
#include "Interface/button.h"
#include "Interface/quit_window.h"
#include "Interface/text.h"

void QuitWindow_OnYesClick ( Window *_window )
{
    dynamic_cast<QuitWindow *>(_window)->OnYesClick();
}

void QuitWindow_OnNoClick ( Window *_window )
{
    dynamic_cast<QuitWindow *>(_window)->OnNoClick();
}

QuitWindow::QuitWindow()
: Window ( g_graphics->GetCenterX() - 136, g_graphics->GetCenterY() - 32, 256, 72 ) 
{
    SetWidgetClass ( "QuitWindow" );

    TextUI *text = new TextUI ( "Are you sure you want to leave ARC++?", false, 23, 16, 245, 9 );
    AddWidget ( text ); text = NULL;

    Button *button = new Button ( (InputCallback)QuitWindow_OnYesClick, this, BUTTON_TYPE_YES, 47, 36 );
    m_enterKeyDefault = button;
    AddWidget ( button ); button = NULL;

    button = new Button ( (InputCallback)QuitWindow_OnNoClick, this, BUTTON_TYPE_NO, 146, 36 );
    AddWidget ( button ); button = NULL;
}

QuitWindow::~QuitWindow()
{
}

void QuitWindow::OnYesClick ()
{
    g_game->Quit();
}

void QuitWindow::OnNoClick ()
{
    m_expired = true;
}
