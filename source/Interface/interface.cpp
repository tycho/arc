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

#include "universal_include.h"

#include "App/app.h"
#include "App/preferences.h"
#include "Game/game.h"
#include "Graphics/graphics.h"
#include "Interface/interface.h"

Interface::Interface()
 : m_sidebar(NULL),
   m_dragWindow(NULL),
   m_fpsWidget(NULL),
   m_rendererWidget(NULL),
   m_farplane(NULL),
   m_tunaID(-1),
   m_tuna1ID(-1),
   m_rawTextID(-1),
   m_sidebarID(-1),
   m_extrasID(-1),
   m_textID(-1),
   m_smallTextID(-1),
   m_tilesID(-1),
   m_shipsID(-1),
   m_mousePointer(MOUSE_POINTER_BOUNCE),
   m_mouseWidth(32),
   m_mouseHeight(32),
   m_mouseX(0),
   m_mouseY(0),
   m_mouseButton(0),
   m_mouseFrame(0) 
{
    m_animsID[0] = m_animsID[1] = -1;
    memset ( m_frameCount, 0, sizeof(m_frameCount) );
    memset ( m_animSpeed, 0, sizeof(m_animSpeed) );
    memset ( m_animFrames, 0, sizeof(m_animFrames) );
    memset ( m_animFS, 0, sizeof(m_animFS) );
    memset ( m_animFX, 0, sizeof(m_animFX) );
    memset ( m_animFY, 0, sizeof(m_animFY) );
    memset ( m_rChars, 0, sizeof(m_rChars) );
    memset ( m_rChars2, 0, sizeof(m_rChars2) );
    m_sidebar = new Sidebar();
    m_chatOverlay = new ChatOverlay ( 7, 0, 0, g_graphics->GetScreenWidth() - 150, 5 + (12 * 8) );
    m_tmrMouseFrame.Start();
    LoadAnims();
    InitSurfaces();
}

Interface::~Interface()
{
	delete m_farplane; m_farplane = NULL;
    while ( m_widgetList.valid(0) )
    {
        Widget *w = m_widgetList[0];
        m_widgetList.remove ( 0 );
        delete w;
        w = NULL;
    }
    m_fpsWidget = NULL; m_rendererWidget = NULL;
    while ( m_ships.valid(0) )
    {
        Ship *w = m_ships[0];
        m_ships.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_shipExplosions.valid(0) )
    {
        ShipExplosion *w = m_shipExplosions[0];
        m_shipExplosions.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_grenadeExplosions.valid(0) )
    {
        GrenadeExplosion *w = m_grenadeExplosions[0];
        m_grenadeExplosions.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_laserZaps.valid(0) )
    {
        LaserZap *w = m_laserZaps[0];
        m_laserZaps.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_lasers.valid(0) )
    {
        Laser *w = m_lasers[0];
        m_lasers.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_bouncies.valid(0) )
    {
        Bounce *w = m_bouncies[0];
        m_bouncies.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_missiles.valid(0) )
    {
        Missile *w = m_missiles[0];
        m_missiles.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_grenades.valid(0) )
    {
        Grenade *w = m_grenades[0];
        m_grenades.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_sparks.valid(0) )
    {
        Spark *w = m_sparks[0];
        m_sparks.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_missileSmoke.valid(0) )
    {
        MissileSmoke *w = m_missileSmoke[0];
        m_missileSmoke.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_grenadeSmoke.valid(0) )
    {
        GrenadeSmoke *w = m_grenadeSmoke[0];
        m_grenadeSmoke.remove ( 0 );
        delete w;
        w = NULL;
    }
    while ( m_shrapnel.valid(0) )
    {
        Shrapnel *w = m_shrapnel[0];
        m_shrapnel.remove ( 0 );
        delete w;
        w = NULL;
    }
    delete m_sidebar; m_sidebar = NULL;
    delete m_chatOverlay; m_chatOverlay = NULL;
}

void Interface::GrenadeSmokeTrail ( int _cX, int _cY, int _color )
{
    GrenadeSmoke *smoke = new GrenadeSmoke ( _cX, _cY, _color );
    m_grenadeSmoke.insert ( smoke );
}

void Interface::MissileSmokeTrail ( int _cX, int _cY, int _color )
{
    MissileSmoke *smoke = new MissileSmoke ( _cX, _cY, _color );
    m_missileSmoke.insert ( smoke );
}

void Interface::FireLaser ( Player *_who, int _lX, int _lY, int _cX, int _cY )
{
    if ( _who == g_game->m_me &&
        g_game->m_laserCharge < 12 ) return;
    if ( _who == g_game->m_me  )
    {
        if ( g_game->m_me->m_cheat == 0 || g_game->m_me->m_cheat == 5 )
            g_game->SubtractLaserCharge ( 12 );
#ifdef ENABLE_NETWORKING
        g_game->m_connection->SendLaserFired ( _lX, _lY, _cX, _cY );
#endif
    }
    Laser *newLaser = new Laser ( _who, _lX, _lY, _cX, _cY );
    m_lasers.insert ( newLaser );
}

void Interface::FireBounce ( Player *_who, int _lX, int _lY, int _cX, int _cY )
{
    if ( _who == g_game->m_me &&
        ( g_game->m_laserCharge < 12 || g_game->m_bounceAmmo == 0 ) ) return;
    if ( _who == g_game->m_me ) {
        if ( g_game->m_me->m_cheat == 0 || g_game->m_me->m_cheat == 5 )
        {
            g_game->SubtractLaserCharge ( 12 );
            g_game->m_bounceAmmo--;
        }
#ifdef ENABLE_NETWORKING
        g_game->m_connection->SendBouncyFired ( _lX, _lY, _cX, _cY );
#endif
    }
    Bounce *newBounce = new Bounce ( _who, _lX, _lY, _cX, _cY );
    m_bouncies.insert ( newBounce );
}

void Interface::ReBounce ( Player *_who, int _cX, int _cY, double _angle, Bounce *_re )
{
    Bounce *newBounce = new Bounce ( _who, _cX, _cY, _angle, _re );
    m_bouncies.insert ( newBounce );
}

void Interface::FireMissile ( Player *_who, int _lX, int _lY, int _cX, int _cY )
{
    if ( _who == g_game->m_me &&
        ( g_game->m_laserCharge < 40 || g_game->m_missileAmmo == 0 ) ) return;
    if ( _who == g_game->m_me ){
        if ( g_game->m_me->m_cheat == 0 || g_game->m_me->m_cheat == 5 )
        {
            g_game->SubtractLaserCharge ( 40 );
            g_game->m_missileAmmo--;
        }
#ifdef ENABLE_NETWORKING
        g_game->m_connection->SendMissileFired ( _lX, _lY, _cX, _cY );
#endif
    }
    Missile *newMissile = new Missile ( _who, _lX, _lY, _cX, _cY );
    m_missiles.insert ( newMissile );
}

void Interface::FireGrenade ( Player *_who, int _lX, int _lY, int _cX, int _cY )
{
    if ( _who == g_game->m_me &&
        ( g_game->m_laserCharge < 24 || g_game->m_grenadeAmmo == 0 ) ) return;
    if ( _who == g_game->m_me ) {
        if ( g_game->m_me->m_cheat == 0 || g_game->m_me->m_cheat == 5 )
        {
            g_game->SubtractLaserCharge ( 24 );
            g_game->m_grenadeAmmo--;
        }
#ifdef ENABLE_NETWORKING
        g_game->m_connection->SendGrenadeFired ( _lX, _lY, _cX, _cY );
#endif
    }
    Grenade *newGrenade = new Grenade ( _who, _lX, _lY, _cX, _cY );
    m_grenades.insert ( newGrenade );
}

void Interface::FirePrimaryWeapon ( int _mouseX, int _mouseY )
{
    if ( !g_game->Playing() || !g_game->m_me->Visible() || g_game->m_me->GetMode() == 1 )
        return;
    Player *me = g_game->m_me;
    FireLaser ( me, m_mouseX - me->GetMoveX (), m_mouseY - me->GetMoveY(), (int)me->GetX(), (int)me->GetY() );
}

void Interface::FireSecondaryWeapon ( int _mouseX, int _mouseY )
{
    if ( !g_game->Playing() || !g_game->m_me->Visible() || g_game->m_me->GetMode() == 1 )
        return;
    Player *me = g_game->m_me; 
    switch ( g_game->GetSelectedWeapon() )
    {
    case WEAPON_TYPE_BOUNCE:
        FireBounce ( me, m_mouseX - me->GetMoveX (), m_mouseY - me->GetMoveY(), (int)me->GetX(), (int)me->GetY() );
        break;
    case WEAPON_TYPE_MISSILE:
        FireMissile ( me, m_mouseX - me->GetMoveX (), m_mouseY - me->GetMoveY(), (int)me->GetX(), (int)me->GetY() );
        break;
    case WEAPON_TYPE_GRENADE:
        FireGrenade ( me, m_mouseX - me->GetMoveX (), m_mouseY - me->GetMoveY(), (int)me->GetX(), (int)me->GetY() );
        break;
    default:
        ARCAbort ( "Invalid secondary weapon selected." );
        break;
    }
}

void Interface::ProcessMouseEvents ()
{
    int x, y;
    Uint8 buttonState = SDL_GetMouseState ( &x, &y );

    if ( buttonState & SDL_BUTTON(1) )
    {
        if ( !g_interface->MouseDown ( true, x, y ) && !(m_mouseButton & SDL_BUTTON(1)) )
        {
            FirePrimaryWeapon ( x, y );
        }
    } else {
        if ( m_mouseButton & SDL_BUTTON(1) )
            g_interface->MouseDown ( false, x, y );
    }
    if ( buttonState & SDL_BUTTON(3) )
    {
        if ( !(m_mouseButton & SDL_BUTTON(3)) )
        {
            FireSecondaryWeapon ( x, y );
        }
    }

    m_mouseButton = buttonState;

    m_mouseX = x;
    m_mouseY = y;

    if ( m_mouseX < 0 ) m_mouseX = 0;
    if ( m_mouseY < 0 ) m_mouseY = 0;

    if ( m_mouseX + 17 > (Sint32)g_graphics->GetScreenWidth () )
        m_mouseX = (Sint32)g_graphics->GetScreenWidth () - 17;

    if ( m_mouseX + 32 > (Sint32)g_graphics->GetScreenWidth () )
        m_mouseWidth = (Sint32)g_graphics->GetScreenWidth () - m_mouseX;
    else
        m_mouseWidth = 32;

    if ( m_mouseY + 17 > (Sint32)g_graphics->GetScreenHeight () )
        m_mouseY = (Sint32)g_graphics->GetScreenHeight () - 17;
}

void Interface::SetDragWindow ( Window *_window )
{
    m_dragWindow = _window;
}

int Interface::LoadAnims()
{
    unsigned char buffer[16896]; unsigned char c;
    char temp[255]; int i = 0; unsigned char b; int j = 0;
    int pos = 0;
    sprintf ( temp, "%s%s", g_app->GetResourcePath(), "data/anims.dat" );
    g_console->WriteLine ( "Loading anims.dat from %s", temp );
    BinaryReader *reader = g_app->m_resource->GetBinaryReader ( "data/anims.dat" );
    ARCReleaseAssert ( reader );
    ARCReleaseAssert ( reader->GetSize() <= sizeof(buffer) );
    reader->ReadBytes ( reader->GetSize(), buffer );
    delete reader; reader = NULL;
    if ( buffer[22] != 143 )
        ARCAbort ( "anims.dat file is missing or corrupt!" );
    memset ( &m_frameCount[i], 0, 255 );
    for ( i = 0; i < 256; i++ )
    {
        pos = i * 66;
        b = buffer[pos]; pos++;
        c = buffer[pos]; pos++;
        if ( b > 0 )
        {
            m_frameCount[i] = b;
            m_animSpeed[i] = c;
        }
        for ( j = 0; j < b; j++ )
        {
            memcpy ( &m_animFrames[i][j], &buffer[pos], sizeof(short) );
            m_animFrames[i][j] = SDL_SwapLE16(m_animFrames[i][j]);
            pos += 2;
        }
    }
    return 0;
}

void Interface::RenderMap()
{
    g_game->GetMap ()->Render ( (short)g_game->m_me->GetX(),
                                (short)g_game->m_me->GetY() );
}

void Interface::RenderMapTransfer ( short _mapTransferPercentage )
{
    SDL_Rect srcRect, dstRect;
    int pval = (g_graphics->GetScreenWidth() - 88) / 12,
        c = 0;
    srcRect.y = 0;
    srcRect.w = 11;
    srcRect.h = 10;
    dstRect.y = g_graphics->GetCenterY() + 200;
    for ( int i = 1; i <= pval; i++ )
    {
        int perc = (int)((double)i / (double)pval * 100.0 );
        if ( perc <= _mapTransferPercentage )
        {
            c = 5;
        } else {
            c = 4;
        }
        srcRect.x = 531 + c * 12;
        dstRect.x = 32 + i * 12;
        g_graphics->Blit ( m_sidebarID, &srcRect, g_graphics->GetScreen(), &dstRect );
    }
}

bool Interface::InsideWidget ( int _mouseX, int _mouseY )
{
    for ( int i = m_widgetList.size() - 1; i >= 0; i-- )
    {
        if ( m_widgetList[i]->IsInsideWidget ( _mouseX, _mouseY ) )
            return true;
    }
    return false;
}

void Interface::RenderMouse()
{
    SDL_Rect cursorFrom;
    bool isCharged = false;
    double laserCharge; int specialAmmo = 0, weaponIndex = 0;

    // Stage 1: Set up the appropriate mouse pointer type.
    if ( InsideWidget ( m_mouseX, m_mouseY ) || !g_game->Playing() )
        m_mousePointer = MOUSE_POINTER_ARROW_LEFT;
    else
    {
        laserCharge = g_game->m_laserCharge;
        switch ( g_game->GetSelectedWeapon () )
        {
        case WEAPON_TYPE_LASER:
            m_mousePointer = MOUSE_POINTER_CLASSIC;
            break;
        case WEAPON_TYPE_MISSILE:
            m_mousePointer = MOUSE_POINTER_MISSILE;
            weaponIndex = 1;
            specialAmmo = g_game->m_missileAmmo;
            if ( laserCharge >= 40 && specialAmmo )
                isCharged = true;
            break;
        case WEAPON_TYPE_GRENADE:
            m_mousePointer = MOUSE_POINTER_GRENADE;
            weaponIndex = 2;
            specialAmmo = g_game->m_grenadeAmmo;
            if ( laserCharge >= 24 && specialAmmo )
                isCharged = true;
            break;
        case WEAPON_TYPE_BOUNCE:
            m_mousePointer = MOUSE_POINTER_BOUNCE;
            weaponIndex = 3;
            specialAmmo = g_game->m_bounceAmmo;
            if ( laserCharge >= 12 && specialAmmo )
                isCharged = true;
            break;
        default:
            ARCAbort ( "Invalid weapon type selected." );
            break;
        }
    }

    // Stage 2: Check mouse pointer type.
    if ( m_mousePointer > MOUSE_POINTER_BOUNCE )
    {
        m_tmrMouseFrame.Stop();
        if ( m_tmrMouseFrame.Elapsed() > 0.15 )
        {
            m_mouseFrame--;
            if ( m_mouseFrame < 1 )
                m_mouseFrame = 3;
            m_tmrMouseFrame.Start();
        }
    } else {
        specialAmmo = 96 - (specialAmmo * 32);
        cursorFrom.x = ( weaponIndex - 1 ) * 64 + 32 -
            ( 32 * ( isCharged ? 0 : 1 ) ) + 147;
        cursorFrom.y = specialAmmo + 279;
        cursorFrom.w = 32; cursorFrom.h = 32;
    }

    // Stage 3: Render
    SDL_Rect Rch, Rto;
    if ( m_mousePointer > MOUSE_POINTER_BOUNCE )
    {
        Rch.x = ((int)m_mousePointer + 2) * 32 + 147;
        Rch.w = m_mouseWidth;
        Rch.y = 32 * m_mouseFrame + 279;
        Rch.h = m_mouseHeight;
        Rto.x = m_mouseX;
        Rto.y = m_mouseY;
        g_graphics->Blit ( GetSidebarSurfaceID(), &Rch, g_graphics->GetScreen(), &Rto );
        return;
    } else {
        Rto.x = m_mouseX;
        Rto.y = m_mouseY;
        Rto.w = cursorFrom.w;
        Rto.h = cursorFrom.h;
        g_graphics->Blit ( GetSidebarSurfaceID(), &cursorFrom, g_graphics->GetScreen(), &Rto );
    }
}

void Interface::AddWidget ( Widget *_widget )
{
    m_widgetList.insert ( _widget );
}

Widget *Interface::GetWidgetOfType ( const char *_widgetType )
{
    for ( int i = m_widgetList.size() - 1; i >= 0; i-- )
    {
        if ( stricmp ( m_widgetList[i]->GetWidgetClass(), _widgetType ) == 0 )
        {
            return m_widgetList[i];
        }
    }
    return NULL;
}

void Interface::RemoveWidget ( Widget *_widget )
{
    // TODO: Clean this up... It seems to essentially do two find() calls
    // because of the find() and remove().

    int id = m_widgetList.find ( _widget );
    if ( id == -1 )
    {
        g_console->SetColour ( IO::Console::FG_YELLOW | IO::Console::FG_INTENSITY );
        g_console->WriteLine ( "WARNING: Tried to remove '%08x' from list but it wasn't found!", (void *)_widget );
        g_console->SetColour ();
    }
    else
        m_widgetList.remove ( id );

    delete _widget;
}

int Interface::SendEnterKey ()
{
    for ( int i = m_widgetList.size() - 1; i >= 0; i-- )
    {
        Widget *widget = m_widgetList[i];
        if ( widget->HasEnterKeyDefault() )
            return widget->SendEnterKey ();
    }
    return 0;
}

int Interface::MouseDown ( bool _mouseDown, Sint32 x, Sint32 y )
{
    if ( m_dragWindow && _mouseDown)
    {
        return m_dragWindow->MouseDown ( _mouseDown, x, y );
    } else {
        for ( int i = m_widgetList.size() - 1; i >= 0; i-- )
        {
            Widget *widget = m_widgetList[i];
            if ( x < widget->m_position.x || y < widget->m_position.y )
                continue;
            if ( x > ( widget->m_position.x + widget->m_position.w ) ||
                y > ( widget->m_position.y + widget->m_position.h ) )
                continue;
            return widget->MouseDown ( _mouseDown, x, y );
        }
        return 0;
    }
}

void Interface::UpdateRendererWidget ()
{
    char speedCaption[128];

    sprintf ( speedCaption, "\1Renderer: %s", g_graphics->RendererName() );

    if ( !m_rendererWidget )
    {
        m_rendererWidget = new TextUI ( speedCaption, false, 3, g_graphics->GetScreenHeight () - 29, 250, 10 );
        m_widgetList.insert ( m_rendererWidget );
    }
    m_rendererWidget->SetText ( speedCaption );
}

void Interface::UpdateFPS ( unsigned int _fps )
{
    char fpsCaption[32]; char c = 2;

    if ( _fps >= 50 )
        c = 1; // GREEN
    else if ( _fps < 50 && _fps >= 30 )
        c = 4; // YELLOW
    else if ( _fps < 30 )
        c = 2; // RED

    sprintf ( fpsCaption, "\1FPS: %c%d", c, _fps );
    if ( !m_fpsWidget )
    {
        m_fpsWidget = new TextUI ( fpsCaption, false, 3, g_graphics->GetScreenHeight () - 40, 50, 10 );
        m_widgetList.insert ( m_fpsWidget );
    }
    m_fpsWidget->SetText ( fpsCaption );
}

void Interface::ExplodeShrapnel ( Player *_who, int _X, int _Y,
                                  double _speed, int _shrapTick,
                                  int _explStart, int _explPower)
{
    Shrapnel *shrapnel = new Shrapnel ( _who, _X, _Y, _speed, _shrapTick, _explStart, _explPower );
    m_shrapnel.insert ( shrapnel );
}

void Interface::ExplodeSpark ( int _cX, int _cY )
{
    Spark *spark = new Spark ( _cX, _cY );
    m_sparks.insert ( spark );
}

void Interface::ExplodeGrenade ( int _cX, int _cY )
{
    GrenadeExplosion *expl = new GrenadeExplosion ( _cX, _cY );
    m_grenadeExplosions.insert ( expl );
}

void Interface::AddShip ( Ship *_ship )
{
    m_ships.insert ( _ship );
}

void Interface::AddLaserZap ( LaserZap *_zap )
{
    m_laserZaps.insert ( _zap );
}

void Interface::AddShipExplosion ( ShipExplosion *_explosion )
{
    m_shipExplosions.insert ( _explosion );
}

void Interface::RenderLasers ()
{
    for ( size_t i = 0; i < m_lasers.size(); i++ )
    {
        if ( !m_lasers.valid ( i ) ) continue;
        Laser *laser = m_lasers[i];
        laser->Update();
        laser->Render();
        if ( laser->Expired() )
        {
            m_lasers.remove ( i );
            delete laser;
            i--;
            continue;
        }
    }
}

void Interface::RenderLaserZaps ()
{
    for ( size_t i = 0; i < m_laserZaps.size(); i++ )
    {
        if ( !m_laserZaps.valid ( i ) ) continue;
        LaserZap *zap = m_laserZaps[i];
        zap->Update();
        if ( zap->Expired() )
        {
            m_laserZaps.remove ( i );
            delete zap;
            i--;
            continue;
        }
        zap->Render();
    }
}

void Interface::RenderSparks ()
{
    for ( size_t i = 0; i < m_sparks.size(); i++ )
    {
        if ( !m_sparks.valid ( i ) ) continue;
        Spark *spark = m_sparks[i];
        spark->Update();
        spark->Render();
        if ( spark->Expired() )
        {
            m_sparks.remove ( i );
            delete spark;
            i--;
            continue;
        }
    }
}

void Interface::RenderBouncies ()
{
    for ( size_t i = 0; i < m_bouncies.size(); i++ )
    {
        if ( !m_bouncies.valid ( i ) ) continue;
        Bounce *bounce = m_bouncies[i];
        bounce->Update();
        bounce->Render();
        if ( bounce->Expired() )
        {
            m_bouncies.remove ( i );
            delete bounce;
            i--;
            continue;
        }
    }
}

void Interface::RenderMissiles ()
{
    for ( size_t i = 0; i < m_missiles.size(); i++ )
    {
        if ( !m_missiles.valid ( i ) ) continue;
        Missile *missile = m_missiles[i];
        missile->Update();
        missile->Render();
        if ( missile->Expired() )
        {
            m_missiles.remove ( i );
            delete missile;
            i--;
            continue;
        }
    }
}

void Interface::RenderShrapnel ()
{
    for ( size_t i = 0; i < m_shrapnel.size(); i++ )
    {
        if ( !m_shrapnel.valid ( i ) ) continue;
        Shrapnel *shrapnel = m_shrapnel[i];
        shrapnel->Update();
        shrapnel->Render();
        if ( shrapnel->Expired() )
        {
            m_shrapnel.remove ( i );
            delete shrapnel;
            i--;
            continue;
        }
    }
}

void Interface::RenderShipExplosions ()
{
    for ( size_t i = 0; i < m_shipExplosions.size(); i++ )
    {
        if ( !m_shipExplosions.valid ( i ) ) continue;
        ShipExplosion *expl = m_shipExplosions[i];
        expl->Update();
        if ( expl->Expired() )
        {
            m_shipExplosions.remove ( i );
            delete expl;
            i--;
            continue;
        }
        expl->Render();
    }
}

void Interface::RenderMissileSmoke ()
{
    for ( size_t i = 0; i < m_missileSmoke.size(); i++ )
    {
        if ( !m_missileSmoke.valid ( i ) ) continue;
        MissileSmoke *smoke = m_missileSmoke[i];
        smoke->Render();
        if ( smoke->Expired() )
        {
            m_missileSmoke.remove ( i );
            delete smoke;
            i--;
            continue;
        }
    }
}

void Interface::RenderGrenadeSmoke ()
{
    for ( size_t i = 0; i < m_grenadeSmoke.size(); i++ )
    {
        if ( !m_grenadeSmoke.valid ( i ) ) continue;
        GrenadeSmoke *smoke = m_grenadeSmoke[i];
        smoke->Render();
        if ( smoke->Expired() )
        {
            m_grenadeSmoke.remove ( i );
            delete smoke;
            i--;
            continue;
        }
    }
}

void Interface::RenderGrenadeExplosions ()
{
    for ( size_t i = 0; i < m_grenadeExplosions.size(); i++ )
    {
        if ( !m_grenadeExplosions.valid ( i ) ) continue;
        GrenadeExplosion *explode = m_grenadeExplosions[i];
        explode->Render();
        if ( explode->Expired() )
        {
            m_grenadeExplosions.remove ( i );
            delete explode;
            i--;
            continue;
        }
    }
}

void Interface::RenderGrenades ()
{
    for ( size_t i = 0; i < m_grenades.size(); i++ )
    {
        if ( !m_grenades.valid ( i ) ) continue;
        Grenade *grenade = m_grenades[i];
        grenade->Update();
        grenade->Render();
        if ( grenade->Expired() )
        {
            m_grenades.remove ( i );
            delete grenade;
            i--;
            continue;
        }
    }
}

void Interface::AddChat ( const char *_chatText )
{
    m_chatOverlay->AddLine ( _chatText );
}

void Interface::RenderGameUI()
{
    m_sidebar->Render();
    m_chatOverlay->Update();
    m_chatOverlay->Render();
}

void Interface::RenderWidgets()
{
    for ( size_t i = 0; i < m_widgetList.size(); i++ )
    {
        Widget *widget = m_widgetList[i];
        if ( widget->GetDestroyFlag() )
        {
            m_widgetList.remove ( i );
            delete widget;
            i--;
            continue;
        }
        widget->Update();
        widget->Render();
    }
}

void Interface::SetupText()
{
    Uint32 rmask, gmask, bmask, amask;
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
    rmask = 0xff000000;
    gmask = 0x00ff0000;
    bmask = 0x0000ff00;
    amask = 0x000000ff;
#else
    rmask = 0x000000ff;
    gmask = 0x0000ff00;
    bmask = 0x00ff0000;
    amask = 0xff000000;
#endif
    SDL_Rect rtmp;
    Uint32 CKey1 = 0; Uint32 thekey = 0; Uint32 i = 0;
    Uint32 CStep = 0; Uint32 Hdr = 0; Uint32 thecolor = 0;
    SDL_PixelFormat *px = g_graphics->GetPixelFormat ( m_rawTextID );
    if ( (int)m_textID == -1 )
    {
        memset ( m_rChars, 0, sizeof(m_rChars) );
        CKey1 = g_graphics->GetPixel ( m_rawTextID, 0, 0 );
        for ( i = 1; i < 585; i++ )
        {
            thekey = g_graphics->GetPixel ( m_rawTextID, i, 7 );
            if ( thekey == CKey1 )
            {
                m_rChars[CStep].x = (Uint16)(Hdr + 1);
                m_rChars[CStep].w = (Uint16)(i - Hdr);
                if ( CStep == 93 )
                {
                    m_rChars[CStep].w--;
                }
                else if ( CStep == 94 )
                {
                    m_rChars[CStep].x--;
                }
                m_rChars[CStep].y = 0;
                m_rChars[CStep].h = 10;
                CStep++;
                Hdr = i;
                if ( CStep > 95 )
                    break;
            }
        }
        CStep = 0;
        Hdr = 0;
        for ( i = 1; i < 366; i++ )
        {
            thekey = g_graphics->GetPixel ( m_rawTextID, i, 0 );
            if ( thekey == CKey1 )
            {
                m_rChars2[CStep].x = (Sint16)(Hdr + 1);
                m_rChars2[CStep].w = (Uint16)(i - Hdr);
                m_rChars2[CStep].y = (Sint16)(0);
                m_rChars2[CStep].h = (Uint16)(5);
                CStep++;
                if ( CStep > 95 )
                    break;
                Hdr = i;
            }
        }
    }
    m_rChars[0].y = 8; m_rChars[0].h = 10; m_rChars[0].x = 0; m_rChars[0].w = 584;
    for ( i = 1; i < 12; i++ )
    {
        if (i == 1) thecolor = SDL_MapRGB(px, 82, 227, 82);
        if (i == 2) thecolor = SDL_MapRGB(px, 231, 81, 82);
        if (i == 3) thecolor = SDL_MapRGB(px, 82, 81, 231);
        if (i == 4) thecolor = SDL_MapRGB(px, 214, 219, 41);
        if (i == 5) thecolor = SDL_MapRGB(px, 231, 227, 231);
        if (i == 6) thecolor = SDL_MapRGB(px, 255, 251, 255);
        if (i == 7) thecolor = SDL_MapRGB(px, 140, 138, 140);
        if (i == 8) thecolor = SDL_MapRGB(px, 148, 146, 255);
        if (i == 9) thecolor = SDL_MapRGB(px, 222, 170, 0);
        if (i == 10) thecolor = SDL_MapRGB(px, 198, 105, 0);
        if (i == 11) thecolor = SDL_MapRGB(px, 189, 186, 189);
        if ( (int)m_textID == -1 )
        {
            m_textID = g_graphics->CreateSurface ( 584, 125, false );
            ARCReleaseAssert ( (int)m_textID != -1 );
            rtmp.x = 0; rtmp.y = 0; rtmp.w = 584; rtmp.h = 125;
            g_graphics->FillRect ( m_textID, &rtmp, SDL_MapRGB(g_graphics->GetPixelFormat ( m_tunaID ),128,128,128) );
        }
        rtmp.x = 0; rtmp.y = 10 * i; rtmp.h = 10 * (i + 1) - rtmp.y; rtmp.w = 584;
        g_graphics->Blit ( m_rawTextID, &m_rChars[0], m_textID, &rtmp );
        g_graphics->ReplaceColour ( m_textID, &rtmp, SDL_MapRGB(g_graphics->GetPixelFormat ( m_tunaID ), 0, 0, 0), thecolor );
    }
	rtmp.x = rtmp.y = 0;
	rtmp.w = g_graphics->GetSurfaceWidth(m_textID);
	rtmp.h = g_graphics->GetSurfaceHeight(m_textID);
    g_graphics->ReplaceColour ( m_textID, &rtmp, SDL_MapRGB(px,128,128,128), g_graphics->GetColorKey() );

    m_rChars2[0].y = 1; m_rChars2[0].h = 6; m_rChars2[0].x = 0; m_rChars2[0].w = 365;
    for ( i = 0; i < 11; i++ )
    {
        if (i == 0) thecolor = SDL_MapRGB(px, 222, 105, 0);
        if (i == 1) thecolor = SDL_MapRGB(px, 255, 180, 0);
        if (i == 2) thecolor = SDL_MapRGB(px, 0, 170, 0);
        if (i == 3) thecolor = SDL_MapRGB(px, 214, 0, 0);
        if (i == 4) thecolor = SDL_MapRGB(px, 82, 81, 231);
        if (i == 5) thecolor = SDL_MapRGB(px, 206, 203, 0);
        if (i == 6) thecolor = SDL_MapRGB(px, 255, 255, 255);
        if (i == 7) thecolor = SDL_MapRGB(px, 0, 81, 0);
        if (i == 8) thecolor = SDL_MapRGB(px, 99, 0, 0);
        if (i == 9) thecolor = SDL_MapRGB(px, 0, 0, 140);
        if (i == 10) thecolor = SDL_MapRGB(px, 99, 97, 0);
        if ( (int)m_smallTextID == -1 )
        {
            m_smallTextID = g_graphics->CreateSurface ( 359, 67, false );
            ARCReleaseAssert ( (int)m_smallTextID != -1 );
            g_graphics->FillRect ( m_smallTextID, NULL, SDL_MapRGB(g_graphics->GetPixelFormat ( m_tunaID ),128,128,128) );
        }
        rtmp.x = 0; rtmp.y = 6 * i; rtmp.h = 6; rtmp.w = 359;
        g_graphics->Blit ( m_rawTextID, &m_rChars2[0], m_smallTextID, &rtmp );
        g_graphics->ReplaceColour ( m_smallTextID, &rtmp, SDL_MapRGB(g_graphics->GetPixelFormat ( m_tunaID ), 0, 0, 0), thecolor );
    }
	rtmp.x = rtmp.y = 0;
	rtmp.w = g_graphics->GetSurfaceWidth(m_smallTextID);
	rtmp.h = g_graphics->GetSurfaceHeight(m_smallTextID);
    g_graphics->ReplaceColour ( m_smallTextID, &rtmp, SDL_MapRGB(px,128,128,128), g_graphics->GetColorKey() );

    m_rChars[0].x = 1;
    m_rChars[0].w = 5;
    m_rChars2[0].x = 1;
    m_rChars2[0].w = 1;
}

int Interface::GetAnimSpeed ( int _index )
{
    return (int)m_animSpeed[_index];
}

void Interface::SetAnimSpeed ( int _index, char _value )
{
    m_animSpeed[_index] = _value;
}

int Interface::GetFrameCount ( int _index )
{
    return (int)m_frameCount[_index];
}

short Interface::GetAnimFrames ( int _index0, int _index1 )
{
    return m_animFrames[_index0][_index1];
}

short Interface::GetAnimFS ( int _index0, int _index1 )
{
    return m_animFS[_index0][_index1];
}

short Interface::GetAnimFX ( int _index0, int _index1 )
{
    return m_animFX[_index0][_index1];
}

short Interface::GetAnimFY ( int _index0, int _index1 )
{
    return m_animFY[_index0][_index1];
}

Uint32 Interface::GetAnimSurfaceID ( int _index )
{
    return m_animsID[_index];
}

Uint32 Interface::GetSidebarSurfaceID()
{
    return m_sidebarID;
}

Uint32 Interface::GetTextSurfaceID()
{
    return m_textID;
}

Uint32 Interface::GetSmallTextSurfaceID()
{
    return m_smallTextID;
}

Uint32 Interface::GetTileSurfaceID()
{
    return m_tilesID;
}

Uint32 Interface::GetShipsSurfaceID()
{
    return m_shipsID;
}

Uint32 Interface::GetTuna1SurfaceID()
{
    return m_tuna1ID;
}

void Interface::RenderFarplane ( short _meX, short _meY )
{
    if ( !m_farplane ) return;
    short ScreenH = g_graphics->GetScreenHeight(),
          ScreenW = g_graphics->GetScreenWidth(),
          Xpos, Ypos, Width, Height;
    if ( ScreenW > 1280 ) ScreenW = 1280;
    if ( ScreenH > 960 ) ScreenH = 960;
    Xpos = (short)(0.1568 * (double)_meX);
    Ypos = (short)(0.1176 * (double)_meY);
    Width = ScreenW;
    Height = ScreenH;
    if ( Xpos + Width > 1280 ) {
        Width = 1280;
        Xpos = 1280 - ScreenW;
    }
    if ( Ypos + Height > 960 ) {
        Height = 960;
        Ypos = 960 - ScreenH;
    }
    if ( Xpos < 0 ) {
        Xpos = 0;
    }
    if ( Ypos < 0 ) {
        Ypos = 0;
    }
    SDL_Rect SrcRect, DstRect;
    DstRect.x = 0; DstRect.y = 0;
    SrcRect.x = Xpos; SrcRect.y = Ypos; SrcRect.w = Width; SrcRect.h = Height;
	m_farplane->Render ( &SrcRect, g_graphics->GetScreen(), &DstRect );
}

void Interface::InitWidgets ()
{
    for ( size_t i = 0; i < m_widgetList.size(); i++ )
    {
		m_widgetList[i]->Initialise();
    }
}

int Interface::InitSurfaces ()
{
    SDL_Rect SrcRect, DstRect;
    short B = 0; short J = 0; int C = 0; int i = 0; 
    int xt = 0; int yt = 0; short X = 0; short a = 0;
    Uint32 tmp = -1;
    g_console->WriteLine ( "Initializing surfaces..." );

    //load farplane (no colour keys or anything)
    tmp = g_graphics->LoadImage ( "graphics/Farplane.png" );
	delete m_farplane;
	m_farplane = new Surface ( g_graphics->GetSurfaceWidth(tmp),
		g_graphics->GetSurfaceHeight(tmp),
		g_prefsManager->GetInt ( "SurfaceSplitFactor", 32 ) );
    ARCReleaseAssert ( m_farplane != NULL );
	m_farplane->Blit ( tmp, NULL, NULL );
	g_graphics->DeleteSurface ( tmp );
	tmp = 0;

    //load tuna
	g_graphics->DeleteSurface ( m_tunaID );
    m_tunaID = g_graphics->LoadImage ( "graphics/tuna.png" );
    ARCReleaseAssert ( (int)m_tunaID != -1 );
    g_graphics->SetColorKey ( g_graphics->GetPixel ( m_tunaID, 0, 0 ) );
	g_graphics->ApplyColorKey ( m_tunaID );

    //load the text block
	g_graphics->DeleteSurface ( m_rawTextID );
    m_rawTextID = g_graphics->CreateSurface ( 584, 20, false );
    ARCReleaseAssert ( (int)m_rawTextID != -1 );
    SrcRect.x = 0; SrcRect.y = 1201; SrcRect.h = 20; SrcRect.w = 584;
    DstRect.y = 0; DstRect.x = 0;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_rawTextID, &DstRect );

    //find each letter, etc, etc.
    SetupText();

    //load tiles
	g_graphics->DeleteSurface ( m_tilesID );
    m_tilesID = g_graphics->LoadImage ( "graphics/Tiles.png", true );
    ARCReleaseAssert ( (int)m_tilesID != -1 );
    
    //create the ships
    SrcRect.x = 0; SrcRect.y = 292; SrcRect.w = 288; 
    SrcRect.h = 128; DstRect.x = 0; DstRect.y = 0;

	g_graphics->DeleteSurface ( m_shipsID );
    m_shipsID = g_graphics->CreateSurface ( 290, 165, false );
    ARCReleaseAssert ( (int)m_shipsID != -1 );
    g_graphics->Blit ( m_tunaID, &SrcRect, m_shipsID, &DstRect );

    //create the nav bar
    SrcRect.x = 493; SrcRect.y = 260; SrcRect.w = 147; 
    SrcRect.h = 480; DstRect.x = 0; DstRect.y = 0;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    m_sidebarID = g_graphics->CreateSurface ( 640, 480, true );
    ARCReleaseAssert ( (int)m_sidebarID != -1 );
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //selected
    SrcRect.x = 536; SrcRect.y = 741; SrcRect.w = 104; 
    SrcRect.h = 184; DstRect.x = 147; DstRect.y = 0;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //scores
    SrcRect.x = 120; SrcRect.y = 1189; SrcRect.w = 280; 
    SrcRect.h = 12; DstRect.x = 251; DstRect.y = 0;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //options
    SrcRect.x = 63; SrcRect.y = 136; SrcRect.w = 71; 
    SrcRect.h = 10; DstRect.x = 531; DstRect.y = 0;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //nav door
    SrcRect.x = 360; SrcRect.y = 260; SrcRect.w = 100; 
    SrcRect.h = 94; DstRect.x = 147; DstRect.y = 184;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    SrcRect.x = 360; SrcRect.y = SrcRect.h + SrcRect.y + 2; SrcRect.w = 100; 
    SrcRect.h = 94; DstRect.x = 247; DstRect.y = 184;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    SrcRect.x = 360; SrcRect.y = SrcRect.h + SrcRect.y + 2; SrcRect.w = 100; 
    SrcRect.h = 94; DstRect.x = 357; DstRect.y = 184;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    SrcRect.x = 360; SrcRect.y = SrcRect.h + SrcRect.y + 2; SrcRect.w = 100; 
    SrcRect.h = 94; DstRect.x = 467; DstRect.y = 184;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //select box
    SrcRect.x = 0; SrcRect.y = 170; SrcRect.w = 48; 
    SrcRect.h = 48; DstRect.x = 251; DstRect.y = 12;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //ship buttons
    SrcRect.x = 64; SrcRect.y = 89; SrcRect.w = 240;
    SrcRect.h = 45; DstRect.x = 300; DstRect.y = 12;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //menu
    SrcRect.x = 429; SrcRect.y = 1006; SrcRect.w = 101;
    SrcRect.h = 94; DstRect.x = 251; DstRect.y = 60;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //time window
    SrcRect.x = 573; SrcRect.y = 1149; SrcRect.w = 67;
    SrcRect.h = 27; DstRect.x = 452; DstRect.y = 120;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //command buttons
    SrcRect.x = 0; SrcRect.y = 29; SrcRect.w = 58;
    SrcRect.h = 139; DstRect.x = 540; DstRect.y = 14;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //mouse pointers
    SrcRect.x = 64; SrcRect.y = 163; SrcRect.w = 256;
    SrcRect.h = 129; DstRect.x = 147; DstRect.y = 278;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    SrcRect.x = 0; SrcRect.y = 262; SrcRect.w = 63;
    SrcRect.h = 26; DstRect.x = 147; DstRect.y = 407;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //radar scope
    SrcRect.x = 609; SrcRect.y = 967; SrcRect.w = 25;
    SrcRect.h = 22; DstRect.x = 251; DstRect.y = 154;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //radar objects *** EXTRAS ***

	g_graphics->DeleteSurface ( m_extrasID );
    m_extrasID = g_graphics->LoadImage ( "graphics/extras.png" );
    ARCReleaseAssert ( (int)m_extrasID != -1 );
    SrcRect.x = 0; SrcRect.y = 0; SrcRect.w = 80;
    SrcRect.h = 60; DstRect.x = 452; DstRect.y = 57;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_extrasID, &SrcRect, m_sidebarID, &DstRect );

    //drop the extras surface (temporary... wasting memory anyway)
    g_graphics->DeleteSurface ( m_extrasID );
    m_extrasID = -1;

    //player list
    SrcRect.x = 360; SrcRect.y = 644; SrcRect.w = 100;
    SrcRect.h = 128; DstRect.x = 352; DstRect.y = 56;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //player list admin
    SrcRect.x = 259; SrcRect.y = 726; SrcRect.w = 100;
    SrcRect.h = 23; DstRect.x = 452; DstRect.y = 156;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_sidebarID, &DstRect );

    //Tuna - Explodes
    SrcRect.x = 0; SrcRect.y = 790; SrcRect.w = 383;
    SrcRect.h = 355; DstRect.x = 0; DstRect.y = 0;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    m_tuna1ID = g_graphics->CreateSurface ( 640, 480, true );
    ARCReleaseAssert ( (int)m_tuna1ID != -1 );
    g_graphics->Blit ( m_tunaID, &SrcRect, m_tuna1ID, &DstRect );

    //bombs, smoke, shield, shrapnel
    SrcRect.x = 0; SrcRect.y = 582; SrcRect.w = 187;
    SrcRect.h = 179; DstRect.x = 383; DstRect.y = 0;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_tuna1ID, &DstRect );
    SrcRect.x = 210; SrcRect.y = 670; SrcRect.w = 88;
    SrcRect.h = 11; DstRect.x = 485; DstRect.y = 165;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_tuna1ID, &DstRect );

    //flags
    SrcRect.x = 288; SrcRect.y = 311; SrcRect.w = 12;
    SrcRect.h = 140; DstRect.x = 570; DstRect.y = 0;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_tuna1ID, &DstRect );

    //powerups
    SrcRect.x = 0; SrcRect.y = 423; SrcRect.w = 288;
    SrcRect.h = 123; DstRect.x = 0; DstRect.y = 355;
    DstRect.w = SrcRect.w; DstRect.h = SrcRect.h;
    g_graphics->Blit ( m_tunaID, &SrcRect, m_tuna1ID, &DstRect );

    //make the health/ammo bar gimmicks
    DstRect.x = 404; DstRect.y = 387; DstRect.h = 15; DstRect.w = 60;
    tmp = SDL_MapRGB ( g_graphics->GetPixelFormat(m_sidebarID), 255, 0, 0 );
    g_graphics->FillRect ( m_sidebarID, &DstRect, tmp );

    DstRect.x = 510; DstRect.y = 387; DstRect.h = 15; DstRect.w = 60;
    tmp = SDL_MapRGB ( g_graphics->GetPixelFormat(m_sidebarID), 0, 0, 255 );
    g_graphics->FillRect ( m_sidebarID, &DstRect, tmp );

    DstRect.x = 465; DstRect.y = 374; DstRect.h = 3; DstRect.w = 4;
    tmp = SDL_MapRGB ( g_graphics->GetPixelFormat(m_sidebarID), 255, 120, 0 );
    g_graphics->FillRect ( m_sidebarID, &DstRect, tmp );

    //WepAmo[0].x = 465; WepAmo[0].w = 3; WepAmo[0].y = 374; WepAmo[0].h = 4;

    DstRect.x = 465; DstRect.y = 380; DstRect.h = 4; DstRect.w = 23;
    tmp = SDL_MapRGB ( g_graphics->GetPixelFormat(m_sidebarID), 0, 255, 0 );
    g_graphics->FillRect ( m_sidebarID, &DstRect, tmp );

    g_graphics->DeleteSurface ( m_tunaID );
    m_tunaID = -1;

	g_graphics->DeleteSurface ( m_animsID[0] );
	g_graphics->DeleteSurface ( m_animsID[1] );
    m_animsID[0] = g_graphics->CreateSurface ( 640, 480, true );
    m_animsID[1] = g_graphics->CreateSurface ( 640, 480, false );
    for ( i = 0; i < 256; i++ )
    {
        if ( (int)m_frameCount[i] > 0 )
        {
            for ( C = 0; C <= ((int)m_frameCount[i] - 1); C++ )
            {
                xt = (m_animFrames[i][C] % 40) * 16;
                yt = (m_animFrames[i][C] - (m_animFrames[i][C] % 40)) / 40 * 16;
                DstRect.w = 16; DstRect.h = 16; SrcRect.w = 16; SrcRect.h = 16;
                SrcRect.x = xt; SrcRect.y = yt;
                DstRect.x = X; DstRect.y = a;
                m_animFX[i][C] = X;
                m_animFY[i][C] = a;
                m_animFS[i][C] = (unsigned char)B;
                ARCReleaseAssert ( (int)m_animsID[B] != -1 );
                ARCReleaseAssert ( (int)m_tilesID != -1 );
                g_graphics->Blit ( GetTileSurfaceID(), &SrcRect, GetAnimSurfaceID(B), &DstRect );
                J += 16;
                X = (J % 640) & -16;
                a = (J - (J % 640)) / 640 * 16;
                if ( a > 464 )
                {
                    B = 1;
                    a -= 480;
                }
            }
        }
    }
    return 0;
}

Interface *g_interface;
