/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_soundsystem_sdlmixer_h
#define __included_soundsystem_sdlmixer_h

#ifdef USE_SDLMIXER

class SDLMixerSoundSystem : public SoundSystem
{
protected:
    Data::RedBlackTree<std::string,Mix_Chunk *>    m_chunks;
    Data::DArray<Data::LList<std::string> *>       m_queues;
    Data::DArray<char *>                           m_channelPlaying;
    bool                                           m_queuesEmpty;

public:
    SDLMixerSoundSystem();
    virtual ~SDLMixerSoundSystem();

    virtual void       AddQueue    ( Data::LList<std::string> *_queue );
    virtual bool       IsPlaying   ( const char *_soundName );
    virtual int        LoadWave    ( const char *_soundName );
    virtual int        PlaySound   ( const char *_soundName, short _distX, short _distY );
    virtual void       Update      ();
};

#endif

#endif
