/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_soundsystem_openal_h
#define __included_soundsystem_openal_h

#ifdef USE_OPENAL

#ifdef TARGET_OS_WINDOWS
#    include <al.h>
#   include <alc.h>
#elif defined(TARGET_OS_MACOSX)
#    include <OpenAL/al.h>
#   include <OpenAL/alc.h>
#else
#    include <AL/al.h>
#    include <AL/alc.h>
#endif

class OpenALSoundSystem : public SoundSystem
{
protected:
    Data::LList<ALuint>                            m_usedSources;
    Data::LList<ALuint>                            m_freeSources;
    Data::RedBlackTree<const char *, ALuint>       m_buffers;
    Data::DArray<Data::LList<std::string> *>       m_queues;
    ALCcontext*                                    m_context;
    ALCdevice*                                     m_device;

    ALuint              AcquireSource ();
public:
    OpenALSoundSystem();
    virtual ~OpenALSoundSystem();

    virtual void       AddQueue    ( Data::LList<std::string> *_queue );
    virtual bool       IsPlaying   ( const char *_soundName );
    virtual int        LoadWave    ( const char *_soundName );
    virtual int        PlaySound   ( const char *_soundName, short _distX, short _distY );
    virtual void       Update      ();
};

#endif

#endif
