/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __interface_h_included
#define __interface_h_included

#include "Game/bounce.h"
#include "Game/laser.h"
#include "Game/shrapnel.h"
#include "Game/grenade_explosion.h"
#include "Game/grenade_smoke.h"
#include "Game/missile_smoke.h"
#include "Game/shrapnel.h"
#include "Game/spark.h"
#include "Game/grenade.h"
#include "Game/missile.h"
#include "Graphics/surface.h"
#include "Interface/chat_overlay.h"
#include "Interface/laser_zap.h"
#include "Interface/sidebar.h"
#include "Interface/ship.h"
#include "Interface/ship_explosion.h"
#include "Interface/text.h"
#include "Interface/widget.h"
#include "Interface/window.h"

typedef enum
{
    MOUSE_POINTER_CLASSIC = 0,
    MOUSE_POINTER_MISSILE = 1,
    MOUSE_POINTER_GRENADE = 2,
    MOUSE_POINTER_BOUNCE = 3,
    MOUSE_POINTER_ARROW_RIGHT = 4,
    MOUSE_POINTER_ARROW_LEFT = 5
} MousePointerType;

class Interface
{
public:
    Data::LList<Laser *> m_lasers;
    Data::LList<Bounce *> m_bouncies;
    Data::LList<Missile *> m_missiles;
    Data::LList<Grenade *> m_grenades;

protected:
    System::Stopwatch m_tmrMouseFrame;

    Sidebar *m_sidebar;
    ChatOverlay *m_chatOverlay;

    Data::LList<Widget *> m_widgetList;

    Data::LList<Ship *> m_ships;
    Data::LList<ShipExplosion *> m_shipExplosions;
    Data::LList<LaserZap *> m_laserZaps;
    Data::LList<Spark *> m_sparks;
    Data::LList<MissileSmoke *> m_missileSmoke;
    Data::LList<GrenadeSmoke *> m_grenadeSmoke;
    Data::LList<GrenadeExplosion *> m_grenadeExplosions;
    Data::LList<Shrapnel *> m_shrapnel;

    Window *m_dragWindow;

    TextUI *m_fpsWidget;
    TextUI *m_rendererWidget;

    Uint32 m_animsID[2];
    Surface *m_farplane;
    Uint32 m_tunaID;
    Uint32 m_tuna1ID;
    Uint32 m_rawTextID;
    Uint32 m_sidebarID;
    Uint32 m_extrasID;
    Uint32 m_textID;
    Uint32 m_smallTextID;
    Uint32 m_tilesID;
    Uint32 m_shipsID;

    unsigned char m_frameCount[256];
    unsigned char m_animSpeed[256];
    short m_animFrames[256][256];

    unsigned char m_animFS[256][256];

    short m_animFX[256][256];
    short m_animFY[256][256];

    MousePointerType m_mousePointer; // TODO: Make this so that it's used properly.
    Uint32 m_mouseWidth;
    Uint32 m_mouseHeight;
    Sint32 m_mouseX;
    Sint32 m_mouseY;
    Uint8  m_mouseButton;
    Sint32 m_mouseFrame;

public:

    SDL_Rect m_rChars[96];
    SDL_Rect m_rChars2[96];

public:
    Interface();
    virtual ~Interface();
    virtual Uint32 GetAnimSurfaceID        ( int _index );
    virtual Uint32 GetShipsSurfaceID       ();
    virtual Uint32 GetTileSurfaceID        ();
    virtual Uint32 GetTextSurfaceID        ();
    virtual Uint32 GetTuna1SurfaceID       ();
    virtual Uint32 GetSmallTextSurfaceID   ();
    virtual Uint32 GetSidebarSurfaceID     ();

    virtual void AddChat                   ( const char *_chatText );
    virtual void AddLaserZap               ( LaserZap *_zap );
    virtual void AddShip                   ( Ship *_ship );
    virtual void AddShipExplosion          ( ShipExplosion *_explosion );
    virtual void AddWidget                 ( Widget *_widget );

    virtual void FirePrimaryWeapon         ( int _mouseX, int _mouseY );
    virtual void FireSecondaryWeapon       ( int _mouseX, int _mouseY );
    virtual void FireLaser                 ( Player *_who, int _lX, int _lY, int _cX, int _cY );
    virtual void FireMissile               ( Player *_who, int _lX, int _lY, int _cX, int _cY );
    virtual void FireBounce                ( Player *_who, int _lX, int _lY, int _cX, int _cY );
    virtual void FireGrenade               ( Player *_who, int _lX, int _lY, int _cX, int _cY );
    virtual void ExplodeShrapnel           ( Player *_who, int _x, int _y, double _speed, int _shrapTick, int _explStart, int _explPower);
    virtual void ExplodeSpark              ( int _cX, int _cY );
    virtual void ExplodeGrenade            ( int _cX, int _cY );
    virtual void GrenadeSmokeTrail         ( int _cX, int _cY, int _color );
    virtual void MissileSmokeTrail         ( int _cX, int _cY, int _color );
    virtual void ReBounce                  ( Player *_who, int _cX, int _cY, double _angle, Bounce *_re );

    virtual void RenderMap                 ();
    virtual void RenderMapTransfer         ( short _mapTransferPercentage );
    virtual void RenderMouse               ();
    virtual void RenderFarplane            ( short _meX, short _meY );
    virtual int  GetFrameCount             ( int _index );
    virtual int  GetAnimSpeed              ( int _index );
    virtual void SetAnimSpeed              ( int _index, char _value );
    virtual short GetAnimFS                ( int _index0, int _index1 );
    virtual short GetAnimFY                ( int _index0, int _index1 );
    virtual short GetAnimFX                ( int _index0, int _index1 );
    virtual short GetAnimFrames            ( int _index0, int _index1 );
    virtual int   LoadAnims                ();

    virtual void ProcessMouseEvents        ();
    virtual void SetDragWindow             ( Window *_window );
    virtual bool InsideWidget              ( int _mouseX, int _mouseY );

    virtual void SetupText                 ();
    virtual int  InitSurfaces              ();
	virtual void InitWidgets               ();
    virtual void UpdateFPS                 ( unsigned int _fps );
    virtual void UpdateRendererWidget      ();
    virtual void RenderBouncies            ();
    virtual void RenderGameUI              ();
    virtual void RenderGrenades            ();
    virtual void RenderGrenadeSmoke        ();
    virtual void RenderGrenadeExplosions   ();
    virtual void RenderLasers              ();
    virtual void RenderLaserZaps           ();
    virtual void RenderMissiles            ();
    virtual void RenderMissileSmoke        ();
    virtual void RenderShipExplosions      ();
    virtual void RenderShrapnel            ();
    virtual void RenderSparks              ();
    virtual void RenderWidgets             ();
    virtual void RemoveWidget              ( Widget *_widget );
    virtual Widget *GetWidgetOfType        ( const char *_widgetType );
    virtual int MouseDown                  ( bool _mouseDown, Sint32 x, Sint32 y );
    virtual int SendEnterKey               ();
};

extern Interface *g_interface;

#endif
