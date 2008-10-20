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

TextUI::TextUI ( const char *_text, bool _smallText, Sint16 x, Sint16 y, Uint16 w, Uint16 h )
 : Widget ( x, y, w, h ), m_smallText(_smallText)
{
    SetWidgetClass ( "TextUI" );
    m_text = newStr ( _text );
}

TextUI::~TextUI ()
{
    delete [] m_text;
    m_text = NULL;
    g_graphics->DeleteSurface ( m_cachedSurfaceID );
}

void TextUI::Update ()
{
    if ( (int)m_cachedSurfaceID == -1 )
        MakeText ( m_text );
}

int TextUI::SendEnterKey ()
{
    return 0;
}

int TextUI::MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y )
{
    return 0;
}

const char *TextUI::GetText ()
{
    ARCReleaseAssert ( m_text != NULL );
    return m_text;
}

void TextUI::SetText ( const char *_text )
{
    if ( !m_text || strcmp ( _text, m_text ) != 0 )
    {
        delete [] m_text;
        m_text = newStr ( _text );
        if ( (int)m_cachedSurfaceID != -1 )
        {
            // Instead of destroying the surface and making a new one, it's simpler to
            // clear the existing surface and refill it with the appropriate text.

            //g_graphics->DeleteSurface ( m_cachedSurfaceID );
            //m_cachedSurfaceID = -1;

            g_graphics->FillRect ( m_cachedSurfaceID, NULL, g_graphics->GetColorKey() );
            MakeText ( m_text );
        }
    }
}

int TextUI::MakeText ( const char *_text )
{
    unsigned i = 0; short p = 0;
    unsigned char t; char c; unsigned char ap; //short q = 0;
    SDL_Rect temp; unsigned int length = (int)strlen(_text);

    memset ( &temp, 0, sizeof ( SDL_Rect ) );

    if ( (int)m_cachedSurfaceID == -1 )
        m_cachedSurfaceID = g_graphics->CreateSurface ( m_position.w, m_position.h, true );

    c = 5;
    for (i = 0; i < length; i++)
    {
        t = _text[i];
        ap = 32;

        // Colour key characters.
        if (m_smallText && t >= 1 && t <= 6)        { c = t - 1; ap = 0; continue; }
        else if (t >= 1 && t <= 11)                    { c = t; ap = 0; continue; }

        // Anything else.
        else if (t == ' ')            { p += 5; continue; }
        else if (t > '@' && t < '['){ ap = (t - 65) * 2 + 1; }
        else if (t > '`' && t < '{'){ ap = (t - 97) * 2 + 2; }
        else if (t > 48 && t < 58)    { ap = t + 6; }
        else if (t == '!')            { ap = 53; }
        else if (t == '?')            { ap = 54; }
        else if (t == '0')            { ap = 64; }
        else if (t == '.')            { ap = 65; }
        else if (t == ',')            { ap = 66; }
        else if (t == '-')            { ap = 67; }
        else if (t == '+')            { ap = 68; }
        else if (t == '(')            { ap = 69; }
        else if (t == ')')            { ap = 70; }
        else if (t == '`')            { ap = 71; }
        else if (t == '~')            { ap = 72; }
        else if (t == '@')            { ap = 73; }
        else if (t == '$')            { ap = 74; }
        else if (t == '#')            { ap = 75; }
        else if (t == '%')            { ap = 76; }
        else if (t == '*')            { ap = 77; }
        else if (t == '[')            { ap = 78; }
        else if (t == ']')            { ap = 79; }
        else if (t == '{')            { ap = 80; }
        else if (t == '}')            { ap = 81; }
        else if (t == '|')            { ap = 82; }
        else if (t == '/')            { ap = 83; }
        else if (t == '\\')           { ap = 84; }
        else if (t == ':')            { ap = 85; }
        else if (t == ';')            { ap = 86; }
        else if (t == 34)             { ap = 87; }
        else if (t == '=')            { ap = 88; }
        else if (t == '<')            { ap = 89; }
        else if (t == '>')            { ap = 90; }
        else if (t == '&')            { ap = 91; }
        else if (t == '^')            { ap = 92; }
        else if (t == '\'')           { ap = 93; }
        else if (t == '_')            { ap = 94; }
        else if (t == 255)            { ap = 95; }

        ARCDebugAssert ( ap <= 95 );

        if ( m_smallText )
        {
            g_interface->m_rChars2[ap].y = c * 6; // Colour selection
            g_interface->m_rChars2[ap].h = 5;
            temp.x = p;
            g_graphics->Blit ( g_interface->GetSmallTextSurfaceID(), &g_interface->m_rChars2[ap], m_cachedSurfaceID, &temp );
            p += g_interface->m_rChars2[ap].w;
        } else {
            g_interface->m_rChars[ap].y = c * 10; // Colour selection
            g_interface->m_rChars[ap].h = 10;
            temp.x = p;
            g_graphics->Blit ( g_interface->GetTextSurfaceID(), &g_interface->m_rChars[ap], m_cachedSurfaceID, &temp );
            p += g_interface->m_rChars[ap].w;
            if ( ap == 93 ) p ++;
        }
    }

    return length;
}
