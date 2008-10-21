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