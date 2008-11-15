/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "App/app.h"
#include "Sound/soundsystem.h"

NullSoundSystem::NullSoundSystem()
{
}

NullSoundSystem::~NullSoundSystem()
{
}

int NullSoundSystem::LoadWave ( const char *_soundName )
{
    return 0;
}

int NullSoundSystem::PlaySound ( const char *_soundName, short _distX, short _distY )
{
    return 0;
}

void NullSoundSystem::AddQueue ( Data::LList<std::string> *_queue )
{
    delete _queue;
}

bool NullSoundSystem::IsPlaying ( const char *_soundName )
{
    return true;
}

void NullSoundSystem::Update ()
{
}
