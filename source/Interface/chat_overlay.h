/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_chat_overlay_h
#define __included_chat_overlay_h

#include <crisscross/stopwatch.h>

#include "Interface/widget.h"

class ChatOverlay : public Widget
{
protected:
    Sint16 m_numRows;
    System::Stopwatch m_lastModification;

    void KillLine();
    void UpdatePositions();

public:
    ChatOverlay ( Sint16 _numRows, Sint16 x, Sint16 y, Uint16 w, Uint16 h );
    virtual ~ChatOverlay();

    virtual void AddLine ( const char *_text );
    virtual void Clear ();

    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y );
    virtual int SendEnterKey ();

    virtual void Update();
};


#endif
