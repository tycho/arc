/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_shrapnel_h
#define __included_shrapnel_h

#include "Game/player.h"
#include "Game/weapon.h"

class Shrapnel : public Weapon
{
protected:
    Data::DArray<short>    m_angle;
    double            m_dist;
    double            m_speed;
    double            m_tick;
    System::Stopwatch        m_timer;

public:
    Shrapnel ( Player *_who, int _x, int _y, double _speed,
               int _shrapTick, int _explStart, int _explPower);
    virtual ~Shrapnel();

    virtual void Update();
    virtual void Render();
};

#endif
