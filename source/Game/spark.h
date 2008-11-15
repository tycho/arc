/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_spark_h
#define __included_spark_h

#include "Game/player.h"
#include "Game/weapon.h"

class Spark : public Weapon
{
protected:
    System::Stopwatch        m_timer;
    Data::DArray<short>    m_angle;
    Data::DArray<double>    m_speed;
    Data::DArray<double>    m_dist;

public:
    Spark ( int _cX, int _cY );
    virtual ~Spark();

    virtual void Update();
    virtual void Render();
};

#endif
