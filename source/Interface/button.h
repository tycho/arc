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
