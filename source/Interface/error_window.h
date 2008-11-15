/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_error_window_h
#define __included_error_window_h

#include "Interface/window.h"

class ErrorWindow : public Window
{
private:
    TextUI *m_caption;
    bool m_critical;
public:
    ErrorWindow ( const char *_text, bool _critical );
    virtual ~ErrorWindow();

    virtual void OnOKClick();
    virtual void SetCaption ( const char *_caption );
};

#endif
