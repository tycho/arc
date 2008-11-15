/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_button_h
#define __included_button_h

#include "Interface/inputwidget.h"

typedef enum
{
    BUTTON_TYPE_BLANK = 0,
    BUTTON_TYPE_BACK = 1,
    BUTTON_TYPE_NEXT = 2,
    BUTTON_TYPE_OK = 3,
    BUTTON_TYPE_CANCEL = 4,
    BUTTON_TYPE_YES = 5,
    BUTTON_TYPE_NO = 6
} ButtonType;

class Button : public InputWidget
{
protected:
    ButtonType m_buttonType;

public:
    Button ( InputCallback _callback, Widget *_callbackParam, ButtonType _buttonType, Sint32 _x, Sint32 _y );
    virtual ~Button();

    virtual ButtonType GetButtonType();

    virtual void Update();
};

#endif
