/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_quit_window_h
#define __included_quit_window_h

#include "Interface/window.h"

class QuitWindow : public Window
{
public:
    QuitWindow();
    virtual ~QuitWindow();
    virtual void OnYesClick();
    virtual void OnNoClick();
};

#endif
