/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_loading_window_h
#define __included_loading_window_h

#include "Interface/window.h"

class LoadingWindow : public Window
{
private:
    TextUI *m_caption;

public:
    LoadingWindow();
    virtual ~LoadingWindow();

    virtual void SetCaption ( const char *_caption );
};

#endif
