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

#ifdef USE_OPENAL

#include "App/app.h"
#include "Sound/soundsystem.h"

#if defined ( TARGET_COMPILER_VC ) || defined ( TARGET_COMPILER_ICC )
#    pragma comment (lib, "openal32.lib")
#endif

#ifdef TARGET_OS_MACOSX
#include <SDL/SDL.h>
#else
#include "SDL.h"
#endif

#include <stdio.h>

namespace
{

ALCint arc_openal_attributes[] =
{
    ALC_FREQUENCY, 48000,
    ALC_SYNC, AL_FALSE,
    0
};

const int arc_openal_num_sources = 64;

// stolen from Styx
typedef struct
{
    char wriff[4];
    uint32_t wsize;
    char wwave[4];
    char wfmt[4];
    uint32_t wchunkheadersize;
} _WaveHeader;

typedef struct
{
    int16_t tag;
    int16_t nchannels;
    int32_t samplerate;
    int32_t bytespersecond;
    int16_t alignment;
    int16_t bps;
    char data[4];
    int32_t datasize;
} _WaveChunk;

ALuint ALLoadWave ( const char* filename )
{
    FILE* file = fopen(filename, "rb");
    _WaveChunk chunk;
    _WaveHeader header;
    
    uint32_t tempuint;
    uint16_t tempusht;
    
    ARCReleaseAssert ( file != NULL);
    
    int retval = fread(header.wriff, 4, 1, file);
    ARCReleaseAssert ( retval != 0 );
    fread(&tempuint, 4, 1, file);
    header.wsize = SDL_SwapLE32(tempuint);
    fread(header.wwave, 4, 1, file);
    fread(header.wfmt, 4, 1, file);
    fread(&tempuint, 4, 1, file);
    header.wchunkheadersize = SDL_SwapLE32(tempuint);
    
    if (strncmp(header.wriff, "RIFF", 4) ||
        strncmp(header.wwave, "WAVE", 4) ||
        header.wchunkheadersize != 16)
    {
        char buffer[1024];
        sprintf ( buffer, "%s seems to be an invalid sound file", filename );
        ARCAbort ( buffer );
    }
    
    fread(&tempusht, 2, 1, file);
    chunk.tag = SDL_SwapLE16(tempusht);
    fread(&tempusht, 2, 1, file);
    chunk.nchannels = SDL_SwapLE16(tempusht);
    fread(&tempuint, 4, 1, file);
    chunk.samplerate = SDL_SwapLE32(tempuint);
    fread(&tempuint, 4, 1, file);
    chunk.bytespersecond = SDL_SwapLE32(tempuint);
    fread(&tempusht, 2, 1, file);
    chunk.alignment = SDL_SwapLE16(tempusht);
    fread(&tempusht, 2, 1, file);
    chunk.bps = SDL_SwapLE16(tempusht);
    fread(chunk.data, 4, 1, file);
    fread(&tempuint, 4, 1, file);
    chunk.datasize = SDL_SwapLE32(tempuint);
    
    ARCReleaseAssert(!strncmp(chunk.data, "data", 4));
    
    uint32_t src_frame_size = (chunk.bps / 8) * chunk.nchannels;
    uint32_t total_size = chunk.datasize;
    
    unsigned char* buf = (unsigned char*)malloc(total_size);
    
    ARCReleaseAssert ( buf != NULL );
    
    if (chunk.bps == 8)
    {
        int retval = fread(buf, 1, total_size, file);
        ARCReleaseAssert ( retval == total_size );
    }
    else
    {
        uint16_t val;
        for (uint32_t i = 0; i < total_size; i += src_frame_size)
        {
            fread(&val, 2, 1, file);
            (*(uint16_t*)(buf + i)) = SDL_SwapLE16(val);
        }
    }
    
    fclose(file);
    
    ALuint buffer = 0;
    alGenBuffers ( 1, &buffer );
    
    ARCReleaseAssert ( buffer != 0 );
    
    ALenum format;
    
    if (chunk.nchannels == 1)
    {
        // mono
        if (chunk.bps == 8)
            format = AL_FORMAT_MONO8;
        else
            format = AL_FORMAT_MONO16;
    }
    else
    {
        // stereo
        if (chunk.bps == 8)
            format = AL_FORMAT_STEREO8;
        else
            format = AL_FORMAT_STEREO16;
    }
    
    alBufferData ( buffer, format, (ALvoid*)buf, total_size, chunk.samplerate );
    
    free ((void*)buf);
    
    return buffer;
}

}

ALuint OpenALSoundSystem::AcquireSource ()
{
    if (m_freeSources.size() > 0)
    {
        ALuint source = m_freeSources.get(0);
        m_freeSources.remove(0);
        m_usedSources.insert_back(source);
        return source;
    }
    else
    {
        ALuint data = m_usedSources.get(0);
        m_usedSources.remove(0);
        m_usedSources.insert_back(data);
        return data;
    }
}

OpenALSoundSystem::OpenALSoundSystem()
{
    m_device = alcOpenDevice ( NULL );
    ARCReleaseAssert ( m_device != NULL );
    m_context = alcCreateContext ( m_device, arc_openal_attributes );
    alcProcessContext ( m_context );
    alcMakeContextCurrent ( m_context );
    
    for (unsigned int i = 0; i < arc_openal_num_sources; i++)
    {
        ALuint source;
        alGenSources ( 1, &source );
        m_freeSources.insert(source);
    }

    for ( size_t i = 0; i < m_queues.size(); i++ )
    {
        if ( !m_queues.valid ( i ) ) continue;
        delete m_queues.get ( i );
        m_queues.remove ( i );
    }
    
    alDistanceModel ( AL_INVERSE_DISTANCE_CLAMPED );
}

OpenALSoundSystem::~OpenALSoundSystem()
{
    alcDestroyContext ( m_context );
    alcCloseDevice ( m_device );
}

int OpenALSoundSystem::LoadWave ( const char *_soundName )
{
    ARCReleaseAssert ( _soundName != NULL );
    char fileName[2048];
    sprintf ( fileName, "%ssound/%s.wav", g_app->GetResourcePath(), _soundName );
    ALuint buf = ALLoadWave(fileName);
    m_buffers.insert(_soundName, buf);
    return 0;
}

int OpenALSoundSystem::PlaySound ( const char *_soundName, short _distX, short _distY )
{
    ALuint buf = m_buffers.find ( _soundName );
    if (!buf)
    {
        LoadWave(_soundName);
        buf = m_buffers.find(_soundName);
        ARCReleaseAssert ( buf != NULL );
    }
    
    ALuint src = AcquireSource ();
    ARCReleaseAssert ( src != 0 );
    
    float loc[3] = { (float)_distX, (float)_distY, 0.0f };
    
    alSourceStop ( src );
    alSourceRewind ( src );
    alSourcei ( src, AL_BUFFER, buf );
    alSourcefv ( src, AL_POSITION, loc );
    alSourcePlay ( src );
    
    return 0;
}

void OpenALSoundSystem::AddQueue ( Data::LList<std::string> *_queue )
{
    // TODO: This is (clearly) invalid usage of the queue. See the SDL_mixer implementation.
    delete _queue;
}

bool OpenALSoundSystem::IsPlaying ( const char *_soundName )
{
    // TODO: This is (clearly) invalid.
    return false;
}

void OpenALSoundSystem::Update ()
{
    // look for sources which have finished playing and add them to the free source list
    unsigned int l = m_usedSources.size();
    for (unsigned int i = 0; i < l; i++)
    {
        ALuint source = m_usedSources.get(i);
        ALint state;
        alGetSourcei(source, AL_SOURCE_STATE, &state);
        if (state != AL_PLAYING)
        {
            m_usedSources.remove(i);
            m_freeSources.insert_back(source);
            return; // can't be arsed enforcing integrity within the Data::LList, so let's just return to the parent function at this point
            // todo: make source reaping in a background thread
        }
    }
}

#endif
