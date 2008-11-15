/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_soundsystem_null_h
#define __included_soundsystem_null_h

class NullSoundSystem : public SoundSystem
{
public:
    NullSoundSystem();
    virtual ~NullSoundSystem();

    virtual void       AddQueue    ( Data::LList<std::string> *_queue );
    virtual bool       IsPlaying   ( const char *_soundName );
    virtual int        LoadWave    ( const char *_soundName );
    virtual int        PlaySound   ( const char *_soundName, short _distX, short _distY );
    virtual void       Update      ();
};

#endif
