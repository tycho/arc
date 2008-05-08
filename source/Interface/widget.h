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

#ifndef __included_widget_h
#define __included_widget_h

class Widget
{
protected:
    bool m_expired;
    char *m_widgetClass;

    Uint32 m_cachedSurfaceID;
    SDL_Rect m_position;

    Data::LList<Widget *> m_widgets;

    Widget *m_enterKeyDefault;

public:
    Widget ();
    Widget ( Sint16 x, Sint16 y, Uint16 w, Uint16 h );
    virtual ~Widget();

    virtual bool HasEnterKeyDefault ();
    virtual bool Expired ();

    virtual bool GetDestroyFlag ();
    virtual void SetDestroyFlag ( bool _destroy );

    virtual void AddWidget ( Widget *_widget );
    virtual void Update ();
    virtual void Render ();
    virtual void Render ( Sint16 _xOffset, Sint16 _yOffset );

    virtual void SetPosition ( Sint16 x, Sint16 y );
    virtual void SetSize ( Uint16 w, Uint16 h );

    virtual void SetWidgetClass ( const char *_id );
    virtual const char *GetWidgetClass ();

    virtual bool IsInsideWidget ( int _mouseX, int _mouseY );
    virtual int MouseDown ( bool _mouseDown, Sint32 _x, Sint32 _y ) = 0;
    virtual int SendEnterKey () = 0;

    virtual Data::LList<Widget *> *GetWidgetList();

    friend class Interface;
    friend class Window;
    friend class QuitWindow;
};

#endif
