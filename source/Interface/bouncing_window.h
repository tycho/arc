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

#ifndef __included_bouncing_window_h
#define __included_bouncing_window_h

#include "Interface/window.h"

class BouncingWindow : public Window
{
protected:
    Sint16 m_xvelocity;
    Sint16 m_yvelocity;

public:
    BouncingWindow ();
    BouncingWindow ( Uint16 x, Uint16 y, Uint16 w, Uint16 h, Sint16 xvel, Sint16 yvel );
    ~BouncingWindow();

    //virtual void PlayBounceNoise ();
    virtual void SetVelocity ( Sint16 xvel, Sint16 yvel );

    virtual void Update ();
};

#endif
