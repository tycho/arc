/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
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
	virtual void Initialise ();
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
