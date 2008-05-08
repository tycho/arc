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
