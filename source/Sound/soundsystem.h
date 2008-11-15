/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_soundsystem_h
#define __included_soundsystem_h

class SoundSystem
{
public:
    SoundSystem();
    virtual ~SoundSystem();

    virtual void    AddQueue    ( Data::LList<std::string> *_queue ) = 0;
    virtual bool    IsPlaying   ( const char *_soundName ) = 0;
    virtual int     LoadWave    ( const char *_soundName ) = 0;
    virtual int     PlaySound    ( const char *_soundName, short _distX, short _distY ) = 0;
    virtual void    Update        () = 0;
};

extern SoundSystem *g_soundSystem;

#include "Sound/soundsystem_null.h"
#include "Sound/soundsystem_openal.h"
#include "Sound/soundsystem_sdlmixer.h"

#endif
