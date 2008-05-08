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
