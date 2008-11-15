/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
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
