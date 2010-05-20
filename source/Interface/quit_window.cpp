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
