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
#include "App/string_utils.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"
#include "Interface/text_input.h"

TextInput::TextInput ( const char *_text, bool _smallText, Sint16 x, Sint16 y, Uint16 w, Uint16 h )
 : TextUI ( _text, _smallText, x, y, w, h )
{
    SetWidgetClass ( "TextInput" );
}

TextInput::~TextInput ()
{
}

int TextInput::SendEnterKey ()
{
    return 0;
}

int TextInput::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    return 0;
}

void TextInput::Update ()
{
    TextUI::Update();
}

void TextInput::Render ()
{
    Widget::Render();
}
